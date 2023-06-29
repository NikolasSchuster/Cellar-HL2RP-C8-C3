--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local category = {};

plugin.changes = {general = {}, group = {}};

category.name = "Chat settings";
category.material = "serverguard/menuicons/icon_reports.png";
category.permissions = "Manage Chat Settings";

local function CreatePanelForRank(uniqueRank)
	local settings = plugin.settings.group[uniqueRank];
	local checkboxes = {};

	local panel = vgui.Create("tiger.panel");
	panel:SetTitle(uniqueRank.." chat settings");
	panel:SetSize(450, 275);
	panel:Center();
	panel:MakePopup();
	panel:DockPadding(24, 24, 24, 48);

	local list = panel:Add("tiger.list");
	list:Dock(TOP);
	list:SetTall(145);

	local confirmButton = panel:Add("tiger.button");
	confirmButton:SetText("Confirm");
	confirmButton:SetPos(362, 235);

	function confirmButton:DoClick()
		panel:Remove();
	end;

	for k, v in SortedPairs(settings) do
		local checkbox = vgui.Create("tiger.checkbox");

		checkbox:SetText(k);
		checkbox:SetChecked(v);
		checkbox:Dock(TOP);

		function checkbox:OnChange(bChecked)
			plugin.changes.group[uniqueRank] = plugin.changes.group[uniqueRank] or {};
			plugin.changes.group[uniqueRank][k] = bChecked;
			plugin.settings.group[uniqueRank][k] = bChecked;
		end;

		checkboxes[k] = checkbox;
		list:AddPanel(checkbox);
	end;
end;

function category:Create(base)
	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("Chat settings");
	base.panel:DockPadding(24, 24, 24, 48);
	base.panel:Dock(FILL);

	base.panel.settingList = base.panel:Add("tiger.list");
	base.panel.settingList:Dock(TOP);
	base.panel.settingList:SetTall(122);

	base.panel.rankList = base.panel:Add("tiger.list");
	base.panel.rankList:Dock(FILL);
	base.panel.rankList:DockMargin(0, 8, 0, 0);

	base.panel.rankList:AddColumn("UNIQUE", 240);
	base.panel.rankList:AddColumn("NAME", 240);

	base.panel.apply = base.panel:Add("tiger.button");
	base.panel.apply:SetText("Apply");
	base.panel.apply:SizeToContents();

	function base.panel.apply:DoClick()
		if ((table.Count(plugin.changes.general) > 0) or (table.Count(plugin.changes.group) > 0)) then
			serverguard.netstream.Start("sgSetChatSettings", plugin.changes);
			plugin.changes = {general = {}, group = {}};
		else
			serverguard.Notify(nil, SERVERGUARD.NOTIFY.RED, "There are no changes to apply.");
		end;
	end;

	function base.panel:PerformLayout(width, height)
		base.panel.apply:SetPos(width - (base.panel.apply:GetWide() + 24), height - (base.panel.apply:GetTall() + 14))
	end;
end;

function category:Update(base)
	local ranks = serverguard.ranks:GetTable();

	base.panel.rankList:Clear();

	for unique, data in pairs(ranks) do
		local panel = base.panel.rankList:AddItem(unique, data.name);
		local label = panel:GetLabel(2);

		label:SetColor(data.color);
		label.oldColor = data.color;

		function panel:OnMousePressed()
			CreatePanelForRank(unique);
		end;
	end;

	plugin.base = base;
	serverguard.netstream.Start("sgGetChatSettings");
end;

plugin:AddSubCategory("Server settings", category);