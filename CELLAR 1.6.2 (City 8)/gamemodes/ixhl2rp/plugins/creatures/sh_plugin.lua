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
			return false
		end
	end
end

function PLUGIN:StartCommand(client, cmd)
	local info = client:GetClassTable()
	
	if info then
		if info.jump then
			if SERVER and client:KeyPressed(IN_JUMP) then
				info.jump(client, info)
			end
		end
	end
end

function PLUGIN:SetupMove(client, mv, cmd)
	if (client:Team() == FACTION_SYNTH and client:GetNetVar("ChargeTime", 0) ~= 0) then
		local charge = client:GetClassTable().charge
		local vel = mv:GetVelocity()

		if (client:GetNetVar("ChargeTime") < CurTime() and vel:Length() < charge.vel * 0.2) then
			if (SERVER) then
				client:SetNetVar("ChargeTime", nil)
			end

			mv:SetVelocity(vector_origin)
		else
			mv:SetVelocity(Angle(0, client:EyeAngles().y, 0):Forward() * charge.vel)
		end
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
