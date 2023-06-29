AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "WarmZone"
ENT.Category = "Helix"
ENT.Spawnable = false

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/hunter/blocks/cube4x4x2.mdl")
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)

		self:SetTrigger(true)
		self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	end

	function ENT:StartTouch(entity)
		if entity:IsPlayer() then
			entity.inWarmth = true
		end
	end

	function ENT:EndTouch(entity)
		if entity:IsPlayer() then
			entity.inWarmth = false
		end
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_NEVER
	end
end

-- properties.Add("ixInitWarmthBox", {
-- 	MenuLabel = "#Initialize WarmthBox",
-- 	Order = 1,
-- 	MenuIcon = "icon16/eye.png",
-- 	Filter = function(self, entity, client)
-- 		return client:IsAdmin() and ENT.PrintName == "WarmZone" 
-- 	end,
-- 	Action = function(self, entity)
-- 		self:MsgStart()
-- 		net.WriteEntity(entity)
-- 		self:MsgEnd()
-- 	end,
-- 	Receive = function(self, length, client)
-- 		if (client:IsAdmin()) then
-- 			local entity = net.ReadEntity()

-- 		end
-- 	end
-- })