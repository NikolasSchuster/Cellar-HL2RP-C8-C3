local PLUGIN = PLUGIN

do
	local COMMUNITY_ID = 1197960265728
	local SECRET = 1100050505
	local f, band, rshift, r, t, m, sub = string.format, bit.band, bit.rshift, string.reverse, tonumber, string.match, string.sub
	
	local function encodeID(accountID)
		local d = f("%02X", band(accountID, 0xFF))
		local c = f("%02X", band(rshift(accountID, 8), 0xFF))
		local b = f("%02X", band(rshift(accountID, 16), 0xFF))
		local a = f("%02X", band(rshift(accountID, 24), 0xFF))
		local rehexed = r(b)..r(c)..r(a)..r(d)

		return SECRET + t("0x"..rehexed)
	end

	local function decodeID(rawID)
		local d = r(f("%02X", band(rawID, 0xFF)))
		local a = r(f("%02X", band(rshift(rawID, 8), 0xFF)))
		local c = r(f("%02X", band(rshift(rawID, 16), 0xFF)))
		local b = r(f("%02X", band(rshift(rawID, 24), 0xFF)))

		return t("0x"..a..b..c..d)
	end

	function GenerateAnonID(steamid) 
		if steamid == "BOT" then return "BOT" end

		local x, y, z = m(steamid, "STEAM_(%d+):(%d+):(%d+)")

		z = (z * 2) + y

		return f("ANON:%s", encodeID(z))
	end

	function GenerateAnonID64(steamid64) 
		if steamid64 == "BOT" then return "BOT" end

		steamid64 = t(sub(steamid64, 5))
		steamid64 = (steamid64 - COMMUNITY_ID)
		
		return f("ANON:%s", encodeID(steamid64))
	end

	function AnonIDToSteamID(anonID)
        if anonID == "BOT" then return "BOT" end
        
        return util.SteamIDFrom64(AnonIDToSteamID64(anonID))
    end

	function AnonIDToSteamID64(anonID)
		if anonID == "BOT" then return "BOT" end
		anonID = (m(anonID, "ANON:(%d+)") - SECRET)

		local raw = decodeID(anonID)

		return "7656"..(COMMUNITY_ID + raw)
	end
end
/*
do
	local playerMeta = FindMetaTable("Player")
	
	function playerMeta:GetName()
		local character = self:GetCharacter()

		return character and character:GetName() or (!self:IsBot() and self:GetAnonID() or self:SteamName())
	end

	playerMeta.Nick = playerMeta.GetName
	playerMeta.Name = playerMeta.GetName
end
*/
ix.log.AddType("disconnect", function(client, ...)
	if (client:IsTimingOut()) then
		return string.format("%s has disconnected (timed out).", GenerateAnonID64(client:SteamID64()))
	else
		return string.format("%s has disconnected.", GenerateAnonID64(client:SteamID64()))
	end
end, FLAG_NORMAL)

ix.log.AddType("charDelete", function(client, ...)
	local arg = {...}
	return string.format("%s deleted character '%s'", client:GetAnonID(), arg[1])
end, FLAG_SERVER)

ix.log.AddType("connect", function(client, ...)
	return string.format("%s has connected.", GenerateAnonID64(client:SteamID64()))
end, FLAG_NORMAL)

ix.log.AddType("charCreate", function(client, ...)
	local arg = {...}
	return string.format("%s created the character '%s'", client:GetAnonID(), arg[1])
end, FLAG_SERVER)

ix.log.AddType("charLoad", function(client, ...)
	local arg = {...}
	return string.format("%s loaded the character '%s'", client:GetAnonID(), arg[1])
end, FLAG_SERVER)

