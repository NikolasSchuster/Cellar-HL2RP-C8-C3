include("shared.lua")

local COLOR_RED = 1
local COLOR_ORANGE = 4
local COLOR_BLUE = 2
local COLOR_GREEN = 3

local colors = {
	[COLOR_RED] = Color(255, 50, 50),
	[COLOR_ORANGE] = Color(255, 80, 20),
	[COLOR_BLUE] = Color(50, 80, 230),
	[COLOR_GREEN] = Color(50, 240, 50)
}

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():Distance(self:GetPos()) > 400 then return end
	
	local position, angles = self:GetPos(), self:GetAngles()

	angles:RotateAroundAxis(angles:Forward(), 90)
	angles:RotateAroundAxis(angles:Right(), -90)

	cam.Start3D2D(position + self:GetUp()*5.25 + self:GetRight()*20 - self:GetForward() * 6, angles, 0.1)
		render.PushFilterMin(TEXFILTER.NONE)
		render.PushFilterMag(TEXFILTER.NONE)

		surface.SetDrawColor(40, 40, 40)
		surface.DrawRect(0, 0, 136, 82)

		draw.SimpleText((self:GetLocked() and "OFFLINE" or (self:GetText() or "")), "Default", 136/2, 0, Color(255, 255, 255, math.abs(math.cos(RealTime() * 1.5) * 255)), 1, 0)

		surface.SetDrawColor(colors[self:GetLocked(0) and COLOR_RED or self:GetDispColor()] or color_white)
		surface.DrawRect(4, 14, 128, 64)

		surface.SetDrawColor(60, 60, 60)
		surface.DrawOutlinedRect(4, 14, 128, 64)

		render.PopFilterMin()
		render.PopFilterMag()
	cam.End3D2D()
end