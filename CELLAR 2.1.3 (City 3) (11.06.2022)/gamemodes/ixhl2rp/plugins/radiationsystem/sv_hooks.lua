function PLUGIN:PlayerLoadedCharacter(client, character, lastCharacter)
	local steamID = client:SteamID64()

	timer.Create("ixRad" .. steamID, 1, 0, function()
		if (IsValid(client) and character) then
			self:RadTick(client, character)
		else
			timer.Remove("ixRad" .. steamID)
		end
	end)
end

function PLUGIN:OnPlayerRespawn(target)
	local character = target:GetCharacter()

	if (character) then
		character:SetRadLevel(0)
	end
end

function PLUGIN:PlayerDeath(client)
	local character = client:GetCharacter()
	local timerID = "ixRadDmg" .. client:SteamID64()

	if (character) then
		character:SetRadLevel(0)
	end

	client.radDmgType = nil
	client.lastRadDmgType = nil
	client.lastRadNotify = nil
	client.lastRadLevel = nil

	timer.Remove(timerID)
end

function PLUGIN:OnPlayerRadLevelChanged(client, character, oldRad, newRad)
	if newRad > 899 then
		client:RadNotify(5)
	elseif newRad > 599 then
		client:RadNotify(4)
	elseif newRad > 449 then
		client:RadNotify(3)
	elseif newRad > 299 then
		client:RadNotify(2)
	elseif newRad > 149 then
		client:RadNotify(1)
	else
		client.lastRadNotify = nil
	end

	client.radDmgType = nil
	client.lastRadDmgType = client.lastRadDmgType or nil

	if newRad > 999 then
		client.radDmgType = 1
	elseif newRad > 899 then
		client.radDmgType = 2
	end

	if client.lastRadDmgType != client.radDmgType then
		local timerID = "ixRadDmg" .. client:SteamID64()
		local t = client.radDmgType == 2 and 20 or 0.5

		if timer.Exists(timerID) then
			timer.Adjust(timerID, t)
		else
			timer.Create(timerID, t, 0, function()
				if (IsValid(client) and character) then
					client:RadDamage()
				else
					timer.Remove(timerID)
				end
			end)
		end

		client.lastRadDmgType = client.radDmgType
	end
end

function PLUGIN:RadTick(client, character)
	if (client.lastRadLevel or 0) != character:GetRadLevel() then
		hook.Run("OnPlayerRadLevelChanged", client, character, client.lastRadLevel, character:GetRadLevel())
		client.lastRadLevel = character:GetRadLevel()
	end

	if !client:IsInArea() and client:GetNetVar("radDmg") then
		client:SetNetVar("radDmg", nil)
		return
	elseif client:IsInArea() and !client:GetNetVar("radDmg") then
		local area = ix.area.stored[client:GetArea()]
	
		if area and area.type == "rad" then
			client:SetNetVar("radDmg", area.properties.radDamage or 0)
		end
	end

	if !client:Alive() or client:GetMoveType() == MOVETYPE_NOCLIP then
		return
	end

	if !client:GetNetVar("radDmg") then
		return
	end

	local rad = client:GetNetVar("radDmg")
	local radResistance = character:GetRadResistance()
	local filter = character:HasWearedFilter()

	if filter and filter:GetFilterQuality() > 0 then
		local value = math.abs(math.max(0.0025, rad * 0.05))

		filter:SetFilterQuality(math.max(filter:GetFilterQuality() - value, 0))
	end

	rad = math.Round(rad + ((rad / 100) * (radResistance - (radResistance * 2))), 2)

	if client:InOutlands() and rad > 0 then
		rad = rad / 2
	end

	if rad > 0 then
		character:SetRadLevel(character:GetRadLevel() + rad)
	end
end

function PLUGIN:OnPlayerAreaChanged(client, oldID, newID)
	local area = ix.area.stored[newID]

	if area and area.type == "rad" then
		client:SetNetVar("radDmg", area.properties.radDamage or 0)
	else
		client:SetNetVar("radDmg", nil)
	end
end