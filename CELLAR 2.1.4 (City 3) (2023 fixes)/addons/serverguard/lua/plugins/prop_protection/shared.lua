--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Prop Protection";
plugin.author = "`impulse";
plugin.version = "1.0";
plugin.description = "Protects props etc from being touched by other players.";
plugin.gamemodes = {"sandbox", "spacebuild"};
plugin.permissions = {"Manage Prop-Protection", "Bypass Prop-Protection", "Manage Prop Blacklist", "Bypass Prop Blacklist", "Bypass Prop Deletion", "Bypass Prop Spam"};

local config = serverguard.config.Create("propprotection");
	config:SetPermission("Manage Prop-Protection");
	config:AddBoolean("useprotection", false, "Global 'use' protection");
	config:AddBoolean("propdamage", false, "Allow props to damage players");
	config:AddBoolean("propblacklist", false, "Prop blacklist");
	config:AddBoolean("propspam", false, "Prop spam protection");
	config:AddBoolean("autodelete", false, "Auto-delete disconnected players' props");
plugin.config = config:Load();

serverguard.phrase:Add("english", "command_cleanup", {SERVERGUARD.NOTIFY.GREEN, "%s", SERVERGUARD.NOTIFY.WHITE, " has removed ", SERVERGUARD.NOTIFY.RED, "%s", SERVERGUARD.NOTIFY.WHITE, "%s props."});

local oldWorldEntity = game.GetWorld;

function game.GetWorld()
	if (SERVER) then
		return oldWorldEntity();
	elseif (CLIENT) then
		return Entity(0);
	end;
end;

local table = table;

function plugin.IsFriend(owner, target)
	if (owner == target) then return true end;
	
	--if (!owner.serverguard or !player.serverguard) then return false end
	
	-- Check if any new friends were added.
	local buddies = SERVER and owner.serverguard.prop_protection.buddies or CLIENT and g_serverGuard.prop_protection.buddies;
	
	if (!buddies) then return false end;
	
	local friends = owner:CPPIGetFriends();
	local players = player.GetHumans();
	
	for i = 1, #players do
		local pPlayer = players[i];
		
		if (IsValid(pPlayer)) then
			for i2 = 1, #buddies do
				local steamID = buddies[i2];
				
				-- If the player is in the server and is in the players buddy table.
				if (pPlayer:SteamID() == steamID) then
					if (!table.HasValue(friends, pPlayer)) then
						table.insert(friends, pPlayer);
					end;
				end;
			end;
		end;
	end;
	
	-- Not in the buddy table? Remove from friends!
	for i = 1, #friends do
		local friend = friends[i];
		
		if (!IsValid(friend)) then
			table.remove(friends, i);
		else
			if (!table.HasValue(buddies, friend:SteamID())) then
				table.remove(friends, i);
			end;
		end;
	end;
	
	friends = owner:CPPIGetFriends();

	for k, friend in pairs(friends) do
		if (friend == target) then
			return true;
		end;
	end;
end;