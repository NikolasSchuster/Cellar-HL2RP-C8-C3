include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

util.AddNetworkString("ScannerFlash")

ENT.noHandsPickup = true
ENT.scanSounds = {
	Sound("npc/scanner/scanner_scan1.wav"),
	Sound("npc/scanner/scanner_scan2.wav"),
	Sound("npc/scanner/scanner_scan4.wav"),
	Sound("npc/scanner/scanner_scan5.wav"),
	Sound("npc/scanner/combat_scan1.wav"),
	Sound("npc/scanner/combat_scan2.wav"),
	Sound("npc/scanner/combat_scan3.wav"),
	Sound("npc/scanner/combat_scan4.wav"),
	Sound("npc/scanner/combat_scan5.wav"),
}
ENT.painSounds = {
	Sound("npc/scanner/scanner_pain1.wav"),
	Sound("npc/scanner/scanner_pain2.wav"),
	Sound("npc/scanner/scanner_alert1.wav"),
}
ENT.sirenSound = Sound("npc/scanner/scanner_siren2.wav")
ENT.SCANNER_ATTACHMENT_LIGHT = "light"

function ENT:SpawnFunction(player, trace, className)
	local entity = ents.Create(className)
	entity:SetPos(trace.HitPos + Vector(0, 0, 32))
	entity:Spawn()

	return entity
end

function ENT:Eject()
	local pilot = self:GetPilot()

	if (IsValid(pilot)) then
		--pilot:SetForcedAnimation(false)
		pilot:SetNWEntity("Scanner", NULL)
		pilot:SetViewEntity(nil)

		net.Start("ScannerExit")
		net.Send(pilot);
	end

	self:SetOwner(NULL)
	self:SetPilot(NULL)
end

function ENT:Transmit(player)
	if IsValid(self:GetPilot()) then return false end

	if IsValid(player:GetPilotingScanner()) then
		player:GetPilotingScanner():Eject()
	end

	net.Start("ScannerEnter")
	net.Send(player)

	self:SetOwner(player)
	self:SetPilot(player)
end

function ENT:CreateFlashSprite()
	if IsValid(self.spotlight) then return; end

	self.flashSprite = ents.Create("env_sprite")
	self.flashSprite:SetAttachment(self, self:LookupAttachment(self.SCANNER_ATTACHMENT_LIGHT))
	self.flashSprite:SetKeyValue("model", "sprites/blueflare1.vmt")
	self.flashSprite:SetKeyValue("scale", 1.4)
	self.flashSprite:SetKeyValue("rendermode", 3)
	self.flashSprite:SetRenderFX(kRenderFxNoDissipation)
	self.flashSprite:Spawn()
	self.flashSprite:Activate()
	self.flashSprite:SetColor(Color(255, 255, 255, 0))
end

function ENT:Spotlight(bool)
	if bool then
		if IsValid(self.spotlight) then return; end

		local attachment = self:LookupAttachment(self.SCANNER_ATTACHMENT_LIGHT)
		local position = self:GetAttachment(attachment)

		if !position then return end

		-- The volumetric light effect.
		self.spotlight = ents.Create("point_spotlight")
		self.spotlight:SetPos(position.Pos)
		self.spotlight:SetAngles(self:GetAngles())
		self.spotlight:SetParent(self)
		self.spotlight:Fire("SetParentAttachment", self.SCANNER_ATTACHMENT_LIGHT)
		self.spotlight:SetLocalAngles(self:GetForward():Angle())
		self.spotlight:SetKeyValue("spotlightwidth", self.spotlightWidth)
		self.spotlight:SetKeyValue("spotlightlength", self.spotlightLength)
		self.spotlight:SetKeyValue("HDRColorScale", self.spotlightHDRColorScale)
		self.spotlight:SetKeyValue("color", "255 255 255")
		-- On by default and disable dynamic light.
		self.spotlight:SetKeyValue("spawnflags", 3)
		self.spotlight:Spawn()
		self.spotlight:Activate()

		-- The actual dynamic light.
		self.flashlight = ents.Create("env_projectedtexture")
		self.flashlight:SetPos(position.Pos)
		self.flashlight:SetParent(self)
		self.flashlight:SetLocalAngles(self.spotlightLocalAngles)
		self.flashlight:SetKeyValue("enableshadows", self.spotlightEnableShadows and 1 or 0)
		self.flashlight:SetKeyValue("nearz", self.spotlightNear)
		self.flashlight:SetKeyValue("lightfov", self.spotlightFOV)
		self.flashlight:SetKeyValue("farz", self.spotlightFar)
		self.flashlight:SetKeyValue("lightcolor", "255 255 255")
		self.flashlight:Spawn()
		self.flashlight:Input("SpotlightTexture", NULL, NULL, "effects/flashlight/soft")
	else
		if IsValid(self.spotlight) then
			self.spotlight:SetParent(NULL)
			self.spotlight:Input("LightOff")
			self.spotlight:Fire("Kill", "", 0.25)
		end

		if IsValid(self.flashlight) then
			self.flashlight:Remove()
		end
	end
end

function ENT:IsSpotlightOn()
	return IsValid(self.spotlight)
end

function ENT:Initialize()
	self:SetModel("models/Combine_Scanner.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:AddSolidFlags(FSOLID_NOT_STANDABLE)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:GetPhysicsObject():EnableMotion(true)
	self:GetPhysicsObject():Wake()
	self:GetPhysicsObject():EnableGravity(false)
	self:ResetSequence("idle")
	self:SetPlaybackRate(1.0)
	self:AddFlags(FL_FLY)
	self:PrecacheGibs()

	self.camhelper = ents.Create("camera_helper")
	self.camhelper:Spawn()
	self.camhelper:SetPos(self:GetPos() + self:GetForward() * 15)
	self.camhelper:SetAngles(self:GetAngles())
	self.camhelper:Activate()
	self.camhelper:SetParent(self)

	self:CreateFlashSprite()

	self.targetDir = vector_origin
	self.health = self.maxHealth
end

function ENT:SetClawScanner()
	self:SetModel("models/shield_scanner.mdl")
	self:PrecacheGibs()
	self:ResetSequence("hoverclosed")
end

function ENT:Flash()
	local max = 30
	local value = max
	local timerID = "ScannerFlash"..self:EntIndex()

	self.flashSprite:SetColor(color_white)
	self:EmitSound("npc/scanner/scanner_photo1.wav")

	net.Start("ScannerFlash")
		net.WriteEntity(self)
	net.SendPVS(self:GetPos())

	timer.Create("ScannerFlash"..self:EntIndex(), 0, max, function()
		if (IsValid(self) and IsValid(self.flashSprite)) then
			self.flashSprite:SetColor(Color(255, 255, 255, (value / max) * 255))
			value = value - 1
		else
			timer.Remove(timerID)
		end
	end)

	self:EmitDelayedSound(table.Random(self.scanSounds), 1)
end

function ENT:EmitDelayedSound(source, delay, volume, pitch)
	timer.Simple(delay or 0, function()
		if (IsValid(self)) then
			self:EmitSound(source, volume, pitch)
		end
	end)
end

function ENT:HandlePilotMove()
	local still = true
	local pilot = self:GetPilot()
	local thirdperson = false --pilot:GetSharedVar("InThirdPerson")

	if pilot:KeyDown(IN_FORWARD) then
		self.accelXY = Lerp(0.1, self.accelXY, 10)
		self.targetDir = self.targetDir + pilot:GetAimVector()
		still = false
	end

	if pilot:KeyDown(IN_JUMP) then
		self.accelXY = Lerp(0.25, self.accelXY, 10)
		self.targetDir = self.targetDir + Vector(0, 0, 1)
		still = false
	end
	
	if pilot:KeyDown(IN_SPEED) then
		self.accelXY = Lerp(0.25, self.accelXY, 10)
		self.targetDir = self.targetDir - Vector(0, 0, 1)
		still = false
	end

	if still then
		self.accelXY = Lerp(0.5, self.accelXY, 0)
		self.accelZ = Lerp(0.5, self.accelZ, 0)
	end

	if thirdperson and pilot:GetViewEntity() != self.camhelper then
		pilot:SetViewEntity(self.camhelper)
	elseif !thirdperson and pilot:GetViewEntity() != self then
		pilot:SetViewEntity(self)
	end
end

function ENT:DiscourageHitGround()
	local trace = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() - self.minHoverHeight,
		filter = {self, self:GetPilot()}
	})

	if trace.Hit then
		self.targetDir.z = self.minHoverPush.z
	end
end

function ENT:Think()
	self.targetDir.x = 0
	self.targetDir.y = 0
	self.targetDir.z = 0
	self:UpdateDirection()

	if IsValid(self:GetPilot()) then
		self:HandlePilotMove()
	end

	self:DiscourageHitGround()
	self.targetDir:Normalize()

	local id = self:GetID()
	if !self.lastID or self.lastID != id then
		--self:SetScannerName(Format("CP-AUTO.SCN.%s", Clockwork.kernel:ZeroNumberToDigits(id, 3)))
		self.lastID = id
	end

	self:NextThink(CurTime())
	return true
end

function ENT:UpdateNoiseVelocity()
	self.noise.z = math.sin(CurTime() * 2) * 75 * (1 - self.accelZ)
end

function ENT:FacePilotDirection()
	self.faceAngles = self:GetPilot():EyeAngles()
	self.faceAngles.p = math.Clamp(self.faceAngles.p, -30, 25)
end

function ENT:UpdateDirection()
	if IsValid(self:GetPilot()) then
		self:FacePilotDirection()
	end
end

local angDiff = math.AngleDifference

function ENT:PhysicsUpdate(phys)
	local dt = FrameTime()

	local velocity = phys:GetVelocity()
	local decay = self.velocityDecay
	local maxSpeed = self.maxSpeed * dt
	local targetDir = self.targetDir

	velocity.x = decay.x * velocity.x + self.accelXY * maxSpeed * targetDir.x
	velocity.y = decay.y * velocity.y + self.accelXY * maxSpeed * targetDir.y
	velocity.z = decay.z * velocity.z + self.accelXY * self.maxSpeedZ * targetDir.z * dt
	self:UpdateNoiseVelocity()
	velocity = velocity + self.noise * dt

	if velocity:LengthSqr() > self.maxSpeedSqr then
		velocity:Normalize()
		velocity:Mul(self.maxSpeed)
	end

	phys:SetVelocity(velocity)

	local angles = self:GetAngles()
	self.accelAnglular.x = angDiff(self.faceAngles.r, angles.r) * self.turnSpeed * dt
	self.accelAnglular.y = angDiff(self.faceAngles.p, angles.p) * self.turnSpeed * dt
	self.accelAnglular.z = angDiff(self.faceAngles.y, angles.y) * self.turnSpeed * dt
	phys:AddAngleVelocity(self.accelAnglular - phys:GetAngleVelocity() * self.angleDecay)

	-- Makes the spotlight motion more smooth.
	if IsValid(self.spotlight) then
		self.spotlight:SetAngles(self:GetAngles())
	end

	self.lastPhys = CurTime()
end

function ENT:Die(dmgInfo)
	local force = dmgInfo and dmgInfo:GetDamageForce() or Vector(0, 0, 50)
	self:GibBreakClient(force)

	local effect = EffectData()
		effect:SetStart(self:GetPos())
		effect:SetOrigin(self:GetPos())
		effect:SetMagnitude(0)
		effect:SetScale(0.5)
		effect:SetColor(25)
		effect:SetEntity(self)
	util.Effect("Explosion", effect, true, true)

	self:EmitSound("NPC_SScanner.Die")
	self:Remove()
end

function ENT:CreateDamageSmoke()
	if IsValid(self.smoke) then return end

	self.smoke = ents.Create("env_smoketrail")
	self.smoke:SetParent(self)
	self.smoke:SetLocalPos(vector_origin)
	self.smoke:SetKeyValue("spawnrate", 5)
	self.smoke:SetKeyValue("opacity", 1)
	self.smoke:SetKeyValue("lifetime", 1)
	self.smoke:SetKeyValue("startcolor", "200 200 200")
	self.smoke:SetKeyValue("startsize", 5)
	self.smoke:SetKeyValue("endsize", 20)
	self.smoke:SetKeyValue("spawnradius", 10)
	self.smoke:SetKeyValue("minspeed", 5)
	self.smoke:SetKeyValue("maxspeed", 10)
	self.smoke:Spawn()
	self.smoke:Activate()
end

function ENT:RemoveDamageSmoke()
	if (IsValid(self.smoke)) then
		self.smoke:Remove()
	end
end

function ENT:DoDamageSound()
	-- smoke trail when damaged (env_smoketrail)
	local critical = self.maxHealth * 0.25
	if self.lastHealth >= critical and self.health <= critical then
		self:CreateDamageSmoke()
		self:EmitSound(self.sirenSound)
	elseif (self.nextPainSound or 0) < CurTime() then
		self.nextPainSound = CurTime() + 0.5

		local painSound = table.Random(self.painSounds)
		self:EmitSound(painSound)
	end
end

function ENT:OnTakeDamage(dmgInfo)
	self.lastHealth = self.health
	self.health = self.health - dmgInfo:GetDamage()

	if self.health <= 0 then
		self:Die(dmgInfo)
	else
		self:DoDamageSound()
	end
end

function ENT:OnRemove()
	self:Spotlight(false)
	self:RemoveDamageSmoke()
	self:Eject()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end