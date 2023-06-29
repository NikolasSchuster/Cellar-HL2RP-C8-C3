--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

function plugin:Send(ply)
	local queryObj = serverguard.mysql:Select("serverguard_watchlist");
		queryObj:Callback(function(result, status, lastID)
			if (IsValid(ply)) then
				serverguard.netstream.Start(ply, "WatchlistGet", result or {});
			end;
		end);
	queryObj:Execute();
end;

function plugin:Add(steam_id, note, callingPlayer)
	steam_id = string.SteamID(steam_id);
	note = note or "";

	if (steam_id) then
		local queryObj = serverguard.mysql:Select("serverguard_watchlist");
			queryObj:Where("steam_id", steam_id);
			queryObj:Limit(1);
			queryObj:Callback(function(result, status, lastID)
				if (type(result) == "table" and #result > 0) then
					local updateObj = serverguard.mysql:Update("serverguard_watchlist");
						updateObj:Update("note", note);
						updateObj:Where("steam_id", steam_id);
						updateObj:Limit(1);
						updateObj:Callback(function()
							if (IsValid(callingPlayer)) then
								serverguard.Notify(SGPF("now_watching", steam_id));
								plugin:Send(callingPlayer);
							end;
						end);
					updateObj:Execute();
				else
					local insertObj = serverguard.mysql:Insert("serverguard_watchlist");
						insertObj:Insert("steam_id", steam_id);
						insertObj:Insert("note", note);
						insertObj:Callback(function()
							if (IsValid(callingPlayer)) then
								serverguard.Notify(callingPlayer, SGPF("now_watching", steam_id));
								plugin:Send(callingPlayer);
							end;
						end);
					insertObj:Execute();
				end;
			end);
		queryObj:Execute();
	end;
end;


function plugin:Edit(steam_id, note, callingPlayer)
	steam_id = string.SteamID(steam_id);
	note = note or "";
	if (steam_id) then
		local queryObj = serverguard.mysql:Select("serverguard_watchlist");
			queryObj:Where("steam_id", steam_id);
			queryObj:Limit(1);
			queryObj:Callback(function(result, status, lastID)
				if (type(result) == "table" and #result > 0) then
					local updateObj = serverguard.mysql:Update("serverguard_watchlist");
						updateObj:Update("note", note);
						updateObj:Where("steam_id", steam_id);
						updateObj:Limit(1);
					updateObj:Execute();
				end	
			end);
		queryObj:Execute();
	end;
end;


function plugin:Remove(steam_id, callingPlayer)
	steam_id = string.SteamID(steam_id);

	if (steam_id) then
		local deleteObj = serverguard.mysql:Delete("serverguard_watchlist");
			deleteObj:Where("steam_id", steam_id);
			deleteObj:Callback(function()
				if (IsValid(callingPlayer)) then
					serverguard.Notify(callingPlayer, SGPF("not_watching", steam_id));
					plugin:Send(callingPlayer);
				end;
			end);
		deleteObj:Execute();
	end;
end;

plugin:Hook("serverguard.mysql.CreateTables", "serverguard.watchlist.CreateTables", function()
	local WATCHLIST_TABLE_QUERY = serverguard.mysql:Create("serverguard_watchlist");
		WATCHLIST_TABLE_QUERY:Create("steam_id", "VARCHAR(255) NOT NULL");
		WATCHLIST_TABLE_QUERY:Create("note", "VARCHAR(255) NOT NULL");
		WATCHLIST_TABLE_QUERY:PrimaryKey("steam_id");
	WATCHLIST_TABLE_QUERY:Execute();
end);

plugin:Hook("PlayerInitialSpawn", "serverguard.watchlist.PlayerInitialSpawn", function(ply)
	local queryObj = serverguard.mysql:Select("serverguard_watchlist");
		queryObj:Where("steam_id", ply:SteamID());
		queryObj:Limit(1);
		queryObj:Callback(function(result, status, lastID)
			if (type(result) == "table" and #result > 0) then
				local admins = {};

				for k, v in pairs(player.GetAll()) do
					if (v:IsAdmin()) then
						admins[#admins + 1] = v;
					end;
				end;

				if (result[1].note == "") then
					serverguard.Notify(admins, SGPF("watchlist", ply:Name(), ply:SteamID()));
				else
					serverguard.Notify(admins, SGPF("watchlist_note", ply:Name(), ply:SteamID(), result[1].note));
				end;
			end;
		end);
	queryObj:Execute();
end);

serverguard.netstream.Hook("WatchlistGet", function(ply, data)
	if (serverguard.player:HasPermission(ply, "Manage Watchlist")) then
		plugin:Send(ply);
	end;
end);

serverguard.netstream.Hook("WatchlistAdd", function(ply, data)
	if (serverguard.player:HasPermission(ply, "Manage Watchlist")) then
		plugin:Add(data.steam_id, data.note, ply);
	end;
end);

serverguard.netstream.Hook("WatchlistEdit", function(ply, data)
	if (serverguard.player:HasPermission(ply, "Manage Watchlist")) then
		plugin:Edit(data.steam_id, data.note, ply);
	end;
end);

serverguard.netstream.Hook("WatchlistRemove", function(ply, data)
	if (serverguard.player:HasPermission(ply, "Manage Watchlist")) then
		plugin:Remove(data, ply);
	end;
end);