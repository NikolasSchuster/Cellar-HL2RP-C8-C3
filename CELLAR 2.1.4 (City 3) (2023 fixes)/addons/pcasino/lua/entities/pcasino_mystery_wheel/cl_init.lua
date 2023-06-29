include("shared.lua")


function ENT:Initialize()
	self.active = false
	self.currentBets = {}

	self.hasInitialized = true
end

function ENT:PostData()
	if not self.hasInitialized then
		self:Initialize()
	end
end

local surface_setdrawcolor = surface.SetDrawColor
local surface_drawrect = surface.DrawRect
local draw_simpletext = draw.SimpleText
local surface_setdrawcolor = surface.SetDrawColor
local surface_setmaterial = surface.SetMaterial
local surface_gettextsize = surface.GetTextSize
local surface_setfont = surface.SetFont
local draw_notexture = draw.NoTexture
local math_cos = math.cos
local math_sin = math.sin
local math_rad = math.rad
local black = Color(0, 0, 0, 155)
local white = Color(255, 255, 255, 100)
function ENT:DrawTranslucent()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 1000000 then return end


	-- We can piggyback off the distance check to only request the entities data when it's needed :D
	if (not self.data) and (not PerfectCasino.Cooldown.Check(self:EntIndex(), 5)) then
		PerfectCasino.Core.RequestConfigData(self)
		return
	end

	if not self.data then return end

	-- Basic setups
	local pos = self:GetPos()
	local ang = self:GetBoneMatrix(2):GetAngles()

	ang:RotateAroundAxis(ang:Up(), 89.8)
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Up(), -162)

	cam.Start3D2D(pos + (self:GetUp()*9.75) + (self:GetRight()*0.2) + (self:GetForward()*-17.4), ang, 0.08)
		-- Spinny wheel icons
		local itter = 0
		for i=1, 360, 360/20 do 
			itter = itter + 1
			local x = math_cos(math_rad(i - 91)) * 155
			local y = math_sin(math_rad(i - 91)) * 155

			draw_notexture()
			surface_setdrawcolor(255, 255, 255, 255)
			surface_setmaterial(PerfectCasino.Icons[self.data.wheel[21 - itter].p].mat)

			PerfectCasino.UI.DrawTexturedRectRotatedPoint(x, y, 60, 60, (-i+1), 0, -218)
			PerfectCasino.UI.TextRotated(self.data.wheel[21 - itter].n, x, y, color_white, "pCasino.Title.Static", i-90, 1)
		end
	cam.End3D2D()

	if tobool(self.data.buySpin.buy) or (tobool(self.data.general.useFreeSpins) and (PerfectCasino.Spins > 0)) then
		-- Basic setups
		local pos = self:GetPos()
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 50)
		ang:RotateAroundAxis(ang:Forward(), 90)
	
		surface_setfont("pCasino.Entity.Arrows")
		local spinSize, _ = surface_gettextsize(PerfectCasino.Translation.UI.PurchaseASpin)
		local moneySize, _ = surface_gettextsize(PerfectCasino.Config.FormatMoney(self.data.buySpin.cost))
		local biggestSize = (spinSize > moneySize) and spinSize or moneySize
		biggestSize = biggestSize + 100

		cam.Start3D2D(pos + (ang:Up()*-35) + (ang:Forward()*25) + (ang:Right()*-9) + ((ang:Right()*-2)*(math.sin(CurTime()*0.5))), ang, 0.05)
				-- Current bet
				surface_setdrawcolor(black)
				surface_drawrect(-10, -20, biggestSize, 120)
				-- Border
				surface_setdrawcolor(white)
				surface_drawrect(-15, -25, biggestSize+10, 5)
				surface_drawrect(-15, -20, 5, 120)
				surface_drawrect(biggestSize-10, -20, 5, 120)
				surface_drawrect(-15, 100, biggestSize+10, 5)
				-- Current Bid
				draw_simpletext((PerfectCasino.Spins > 0) and PerfectCasino.Translation.UI.FreeSpin or PerfectCasino.Translation.UI.PurchaseASpin, "pCasino.Entity.Arrows", biggestSize/2-10, 37, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				draw_simpletext((PerfectCasino.Spins > 0) and string.format(PerfectCasino.Translation.UI.FreeSpinCount, PerfectCasino.Spins) or PerfectCasino.Config.FormatMoney(self.data.buySpin.cost), "pCasino.Entity.Arrows", biggestSize/2-10, 37, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		cam.End3D2D()
	end
end