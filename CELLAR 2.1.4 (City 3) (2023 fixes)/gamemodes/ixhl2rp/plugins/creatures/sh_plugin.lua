local PLUGIN = PLUGIN

PLUGIN.name = "Creatures"
PLUGIN.author = ""
PLUGIN.description = ""

PrecacheParticleSystem("hunter_muzzle_flash")

local playerMeta = FindMetaTable("Player")

function playerMeta:SoundEvent(soundName)
	local infoTable = self:GetClassTable()

	if (infoTable) then
		local soundTable = infoTable.sounds

		if (soundTable[soundName]) then
			local snd

			if (istable(soundTable[soundName])) then
				snd = table.Random(soundTable[soundName])
			else
				snd = soundTable[soundName]
			end

			self:EmitSound(snd)
			return true
		end
	end

	return false
end

function playerMeta:SoundEventLoop(name, volume, pitch)
	if (self.loopingSounds) then
		if (!self.loopingSounds[name]) then
			return
		end

		local snd = self.loopingSounds[name]

		if (snd:IsPlaying()) then
			if (volume) then
				snd:ChangeVolume(volume)
			end

			if (pitch) then
				snd:ChangePitch(pitch, 0.1)
			end
		else
			if (volume or pitch) then
				snd:PlayEx(volume or 1, pitch or 100)
			else
				snd:Play()
			end
		end
	end
end

function playerMeta:SoundLoopStop(name)
	if (self.loopingSounds) then
		if (!self.loopingSounds[name]) then return end
		local snd = self.loopingSounds[name]

		snd:FadeOut(0.1)
	end
end

function playerMeta:SoundLoopStopAll()
	if (self.loopingSounds) then
		for _, v in pairs(self.loopingSounds) do
			v:Stop()
		end
	end
end

function playerMeta:GetClassTable()
	if (self.infoTable == nil and self:GetCharacter() and self:GetCharacter():GetClass()) then
		local class = ix.class.list[self:GetCharacter():GetClass()]

		if (class) then
			self.infoTable = class.infoTable
		end
	end

	return self.infoTable
end

function PLUGIN:OnPlayerHitGround(client)
	local infoTable = client:GetClassTable()

	if (infoTable) then
		if (SERVER and infoTable.land) then
			infoTable.land(client, infoTable)
		end

		if (infoTable.noFallDamage) then
			return true
		end
	end
end

function PLUGIN:StartCommand(client, userCmd)
	if (client:Alive() and CurTime() < (client.ixNextJump or 0)) then
		userCmd:RemoveKey(IN_JUMP)
	end
end

function PLUGIN:SetupMove(client, moveData)
	if (client:Alive() and client:GetMoveType() != MOVETYPE_NOCLIP) then
		local info = client:GetClassTable()

		if (info) then
			if (info.jump) then
				local delay, func = info.jump.delay, info.jump.func
				local curTime = CurTime()
				local nextJump = client.ixNextJump or 0

				if (client:KeyPressed(IN_JUMP) and client:IsOnGround() and curTime >= nextJump) then
					if (SERVER) then
						func(client, moveData, info)

						client.ixCouldShoot = true
						client:SetNetVar("canShoot", true)
					end

					client.ixNextJump = curTime + delay

					return true
				elseif (curTime < nextJump) then
					local newButtons = bit.band(moveData:GetButtons(), bit.bnot(IN_JUMP))
					moveData:SetButtons(newButtons)
				end
			elseif (client:Team() == FACTION_SYNTH and client:GetNetVar("ChargeTime", 0) != 0) then
				local charge = info.charge
				local velocity = moveData:GetVelocity()

				if (client:GetNetVar("ChargeTime") < CurTime() and velocity:Length() < charge.vel * 0.2) then
					if (SERVER) then
						client:SetNetVar("ChargeTime", nil)
					end

					moveData:SetVelocity(vector_origin)
				else
					moveData:SetVelocity(Angle(0, client:EyeAngles().y, 0):Forward() * charge.vel)
				end
			end
		end
	end
end

function PLUGIN:AdjustStaminaOffset(client)
	local character = client:GetCharacter()
	local faction = character and character:GetFaction()

	if (faction and (faction == FACTION_ZOMBIE or faction == FACTION_SYNTH)) then
		-- we can use GetMaxStamina function instead of a hardcoded value but I don't want to run the same hook twice every second
		return 100
	end
end

do
	sound.Add({
		name = "NPC_ANTLION_PAIN",
		channel = CHAN_BODY,
		volume = 0.85,
		level = 85,
		pitch = {90, 105},
		sound = {
			"npc/antlion/pain1.wav",
			"npc/antlion/pain2.wav"
		}
	})

	sound.Add({
		name = "NPC_ANTLION_GUARD_DEATH",
		channel = CHAN_BODY,
		volume = 0.85,
		level = 85,
		pitch = {90, 105},
		sound = {
			"npc/antlion_guard/antlion_guard_die1.wav",
			"npc/antlion_guard/antlion_guard_die2.wav"
		}
	})
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sh_anim.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")
