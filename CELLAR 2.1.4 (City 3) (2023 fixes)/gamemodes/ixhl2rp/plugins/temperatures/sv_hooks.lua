local PLUGIN = PLUGIN


function PLUGIN:OnPlayerAreaChanged(client, oldID, newID)
	local valid = string.StartWith(ix.area.stored[newID].type, "temperature")
	local bTimer = timer.Exists("ixTemp" .. client:SteamID())

	if valid and not bTimer then
		self:SetupTempTimer(client)
	elseif not valid and bTimer then
		timer.Remove("ixTemp" .. client:SteamID())
	end
end

function PLUGIN:SetupTempTimer(client)
	local uniqueID = "ixTemp" .. client:SteamID()
	timer.Remove(uniqueID)

	local character = client:GetCharacter()
	if character then
		local faction = ix.faction.indices[character:GetFaction()]

		if faction.tempImmunity then
			return
		end
	else
		return
	end

	timer.Create(uniqueID, ix.config.Get("tempTickTime", 4), 0, function()
		if not IsValid(client) then
			timer.Remove(uniqueID)
			return
		end

		self:TempTick(client)
	end)
end

function PLUGIN:CharacterLoaded(character)
	local client = character:GetPlayer()
	self:SetupTempTimer(client)
	client:SetLocalVar("coldCounter", character:GetData("coldCounter", 100))
end
