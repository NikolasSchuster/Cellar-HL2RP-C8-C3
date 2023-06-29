--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.CLIENT);
-- plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);