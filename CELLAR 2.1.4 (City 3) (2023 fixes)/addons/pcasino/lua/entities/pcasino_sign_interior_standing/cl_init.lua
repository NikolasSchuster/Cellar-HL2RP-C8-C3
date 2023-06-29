include("shared.lua")

function ENT:PostData()
end

local draw_simpletext = draw.SimpleText
function ENT:Draw()
	self:DrawModel()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 1000000 then return end

	-- We can piggyback off the distance check to only request the entities data when it's needed :D
	if (not self.data) and (not PerfectCasino.Cooldown.Check(self:EntIndex(), 5)) then
		PerfectCasino.Core.RequestConfigData(self)
		return
	end

	if not self.data then return end

	local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)

	cam.Start3D2D(pos + (self:GetUp() * 26) + (self:GetForward() * 2.4) + (self:GetRight() * 7.1), ang, 0.05)
			PerfectCasino.UI.WrapText(self.data.general.text, 15, "pCasino.Title.Static", 140, 100, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()

	ang:RotateAroundAxis(ang:Right(), 180)

	cam.Start3D2D(pos + (self:GetUp() * 26) + (self:GetForward() * -2.4) + (self:GetRight() * -7.1), ang, 0.05)
			PerfectCasino.UI.WrapText(self.data.general.text, 15, "pCasino.Title.Static", 140, 100, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end