--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local command = {};

command.help				= "Notifies admins when a certain player connects.";
command.command 			= "watch";
command.arguments 			= {"player"};
command.optionalArguments	= {"note"};
command.permissions 		= {"Manage Watchlist"};

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player);

	if (IsValid(target)) then
		plugin:Add(target:SteamID(), table.concat(arguments, " ", 2), player);
	else
		plugin:Add(arguments[1], table.concat(arguments, " ", 2), player);
	end;
end;

plugin:AddCommand(command);

local command = {};

command.help				= "Removes a player from the watchlist.";
command.command 			= "unwatch";
command.arguments 			= {"steamid"};
command.permissions 		= {"Manage Watchlist"};

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player);

	if (IsValid(target)) then
		plugin:Remove(target:SteamID(), player);
	else
		plugin:Remove(arguments[1], player);
	end;
end;

plugin:AddCommand(command);