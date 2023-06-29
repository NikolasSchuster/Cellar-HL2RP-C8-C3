local GM = GM or GAMEMODE

function GM:PlayerInitialSpawn(client)
	client.ixJoinTime = RealTime()

	if (client:IsBot()) then
		local botID = os.time() + client:EntIndex()
		local index = math.random(1, table.Count(ix.faction.indices))
		local faction = ix.faction.indices[index]

		local data = {
			name = client:Name(),
			faction = faction and faction.uniqueID or "unknown",
			model = faction and table.Random(faction:GetModels(client, table.Random(faction.genders or {GENDER_MALE, GENDER_FEMALE}))) or "models/gman.mdl",
			specials = {
				["st"] = 3,
				["ag"] = 3,
				["pe"] = 3,
				["en"] = 3,
				["in"] = 3,
				["lk"] = 3,
			},
			skills = {}
		}
		for a, b in pairs(ix.skills.list) do
			data.skills[a] = {0, 0, 0}
		end
		local character = ix.char.New(data, botID, client, client:SteamID64())
		character.isBot = true

		local inventory = ix.inventory.Create(ix.config.Get("inventoryWidth"), ix.config.Get("inventoryHeight"), botID)
		inventory:SetOwner(botID)
		inventory.noSave = true

		character.vars.inv = {inventory}

		ix.char.loaded[botID] = character

		character:Setup()
		character.limbobject = LDATA_HUMAN_MALE
		client:Spawn()

		ix.chat.Send(nil, "connect", client:SteamName())

		return
	end

	ix.config.Send(client)
	ix.date.Send(client)

	client:LoadData(function(data)
		if (!IsValid(client)) then return end

		-- Don't use the character cache if they've connected to another server using the same database
		local address = ix.util.GetAddress()
		local bNoCache = client:GetData("lastIP", address) != address
		client:SetData("lastIP", address)

		net.Start("ixDataSync")
			net.WriteTable(data or {})
			net.WriteUInt(client.ixPlayTime or 0, 32)
		net.Send(client)

		ix.char.Restore(client, function(charList)
			if (!IsValid(client)) then return end

			MsgN("Loaded (" .. table.concat(charList, ", ") .. ") for " .. client:Name())

			for _, v in ipairs(charList) do
				ix.char.loaded[v]:Sync(client)
			end

			client.ixCharList = charList

			net.Start("ixCharacterMenu")
			net.WriteUInt(#charList, 6)

			for _, v in ipairs(charList) do
				net.WriteUInt(v, 32)
			end

			net.Send(client)

			client.ixLoaded = true
			client:SetData("intro", true)

			for _, v in ipairs(player.GetAll()) do
				if (v:GetCharacter()) then
					v:GetCharacter():Sync(client)
				end
			end
		end, bNoCache)

		ix.chat.Send(nil, "connect", client:SteamName())
	end)

	client:SetNoDraw(true)
	client:SetNotSolid(true)
	client:Lock()
	client:SyncVars()

	timer.Simple(1, function()
		if (!IsValid(client)) then
			return
		end

		client:KillSilent()
		client:StripAmmo()
	end)
end

function PLUGIN:CanPlayerUseCharacter(client, character)
	local currentChar = client:GetCharacter()

	if currentChar then
		local status, result = hook.Run("CanPlayerSwitchCharacter", client, currentChar, character)

		if status == false then
			return status, result
		end
	end
end

function PLUGIN:CanPlayerSwitchCharacter(client, character, newCharacter)
	if IsValid(client.ixRagdoll) then
		return false, "@notNow"
	end

	if client:GetNetVar("forcedSequence") then
		return false, "@notNow"
	end
end

