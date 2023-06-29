local PLUGIN = PLUGIN

PLUGIN.name = "Anonymous System"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

ix.chat.Register("connect", {
	CanSay = function(self, speaker, text)
		return !IsValid(speaker)
	end,
	OnChatAdd = function(self, speaker, text)
	end,
	noSpaceAfter = true
})

ix.chat.Register("disconnect", {
	CanSay = function(self, speaker, text)
		return !IsValid(speaker)
	end,
	OnChatAdd = function(self, speaker, text)
	end,
	noSpaceAfter = true
})

if CLIENT then
	language.Add("game_player_joined_game", "")
	language.Add("game_player_left_game", "")
end

do
	local PLAYER = FindMetaTable("Player")

	function PLAYER:GetAnonID()
		return self:GetNetVar("AnonID", "BOT") 
	end
end

CAMI.RegisterPrivilege({
	Name = "DEANONYMOUS",
	MinAccess = "founder"
})

if CLIENT then
	PLUGIN.deanon = PLUGIN.deanon or false
	PLUGIN.anonData = PLUGIN.anonData or {}

	net.Receive("ixDeanonAll", function(len)
		local data = net.ReadTable()

		for k, v in pairs(data) do
			local client = Entity(v[1])

			if IsValid(client) and client:IsPlayer() then
				PLUGIN.anonData[client] = {v[2], v[3], v[4]}
			end
		end

		PLUGIN.deanon = true
	end)

	net.Receive("ixDeanon", function(len)
		local client = net.ReadEntity()
		local a = net.ReadString()
		local b = net.ReadString()
		local c = net.ReadString()

		if IsValid(client) and client:IsPlayer() then
			PLUGIN.anonData[client] = {a, b, c}
		end
	end)

	do
		local META = FindMetaTable("Player")

		function META:AnonSteamName()
			if PLUGIN.anonData[self] then
				return PLUGIN.anonData[self][1]
			end
		end

		function META:AnonSteamID()
			if PLUGIN.anonData[self] then
				return PLUGIN.anonData[self][2]
			end
		end

		function META:AnonSteamID64()
			if PLUGIN.anonData[self] then
				return PLUGIN.anonData[self][3]
			end
		end
	end
else
	util.AddNetworkString("ixDeanon")
	util.AddNetworkString("ixDeanonAll")

	PLUGIN.deanoners = PLUGIN.deanoners or {}

	function PLUGIN:SendDeanonData(user, client)
		net.Start("ixDeanon")
			net.WriteEntity(user)
			net.WriteString(user:SteamName())
			net.WriteString(user:SteamID())
			net.WriteString(user:SteamID64())
		if client and client:IsPlayer() then
			net.Send(client)
		else
			local f = RecipientFilter()

			for k, v in pairs(self.deanoners) do
				if !k or !IsValid(k) or k == user then continue end

				f:AddPlayer(k)
			end

			net.Send(f)
		end
	end

	function PLUGIN:SendAllDeanonData(client)
		local tbl = {}

		for k, v in pairs(player.GetAll()) do
			tbl[#tbl + 1] = {v:EntIndex(), v:SteamName(), v:SteamID(), v:SteamID64()}
		end

		net.Start("ixDeanonAll")
			net.WriteTable(tbl)
		net.Send(client)
	end
end

ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")