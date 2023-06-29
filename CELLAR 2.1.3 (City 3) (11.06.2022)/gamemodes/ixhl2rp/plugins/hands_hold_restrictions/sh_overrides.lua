
if (SERVER) then
	util.AddNetworkString("ixPickedUpPlayer")
else
	net.Receive("ixPickedUpPlayer", function()
		local client = LocalPlayer()
		local heldPlayer = net.ReadEntity()

		if (IsValid(heldPlayer) and heldPlayer != game.GetWorld()) then
			client.ixHeldPlayer = heldPlayer
		else
			client.ixHeldPlayer = nil
		end
	end)
end

local ix_hands = weapons.Get("ix_hands")

-- DropObject is not being called if held entity being removed
function ix_hands:Think()
	if (!IsValid(self:GetOwner())) then
		return
	end

	if (CLIENT) then
		local viewModel = self:GetOwner():GetViewModel()

		if (IsValid(viewModel) and self.NextAllowedPlayRateChange < CurTime()) then
			viewModel:SetPlaybackRate(1)
		end
	else
		if (self:IsHoldingObject()) then
			local physics = self:GetHeldPhysicsObject()
			local bIsRagdoll = self.heldEntity:IsRagdoll()
			local holdDistance = bIsRagdoll and self.holdDistance * 0.5 or self.holdDistance
			local targetLocation = self:GetOwner():GetShootPos() + self:GetOwner():GetForward() * holdDistance

			if (bIsRagdoll) then
				targetLocation.z = math.min(targetLocation.z, self:GetOwner():GetShootPos().z - 32)
			end

			if (!IsValid(physics)) then
				self:DropObject()
				return
			end

			if (physics:GetPos():DistToSqr(targetLocation) > self.maxHoldDistanceSquared) then
				self:DropObject()
			else
				local physicsObject = self.holdEntity:GetPhysicsObject()
				local currentPlayerAngles = self:GetOwner():EyeAngles()
				local client = self:GetOwner()

				if (client:KeyDown(IN_ATTACK2)) then
					local cmd = client:GetCurrentCommand()
					self.heldObjectAngle:RotateAroundAxis(currentPlayerAngles:Forward(), cmd:GetMouseX() / 15)
					self.heldObjectAngle:RotateAroundAxis(currentPlayerAngles:Right(), cmd:GetMouseY() / 15)
				end

				self.lastPlayerAngles = self.lastPlayerAngles or currentPlayerAngles
				self.heldObjectAngle.y = self.heldObjectAngle.y - math.AngleDifference(self.lastPlayerAngles.y, currentPlayerAngles.y)
				self.lastPlayerAngles = currentPlayerAngles

				physicsObject:Wake()
				physicsObject:ComputeShadowControl({
					secondstoarrive = 0.01,
					pos = targetLocation,
					angle = self.heldObjectAngle,
					maxangular = 256,
					maxangulardamp = 10000,
					maxspeed = 256,
					maxspeeddamp = 10000,
					dampfactor = 0.8,
					teleportdistance = self.maxHoldDistance * 0.75,
					deltatime = FrameTime()
				})

				if (physics:GetStress() > self.maxHoldStress) then
					self:DropObject()
				end
			end
		elseif (self.bHeldPlayerSent) then
			self:GetOwner().ixHeldPlayer = nil
	
			net.Start("ixPickedUpPlayer")
			net.Send(self:GetOwner())
	
			self.bHeldPlayerSent = nil
		end

		-- Prevents the camera from getting stuck when the object that the client is holding gets deleted.
		if(!IsValid(self.heldEntity) and self:GetOwner():GetLocalVar("bIsHoldingObject", true)) then
			self:GetOwner():SetLocalVar("bIsHoldingObject", false)
		end
	end
end

function ix_hands:PickupObject(entity)
	if (self:IsHoldingObject() or
		!IsValid(entity) or
		!IsValid(entity:GetPhysicsObject())) then
		return
	end

	local physics = entity:GetPhysicsObject()
	physics:EnableGravity(false)
	physics:AddGameFlag(FVPHYSICS_PLAYER_HELD)

	entity.ixHeldOwner = self:GetOwner()
	entity.ixCollisionGroup = entity:GetCollisionGroup()
	entity:StartMotionController()
	entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	self.heldObjectAngle = entity:GetAngles()
	self.heldEntity = entity

	self.holdEntity = ents.Create("prop_physics")
	self.holdEntity:SetPos(self.heldEntity:LocalToWorld(self.heldEntity:OBBCenter()))
	self.holdEntity:SetAngles(self.heldEntity:GetAngles())
	self.holdEntity:SetModel("models/weapons/w_bugbait.mdl")
	self.holdEntity:SetOwner(self:GetOwner())

	self.holdEntity:SetNoDraw(true)
	self.holdEntity:SetNotSolid(true)
	self.holdEntity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.holdEntity:DrawShadow(false)

	self.holdEntity:Spawn()

	local trace = self:GetOwner():GetEyeTrace()
	local physicsObject = self.holdEntity:GetPhysicsObject()

	if (IsValid(physicsObject)) then
		physicsObject:SetMass(2048)
		physicsObject:SetDamping(0, 1000)
		physicsObject:EnableGravity(false)
		physicsObject:EnableCollisions(false)
		physicsObject:EnableMotion(false)
	end

	if (trace.Entity:IsRagdoll()) then
		local tracedEnt = trace.Entity
		self.holdEntity:SetPos(tracedEnt:GetBonePosition(tracedEnt:TranslatePhysBoneToBone(trace.PhysicsBone)))
	end

	self.constraint = constraint.Weld(self.holdEntity, self.heldEntity, 0,
		trace.Entity:IsRagdoll() and trace.PhysicsBone or 0, 0, true, true)

	-- PickupObject func is being executed only on server
	if (self.heldEntity.ixPlayer) then
		self:GetOwner().ixHeldPlayer = self.heldEntity.ixPlayer

		net.Start("ixPickedUpPlayer")
			net.WriteEntity(self.heldEntity.ixPlayer)
		net.Send(self:GetOwner())

		self.bHeldPlayerSent = true
	end
end

function ix_hands:DropObject(bThrow)
	-- DropObject func is being executed only on server
	if (self.bHeldPlayerSent) then
		self:GetOwner().ixHeldPlayer = nil

		net.Start("ixPickedUpPlayer")
		net.Send(self:GetOwner())

		self.bHeldPlayerSent = nil
	end

	if (!IsValid(self.heldEntity) or self.heldEntity.ixHeldOwner != self:GetOwner()) then
		return
	end

	self.lastPlayerAngles = nil
	self:GetOwner():SetLocalVar("bIsHoldingObject", false)

	self.constraint:Remove()
	self.holdEntity:Remove()

	self.heldEntity:StopMotionController()
	self.heldEntity:SetCollisionGroup(self.heldEntity.ixCollisionGroup or COLLISION_GROUP_NONE)

	local physics = self:GetHeldPhysicsObject()
	physics:EnableGravity(true)
	physics:Wake()
	physics:ClearGameFlag(FVPHYSICS_PLAYER_HELD)

	if (bThrow) then
		timer.Simple(0, function()
			if (IsValid(physics) and IsValid(self:GetOwner())) then
				physics:AddGameFlag(FVPHYSICS_WAS_THROWN)
				physics:ApplyForceCenter(self:GetOwner():GetAimVector() * ix.config.Get("throwForce", 732))
			end
		end)
	end

	self.heldEntity.ixHeldOwner = nil
	self.heldEntity.ixCollisionGroup = nil
	self.heldEntity = nil
end

-- we will re-register SWEP to prevent auto refresh issues
weapons.Register(ix_hands, "ix_hands")
