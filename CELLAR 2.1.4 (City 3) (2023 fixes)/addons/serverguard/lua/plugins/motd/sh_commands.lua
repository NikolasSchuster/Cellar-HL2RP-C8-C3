--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local command = {};

command.help = "Open the MOTD.";
command.command = "motd";

function command:Execute(player, silent, arguments)
	serverguard.netstream.Start(player, "sgOpenMOTD", 1);
end;

plugin:AddCommand(command);