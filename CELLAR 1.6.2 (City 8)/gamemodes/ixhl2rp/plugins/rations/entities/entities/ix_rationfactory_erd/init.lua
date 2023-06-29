include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local minimum = Vector(-8, -8, -8)
local maximum = Vector(8, 8, 64)
local randomSounds = {
	Sound("buttons/combine_button1.wav"),
	Sound("buttons/combine_button2.wav"),
	Sound("buttons/combine_button3.wav"),
	Sound("buttons/combine_button5.wav"),
	Sound("buttons/combine_button7.wav")
}
	
function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01.mdl")
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	
	self.dispenser = ents.Create("prop_dynamic")
	self.dispenser:DrawShadow(false)
	self.dispenser:SetAngles(self:GetAngles())
	self.dispenser:SetParent(self)
	self.dispenser:SetModel("models/props_combine/combine_dispenser.mdl")
	self.dispenser:SetPos(self:GetPos())
	self.dispenser:Spawn()

	self:SetText("Ready")
	self:SetDispColor(3)
	self:DeleteOnRemove(self.dispenser)
	
	self:SetCollisionBounds(minimum, maximum)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:PhysicsInitBox(minimum, maximum)
	self:DrawShadow(false)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:Toggle()
	self:SetLocked(!self:GetLocked())
	self:EmitRandomSound()
end

function ENT:SetFlashDuration(duration)
	self:EmitSound("buttons/combine_button_locked.wav")
	self:SetFlash(CurTime() + duration)
end

function ENT:CreateDummyRation()
	local entity = ents.Create("prop_physics")
	entity:SetAngles(self:GetAngles())
	entity:SetModel("models/weapons/w_packate.mdl")
	entity:SetPos(self:GetPos() + self:GetForward() * -10 + self:GetRight() * -6 + self:GetUp() * -5)
	entity:Spawn()
	
	return entity
end

function ENT:Dispense(activator, dispenseType)
	local curTime = CurTime()
	
	if !self.nextDispense or curTime >= self.nextDispense then
		self.nextDispense = curTime + 1
		self:SetRation(curTime + 1)
		self:SetText("Dispensing")
		
		local frameTime = FrameTime() * 0.5
		local entity = self:CreateDummyRation()
		
		if IsValid(entity) then
			local forward = self:GetForward() * 25
			local right = self:GetRight() * 1
			local up = self:GetUp() * 1
			self.dispenser:EmitSound("ambient/machines/combine_terminal_idle4.wav")
			entity:SetNotSolid(true)
			entity:SetParent(self.dispenser, 1)
			self.dispenser:Fire("SetAnimation", "dispense_package", 0)
			timer.Simple(1.75, function()
				if IsValid(self) and IsValid(entity) then
					local position = entity:GetPos()
					local angles = entity:GetAngles()
					
					entity:CallOnRemove("CreateRation", function()
						ix.item.Spawn(dispenseType, position, function(item, ent)
							item:SetData("T", true)
						end, angles)

						self:SetText("Ready")
					end)
					
					entity:SetNoDraw(true)
					entity:Remove()
				end
			end)
		end
	end
end

function ENT:EmitRandomSound()
	self:EmitSound(randomSounds[math.random(1, #randomSounds)])
end

function ENT:PhysicsUpdate(physicsObject)
	if !self:IsPlayerHolding() and !self:IsConstrained() then
		physicsObject:SetVelocity(Vector(0, 0, 0))
		physicsObject:Sleep()
	end
end

function ENT:Think()
	local r, g, b, a = self:GetColor()
	local rationTime = self:GetRation()
	local flashTime = self:GetFlash()
	local curTime = CurTime()
	
	if rationTime > curTime then
		local timeLeft = rationTime - curTime
		self:SetDispColor(2)
		if !self.nextFlash or curTime >= self.nextFlash or (self.flashUntil and self.flashUntil > curTime) then
			if !self.flashUntil or curTime >= self.flashUntil then
				self.nextFlash = curTime + (timeLeft / 4)
				self.flashUntil = curTime + (FrameTime() * 4)
			end
		end
	else
		self:SetDispColor(3)
		
		if self:GetLocked() then
			self:SetDispColor(4)
		end
		
		if flashTime and flashTime >= curTime then
			self:SetDispColor(1)
		end
	end
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() and activator:GetEyeTraceNoCursor().Entity == self then
		local curTime = CurTime()
		if !self.nextUse or curTime >= self.nextUse then
			if !activator:IsCombine() then
				if !self:GetLocked() then
					if !self.nextDispense or curTime >= self.nextDispense then
						self:Dispense(activator, "empty_ration")
					end
				else
					self:SetFlashDuration(3)
				end		
			else
				self:Toggle()
			end

			self.nextUse = curTime + 3
		end
	end
end

function ENT:CanTool(player, trace, tool)
	return false
end