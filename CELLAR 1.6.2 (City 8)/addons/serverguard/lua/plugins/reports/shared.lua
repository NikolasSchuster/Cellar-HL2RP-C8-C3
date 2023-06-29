--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Reports";
plugin.author = "`impulse";
plugin.version = "1.0";
plugin.description = "A system to let players report something to admins.";
plugin.permissions = {"Manage Reports", "Delete All Reports"};

serverguard.phrase:Add("english", "report_received", {
	SERVERGUARD.NOTIFY.RED, "[REPORT] ", SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, ": %s"
});

local config = serverguard.config.Create("reports");
	config:SetPermission("Manage Reports");
	config:AddBoolean("alert", true, "Alert staff members of a new report.");
	config:AddBoolean("tracker", true, "Track staff statistics for reports.");
plugin.config = config:Load();