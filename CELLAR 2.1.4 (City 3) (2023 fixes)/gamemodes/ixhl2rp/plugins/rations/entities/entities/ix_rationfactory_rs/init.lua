include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local SPAWN_ITEM = "ration_tier_1"

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_smallmonitor001.mdl")
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self.nextUse = 0
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:PhysicsUpdate(physicsObject)
	if !self:IsPlayerHolding() and !self:IsConstrained() then
		physicsObject:SetVelocity(Vector(0, 0, 0))
		physicsObject:Sleep()
	end
end

function ENT:Touch(ent)
	if !ent.GetItemID then
		return
	end

	if self.nextUse > CurTime() then
		return
	end

	local item = ent:GetItemTable()

	if !item or item.uniqueID != "filled_ration" then
		return
	end
	
	ent:Remove()

	ix.item.Spawn(SPAWN_ITEM, ent:GetPos(), nil, ent:GetAngles())

	self:EmitSound("buttons/button4.wav")
	self.nextUse = CurTime() + .75
end