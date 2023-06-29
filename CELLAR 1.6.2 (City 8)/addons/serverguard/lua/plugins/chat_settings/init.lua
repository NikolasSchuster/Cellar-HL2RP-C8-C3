--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local hostname = GetConVar("hostname");
local savedSettings = serverguard.von.deserialize(file.Read("serverguard/chat_settings/settings.txt") or "{}");

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);
file.CreateDir("serverguard/chat_settings");

plugin:Hook("serverguard.RanksLoaded", "chat_settings.RanksLoaded", function()
	for k, v in pairs(serverguard.ranks:GetStored()) do
		plugin.settings.group[k] = table.Copy(plugin.settings.groupOptions);
	end;

	if (savedSettings.general) then
		for k, v in pairs(savedSettings.general) do
			if (plugin.settings.general[k] != nil) then
				plugin.settings.general[k] = v;
			end;
		end;

		for k, v in pairs(savedSettings.group) do
			plugin.settings.group[k] = plugin.settings.group[k] or {};
			
			table.Merge(plugin.settings.group[k], plugin.settings.groupOptions);
			table.Merge(plugin.settings.group[k], v);

			for k2, v2 in pairs(plugin.settings.group[k]) do
				if (plugin.settings.groupOptions[k2] == nil) then
					plugin.settings.group[k][k2] = nil;
				end;
			end;
		end;
	end;
end);

plugin:Hook("serverguard.RankCreated", "chat_settings.RankCreated", function(uniqueID)
	if (!plugin.settings.group[uniqueID]) then
		plugin.settings.group[uniqueID] = table.Copy(plugin.settings.groupOptions);
	end;
end);

serverguard.netstream.Hook("sgGetChatSettings", function(player, data)
	serverguard.netstream.Start(player, "sgGetChatSettings", plugin.settings);
end);

serverguard.netstream.Hook("sgSetChatSettings", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Chat Settings")) then
		if (type(data) == "table" and data.general and data.group) then
			for k, v in pairs(data.general) do
				if (plugin.settings.general[k] != nil) then
					plugin.settings.general[k] = v;
				end;
			end;

			for k, v in pairs(data.group) do
				if (plugin.settings.group[k] != nil) then
					plugin.settings.group[k] = table.Merge(table.Copy(plugin.settings.groupOptions), v);
				end;
			end;

			file.Write("serverguard/chat_settings/settings.txt", serverguard.von.serialize(plugin.settings));			
			serverguard.Notify(player, "Chat settings updated.");
		end;
	end;
end);

plugin:Hook("PlayerInitialSpawn", "chat_settings.PlayerInitialSpawn", function(player)
	local welcomeMessage = plugin:GetSetting("Player welcome message");

	local replacements = {
            ["{name}"] = player:Name(),
            ["{map}"]  = game.GetMap(),
            ["{servername}"] = hostname:GetString(),
            ["{time}"] = os.date("%I:%M %p"),
            ["{steamid}"] = player:SteamID(),
            ["{steamid64}"] = player:SteamID64()
        };
	
	if (welcomeMessage != "") then
		for k,v in pairs(replacements) do
			welcomeMessage = string.gsub(welcomeMessage, k, v);
		end

		serverguard.Notify(player, hook.Call("chat_settings.WelcomeMessage", nil, player, welcomeMessage) or welcomeMessage);
	end;
end);

plugin:Hook("PlayerConnected", "chat_settings.PlayerConnected", function(player)
	local connectMessage = plugin:GetSetting("Player connect message");

	if (connectMessage != "") then
		connectMessage = string.gsub(connectMessage,{
            ["{name}"] = player:Name(),
            ["{steamid}"] = player:SteamID()
        })

		serverguard.Notify(nil, SERVERGUARD.NOTIFY.WHITE, hook.Call("chat_settings.ConnectMessage", nil, player, connectMessage) or connectMessage);
	end;
end);

plugin:Hook("PlayerDisconnected", "chat_settings.PlayerDisconnected", function(player)
	local disconnectMessage = plugin:GetSetting("Player disconnect message");

	if (disconnectMessage != "") then
		disconnectMessage = string.gsub(disconnectMessage, "{name}", player:Name());
		disconnectMessage = string.gsub(disconnectMessage, "{steamid}", player:SteamID());

		serverguard.Notify(nil, SERVERGUARD.NOTIFY.WHITE, hook.Call("chat_settings.DisconnectMessage", nil, player, disconnectMessage) or disconnectMessage);
	end;
end);

plugin:Hook("serverguard.CommandNotify", "chat_settings.CommandNotify", function(player, targets, arguments)
	if (plugin:SettingIsActive("Hide commands ran", player)) then
		return true;
	end;
end);