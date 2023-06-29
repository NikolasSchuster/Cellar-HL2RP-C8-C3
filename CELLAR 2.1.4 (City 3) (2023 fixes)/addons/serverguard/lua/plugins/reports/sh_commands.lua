--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local command = {};

command.help = "Report something to the admins.";
command.command = "report";
command.bDisallowConsole = true;

function command:Execute(player, silent, arguments)
	serverguard.netstream.Start(player, "sgStartReport", true);
end;

plugin:AddCommand(command);