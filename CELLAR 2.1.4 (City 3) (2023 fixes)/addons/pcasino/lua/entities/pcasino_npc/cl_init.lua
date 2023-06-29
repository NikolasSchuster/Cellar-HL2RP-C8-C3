include("shared.lua")

function ENT:Initialize()
	-- To prevent some weird issue where the animation was going crazy
	self:SetSequence(self:LookupSequence("idle_subtle"))

	self.hasInitialized = true
end


function ENT:PostData()
	if not self.hasInitialized then
		self:Initialize()
	end

	surface.SetFont("pCasino.Entity.Arrows")
	self.textWidth = surface.GetTextSize(self.data.text.overhead)
end

local surface_setdrawcolor = surface.SetDrawColor
local surface_drawrect = surface.DrawRect
local draw_simpletext = draw.SimpleText
local black = Color(0, 0, 0, 155)
local white = Color(255, 255, 255, 100)
local gold = Color(255, 200, 0, 100)
function ENT:Draw()
	self:DrawModel()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 200000 then return end

	-- We can piggyback off the distance check to only request the entities data when it's needed :D
	if (not self.data) and (not PerfectCasino.Cooldown.Check(self:EntIndex(), 5)) then
		PerfectCasino.Core.RequestConfigData(self)
		return
	end

	if not self.data then return end

	if (not self.data.text.overhead) or (self.data.text.overhead == " ") then return end

	local ang = LocalPlayer():EyeAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)

	cam.Start3D2D(self:GetPos()+self:GetUp()*78, ang, 0.07)
		-- Previous bet step
		surface_setdrawcolor(black)
		surface_drawrect(-(self.textWidth + 10)*0.5, 5, self.textWidth + 10, 65)
		-- Border
		surface_setdrawcolor(white)
		surface_drawrect(-(self.textWidth + 20)*0.5, 0, self.textWidth + 20, 5)
		surface_drawrect(-(self.textWidth + 20)*0.5, 5, 5, 65)
		surface_drawrect((self.textWidth*0.5) + 5, 5, 5, 65)
		surface_drawrect(-(self.textWidth + 20)*0.5, 70, self.textWidth+20, 5)
		-- Text
		draw_simpletext(self.data.text.overhead, "pCasino.Entity.Arrows", 0, 35, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end