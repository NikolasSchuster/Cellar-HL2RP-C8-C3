AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Warmth Beacon"
ENT.Category = "Helix"
ENT.Spawnable = true

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:GetPhysicsObject():Wake()

		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		local warmzone = ents.Create("ix_warmzone")
		local pos = self:GetPos()
		pos[3] = pos[3] + 15
		warmzone:SetPos(pos)
		warmzone:SetParent(self)
		warmzone:Spawn()
	end
end
