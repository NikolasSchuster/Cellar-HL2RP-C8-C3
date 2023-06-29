--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Chat Settings";
plugin.author = "duck";
plugin.version = "1.0";
plugin.description = "Allows for the editing of various settings for the chat.";
plugin.permissions = {"Manage Chat Settings"};
plugin.settings = {};
plugin.settings.group = {};

-- General setting names and default values. Strings and booleans only.
plugin.settings.general = {
	["Player welcome message"] = "",
	["Player connect message"] = "",
	["Player disconnect message"] = "",
	["Show *DEAD* prefix"] = true
};

-- Booleans only for group options.
plugin.settings.groupOptions = {
	["Hide commands ran"] = false,
	["Show rank prefix"] = false
};

--- Gets whether or not a setting is active or applicable for a player.
-- @string setting The setting to check for.
-- @player player If checking for a player, the player to check the setting for.
-- @return bool Whether or not the setting is active or applicable for the player.
function plugin:SettingIsActive(setting, player)
	if (IsValid(player)) then
		local rankSettings = self.settings.group[serverguard.player:GetRank(player)];

		if (rankSettings) then
			return rankSettings[setting];
		end;
	else
		setting = self.settings.general[setting];

		return setting and setting != "";
	end;
end;

--- Gets a general setting's value, either a boolean or a string.
-- @string setting The setting to check for.
-- @return The value of the setting.
function plugin:GetSetting(setting)
	return plugin.settings.general[setting];
end;