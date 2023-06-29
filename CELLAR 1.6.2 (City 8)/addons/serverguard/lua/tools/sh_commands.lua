--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

--
-- Ban lengths, in seconds.
--

serverguard.banLengths = {
	{"1 Minute",		1},
	{"10 Minutes",		10},
	{"30 Minutes",		30},
	{"1 Hour",			60},
	{"6 Hours",			360},
	{"1 Day",			1440},
	{"1 Week",			10080},
	{"1 Month",			43200},
	{"Indefinite",		0}
};

--
-- Simple kick reason list.
--

serverguard.kickReasons = {
	"Spammer",
	"Crashed server",
	"Mingebag",
	"Griefer",
	"Foul language",
	"Disobeying the rules",
	"DDoS Threats"
};


--
-- Jail lengths
--

serverguard.jailLengths = {
	{"1 Minute",		60},
	{"2 Minutes",		120},
	{"5 Minutes",		300},
	{"10 Minutes",		600},
	{"30 Minutes",		1800},
	{"1 Hour",			3600},
	{"Indefinite",		0}
};

--
-- The menu command.
--

local command = {};

command.help		= "Open the menu.";
command.command 	= "menu";
command.bDisallowConsole = true;

function command:Execute(player, silent, arguments)
	player:ConCommand("+serverguard_menu");
end;

serverguard.command:Add(command);

--
-- The ban command.
--

local command = {};

command.help				= "Ban a player.";
command.command 			= "ban";
command.arguments 			= {"player", "length"};
command.optionalArguments	= {"reason"};
command.permissions 		= {"Ban"};

function command:Execute(player, silent, arguments)
	local target, length = arguments[1], arguments[2];

	if (target and length) then
		serverguard:BanPlayer(player, arguments[1], arguments[2], table.concat(arguments, " ", 3));
	end;
end;

function command:ContextMenu(player, menu, rankData)
	local banMenu, menuOption = menu:AddSubMenu("Ban Player");
	
	banMenu:SetSkin("serverguard");
	menuOption:SetImage("icon16/delete.png");
	
	
	
	for k, v in pairs(serverguard.banLengths) do
		local option = banMenu:AddOption(v[1], function()
			Derma_StringRequest("Ban Reason", "Specify ban reason.", "", function(text)
				serverguard.command.Run("ban", false, player:Name(), v[2], text);
			end, function(text) end, "Accept", "Cancel");
		end);
		
		option:SetImage("icon16/clock.png");
	end;

	local option = banMenu:AddOption("Custom", function()
		Derma_StringRequest("Ban Length", "Specify ban length (example: 1y1w2d1h)", "", function(length)
			Derma_StringRequest("Ban Reason", "Specify ban reason.", "", function(text)
				serverguard.command.Run("ban", false, player:Name(), util.ParseDuration(length), text);
			end);
		end, function(text) end, "Accept", "Cancel");
	end);
		
	option:SetImage("icon16/clock.png");
end;

serverguard.command:Add(command);

--
-- The unban command.
--

local command = {};

command.help				= "Unban a player.";
command.command 			= "unban";
command.arguments 			= {"steamid"};
command.permissions 		= {"Unban"};

function command:Execute(player, silent, arguments)
	local steamID = arguments[1];
	
	if (serverguard.banTable[steamID]) then
		if (!silent) then
			serverguard.Notify(nil, SGPF("command_unban", serverguard.player:GetName(player), serverguard.banTable[steamID].player));
		end;

		serverguard:UnbanPlayer(steamID, player);
	elseif (!util.IsConsole(player)) then
		serverguard.Notify(player, SGPF("command_no_entry"));
	end;
end;

serverguard.command:Add(command);

--
-- The kick command.
--

local command = {};

command.help				= "Kick a player.";
command.command 			= "kick";
command.arguments			= {"player"};
command.optionalArguments	= {"reason"};
command.permissions			= {"Kick"};

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player);
	
	if (IsValid(target)) then
		if (serverguard.player:HasBetterImmunity(player, serverguard.player:GetImmunity(target))) then
			local reason = table.concat(arguments, " ", 2);
			
			if (string.Trim(reason) == "") then
				reason = "No Reason";
			end;

			if (!silent) then
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " has kicked ", SERVERGUARD.NOTIFY.RED, target:Name(), SERVERGUARD.NOTIFY.WHITE, ". Reason: " .. reason);
			end;
			
			game.ConsoleCommand("kickid " .. target:UserID() .. " " .. reason .. "\n");
		else
			serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "This player has a higher immunity than you.");
		end;
	end;
end;

function command:ContextMenu(player, menu, rankData)
	local kickMenu, menuOption = menu:AddSubMenu("Kick Player")
	
	kickMenu:SetSkin("serverguard");
	menuOption:SetImage("icon16/delete.png");
	
	for k, v in pairs(serverguard.kickReasons) do
		local option = kickMenu:AddOption(v, function()
			serverguard.command.Run("kick", false, player:Name(), v);
		end);
		
		option:SetImage("icon16/page_paste.png");
	end;
	
	kickMenu:AddOption("Custom Reason", function()
		Derma_StringRequest("Kick Reason", "Specify kick reason.", "", function(text)
			serverguard.command.Run("kick", false, player:Name(), text);
		end, function(text) end, "Accept", "Cancel");
	end);
end;

serverguard.command:Add(command);

--
-- The rank command.
--

local command = {};

command.help		= "Set a player's rank.";
command.command 	= "rank";
command.arguments	= {"player", "rank", "length minutes"};
command.permissions = "Set Rank";
command.aliases		= {"setrank", "setgroup", "group"};

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player, true);
	local rankData = serverguard.ranks:GetRank(arguments[2] or "");
	local length = tonumber(arguments[3]) or 0
	
	
	if (rankData) then
		if (serverguard.player:HasBetterImmunity(player, rankData.immunity)) then				
			if (IsValid(target)) then
				if (player != target) then
					if (serverguard.player:HasBetterImmunity(player, serverguard.player:GetImmunity(target))) then
						serverguard.player:SetRank(target, rankData.unique, length * 60);
						serverguard.player:SetImmunity(target, rankData.immunity);
    					serverguard.player:SetTargetableRank(target, rankData.targetable)
						serverguard.player:SetBanLimit(target, rankData.banlimit)

						if (!silent) then
							serverguard.Notify(nil, SGPF("command_rank", serverguard.player:GetName(player), serverguard.player:GetName(target), string.Ownership(serverguard.player:GetName(target), true), rankData.name, (length != nil and length > 0) and length .. " minute(s)" or "Indefinitely"));
						end;
					else
						serverguard.Notify(player, SGPF("player_higher_immunity"));
					end;
				else
					serverguard.Notify(player, SGPF("command_rank_cannot_set_own"));
				end;
			elseif (string.SteamID(arguments[1])) then
				local queryObj = serverguard.mysql:Select("serverguard_users");
					queryObj:Where("steam_id", arguments[1]);
					queryObj:Limit(1);
					queryObj:Callback(function(result, status, lastID)
						if (type(result) == "table" and #result > 0) then
							target = result[1];
							
							if (!util.IsConsole(player) and target.steam_id == player:SteamID()) then
								serverguard.Notify(player, SGPF("command_rank_cannot_set_own"));
								return;
							end;

							local playerRankData = serverguard.ranks:GetRank(target.rank);

							local data = (target.data and serverguard.von.deserialize(target.data)) or {};
							
							if (length != nil and isnumber(length) and length > 0) then
								data.groupExpire = os.time() + length * 60;
							else
								data.groupExpire = false;
							end;
							
							
							if (!playerRankData or serverguard.player:HasBetterImmunity(player, playerRankData.immunity)) then
								local updateObj = serverguard.mysql:Update("serverguard_users");
									updateObj:Update("rank", rankData.unique);
									updateObj:Update("data", serverguard.von.serialize(data));
									updateObj:Where("steam_id", target.steam_id);
									updateObj:Limit(1);
									updateObj:Callback(function(result, status, lastID)
										if (!silent) then
											serverguard.Notify(nil, SGPF("command_rank", serverguard.player:GetName(player), target.name, string.Ownership(target.name, true), rankData.name, (length != nil and length > 0) and length .. " minute(s)" or "Indefinitely"));
										end;
									end);
								updateObj:Execute();
							else
								serverguard.Notify(player, SGPF("player_higher_immunity"));
							end;
						else
							local insertObj = serverguard.mysql:Insert("serverguard_users");
								insertObj:Insert("name", arguments[1]);
								insertObj:Insert("rank", rankData.unique);
								insertObj:Insert("steam_id", arguments[1]);
								insertObj:Insert("last_played", os.time());
								insertObj:Insert("data", serverguard.von.serialize(data))
								insertObj:Callback(function(result, status, lastID)
									if (!silent) then
										serverguard.Notify(nil, SGPF("command_rank", serverguard.player:GetName(player), arguments[1], string.Ownership(arguments[1], true), rankData.name, (length != nil and length > 0) and length .. " minute(s)" or "Indefinitely"));
									end;
								end);
							insertObj:Execute();
						end;
					end);
				queryObj:Execute();
			else
				serverguard.Notify(player, SGPF("cant_find_player_with_identifier"));
			end;
		else
			serverguard.Notify(player, SGPF("command_rank_invalid_immunity"));
		end;
	else
		serverguard.Notify(player, SGPF("command_rank_invalid_unique", arguments[2] or ""));

		local rankList = {};

		for k, v in pairs(serverguard.ranks:GetRanks()) do
			rankList[#rankList + 1] = k;
		end;

		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, SGPF("command_rank_valid_list", table.concat(rankList, ", ")));
	end;
end;

function command:ContextMenu(player, menu, rankData)
	local rankMenu, menuOption = menu:AddSubMenu("Set Rank");
	
	rankMenu:SetSkin("serverguard");
	menuOption:SetImage("icon16/award_star_add.png");
	
	local sorted = {};
	
	for k, v in pairs(serverguard.ranks:GetTable()) do
		table.insert(sorted, v);
	end;
	
	table.sort(sorted, function(a, b) return  a.immunity > b.immunity end);
	
	for _, data in pairs(sorted) do
		local timeMenu, menuRank = rankMenu:AddSubMenu(data.name);
		timeMenu:SetSkin("serverguard");
		
		local option = timeMenu:AddOption("Indefinitely", function()
			serverguard.command.Run("rank", false, player:Name(), data.unique, 0);
		end);
		option:SetImage("icon16/clock.png");
		
		local option = timeMenu:AddOption("Custom", function()
			Derma_StringRequest("Rank Length", "Specify the time after which this rank will expire (in minutes).", "", function(length)
				serverguard.command.Run("rank", false, player:Name(), data.unique, tonumber(length));
			end, function(text) end, "Accept", "Cancel");
		end);
		option:SetImage("icon16/clock.png");
		
		if (data.texture and data.texture != "") then
			menuRank:SetImage(data.texture);
		end;
	end;
end;

serverguard.command:Add(command);

hook.Add("serverguard.LoadedPlayerData", "serverguard.ranks.LoadedPlayerData", function(player, steamid)
	local expiration = tonumber(serverguard.player:GetData(player, "groupExpire", 0));
	if (expiration and expiration > 0) then
		if (os.time() > expiration) then
			serverguard.player:SetRank(player, "user", 0);
		else
			timer.Create("serverguard.timer.RemoveRank_" .. player:UniqueID(), expiration - os.time(), 1, function()
				if (IsValid(player)) then
					serverguard.player:SetRank(player, "user", 0);
				end;
			end);
		end;
	end;
end);

hook.Add("PlayerDisconnected", "serverguard.ranks.PlayerDisconnected", function(player)
	if timer.Exists("serverguard.timer.RemoveRank_" .. player:UniqueID()) then
		timer.Remove("serverguard.timer.RemoveRank_" .. player:UniqueID());
	end;
end);

--
-- The toggle plugin command.
--

local command = {};

command.help		= "Toggle a plugin.";
command.command 	= "plugintoggle";
command.arguments	= {"name"};
command.permissions	= "Manage Plugins";
command.aliases		= {"toggleplugin"};

function command:Execute(player, silent, arguments)
	local pluginTable = serverguard.plugin.Get(arguments[1]);

	if (pluginTable) then
		local uniqueID = pluginTable.unique;
		local bWhitelisted = true

		if (pluginTable.gamemodes and #pluginTable.gamemodes > 0) then
			if (!table.HasValue(pluginTable.gamemodes, engine.ActiveGamemode())) then
				bWhitelisted = false;
			end;
		end;

		serverguard.netstream.Start(nil, "sgGetPluginStatus", {
			uniqueID, !pluginTable.toggled
		});

		serverguard.plugin:Toggle(uniqueID, !pluginTable.toggled);
		if !bWhitelisted then
			serverguard.plugin:SaveData(true,uniqueID);
		else
			serverguard.plugin:SaveData();
		end;
	end;		
end;

serverguard.command:Add(command);

--
-- The bring command.
--

local command = {};

command.help				= "Bring a player to you.";
command.command 			= "bring";
command.arguments			= {"player"};
command.permissions			= "Bring";
command.bDisallowConsole	= true;
command.immunity 			= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(player, target)
	local position = serverguard:playerSend(target, player, false);
	
	if (not target:Alive()) then
		target:Spawn();
	end
	
	if (position) then
		target.sg_LastPosition = target:GetPos();
		target.sg_LastAngles = target:EyeAngles();
		target:SetPos(position);

		return true;
	end;
end;

function command:OnNotify(player, targets)
	return SGPF("command_bring", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

serverguard.command:Add(command);

--
-- The send command.
--

local command = {};

command.help				= "Send a player to where you're looking, or to another player.";
command.command 			= "send";
command.arguments			= {"player"};
command.optionalArguments	= {"to player"};
command.permissions			= "Send";
command.bDisallowConsole	= true;

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player)
	
	if (IsValid(target)) then
		if (!serverguard.player:HasBetterImmunity(player, serverguard.player:GetImmunity(target))) then
			serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "This player has a higher immunity than you.");
			return;
		end;

		if (not target:Alive()) then
			target:Spawn();
		end
		
		if (arguments[2] != nil) then
			local sendTarget = util.FindPlayer(arguments[2], player);

			if (IsValid(sendTarget)) then
				local position = serverguard:playerSend(target, sendTarget, target:GetMoveType() == MOVETYPE_NOCLIP);

				if (position) then
					target.sg_LastPosition = target:GetPos();
					target.sg_LastAngles = target:EyeAngles();

					target:SetPos(position);

					if (!silent) then
						serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " has sent ", SERVERGUARD.NOTIFY.RED, target:Name(), SERVERGUARD.NOTIFY.WHITE, " to ", SERVERGUARD.NOTIFY.RED, string.Ownership(sendTarget:Name()), SERVERGUARD.NOTIFY.WHITE, " location.");
					end;
				else
					serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "Could not find any proper location to place the player.");
				end;

				return;
			end;
		end;

		target.sg_LastPosition = target:GetPos();
		target.sg_LastAngles = target:EyeAngles();

		local trace = player:GetEyeTrace();
			trace = trace.HitPos +trace.HitNormal *1.25;
		target:SetPos(trace);
		
		if (!silent) then
			serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " has sent ", SERVERGUARD.NOTIFY.RED, target:Name(), SERVERGUARD.NOTIFY.WHITE, " to their location.");
		end;
	end;
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Send Player", function()
		serverguard.command.Run("send", false, player:Name());
	end);
	
	option:SetImage("icon16/wand.png");
end;

serverguard.command:Add(command);

--
-- The goto command.
--

local command = {};

command.help				= "Go to a player.";
command.command 			= "goto";
command.arguments			= {"player"};
command.permissions			= "Goto";
command.bDisallowConsole	= true;
command.bSingleTarget		= true;
command.immunity 			= SERVERGUARD.IMMUNITY.ANY;
command.aliases				= {"tp", "teleport"};

function command:OnPlayerExecute(player, target)
	local position = serverguard:playerSend(player, target, true);

	if (position) then
		player:SetPos(position);
		player:SetEyeAngles(Angle(target:EyeAngles().pitch, target:EyeAngles().yaw, 0));
		
		return true;
	else
		if (serverguard.player:HasPermission(player, "Noclip")) then
			player:SetMoveType(MOVETYPE_NOCLIP);
			position = serverguard:playerSend(player, target, true);

			player:SetPos(position);
			player:SetEyeAngles(Angle(target:EyeAngles().pitch, target:EyeAngles().yaw, 0));

			return true;
		end;
	end;
end;

function command:OnNotify(player, targets)
	return SGPF("command_goto", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Go To Player", function()
		serverguard.command.Run("goto", false, player:Name());
	end);

	option:SetImage("icon16/wand.png");
end;

serverguard.command:Add(command);

--
-- The return command.
--

local command = {};

command.help				= "Return a player to their previous location.";
command.command 			= "return";
command.arguments			= {"player"};
command.permissions			= "Return";
command.bDisallowConsole	= true;

function command:Execute(player, bSilent, arguments)
	local target = util.FindPlayer(arguments[1], player);

	if (IsValid(target)) then
		if (target.sg_LastPosition and target.sg_LastAngles) then
			if (target.sg_jail) then
				serverguard:UnjailPlayer(target);
			end;

			target:SetPos(target.sg_LastPosition);
			target:SetEyeAngles(Angle(target.sg_LastAngles.pitch, target.sg_LastAngles.yaw, 0));

			target.sg_LastPosition = nil;
			target.sg_LastAngles = nil;

			if (!bSilent) then
				serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " has returned ", SERVERGUARD.NOTIFY.RED, serverguard.player:GetName(target), SERVERGUARD.NOTIFY.WHITE, " to their previous location.");
			end;
		else
			serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "This player has not been previously teleported.");
		end;
	end;
end;

serverguard.command:Add(command);

--
-- The change map command.
--

local command = {};

command.help		= "Change the map.";
command.command 	= "map";
command.arguments	= {"map"};
command.permissions	= "Map";
command.aliases		= {"changemap", "changelevel"};

function command:Execute(player, silent, arguments)
	local map = string.lower(arguments[1]);
	
	game.ConsoleCommand("changelevel " .. map .. "\n");
	
	-- If the server has not changed map by this time, the map does not exist.
	timer.Simple(0.2, function()
		if (IsValid(player)) then
			serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "\"" .. map .. "\" is not installed on this server.");
		end;
	end);
end;

serverguard.command:Add(command);


--
-- The "admin chat" command.
--

local command = {};

command.help		= "Talk to admins.";
command.command 	= "a";
command.quotes		= true;
command.arguments	= {"text"};
command.permissions	= "Admin Chat";

function command:Execute(pPlayer, silent, arguments)
	local text = table.concat(arguments, " ");
	local recipients = {};

	for k, v in ipairs(player.GetAll()) do
		if (v:IsAdmin()) then
			recipients[#recipients + 1] = v;
		end;
	end;

	if (#recipients > 0) then
		serverguard.netstream.Start(recipients, "sgTalkToAdmins", {pPlayer, text});
	end;

	if (util.IsConsole(pPlayer)) then
		return;
	end;

	if (!pPlayer:IsAdmin()) then
		if (#recipients > 0) then
			serverguard.Notify(pPlayer, SERVERGUARD.NOTIFY.WHITE, "Sent the message to the admin chat.");
		else
			serverguard.Notify(pPlayer, SERVERGUARD.NOTIFY.WHITE, "There are currently no admins online.");
		end;
	end;
end;

if (CLIENT) then
	serverguard.netstream.Hook("sgTalkToAdmins", function(data)
		local pPlayer = data[1];
		local text = data[2];

		if (util.IsConsole(pPlayer)) then
			chat.AddText(Color(255, 0, 0), "[Admins] ", color_white, "Console: " .. text);
			return;
		end;

		if (pPlayer:Name() != pPlayer:Nick()) then
			chat.AddText(Color(255, 0, 0), "[Admins] ", team.GetColor(pPlayer:Team()), "(" .. pPlayer:Name() .. ") " .. pPlayer:Nick(), color_white, ": " .. text);
			serverguard.PrintConsole("[Admins] (" .. pPlayer:Name() .. ") " .. pPlayer:Nick() .. ": " .. text);
		else
			chat.AddText(Color(255, 0, 0), "[Admins] ", team.GetColor(pPlayer:Team()), pPlayer:Nick(), color_white, ": " .. text);
			serverguard.PrintConsole("[Admins] " .. pPlayer:Nick() .. ": " .. text);
		end;
	end);
end;

serverguard.command:Add(command);

--
-- The "clear decals" command.
--

local command = {};

command.help		= "Clear decals for everyone.";
command.command 	= "cleardecals";
command.permissions	= "Clear Decals";

function command:Execute(pPlayer, silent, arguments)
	serverguard.netstream.Start(nil, "sgClearDecals", 1);
	
	if (!silent) then
		serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(pPlayer), SERVERGUARD.NOTIFY.WHITE, " has cleared all decals.");
	end;
end;

if (CLIENT) then
	serverguard.netstream.Hook("sgClearDecals", function(data)
		LocalPlayer():ConCommand("r_cleardecals", true);
	end);
end;

serverguard.command:Add(command);

--
-- The rcon command.
--

if (serverguard.RconEnabled) then
	local command = {}

	command.help		= "Run a command on the server.";
	command.command 	= "rcon";
	command.arguments	= {"text"};
	command.permissions	= "Rcon";

	function command:Execute(_, silent, arguments)
		game.ConsoleCommand(table.concat(arguments, " ") .. "\n");
	end;

	serverguard.command:Add(command);
end;

--
-- The god command.
--

local command = {}

command.help		= "Enable god mode for a player.";
command.command 	= "god";
command.arguments	= {"player"};
command.permissions	= "God mode";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(_, target)
	target:GodEnable();
	return true;
end;

function command:OnNotify(pPlayer, targets)
	return SGPF("command_god", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(pPlayer, menu, rankData)
	local option = menu:AddOption("Toggle God Mode", function() 
		if (!pPlayer:HasGodMode()) then
			serverguard.command.Run("god", false, pPlayer:Name());
		else
			serverguard.command.Run("ungod", false, pPlayer:Name());
		end;
	end);

	option:SetImage("icon16/shield.png");
end;

serverguard.command:Add(command);

--
-- The ungod command.
--

local command = {}

command.help		= "Disable god mode for a player.";
command.command 	= "ungod";
command.arguments	= {"player"};
command.permissions	= "God mode";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(_, target)
	target:GodDisable();
	return true;
end;

function command:OnNotify(pPlayer, targets)
	return SGPF("command_god_disable", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets));
end;

serverguard.command:Add(command);

--
-- The "set health" command.
--

local command = {};

command.help		= "Set a player's health.";
command.command 	= "hp";
command.arguments	= {"player", "hp"};
command.permissions	= "Set Health";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;
command.aliases		= {"sethp", "sethealth"};

function command:OnPlayerExecute(_, target, arguments)
	local amount = util.ToNumber(arguments[2]);
	target:SetHealth(amount);

	hook.Add("OnPlayerSetHealth", target, amount)

	return true;
end;

function command:OnNotify(pPlayer, targets, arguments)
	local amount = util.ToNumber(arguments[2]);

	return SGPF("command_hp", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount);
end;

function command:ContextMenu(pPlayer, menu, rankData)
	local option = menu:AddOption("Set Health", function() 
		Derma_StringRequest("Set Health", "Specify health amount.", "", function(text)
			serverguard.command.Run("hp", false, pPlayer:Name(), text);
		end, function(text) end, "Accept", "Cancel") end);

	option:SetImage("icon16/heart.png");
end;

serverguard.command:Add(command);

--
-- The respawn command.
--

local command = {};

command.help		= "Respawn a player.";
command.command 	= "respawn";
command.arguments	= {"player"};
command.permissions	= "Respawn";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(_, target, arguments)
	target:Spawn();

	hook.Run("OnPlayerRespawn", target)

	-- Needed for TTT.
	if (target.SpawnForRound) then
		target:SpawnForRound();

		-- Remove their corpse.
		if (IsValid(target.server_ragdoll)) then
			target.server_ragdoll:Remove();
		end;
	end;

	return true;
end;

function command:OnNotify(pPlayer, targets, arguments)
	local amount = util.ToNumber(arguments[2]);

	return SGPF("command_respawn", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets), amount);
end;

function command:ContextMenu(pPlayer, menu, rankData)
	local option = menu:AddOption("Respawn", function()
		serverguard.command.Run("respawn", false, pPlayer:Name());
	end);
	
	option:SetImage("icon16/user_go.png");
end;

serverguard.command:Add(command);

--
-- The respawn command.
--

local command = {};

command.help		= "Respawn a player and bring him back.";
command.command 	= "respawnbring";
command.arguments	= {"player"};
command.permissions	= "Respawn";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(_, target, arguments)
	local pos = target:GetPos()

	target:Spawn();
	target:SetPos(pos)

	hook.Run("OnPlayerRespawn", target)

	-- Needed for TTT.
	if (target.SpawnForRound) then
		target:SpawnForRound();

		-- Remove their corpse.
		if (IsValid(target.server_ragdoll)) then
			target.server_ragdoll:Remove();
		end;
	end;

	return true;
end;

function command:OnNotify(pPlayer, targets, arguments)
	local amount = util.ToNumber(arguments[2]);

	return SGPF("command_respawn", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets), amount);
end;

function command:ContextMenu(pPlayer, menu, rankData)
	local option = menu:AddOption("Respawn Bring", function()
		serverguard.command.Run("respawnbring", false, pPlayer:Name());
	end);
	
	option:SetImage("icon16/user_go.png");
end;

serverguard.command:Add(command);

--
-- The ammo command.
--

local command = {}

command.help		= "Give a player ammo.";
command.command 	= "ammo";
command.arguments	= {"player"};
command.permissions	= "Give Ammo";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

local infiniteAmmo = 999999
function command:OnPlayerExecute(_, target, arguments)
	local ammoAmount = util.ToNumber(arguments[2])

	if (ammoAmount < 1) then ammoAmount = infiniteAmmo end
	for _, weapon in pairs(target:GetWeapons()) do
		target:GiveAmmo(ammoAmount, weapon:GetPrimaryAmmoType())
		target:GiveAmmo(ammoAmount, weapon:GetSecondaryAmmoType())
	end

	return true
end

function command:OnNotify(pPlayer, targets, arguments)
	local amount = util.ToNumber(arguments[2]);
	if (amount < 1) then amount = "infinite" end
	return SGPF("command_ammo", serverguard.player:GetName(pPlayer), amount, util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(pPlayer, menu, rankData)
	local option = menu:AddOption("Give Infinite Ammo", function()
		serverguard.command.Run("ammo", false, pPlayer:Name());
	end);
	
	option:SetImage("icon16/tab_add.png");
end;

serverguard.command:Add(command);

--
-- The slap command.
--

local slapSounds = {
	Sound("physics/body/body_medium_impact_hard1.wav"),
	Sound("physics/body/body_medium_impact_hard2.wav"),
	Sound("physics/body/body_medium_impact_hard3.wav"),
	Sound("physics/body/body_medium_impact_hard5.wav"),
	Sound("physics/body/body_medium_impact_hard6.wav"),
	Sound("physics/body/body_medium_impact_soft5.wav"),
	Sound("physics/body/body_medium_impact_soft6.wav"),
	Sound("physics/body/body_medium_impact_soft7.wav")
};

local command = {};

command.help		= "Slap a player.";
command.command 	= "slap";
command.arguments	= {"player"};
command.permissions	= "Slap";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(_, target, arguments)
	target:SetHealth(target:Health() -math.random(2, 6));
	target:SetVelocity(Vector(math.random(-225, 225), math.random(-225, 225), 10));
	target:EmitSound(slapSounds[math.random(1, #slapSounds)]);

	return true;
end;

function command:OnNotify(pPlayer, targets, arguments)
	local amount = util.ToNumber(arguments[2]);

	return SGPF("command_slap", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets), amount);
end;

function command:ContextMenu(pPlayer, menu, rankData)
	local option = menu:AddOption("Slap", function()
		serverguard.command.Run("slap", false, pPlayer:Name());
	end);

	option:SetImage("icon16/transmit_error.png");
end;
	
serverguard.command:Add(command);

--
-- The "toggle npc target" command.
--

local command = {};

command.help		= "Toggle NPC targeting for a player.";
command.command 	= "npctarget";
command.arguments	= {"player"};
command.permissions	= "NPC Target";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(_, target, arguments)
	if (target.sg_notarget == nil) then
		target.sg_notarget = false;
	end;
	
	target:SetNoTarget(!target.sg_notarget);
	target.sg_notarget = !target.sg_notarget;

	return true;
end;

function command:OnNotify(pPlayer, targets, arguments)
	local amount = util.ToNumber(arguments[2]);

	return SGPF("command_npctarget", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets), amount);
end;

function command:ContextMenu(pPlayer, menu, rankData)
	local option = menu:AddOption("Toggle NPC Target", function() 
		serverguard.command.Run("npctarget", false, pPlayer:Name());
	end);

	option:SetImage("icon16/transmit.png");
end;

serverguard.command:Add(command);

--
-- The slay command.
--

local command = {};

command.help		= "Slay a player.";
command.command 	= "slay";
command.arguments	= {"player"};
command.permissions	= "Slay";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;
command.aliases		= {"kill"};

function command:OnPlayerExecute(_, target, arguments)
	target:Kill();

	return true;
end;

function command:OnNotify(pPlayer, targets)
	return SGPF("command_slay", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(pPlayer, menu, rankData)
	local option = menu:AddOption("Slay", function() 
		serverguard.command.Run("slay", false, pPlayer:Name());
	end);

	option:SetImage("icon16/user_delete.png");
end;

serverguard.command:Add(command);

--
-- The "give weapon" command.
--

local command = {};

command.help		= "Give a weapon to a player.";
command.command 	= "giveweapon";
command.arguments	= {"player", "weapon"};
command.permissions	= "Give Weapon";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;
command.aliases		= {"give"};

function command:OnPlayerExecute(_, target, arguments)
	local weapon = arguments[2];
	target:Give(weapon);

	return true;
end;

function command:OnNotify(pPlayer, targets, arguments)
	local weapon = arguments[2];

	return SGPF("command_giveweapon", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets), weapon);
end;

serverguard.command:Add(command);

--
-- The ragdoll command.
--

local command = {};

command.help		= "Ragdoll a player.";
command.command 	= "ragdoll";
command.arguments	= {"player"};
command.permissions	= "Ragdoll";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

local function MakeInvisible(player, invisible)
	player:SetNoDraw(invisible);
	player:SetNotSolid(invisible);
	
	player:DrawViewModel(!invisible);
	player:DrawWorldModel(!invisible);

	if (invisible) then
		player:GodEnable();
	else
		player:GodDisable();
	end;
end;

function command:OnPlayerExecute(player, target, arguments)
	if (IsValid(target.sgRagdoll)) then
		MakeInvisible(target, false);
		
		local position = target.sgRagdoll:GetPos();

        target:UnSpectate();
		target.sgRagdoll:Remove();
		
		target:SetParent(NULL);
		target:Spawn();
		target:SetPos(position +Vector(0, 0, 5));
		
		for k, weapon in pairs(target.sg_weapons) do
			target:Give(weapon);
		end;
		
		target.sg_weapons = nil;
	else
		target.sg_weapons = {};
		
		for k, weapon in pairs(target:GetWeapons()) do
			if (IsValid(weapon)) then
				table.insert(target.sg_weapons, weapon:GetClass());
			end;
		end;
		
		target.sgRagdoll = ents.Create("prop_ragdoll");
		target.sgRagdoll:SetPos(target:GetPos());
		target.sgRagdoll:SetModel(target:GetModel());
		target.sgRagdoll:SetAngles(target:GetAngles());
		target.sgRagdoll:SetSkin(target:GetSkin());
		target.sgRagdoll:SetMaterial(target:GetMaterial());
		target.sgRagdoll:Spawn();

		target.sgRagdoll:CallOnRemove("UnragdollPlayer", function(ragdoll)
			if (IsValid(target)) then
				MakeInvisible(target, false);

				local position = ragdoll:GetPos();
								
				target:SetParent(NULL);
				target:Spawn();
				target:SetPos(position + Vector(0, 0, 5));
				
				if (target.sg_weapons) then
					for k, weapon in pairs(target.sg_weapons) do
						target:Give(weapon);
					end;
				end;
				
				target.sg_weapons = nil;
			end;
		end);

		target.sgRagdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON);
		
		local velocity = target:GetVelocity();
		local physObjects = target.sgRagdoll:GetPhysicsObjectCount() - 1;
		
		for i = 0, physObjects do
			local bone = target.sgRagdoll:GetPhysicsObjectNum(i);
			
			if (IsValid(bone)) then
				local position, angle = target:GetBonePosition(target.sgRagdoll:TranslatePhysBoneToBone(i));
				
				if (position and angle) then
					bone:SetPos(position);
					bone:SetAngles(angle);
				end;
				
				bone:AddVelocity(velocity);
			end;
		end;
		
		target:StripWeapons();
		target:SetMoveType(MOVETYPE_OBSERVER);
		target:Spectate(OBS_MODE_CHASE);
		target:SpectateEntity(target.sgRagdoll);
		target:SetParent(target.sgRagdoll);
		
		MakeInvisible(target, true);
	end;

	return true;
end;

function command:OnNotify(player, targets)
	return SGPF("command_ragdoll", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Toggle ragdoll", function() 
		serverguard.command.Run("ragdoll", false, player:Name());
	end);

	option:SetImage("icon16/television.png");
end;

serverguard.command:Add(command);

--
-- The ignite command.
--

local command = {};

command.help		= "Ignite a player.";
command.command 	= "ignite";
command.arguments	= {"player"};
command.permissions	= "Ignite";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(player, target, arguments)
	target:Ignite(99999999);

	return true;
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_ignite", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Ignite", function() 
		serverguard.command.Run("ignite", false, player:Name());
	end);

	option:SetImage("icon16/bomb.png");
end;

serverguard.command:Add(command);

--
-- The extinguish command.
--

local command = {}

command.help		= "Extinguish a player.";
command.command 	= "extinguish";
command.arguments	= {"player"};
command.permissions	= "Extinguish";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;
command.aliases		= {"unignite"};

function command:OnPlayerExecute(player, target, arguments)
	target:Extinguish();

	return true;
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_extinguish", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Extinguish", function() 
		serverguard.command.Run("extinguish", false, player:Name());
	end);

	option:SetImage("icon16/user_delete.png");
end;

serverguard.command:Add(command);

--
-- The mute command.
--

local command = {};

command.help		= "Mute a player.";
command.command 	= "mute";
command.arguments	= {"player"};
command.permissions	= "Mute";
command.immunity 	= SERVERGUARD.IMMUNITY.LESS;

function command:OnPlayerExecute(player, target, arguments)
	target.sgMuted = true;
	target:SetNetworkedBool("serverguard_muted", true);

	return true;
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_mute", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Mute/Unmute", function() 
		if (player:GetNetworkedBool("serverguard_muted")) then
			serverguard.command.Run("unmute", false, player:Name());
		else
			serverguard.command.Run("mute", false, player:Name());
		end;
	end);

	option:SetImage("icon16/comment.png");
end;

serverguard.command:Add(command);

--
-- The unmute command.
--

local command = {};

command.help		= "Unmute a player.";
command.command 	= "unmute";
command.arguments	= {"player"};
command.permissions	= "Unmute";
command.immunity 	= SERVERGUARD.IMMUNITY.LESS;

function command:OnPlayerExecute(player, target, arguments)
	target.sgMuted = false;
	target:SetNetworkedBool("serverguard_muted", false);

	return true;
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_unmute", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

serverguard.command:Add(command);

--
-- The gag command.
--

local command = {};

command.help		= "Gag a player.";
command.command 	= "gag";
command.arguments	= {"player"};
command.permissions	= "Gag";
command.immunity 	= SERVERGUARD.IMMUNITY.LESS;

function command:OnPlayerExecute(player, target, arguments)
	target.sgGagged = true;
	target:SetNetworkedBool("serverguard_gagged", true);

	return true;
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_gag", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Gag/Ungag", function() 
		if (player:GetNetworkedBool("serverguard_gagged")) then
			serverguard.command.Run("ungag", false, player:Name());
		else
			serverguard.command.Run("gag", false, player:Name());
		end;
	end);

	option:SetImage("icon16/sound.png");
end;

serverguard.command:Add(command);

--
-- The ungag command.
--

local command = {};

command.help		= "Ungag a player.";
command.command 	= "ungag";
command.arguments	= {"player"};
command.permissions	= "Ungag";
command.immunity 	= SERVERGUARD.IMMUNITY.LESS;

function command:OnPlayerExecute(player, target, arguments)
	target.sgGagged = false;
	target:SetNetworkedBool("serverguard_gagged", false);

	return true;
end;

function command:OnNotify(player, targets, arguments)
	return SGPF("command_ungag", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

serverguard.command:Add(command);

if (SERVER) then
	hook.Add("PlayerCanHearPlayersVoice", "serverguard.PlayerCanHearPlayersVoice", function(listener, speaker)
		if (speaker.sgGagged) then
			return false;
		end;
	end);
end;

--
-- The invisible command.
--

local command = {};

command.help		= "Toggle a player's invisibility.";
command.command 	= "invisible";
command.arguments	= {"player"};
command.permissions	= "Invisible";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;
command.aliases		= {"cloak"};

function command:OnPlayerExecute(player, target, arguments)
	if (target.sg_invisible) then
		target:SetNoDraw(false);
		target:SetNotSolid(false);
		target:GodDisable();
		target:DrawWorldModel(true);
		
		target.sg_invisible = false;
		self:CloakHooks()
	else
		target:SetNoDraw(true);
		target:SetNotSolid(true);
		target:GodEnable();
		target:DrawWorldModel(false);
		
		
		
		target.sg_invisible = true;
		self:CloakHooks()
	end;

	return true;
end;

function command:OnNotify(player, targets)
	return SGPF("command_invisible", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Toggle Invisibility", function()
		serverguard.command.Run("invisible", false, player:Name());
	end);

	option:SetImage("icon16/user_edit.png");
end;

local function OnVehicleEnterdHook(player, vehicle, role)
	if (player.sg_invisible) then
		serverguard.command.stored.invisible:OnPlayerExecute(nil, player)
		serverguard.command.stored.invisible:CloakHooks()
	end
end

local function OnPlayerDeathHook(player, inflictor, attacker)
	if (player.sg_invisible) then
		serverguard.command.stored.invisible:OnPlayerExecute(nil, player)
		serverguard.command.stored.invisible:CloakHooks()
	end
end

local sg_invisibleHookActive = false
function command:CloakHooks()
	local playerCloakedCount = 0
	for k, user in pairs(player.GetAll()) do
		if (user.sg_invisible) then
			playerCloakedCount = playerCloakedCount + 1
		end
	end
	if (not (0 == playerCloakedCount) and not sg_invisibleHookActive) then
		sg_invisibleHookActive = true
		hook.Add("PlayerEnteredVehicle", "serverguard_cloak_PlayerEnteredVehicle", OnVehicleEnterdHook)
		hook.Add("PlayerDeath", "serverguard_cloak_PlayerDeath", OnPlayerDeathHook)
	elseif ((0 == playerCloakedCount) and sg_invisibleHookActive) then
		sg_invisibleHookActive = false
		hook.Remove("PlayerEnteredVehicle", "serverguard_cloak_PlayerEnteredVehicle")
		hook.Remove("PlayerDeath", "serverguard_cloak_PlayerDeath")
	end
end


serverguard.command:Add(command);

--
-- The freeze command.
--

local command = {};

command.help		= "Freeze or unfreeze a player.";
command.command 	= "freeze";
command.arguments	= {"player"};
command.permissions	= "Freeze";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(player, target, arguments)
	if (target.sg_isFrozen) then
		target:Freeze(false);
		target.sg_isFrozen = false;

		if (target:GetMoveType() == MOVETYPE_NONE) then
			target:SetMoveType(MOVETYPE_WALK);
		end;
	else
		target:Freeze(true);
		target.sg_isFrozen = true;
	end;

	return true;
end;

local function FreezeBlock(player)
    if (player.sg_isFrozen) then
        return false
    end
end
local function FreezeHookHelper(...)
    for i = 1, select("#", ...) do
        local name = select(i, ...)
        hook.Add(name, "serverguard.freeze."..name, FreezeBlock)
    end
end
FreezeHookHelper("PlayerSpawnEffect", "PlayerSpawnNPC", "PlayerSpawnObject",
                 "PlayerSpawnProp", "PlayerSpawnRagdoll", "PlayerSpawnSENT",
                 "PlayerSpawnSWEP", "PlayerSpawnVehicle"
                )

function command:OnNotify(player, targets)
	return SGPF("command_freeze", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Freeze/Unfreeze", function() 
		serverguard.command.Run("freeze", false, player:Name());
	end);

	option:SetImage("icon16/joystick_error.png");
end;

serverguard.command:Add(command);

--
-- The "strip weapons" command.
--

local command = {};

command.help		= "Remove all weapons from a player.";
command.command 	= "stripweapons";
command.arguments	= {"player"};
command.permissions	= "Strip Weapons";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;
command.aliases		= {"strip"};

function command:OnPlayerExecute(player, target, arguments)
	target:StripWeapons();

	return true;
end;

function command:OnNotify(player, targets)
	return SGPF("command_stripweapons", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Strip Weapons", function() 
		serverguard.command.Run("stripweapons", false, player:Name());
	end);

	option:SetImage("icon16/gun.png");
end;

serverguard.command:Add(command);

--
-- The announce command.
--

local command = {};

command.help		= "Announce something to the server.";
command.command 	= "announce";
command.arguments	= {"text"};
command.permissions	= "Announce";

function command:Execute(player, silent, arguments)
	local text = table.concat(arguments, " ");
	
	serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, text);
end;

serverguard.command:Add(command);

--
-- The help command.
--

local command = {};

command.help		= "Ask admins for help.";
command.command 	= "help";
command.arguments	= {"text"};

function command:Execute(pPlayer, silent, arguments)
	local text = table.concat(arguments, " ");
	
	for k, v in ipairs(player.GetAll()) do
		if (serverguard.player:HasPermission(v, "See Help Requests") or v == pPlayer) then
			serverguard.Notify(v, SERVERGUARD.NOTIFY.RED, "[HELP] ", SERVERGUARD.NOTIFY.WHITE, serverguard.player:GetName(pPlayer), SERVERGUARD.NOTIFY.WHITE, ": " .. text);

			pPlayer.sg_pendingHelpRequest = true;
			pPlayer.sg_pendingHelpRequestTime = os.time();
		end;
	end;
end;

serverguard.command:Add(command);

local command = {};

command.help		= "Respond to the latest help request.";
command.command 	= "respond";
command.arguments	= {"text"};
command.permissions = "Respond to Help Requests";

function command:Execute(pPlayer, silent, arguments)
	local target = nil;
	local requestTime = 0;
	
	for k,v in pairs(player.GetAll()) do
		if v.sg_pendingHelpRequest and v.sg_pendingHelpRequestTime > requestTime then
			requestTime = v.sg_pendingHelpRequestTime;
			target = v;
		end;
	end;

	if (IsValid(target)) then
		if (target.sg_pendingHelpRequest) then
			local text = table.concat(arguments, " ", 1);

			for k, v in ipairs(player.GetAll()) do
				if (serverguard.player:HasPermission(v, "See Help Requests") or v == target) then
					serverguard.Notify(v, SERVERGUARD.NOTIFY.RED, "[RESPONSE] ", SERVERGUARD.NOTIFY.WHITE, serverguard.player:GetName(pPlayer), SERVERGUARD.NOTIFY.WHITE, ": " .. text);

					pPlayer.sg_pendingHelpRequest = nil;
				end;
			end;
		end;
	else
		serverguard.Notify(pPlayer, SERVERGUARD.NOTIFY.RED, "There are no pending help requests.");
	end;
end;

serverguard.command:Add(command);

--
-- The spectate command.
--

local command = {};

command.help				= "Start spectating someone.";
command.command 			= "spectate";
command.arguments			= {"player"};
command.permissions			= "FSpectate";
command.bDisallowConsole	= true;
command.bSingleTarget 		= true;
command.immunity 			= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(player, target, arguments)
	if (player != target) then
		serverguard.player:SpectateTarget(player, target);
		serverguard.player:SetupSpectate(player, OBS_MODE_IN_EYE);

		serverguard.Notify(player, SGPF("command_spectate_hint"));
		return true;
	end;
end;

function command:OnNotify(player, targets)
	return SGPF("command_spectate", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Spectate", function() 
		serverguard.command.Run("spectate", false, player:Name());
	end);

	option:SetImage("icon16/camera.png");
end;

serverguard.command:Add(command);

--
-- The noclip command.
--

local command = {}

command.help 				= "Toggle noclip mode."
command.command 			= "noclip"
command.permissions			= "Noclip";
command.arguments 			= {"player"};
command.immunity 			= SERVERGUARD.IMMUNITY.LESSOREQUAL;
command.bDisallowConsole 	= true;

function command:OnPlayerExecute(player, target, arguments)
	if (target:GetMoveType() != MOVETYPE_NOCLIP) then
		target:SetMoveType(MOVETYPE_NOCLIP);
	else
		target:SetMoveType(MOVETYPE_WALK);
	end;

	return true;
end;

function command:OnNotify(player, targets)
	return SGPF("command_noclip", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

hook.Add("PlayerNoClip", "serverguard.PlayerNoClip", function(player)
	if (player.sg_jail or player:GetNetworkedBool("serverguard_jailed", false)) then
		return false;
	end;

	if (serverguard.player:HasPermission(player, "Noclip")) then
		return true;
	end;
end);

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Toggle Noclip", function() 
		serverguard.command.Run("noclip", false, player:Name());
	end);

	option:SetImage("icon16/arrow_up.png");
end;

serverguard.command:Add(command);

--
-- Restart the current map.
--

local command = {};

command.help		= "Restart the current map.";
command.command 	= "maprestart";
command.arguments	= {"delay seconds"};
command.permissions	= "Map Restart";
command.aliases		= {"restartmap"};

function command:Execute(player, silent, arguments)
	local delay = tonumber(arguments[1]);

	timer.Simple(delay, function()
		RunConsoleCommand("changelevel", game.GetMap());
	end);

	if (!silent) then
		serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " is restarting the map in ", SERVERGUARD.NOTIFY.RED, tostring(delay), SERVERGUARD.NOTIFY.WHITE, " seconds!")
	end;
end;

serverguard.command:Add(command);

--
-- Freeze all props on the server.
--

local command = {};

command.help 		= "Freeze all props in the server.";
command.command 	= "freezeprops";
command.permissions = "Freeze Props";

function command:Execute(player, silent, arguments)
	for k, v in ipairs(ents.FindByClass("prop_physics")) do
		local physicsObject = v:GetPhysicsObject();

		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(false);
		end;
	end;

	if (!silent) then
		serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " has frozen all props.");
	end;
end;

serverguard.command:Add(command);

--
-- Jail a player.
--

local command = {};

command.help		= "Jail a player.";
command.command 	= "jail";
command.arguments	= {"player", "seconds"};
command.permissions	= "Jail";
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(player, target, arguments)
	if (!target.sg_jail) then
		local duration = tonumber(arguments[2]) or 0;
	
		serverguard:JailPlayer(target, duration);

		return true;
	end;
end;

function command:OnNotify(player, targets)
	return SGPF("command_jail", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets), (targets[1].sg_jailTime and targets[1].sg_jailTime .. " second(s)") or "Indefinite");
end;

function command:ContextMenu(player, menu, rankData)
	local jailMenu, menuOption = menu:AddSubMenu("Jail");
	menuOption:SetImage("icon16/lock.png");
	
	for k, v in pairs(serverguard.jailLengths) do
		local option = jailMenu:AddOption(v[1], function()
			serverguard.command.Run("jail", false, player:Name(), v[2]);
		end);
		
		option:SetImage("icon16/clock.png");
	end;
	
	local option = jailMenu:AddOption("Custom", function()
		Derma_StringRequest("Jail Length", "Specify jail time in seconds.", "", function(duration)
			serverguard.command.Run("jail", false, player:Name(), tonumber(duration));
		end, function(text) end, "Accept", "Cancel");
	end);
		
	option:SetImage("icon16/clock.png");
end;

serverguard.command:Add(command);

--
-- Teleport and jail a player.
--

local command = {};

command.help		= "Teleport and jail a player.";
command.command 	= "jailtp";
command.arguments	= {"player", "seconds"};
command.permissions	= "Jail";
command.bDisallowConsole = true;

function command:OnPlayerExecute(player, target, arguments)
	if (!target.sg_jail) then
		local duration = tonumber(arguments[2]) or 0;
		target.sg_LastPosition = target:GetPos();
		target.sg_LastAngles = target:EyeAngles();

		target:SetPos(player:GetEyeTraceNoCursor().HitPos + Vector(0, 0, 5));
		serverguard:JailPlayer(target, duration);

		return true;
	end;
end;

function command:OnNotify(player, targets)
	return SGPF("command_jailtp", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets), (targets[1].sg_jailTime and targets[1].sg_jailTime .. " second(s)") or "Indefinite");
end;

serverguard.command:Add(command);

--
-- Unjail a player.
--

local command = {};

command.help		= "Unjail a player.";
command.command 	= "unjail";
command.arguments	= {"player"};
command.permissions	= "Jail";
command.aliases		= {"release"};

function command:OnPlayerExecute(player, target)
	if (target.sg_jail) then
		serverguard:UnjailPlayer(target);

		return true;
	end;
end;

function command:OnNotify(player, targets)
	return SGPF("command_unjail", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Unjail", function()
		serverguard.command.Run("unjail", false, player:Name());
	end);

	option:SetImage("icon16/lock.png");
end;

serverguard.command:Add(command);

--
-- Restrict a player from using certain features.
--

local command = {};

command.help		= "Restrict a player from using certain features.";
command.command 	= "restrict";
command.arguments	= {"player", "time"};
command.permissions	= "Restrict";
command.immunity 	= SERVERGUARD.IMMUNITY.LESS;
command.bSingleTarget = true;

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player);
	local time, text = util.ParseDuration(arguments[2]);

	if (IsValid(target)) then
		if (serverguard.player:HasBetterImmunity(player, serverguard.player:GetImmunity(target))) then
			if (time and time > 0) then
				time = os.time() + (time * 60);
			else
				return;
			end;

			serverguard.player:SetData(target, "restrictTime", time);

			if (!silent) then
				serverguard.Notify(nil, SGPF("command_restrict", serverguard.player:GetName(player), serverguard.player:GetName(target), string.Ownership(serverguard.player:GetName(target), true), text));
			end;
		else
			serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "This player has a higher immunity than you.");
		end;
	end;
end;

serverguard.command:Add(command);

--
-- Unrestrict a player from using tools.
--

local command = {};

command.help		= "Unrestrict a player from using certain features.";
command.command 	= "unrestrict";
command.arguments	= {"player"};
command.permissions	= "Restrict";
command.immunity 	= SERVERGUARD.IMMUNITY.LESS;
command.bSingleTarget = true;

function command:Execute(player, silent, arguments)
	local target = util.FindPlayer(arguments[1], player);

	if (IsValid(target)) then
		serverguard.player:SetData(target, "restrictTime", nil);

		if (!silent) then
			serverguard.Notify(nil, SGPF("command_unrestrict", serverguard.player:GetName(player), serverguard.player:GetName(target), string.Ownership(serverguard.player:GetName(target), true)));
		end;
	end;
end;

serverguard.command:Add(command);


local command = {};

command.help				= "Temporarily demote/undemote yourself.";
command.command 			= "incognito";
command.bDisallowConsole	= true;

function command:Execute(player, silent, arguments)
	if (!player.sg_incognito) then
		local rank = serverguard.player:GetRank(player, true);

		if (serverguard.ranks:HasPermission(rank, "Go Incognito")) then
			serverguard.player:SetRank(player, "user", 0, true);
			player.sg_incognito = rank;
			serverguard.Notify(player, SGPF("incognito_enabled"));
		else
			serverguard.Notify(player, SGPF("incognito_prohibited"));
		end;
	else
		serverguard.player:SetRank(player, player.sg_incognito, 0, false);
		serverguard.Notify(player, SGPF("incognito_disabled"));
		player.sg_incognito = nil
	end;
end;

serverguard.command:Add(command);

serverguard.phrase:Add("english", "incognito_enabled", {
	SERVERGUARD.NOTIFY.GREEN, "You've gone incognito."
});

serverguard.phrase:Add("english", "incognito_disabled", {
	SERVERGUARD.NOTIFY.WHITE, "You're no longer incognito."
});

serverguard.phrase:Add("english", "incognito_prohibited", {
	SERVERGUARD.NOTIFY.RED, "Your rank isn't allowed to go incognito."
});

local COMMAND = {
	help			= "Attempt to find friends of a player.",
	command			= "friends",
	arguments		= { "player" },
	permissions		= "Get Friends",
	aliases			= {}
}

if SERVER then
	local _friendCache = {}

	local function insertFriend( pPlayer, sSteamID64 )
		if not _friendCache[ sSteamID64 ] then
			_friendCache[ sSteamID64 ] = {}
		end

		table.insert( _friendCache[ sSteamID64 ], pPlayer )

		if not pPlayer.sg_Friends then
			pPlayer.sg_Friends = {}
		end

		pPlayer.sg_Friends[ sSteamID64 ] = true
	end

	local function clearFriend( pPlayer, sSteamID64 )
		local tFriendCache = _friendCache[ sSteamID64 ]
		if tFriendCache then
			for _, pFriend in pairs( tFriendCache ) do
				if pFriend.sg_Friends then
					pFriend.sg_Friends[ sSteamID64 ] = nil
				end
			end
		end

		local tPlyFriendCache = pPlayer.sg_Friends
		if tPlyFriendCache then
			for sSteamID, _ in pairs( tPlyFriendCache ) do
				if _friendCache[ sSteamID ] then
					table.RemoveByValue( _friendCache[ sSteamID ], pPlayer )
				end
			end
		end
	end

	util.AddNetworkString( "sgGiveFriendStatusAll" )
	util.AddNetworkString( "sgGiveFriendStatusSingle")

	net.Receive( "sgGiveFriendStatusAll", function( iLen, pPlayer )
		local tFriendData = net.ReadTable()

		if pPlayer.sg_Friends then return end

		for _, sSteamID64 in ipairs( tFriendData ) do
			insertFriend( pPlayer, sSteamID64 )
		end
	end )

	net.Receive( "sgGiveFriendStatusSingle", function( iLen, pPlayer )
		local sSteamID64 = net.ReadString()

		insertFriend( pPlayer, sSteamID64 )
	end )

	gameevent.Listen( "player_disconnect" )
	hook.Add( "player_disconnect", "serverguard.command.friends.PlayerDisconnect", function( tData )
		local sSteamID64 = util.SteamIDTo64( tData.networkid )
		if not sSteamID64 then return end

		local pPlayer = Player( tData.userid )
		if not pPlayer then return end

		clearFriend( pPlayer, sSteamID64 )
		_friendCache[ sSteamID64 ] = nil
	end )
else -- CLIENT
	local _sendPlayers = {}

	hook.Add( "OnEntityCreated", "serverguard.commands.friends.PlayerSpawn", function( pPlayer )
		if not IsValid( pPlayer ) then return end
		if not pPlayer:IsPlayer() then return end
		if pPlayer == LocalPlayer() then return end
		if pPlayer:IsBot() then return end

		local sSteamID64 = pPlayer:SteamID64()
		if _sendPlayers[ sSteamID64 ] then return end
		_sendPlayers[ sSteamID64 ] = true

		net.Start( "sgGiveFriendStatusSingle" )
			net.WriteString( sSteamID64 )
		net.SendToServer()
	end )

	gameevent.Listen( "player_disconnect" )
	hook.Add( "player_disconnect", "serverguard.commands.friends.PlayerDisconnect", function( tData )
		local sSteamID64 = util.SteamIDTo64( tData.networkid )
		if not sSteamID64 then return end

		_sendPlayers[ sSteamID64 ] = nil
	end )

	hook.Add( "InitPostEntity", "serverguard.commands.friends.PostEntityInit", function()
		local tFriendData = {}
		local pLocalPlayer = LocalPlayer()
		for _, pPlayer in ipairs( player.GetAll() ) do
			if pPlayer:GetFriendStatus() != "friend" then continue end
			if pPlayer == pLocalPlayer then continue end

			table.insert( tFriendData, pPlayer:SteamID64() )
		end

		net.Start( "sgGiveFriendStatusAll" )
			net.WriteTable( tFriendData )
		net.SendToServer()
	end )
end

local function friendsChatAddTable( tTbl, cCol )
	if SERVER then return end

	local cWhite, cRed =
		serverguard.NotifyColors[ SERVERGUARD.NOTIFY.RED ],
		serverguard.NotifyColors[ SERVERGUARD.NOTIFY.WHITE ]

	local tChat = {}
	for sSteamID64, _ in pairs( tTbl ) do
		local pPlayer = player.GetBySteamID64( sSteamID64 )
		if not IsValid( pPlayer ) then continue end

		table.insert( tChat, cCol )
		table.insert( tChat, pPlayer:Name() )
		table.insert( tChat, cWhite )
		table.insert( tChat, ", " )
	end

	tChat[ #tChat ] = nil
	if #tChat == 0 then
		table.insert( tChat, cRed )
		table.insert( tChat, "/" )
		table.insert( tChat, cWhite )
	end

	return unpack( tChat )
end

serverguard.netstream.Hook( "sgGetFriends", function( tData )
	local tFriends = tData.friends
	local tMutualFriends = tData.mutualFriends
	local pTargetsName = tData.targetName

	if table.Count( tFriends ) == 0 then
		chat.AddText( serverguard.NotifyColors[ SERVERGUARD.NOTIFY.RED ],
									"No friends were found for your target!" )

		return
	end

	local cGreen, cWhite, cRed =
		serverguard.NotifyColors[ SERVERGUARD.NOTIFY.GREEN ],
		serverguard.NotifyColors[ SERVERGUARD.NOTIFY.WHITE ],
		serverguard.NotifyColors[ SERVERGUARD.NOTIFY.RED ]

	chat.AddText( cWhite, pTargetsName .. "'s Friends" )

	chat.AddText( cWhite, "Friends: ",
		friendsChatAddTable( tFriends, cRed ) )

	chat.AddText( cWhite, "Mutal Friends: ",
		friendsChatAddTable( tMutualFriends, cGreen ) )
end )

function COMMAND:OnPlayerExecute( pPlayer, pTarget )
	if not IsValid( pTarget ) then return end

	local tMutualFriends = {}
	for sSteamID64, _ in pairs( pTarget.sg_Friends ) do
		if pPlayer.sg_Friends[ sSteamID64 ] then
			tMutualFriends[ sSteamID64 ] = true
		end
	end

	serverguard.netstream.StartChunked( pPlayer, "sgGetFriends", {
		friends = pTarget.sg_Friends,
		mutualFriends = tMutualFriends,
		targetName = pTarget:Name()
	} )

	return true
end

serverguard.command:Add( COMMAND )

local command = {
    help = "Toggles nocollide between a player and entities",
    command = "nocollide",
    arguments = {"player"},
    permissions = "No Collide",
    aliases = {"collide"}
}

hook.Add("ShouldCollide", "serverguard.commands.nocollide", function(e1,e2)
    if (e1:IsPlayer() and e1.sg_NoCollide or e2:IsPlayer() and e2.sg_NoCollide) then
        return false
    end
end)
if (CLIENT) then
    serverguard.netstream.Hook("sgSetCollision", function(dat)
        local ply = dat[1]
        local enable = dat[2]
        ply.sg_NoCollide = dat[2]
        ply:SetCustomCollisionCheck(true)
        ply:CollisionRulesChanged()
    end)
end

function command:OnPlayerExecute(_, target)
    target.sg_NoCollide = not target.sg_NoCollide
    
    target:SetCustomCollisionCheck(true)
    target:CollisionRulesChanged()
    serverguard.netstream.Start(player.GetAll(), "sgSetCollision", {
        target,
        target.sg_NoCollide
    })
    
    return true
end

function command:OnNotify(pPlayer, targets)
	return SGPF("command_nocollide", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets));
end

serverguard.command:Add(command)