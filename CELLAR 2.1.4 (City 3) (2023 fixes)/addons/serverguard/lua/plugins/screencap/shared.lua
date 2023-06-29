--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Screen Capture";
plugin.author = "alexgrist";
plugin.version = "1.0";
plugin.description = "Capture someones screen and view it.";
plugin.permissions = {"Screencap"};

do
	local META = FindMetaTable("Player")

	function META:UID()
		return util.CRC("anon_"..self:Name()..self:EntIndex())
	end
end