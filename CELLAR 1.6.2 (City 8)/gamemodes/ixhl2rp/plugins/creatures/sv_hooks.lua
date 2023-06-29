function PLUGIN:PlayerJoinedClass(client, class)
	local classTable = ix.class.list[class]
	
	if classTable then
		local info = classTable.infoTable

		if info then
			client.infoTable = info

			if classTable.model then
				client:SetModel(classTable.model)
			end

			self:SetupCreatureClass(client, class, info)
		end
	end
end

function PLUGIN:PostPlayerLoadout(client)
	timer.Simple(0, function()
		self:ResetCreatureClass(client)

		local class = client:GetCharacter():GetClass()
		local classTable = ix.class.list[class]

		if classTable then
			local info = classTable.infoTable
			
			if info then
				client.infoTable = info

				if classTable.model then
					client:SetModel(classTable.model)
				end

				self:SetupCreatureClass(client, class, info)
			else
				if client.infoTable then
					self:ResetCreatureClass(client)
				end
			end
		end
	end)
end

net.Receive("FlashlightSwitched", function(len, client)
	local infoTable = client:GetClassTable()

	if (infoTable) then
		if infoTable.flashlight then
			infoTable.flashlight(client, infoTable)
		end
	end
end)

function PLUGIN:GetPlayerPainSound(client)
	local infoTable = client:GetClassTable()

	if (infoTable) then
		local soundTable = infoTable.sounds

		if (soundTable.pain) then
			local snd

			if (istable(soundTable.pain)) then
				snd = table.Random(soundTable.pain)
			else
				snd = soundTable.pain
			end

			return snd
		end
	end
end

function PLUGIN:GetPlayerDeathSound(client)
	local infoTable = client:GetClassTable()

	if (infoTable) then
		local soundTable = infoTable.sounds

		if (soundTable.die) then
			local snd

			if (istable(soundTable.die)) then
				snd = table.Random(soundTable.die)
			else
				snd = soundTable.die
			end

			return snd
		end
	end
end

function PLUGIN:DoAnimationEvent(client, event, data)
	local info = client:GetClassTable()
	
	if info then
		if event == PLAYERANIMEVENT_JUMP then
			if info.jump then
				return ACT_INVALID
			end
		end
	end
end

function PLUGIN:PlayerTick(client)
	if client:IsBot() then
		return
	end

	local info = client:GetClassTable()

	if info then
		if info.think then
			info.think(client, info)
		end

		if !client:IsOnGround() then
			if info.glideThink then
				info.glideThink(client, info)
			end
		end
	end
end

function PLUGIN:ModifyCharacterRunSpeed(client)
	if client.infoTable then
		if (client.infoTable.moveData or {}).run then
			return (client.infoTable.moveData or {}).run
		end
	end
end

hook.Add("prone.CanEnter", "Creatures", function(client)
	if client.infoTable then
		return false
	end
end)