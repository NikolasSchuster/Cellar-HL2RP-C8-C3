--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Private Messaging";
plugin.author = "duck";
plugin.version = "1.0";
plugin.description = "Allows players to private message each other.";
plugin.permissions = {"Manage Private Messages", "Delete All Private Messages"};
plugin.messages = {};

serverguard.phrase:Add("english", "command_pm_received", {SERVERGUARD.NOTIFY.RED, "[PM] ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, ": %s"});
serverguard.phrase:Add("english", "command_pm_sent", {SERVERGUARD.NOTIFY.RED, "[PM] ", SERVERGUARD.NOTIFY.WHITE, "You to ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, ": %s"});