ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()  
    self:SetSolid(SOLID_BBOX)
    self:SetTrigger(true)
end

function ENT:SetupZone(pos1, pos2)
	self.worldPos1 = pos1
	self.worldPos2 = pos2

	self:SetPos(pos1 + (pos1 - pos2)/2)
	self:SetCollisionBoundsWS(pos1, pos2)
end

function ENT:StartTouch(activator)
	if IsValid(activator) then
		if activator:IsPlayer() then
			activator:SetLocalVar("inOutlands", true)
		end
	end
end

function ENT:EndTouch(activator)
	if IsValid(activator) then
		if activator:IsPlayer() then
			activator:SetLocalVar("inOutlands", false)
		end
	end
end
