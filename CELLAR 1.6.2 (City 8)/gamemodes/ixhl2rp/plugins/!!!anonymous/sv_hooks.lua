local PLUGIN = PLUGIN

PLUGIN.stored = PLUGIN.stored or {}

function PLUGIN:DatabaseConnected()
	local query = mysql:Create("anon_ids")
		query:Create("steamid", "VARCHAR(20) NOT NULL")
		query:Create("anonid", "TEXT NOT NULL")
		query:PrimaryKey("steamid")
	query:Execute()
end

function PLUGIN:CheckPassword(steamID64)
	if !self.stored[steamID64] then
		local query = mysql:Select("anon_ids")
			query:Select("anonid")
			query:Where("steamid", steamID64)
			query:Callback(function(result)
				if (istable(result) and #result > 0) then
					self.stored[steamID64] = result[1].anonid
				else
					self.stored[steamID64] = GenerateAnonID64(steamID64)

					local query = mysql:Insert("anon_ids")
						query:Insert("steamid", tostring(steamID64))
						query:Insert("anonid", self.stored[steamID64])
					query:Execute()
				end
			end)
		query:Execute()
	end
end

function PLUGIN:PlayerInitialSpawn(client)
	local steamID = client:SteamID64()

	if self.stored[steamID] then
		client:SetNetVar("AnonID", self.stored[steamID])
	else
		client:SetNetVar("AnonID", GenerateAnonID64(steamID))
	end

	timer.Simple(5, function()
		if IsValid(client) then
			self:SendDeanonData(client)
		end
	end)
end

function PLUGIN:PrePlayerLoadedCharacter(client, character, oldcharacter)
	if CAMI.PlayerHasAccess(client, "DEANONYMOUS", nil) and !self.deanoners[client] then
		self.deanoners[client] = true

		self:SendAllDeanonData(client)
	end
end

require("statusx")
require("query")

query.EnableInfoDetour(true)

function PLUGIN:GetOnline()
	return player.GetCount()
end

local cache_steamid = {}
function PLUGIN:STATUS_PLAYERINFO(client, players)
	local ourinfo = {}
	local lastUserID = 2

  	for k, v in pairs(players) do
  		if !cache_steamid[v.steamid] then
  			cache_steamid[v.steamid] = util.SteamIDTo64(v.steamid)
  		end
  		local a = player.GetBySteamID64(util.SteamIDTo64(v.steamid))
  		local name = "Anon"
  		if a and a:GetCharacter() then
  			name = a:GetName()
  		end
  		v.userid = lastUserID
  		v.name = name
		v.steamid = self.stored[cache_steamid[v.steamid]] or "BOT"

		ourinfo[#ourinfo + 1] = v
		lastUserID = lastUserID + 1
	end

	return ourinfo
end

function PLUGIN:A2S_PLAYER(ip, port, info)
	local ourinfo = {}

	for k, v in ipairs(player.GetAll()) do
		local char = v:GetCharacter()

		local data = {
			name = char and char:GetName() or "Anon",
			score = v:Frags(),
			time = v:TimeConnected()
		}

		ourinfo[#ourinfo + 1] = data
	end

    return ourinfo
end
