
PLUGIN.name = "LOOC Steam Name"
PLUGIN.author = "LegAz"
PLUGIN.description = "Use steam name in LOOC when player is in ovserver."

if (SERVER) then
	local helix = GM or GAMEMODE

	function helix:PlayerSay(client, text)
		local chatType, message, anonymous = ix.chat.Parse(client, text, true)

		if (chatType == "ic") then
			if (ix.command.Parse(client, message)) then
				return ""
			end
		end

		local data

		if (chatType == "looc" and !client:InVehicle() and client:GetMoveType() == MOVETYPE_NOCLIP and CAMI.PlayerHasAccess(client, "Helix - Observer", nil)) then
			data = {steamName = client:SteamName()}
		end

		text = ix.chat.Send(client, chatType, message, anonymous, nil, data)

		if (isstring(text) and chatType != "ic") then
			ix.log.Add(client, "chat", chatType and chatType:utf8upper() or "??", text)
		end

		hook.Run("PostPlayerSay", client, chatType, message, anonymous)

		return ""
	end
else
	local cellarDoor22 = Material("cellar/main/cellardoor22.png")

	function PLUGIN:InitializedChatClasses()
		ix.chat.classes["looc"].OnChatAdd = function(self, speaker, text, _, data)
			if (data.steamName) then
				chat.AddText(cellarDoor22, Color(255, 50, 50), "[LOOC] ", ix.config.Get("chatColor"), data.steamName .. ": " .. text)
			else
				chat.AddText(Color(255, 50, 50), "[LOOC] ", ix.config.Get("chatColor"), speaker:Name() .. ": " .. text)
			end
		end
	end
end
