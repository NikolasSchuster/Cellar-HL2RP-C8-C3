--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Watchlist";
plugin.author = "duck";
plugin.version = "1.0";
plugin.description = "Track the troublemakers.";
plugin.permissions = {"Manage Watchlist"};

serverguard.phrase:Add("english", "watchlist", {
	SERVERGUARD.NOTIFY.GREEN, "[Watchlist] ", SERVERGUARD.NOTIFY.RED, "%s", " (%s)", SERVERGUARD.NOTIFY.WHITE, " has joined the server."
});

serverguard.phrase:Add("english", "watchlist_note", {
	SERVERGUARD.NOTIFY.GREEN, "[Watchlist] ", SERVERGUARD.NOTIFY.RED, "%s", " (%s)", SERVERGUARD.NOTIFY.WHITE, " has joined the server (%s)"
});

serverguard.phrase:Add("english", "now_watching", {
	SERVERGUARD.NOTIFY.GREEN, "[Watchlist] ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " is now being watched."
});

serverguard.phrase:Add("english", "not_watching", {
	SERVERGUARD.NOTIFY.GREEN, "[Watchlist] ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, " is no longer being watched."
});