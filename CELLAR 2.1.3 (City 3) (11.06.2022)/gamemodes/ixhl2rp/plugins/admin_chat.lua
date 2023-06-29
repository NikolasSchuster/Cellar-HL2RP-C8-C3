PLUGIN.name = "Admin Chat"
PLUGIN.author = ""
PLUGIN.description = ""

if SERVER then
	util.AddNetworkString("ixOpenURL")
else
	local urls = {
		[0] = "https://discord.gg/4zYr654",
		[1] = "https://steamcommunity.com/sharedfiles/filedetails/?id=2625033591",
		[2] = "https://docs.google.com/document/d/1wU3DDNXKDVSNenq9wecuqXYBNQaAVi7YAFOtO81pbBE",
		[3] = "https://docs.google.com/document/d/1kXwYo3sBgtdsuVu1y8ucaJvTJu2PRtKsmhL2FGdziBo",
		[4] = "https://www.youtube.com/watch?v=FwuQILSwWXE",
	}

	net.Receive("ixOpenURL", function(len)
	    gui.OpenURL(urls[net.ReadUInt(3)])
	end)
end

CAMI.RegisterPrivilege({
	Name = "Helix - Admin Chat",
	MinAccess = "admin"
})

ix.chat.Register("adminchat", {
	format = "whocares",
	OnGetColor = function(self, speaker, text)
		return Color(0, 196, 255)
	end,
	OnCanHear = function(self, speaker, listener)
		if (CAMI.PlayerHasAccess(listener, "Helix - Admin Chat", nil)) then
			return true
		end

		return false
	end,
	OnCanSay = function(self, speaker, text)
		if (CAMI.PlayerHasAccess(speaker, "Helix - Admin Chat", nil)) then
			speaker:Notify("You aren't an admin. Use '@messagehere' to create a ticket.")

			return false
		end

		return true
	end,
	OnChatAdd = function(self, speaker, text)
		local icon = serverguard.ranks:GetRank(serverguard.player:GetRank(speaker)).texture or "icon16/user.png"

		icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

		if (CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Admin Chat", nil) and CAMI.PlayerHasAccess(speaker, "Helix - Admin Chat", nil)) then
			chat.AddText(icon, Color(255, 215, 0), "[А] ", Color(128, 0, 255, 255), (speaker:AnonSteamName() and "("..speaker:AnonSteamName()..") " or "")..speaker:Name(), ": ", Color(255, 255, 255), text)
		end
	end,
	prefix = "/a"
})

ix.command.Add("Discord", {
	description = "Ссылка на дискорд сервера.",
	OnRun = function(self, client)
		net.Start("ixOpenURL")
			net.WriteUInt(0, 3)
		net.Send(client)
	end,
	bNoIndicator = true
})

ix.command.Add("Content", {
	description = "Ссылка на контент сервера.",
	OnRun = function(self, client)
		net.Start("ixOpenURL")
			net.WriteUInt(1, 3)
		net.Send(client)
	end
})

ix.command.Add("Guide", {
	description = "Ссылка на гайд сервера.",
	OnRun = function(self, client)
		net.Start("ixOpenURL")
			net.WriteUInt(2, 3)
		net.Send(client)
	end
})

ix.command.Add("Rules", {
	description = "Ссылка на правила сервера.",
	OnRun = function(self, client)
		net.Start("ixOpenURL")
			net.WriteUInt(3, 3)
		net.Send(client)
	end
})

ix.command.Add("Video", {
	description = "Ссылка на видео-гайд сервера.",
	OnRun = function(self, client)
		net.Start("ixOpenURL")
			net.WriteUInt(4, 3)
		net.Send(client)
	end
})