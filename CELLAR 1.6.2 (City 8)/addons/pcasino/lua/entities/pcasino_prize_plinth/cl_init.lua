include("shared.lua")

function ENT:PostData()
	self.item = ClientsideModel(self.data.general.model)
	self.item:SetParent(self)
	self.item:SetPos(self:GetPos() + (self:GetUp() * 5))
	self.item:SetAngles(self:GetAngles())

	if self.data.general.bow then
		self.item.bow = ClientsideModel("models/freeman/owain_giantbow.mdl")
		self.item.bow:SetParent(self.item)
		local boundMin, boundMax = self.item:GetModelRenderBounds()
		self.item.bow:SetPos(self.item:GetPos() + Vector(0, 0, boundMax[3] + 8 + (self.data.general.bowOffset or 0)))
		self.item.bow:SetAngles(self.item:GetAngles())
	end
end

function ENT:Think()
	if not IsValid(self.item) then return end

	if not (self:GetBoneMatrix(1)) then return end
	
	local ang = self:GetBoneMatrix(1):GetAngles()
	ang:RotateAroundAxis(ang:Right(), -90)
	self.item:SetAngles(ang)
end

function ENT:OnRemove()

	if IsValid(self.item) then
		self.item:Remove()
		
		if IsValid(self.item.bow) then
			self.item.bow:Remove()
		end
	end

end

function ENT:Draw()
	self:DrawModel()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 1000000 then return end

	-- We can piggyback off the distance check to only request the entities data when it's needed :D
	if (not self.data) and (not PerfectCasino.Cooldown.Check(self:EntIndex(), 5)) then
		PerfectCasino.Core.RequestConfigData(self)
		return
	end
end