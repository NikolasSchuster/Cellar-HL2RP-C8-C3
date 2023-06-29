--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.SHARED);
-- plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

-- plugin:Hook("serverguard.mysql.CreateTables", "serverguard.private_messaging.CreateTables", function()
-- 	local PM_TABLE_QUERY = serverguard.mysql:Create("serverguard_pms");
-- 		PM_TABLE_QUERY:Create("id", "INTEGER NOT NULL AUTO_INCREMENT");
-- 		PM_TABLE_QUERY:Create("sender", "VARCHAR(255) NOT NULL");
-- 		PM_TABLE_QUERY:Create("sender_steamid", "VARCHAR(255) NOT NULL");
-- 		PM_TABLE_QUERY:Create("receiver", "VARCHAR(255) NOT NULL");
-- 		PM_TABLE_QUERY:Create("receiver_steamid", "VARCHAR(255) NOT NULL");
-- 		PM_TABLE_QUERY:Create("message", "VARCHAR(255) NOT NULL");
-- 		PM_TABLE_QUERY:PrimaryKey("id");
-- 	PM_TABLE_QUERY:Execute();
-- end);

-- plugin:Hook("serverguard.mysql.OnConnected", "serverguard.private_messaging.OnConnected", function()
-- 	local queryObj = serverguard.mysql:Select("serverguard_pms");
-- 		queryObj:Callback(function(result, status, lastID)
-- 			if (type(result) == "table" and #result > 0) then
-- 				plugin.messages = result;
-- 			end;
-- 		end);
-- 	queryObj:Execute();
-- end);

-- serverguard.netstream.Hook("sgGetPrivateMessages", function(player, data)
-- 	if (serverguard.player:HasPermission(player, "Manage Private Messages")) then
-- 		serverguard.netstream.StartChunked(player, "sgGetPrivateMessages", plugin.messages);
-- 	end;
-- end);

-- serverguard.netstream.Hook("sgRemovePrivateMessage", function(player, data)
-- 	if (serverguard.player:HasPermission(player, "Manage Private Messages")) then
-- 		local id = data;

-- 		if (tonumber(id)) then
-- 			for k, v in pairs(plugin.messages) do
-- 				if (v.id == id) then
-- 					plugin.messages[k] = nil;
-- 				end;
-- 			end;

-- 			local deleteObj = serverguard.mysql:Delete("serverguard_pms");
-- 				deleteObj:Where("id", id);
-- 				deleteObj:Callback(function()
-- 					if (IsValid(player)) then
-- 						serverguard.netstream.StartChunked(player, "sgGetPrivateMessages", plugin.messages);
-- 					end;
-- 				end);
-- 			deleteObj:Execute();
-- 		elseif (serverguard.player:HasPermission(player, "Delete All Private Messages")) then
-- 			serverguard.mysql:Delete("serverguard_pms"):Execute();
-- 			table.Empty(plugin.messages);
-- 		end;
-- 	end;
-- end);