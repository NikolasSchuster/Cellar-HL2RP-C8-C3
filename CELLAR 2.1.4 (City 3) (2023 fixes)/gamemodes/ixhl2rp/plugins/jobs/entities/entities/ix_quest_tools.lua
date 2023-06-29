-- make a client-side entity that can be picked up on Use and
-- the server gets notified of the pickup

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Quest Pickup"

ENT.Spawnable = true
ENT.AdminSpawnable = true

local PLUGIN = PLUGIN


function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:GetPhysicsObject():Wake()
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:DrawShadow(false)

	self:SetData("uniqueID", self:GetData("uniqueID", math.random(1, 10000)))

	PLUGIN:SaveData()
end

function ENT:Use(activator, caller)
	if not activator:IsPlayer() then return end
	if not activator:GetData("questsVisibleTools", {})[self:GetData("uniqueID")] then return end
	net.Start("ixQuestPickup")
	net.WriteEntity(self)
	net.Send(activator)
end

function ENT:Draw()
	local drawTools = ix.option.Get("drawTools")
	if not LocalPlayer():GetData("questsVisibleTools", {})[self:GetData("uniqueID")] or drawTools then return end
	self:DrawModel()
end
