include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")


local randomSounds = {
	Sound("ambient/machines/combine_terminal_idle2.wav"),
	Sound("buttons/button4.wav")
}

function ENT:Initialize()
	self:SetModel("models/props_combine/combinebutton.mdl")
	
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self.tube = ents.Create("prop_dynamic")
	self.tube:DrawShadow(false);
	self.tube:SetAngles(self:GetAngles())
	self.tube:SetParent(self);
	self.tube:SetModel("models/props_phx/construct/metal_tubex2.mdl")
	self.tube:SetPos(self:GetPos() + self:GetUp() * -5 - self:GetForward() * 30)
	self.tube:Spawn()

	self:DeleteOnRemove(self.tube)

	self:SetText("Ready")
	self:SetDispColor(3)
	
	self.timeStep = 8;
	self.nextUse = 0
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:EmitRandomSound()
	self:EmitSound(randomSounds[math.random(1, #randomSounds)])
end

function ENT:PhysicsUpdate(physicsObject)
	if !self:IsPlayerHolding() and !self:IsConstrained() then
		physicsObject:SetVelocity( Vector(0, 0, 0) )
		physicsObject:Sleep()
	end
end

function ENT:Think()
	local curTime = CurTime()
		
	if !self:GetLocked() then
		if curTime >= self.nextUse then
			if self:GetDispColor() != 3 then
				self:SetText(0, "Ready")
				self:SetDispColor(3)
			end
		else
			if self:GetDispColor() != 1 then
				self:SetText(0, "Recharging...")
				self:SetDispColor(1)
			end
		end
	end
end

function ENT:Toggle()
	self:SetLocked(!self:GetLocked())
	self:EmitRandomSound()
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() and activator:GetEyeTraceNoCursor().Entity == self then
		local curTime = CurTime()
		
		if !activator:IsCombine() then
			if (!self.nextUse or curTime >= self.nextUse) and !self:GetLocked() then
				self:EmitRandomSound()
				
				self:SpawnItem(activator)
				
				self.nextUse = curTime + self.timeStep
			else
				self:EmitSound("buttons/button11.wav")
			end
		else
			self:Toggle()
		end
	end
end

function ENT:SpawnItem(activator)
	local entity = ents.Create("ix_ration_crate")
	
	self.timeStep = 60
	entity:SetPos(self.tube:GetPos() + self.tube:GetUp() * 20)
	entity:SetAngles(self:GetAngles())
	entity:Spawn()
end

function ENT:CanTool(player, trace, tool)
	return false
end