local PLUGIN = PLUGIN

PLUGIN.name = "Family Restrict"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

if CLIENT then
	return
end

local whitelist = {
	["76561198313137317"] = true,
	["76561199056812629"] = true
}
function PLUGIN:PlayerInitialSpawn(client)
	local steamid64 = client:SteamID64()
	
	if !client:IsBot() and client:OwnerSteamID64() != steamid64 and !whitelist[steamid64] then
		client:Kick("Аккаунты с семейным доступом запрещены!")
	end
end
