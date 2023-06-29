local PLUGIN = PLUGIN

util.AddNetworkString("donateNotify")

do
	local PLAYER = FindMetaTable("Player")

	function PLAYER:GiveDonatorWeapons()
		self:Give("weapon_physgun")
		self:Give("gmod_tool")
	end

	function PLAYER:StripDonator()
		local character = self:GetCharacter()

		if character then
			if !character:HasFlags("p") then
				self:StripWeapon("weapon_physgun")
			end

			if !character:HasFlags("t") then
				self:StripWeapon("gmod_tool")
			end

			if ix.faction.indices[character:GetFaction()].bSubscriber then
				character:Kick()
			end
		end

		for k, faction in pairs(ix.faction.indices) do
			if faction.bSubscriber then
				self:SetWhitelisted(k, false)
				continue
			end
		end
	end
end

function PLUGIN:CharacterLoaded(character)
	local client = character:GetPlayer()
	local index = client:GetData("vault", 0) or 0

	if index == 0 then
		ix.inventory.New(0, "vault", function(inventory)
			inventory.vars.isBag = true

			client:SetData("vault", inventory:GetID())
		end)
	end

	if client:IsSuperAdmin() then return end

	for k, faction in pairs(ix.faction.indices) do
		if faction.bSubscriber then
			if faction.name == "Zombie" and client:GetData("z_whitelist") then return end
			client:SetWhitelisted(k, client:IsDonator())
		end
	end

end

function PLUGIN:PlayerInitialSpawn(client)
	local query = mysql:Select("ix_players")
		query:Select("data")
		query:Where("steamid", client:SteamID64())
		query:Limit(1)
		query:Callback(function(result)
			if istable(result) and #result > 0 then
				local data = util.JSONToTable(result[1].data or "[]")

				if data.donator then
					if os.time() > tonumber(data.donateTime) then
						client.notifySubscription = 2

						data.donator = nil
						data.donateTime = nil

						local updateQuery = mysql:Update("ix_players")
							updateQuery:Update("data", util.TableToJSON(data))
							updateQuery:Where("steamid", client:SteamID64())
						updateQuery:Execute()

						client:SetData("donator", nil)
						client:SetData("donateTime", nil)
						client:StripDonator()
					else
						client.notifySubscription = 1

						client:SetNetVar("donator", true)
					end
				end
			end
		end)
	query:Execute()
end

function PLUGIN:PostPlayerLoadout(client)
	if client:IsDonator() then
		client:GiveDonatorWeapons()
	end

	if client.notifySubscription then
		net.Start("donateNotify")
			net.WriteUInt(client.notifySubscription, 2)
		net.Send(client)

		client.notifySubscription = nil
	end
end

function PLUGIN:PlayerSpawnProp(client)
	if (client:GetCharacter() and client:IsDonator()) then
		return true
	end
end
/*
function PLUGIN:pac_CanWearParts(client)
	if client:IsDonator() then
		return true
	end
end*/

function PLUGIN:SetDonateSubscription(steamid64, timeLeft, callback)
	timeLeft = timeLeft or (os.time() + 2592000)

	local query = mysql:Select("ix_players")
		query:Select("data")
		query:Where("steamid", steamid64)
		query:Limit(1)
		query:Callback(function(result)
			if istable(result) and #result > 0 then
				local data = util.JSONToTable(result[1].data or "[]")
				local whitelists = data.whitelists and data.whitelists[Schema.folder]

				if !whitelists then
					whitelists = {}
				end

				for k, faction in pairs(ix.faction.indices) do
					if faction.bSubscriber then
						whitelists[faction.uniqueID] = true
						continue
					end
				end

				data.donator = true
				data.donateTime = timeLeft

				local updateQuery = mysql:Update("ix_players")
					updateQuery:Update("data", util.TableToJSON(data))
					updateQuery:Where("steamid", steamid64)
				updateQuery:Execute()

				if callback then
					callback(true)
				end

				for _, v in ipairs(player.GetAll()) do
					if v:SteamID64() == steamid64 then
						v:SetData("donator", true)
						v:SetData("donateTime", timeLeft)
						v:SetNetVar("donator", true)

						for k, faction in pairs(ix.faction.indices) do
							if faction.bSubscriber then
								v:SetWhitelisted(k, true)
								continue
							end
						end

						v:GiveDonatorWeapons()

						net.Start("donateNotify")
							net.WriteUInt(0, 2)
						net.Send(v)

						break
					end
				end
			else
				if callback then
					callback(false)
				end
			end
		end)
	query:Execute()
end

function PLUGIN:AddDonateSubscription(steamid64, timeLeft, callback)
	timeLeft = timeLeft or 2592000

	local query = mysql:Select("ix_players")
		query:Select("data")
		query:Where("steamid", steamid64)
		query:WhereLike("data", "\"donator\":true")
		query:Limit(1)
		query:Callback(function(result)
			if istable(result) and #result > 0 then
				local data = util.JSONToTable(result[1].data or "[]")

				data.donateTime = data.donateTime + timeLeft

				local updateQuery = mysql:Update("ix_players")
					updateQuery:Update("data", util.TableToJSON(data))
					updateQuery:Where("steamid", steamid64)
				updateQuery:Execute()

				if callback then
					callback(true)
				end

				for _, v in ipairs(player.GetAll()) do
					if v:SteamID64() == steamid64 then
						v:SetData("donateTime", data.donateTime)
						break
					end
				end
			else
				if callback then
					callback(false)
				end
			end
		end)
	query:Execute()
end

function PLUGIN:ResetDonateSubscription(steamid64, callback)
	local query = mysql:Select("ix_players")
		query:Select("data")
		query:Where("steamid", steamid64)
		query:WhereLike("data", "\"donator\":true")
		query:Limit(1)
		query:Callback(function(result)
			if istable(result) and #result > 0 then
				local data = util.JSONToTable(result[1].data or "[]")

				data.donator = nil
				data.donateTime = nil

				local updateQuery = mysql:Update("ix_players")
					updateQuery:Update("data", util.TableToJSON(data))
					updateQuery:Where("steamid", steamid64)
				updateQuery:Execute()

				if callback then
					callback(true)
				end

				for _, v in ipairs(player.GetAll()) do
					if v:SteamID64() == steamid64 then
						v:SetData("donator", nil)
						v:SetData("donateTime", nil)
						v:SetNetVar("donator", nil)

						v:StripDonator()

						net.Start("donateNotify")
							net.WriteUInt(2, 2)
						net.Send(v)

						break
					end
				end
			else
				if callback then
					callback(false)
				end
			end
		end)
	query:Execute()
end

local TIME_CHECK = 3600
timer.Create("ixSubscriptionCheck", TIME_CHECK, 0, function()
	local query = mysql:Select("ix_players")
		query:Select("data")
		query:Select("steamid")
		query:WhereLike("data", "\"donator\":true")
		query:Callback(function(result)
			if istable(result) and #result > 0 then
				for _, v in ipairs(result) do
					local data = util.JSONToTable(v.data or "[]")

					if os.time() > (tonumber(data.donateTime) or 0) then
						data.donator = nil
						data.donateTime = nil

						local updateQuery = mysql:Update("ix_players")
							updateQuery:Update("data", util.TableToJSON(data))
							updateQuery:Where("steamid", v.steamid)
						updateQuery:Execute()

						for _, v in ipairs(player.GetAll()) do
							if v:SteamID64() == v.steamid then
								v:SetData("donator", nil)
								v:SetData("donateTime", nil)
								v:SetNetVar("donator", nil)

								v:StripDonator()

								net.Start("donateNotify")
									net.WriteUInt(2, 2)
								net.Send(v)

								break
							end
						end
					end
				end
			end
		end)
	query:Execute()
end)