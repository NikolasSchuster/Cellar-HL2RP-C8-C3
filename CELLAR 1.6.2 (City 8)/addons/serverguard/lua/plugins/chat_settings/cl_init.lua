--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

plugin:Hook("OnPlayerChat", "chat_settings.OnPlayerChat", function(player, text, bTeam, bIsDead, prefixText, col1, col2)
	local message = {};

	if (bIsDead and plugin:SettingIsActive("Show *DEAD* prefix")) then
		table.insert(message, Color(255, 0, 0));
		table.insert(message, "*DEAD* ");
	end;

	if (bTeam) then
		table.insert(message, Color(0, 255, 0));
		table.insert(message, "(TEAM) ");
	end;

	if (plugin:SettingIsActive("Show rank prefix", player)) then
		local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(player));

		table.insert(message, Color(230, 230, 230));
		table.insert(message, "(");
		table.insert(message, rankData.color);

		table.insert(message, rankData.name);
		table.insert(message, Color(230, 230, 230));
		table.insert(message, ") ");
	end;

	if (!util.IsConsole(player)) then
		table.insert(message, team.GetColor(player:Team()));
	else
		table.insert(message, serverguard.NotifyColors[SERVERGUARD.NOTIFY.GREEN]);
	end;

	table.insert(message, prefixText or serverguard.player:GetName(player));
	table.insert(message, Color(230, 230, 230));
	table.insert(message, ": "..text);

	chat.AddText(unpack(message));
	
	return true;
end);

plugin:Hook("InitPostEntity", "chat_settings.InitPostEntity", function()
	serverguard.netstream.Start("sgGetChatSettings");
end);

serverguard.netstream.Hook("sgGetChatSettings", function(data)
	plugin.settings = data;

	if (IsValid(plugin.base)) then
		local base = plugin.base;

		base.panel.settingList:Clear();

		for k, v in SortedPairs(plugin.settings.general) do
			local settingType = type(v);

			if (settingType == "boolean") then
				local checkbox = vgui.Create("tiger.checkbox");

				checkbox:SetText(k);
				checkbox:SetChecked(v);
				checkbox:Dock(TOP);

				function checkbox:OnChange(bChecked)
					plugin.changes.general[k] = bChecked;
					plugin.settings.general[k] = bChecked;
				end;

				base.panel.settingList:AddPanel(checkbox);
			elseif (settingType == "string") then
				local textEntry = vgui.Create("tiger.textentry");

				textEntry:SetLabelText(k);
				textEntry:SetValue(v);
				textEntry:Dock(TOP);

				function textEntry:OnValueChange(text)
					plugin.changes.general[k] = text;
					plugin.settings.general[k] = text;
				end;

				-- Call OnValueChange without having to press the enter key.
				function textEntry:GetUpdateOnType()
					return true;
				end;

				base.panel.settingList:AddPanel(textEntry);
			end;
		end;
	end;
end);