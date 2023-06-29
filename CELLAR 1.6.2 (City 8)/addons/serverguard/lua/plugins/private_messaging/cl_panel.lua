-- --[[
-- 	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
-- 	without permission of its author (gustaf@thrivingventures.com).
-- ]]

-- local plugin = plugin;
-- local category = {};

-- category.name = "Private messages";
-- category.material = "serverguard/menuicons/icon_private_messages.png";
-- category.permissions = "Manage Private Messages";

-- function category:Create(base)
-- 	serverguard.netstream.Start("sgGetPrivateMessages");

-- 	category.panel = base:Add("tiger.panel");
-- 	category.panel:SetTitle("Private messages");
-- 	category.panel:DockPadding(24, 24, 24, 48);
-- 	category.panel:Dock(FILL);

-- 	category.panel.statusLabel = category.panel:Add("DLabel");
-- 	category.panel.statusLabel:SetFont("tiger.button");
-- 	category.panel.statusLabel:SetText("");
-- 	category.panel.statusLabel:SetSkin("serverguard");

-- 	category.panel.list = category.panel:Add("tiger.list");
-- 	category.panel.list:Dock(FILL);

-- 	category.panel.list:AddColumn("#", 25):SetDisabled(true);
-- 	category.panel.list:AddColumn("SENDER", 150);
-- 	category.panel.list:AddColumn("RECEIVER", 150);
-- 	category.panel.list:AddColumn("MESSAGE", 200);
-- 	category.panel.list.sortType = SORT_DESCENDING;

-- 	category.panel.refreshButton = category.panel:Add("tiger.button");
-- 	category.panel.refreshButton:SetText("Refresh");
-- 	category.panel.refreshButton:SizeToContents();

-- 	if (serverguard.player:HasPermission(LocalPlayer(), "Delete All Private Messages")) then
-- 		category.panel.deleteAllButton = category.panel:Add("tiger.button");
-- 		category.panel.deleteAllButton:SetText("Delete all");
-- 		category.panel.deleteAllButton:SizeToContents();
-- 	end;

-- 	category.panel.searchPanel = category.panel:Add("Panel");
-- 	category.panel.searchPanel:SetTall(20);
-- 	category.panel.searchPanel:Dock(TOP);
-- 	category.panel.searchPanel:DockMargin(2, 0, 2, 14);
-- 	category.panel.searchPanel.searchLabel = category.panel.searchPanel:Add("DLabel");
-- 	category.panel.searchPanel.searchLabel:SetText("Search by");
-- 	category.panel.searchPanel.searchLabel:SizeToContents();
-- 	category.panel.searchPanel.searchLabel:Dock(LEFT);
-- 	category.panel.searchPanel.searchLabel:DockMargin(0, 0, 8, 0);
-- 	category.panel.searchPanel.searchLabel:SetSkin("serverguard");

-- 	category.panel.searchPanel.comboBox = category.panel.searchPanel:Add("DComboBox");
-- 	category.panel.searchPanel.comboBox:SetTall(20);
-- 	category.panel.searchPanel.comboBox:SetSkin("serverguard");
-- 	category.panel.searchPanel.comboBox:Dock(LEFT);
-- 	category.panel.searchPanel.comboBox:DockMargin(0, 0, 8, 0);
-- 	category.panel.searchPanel.comboBox:SetWide(120);
-- 	category.panel.searchPanel.comboBox:AddChoice("Sender Name");
-- 	category.panel.searchPanel.comboBox:AddChoice("Sender SteamID");
-- 	category.panel.searchPanel.comboBox:AddChoice("Receiver Name");
-- 	category.panel.searchPanel.comboBox:AddChoice("Receiver SteamID");
-- 	category.panel.searchPanel.comboBox:AddChoice("Message");
-- 	category.panel.searchPanel.comboBox:AddChoice("ID");
-- 	category.panel.searchPanel.comboBox:SetText("Sender Name");

-- 	function category.panel.searchPanel.comboBox:OnSelect(index, value)
-- 		category.panel.searchPanel.textEntry:OnValueChange(category.panel.searchPanel.textEntry:GetText());
-- 	end;

-- 	function category.panel.searchPanel.comboBox:OpenMenu(pControlOpener)
-- 		DComboBox.OpenMenu(self, pControlOpener);

-- 		if (IsValid(self.Menu)) then
-- 			self.Menu:SetSkin("serverguard");
-- 		end;
-- 	end;

-- 	category.panel.searchPanel.textEntry = category.panel.searchPanel:Add("DTextEntry");
-- 	category.panel.searchPanel.textEntry:SetTall(20);
-- 	category.panel.searchPanel.textEntry:SetSkin("serverguard");
-- 	category.panel.searchPanel.textEntry:Dock(FILL);

-- 	function category.panel.searchPanel.textEntry:OnValueChange(text)
-- 		local children = category.panel.list:GetCanvas():GetChildren();
-- 		local searchOption = category.panel.searchPanel.comboBox:GetText();

-- 		if (searchOption == "") then return; end;

-- 		for k, v in pairs(children) do
-- 			local labelText = "";

-- 			if (searchOption == "Sender Name") then
-- 				labelText = v:GetLabel(2):GetText();
-- 			elseif (searchOption == "Sender SteamID") then
-- 				labelText = v.sender_steamid;
-- 			elseif (searchOption == "Receiver Name") then
-- 				labelText = v:GetLabel(3):GetText();
-- 			elseif (searchOption == "Receiver SteamID") then
-- 				labelText = v.receiver_steamid;
-- 			elseif (searchOption == "ID") then
-- 				labelText = v:GetLabel(1):GetText();
-- 			elseif (searchOption == "Message") then
-- 				labelText = v:GetLabel(4):GetText();
-- 			end;

-- 			if (!string.find(string.lower(labelText):PatternSafe(), string.lower(text):PatternSafe())) then
-- 				v:SetSize(0, 0);
-- 			else
-- 				v:SetSize(716, 30);
-- 			end;
-- 		end;
-- 	end;

-- 	-- Call OnValueChange without having to press the enter key.
-- 	function category.panel.searchPanel.textEntry:GetUpdateOnType()
-- 		return true;
-- 	end;

-- 	function category.panel.refreshButton:DoClick()
-- 		category.panel.list:Clear();
-- 		serverguard.netstream.Start("sgGetPrivateMessages");
-- 	end;

-- 	if (serverguard.player:HasPermission(LocalPlayer(), "Delete All Private Messages")) then
-- 		function category.panel.deleteAllButton:DoClick()
-- 			util.CreateDialog("Notice", "Are you sure you want to delete all private messages?",
-- 				function()
-- 					serverguard.netstream.Start("sgRemovePrivateMessage", true);
-- 					category.panel.list:Clear();
-- 					category.panel.statusLabel:SetText("Total private messages: 0");
					
-- 					timer.Simple(FrameTime() * 8, function() category.panel.list:GetCanvas():InvalidateLayout() end);
-- 				end, "&Yes",
-- 				function()
-- 				end, "No"
-- 			);
-- 		end;
-- 	end;

-- 	function category.panel:PerformLayout(width, height)
-- 		category.panel.refreshButton:SetPos(width - (category.panel.refreshButton:GetWide() + 24), height - (category.panel.refreshButton:GetTall() + 14));
-- 		category.panel.statusLabel:SetPos(25, height - (category.panel.statusLabel:GetTall() + 18));

-- 		if (serverguard.player:HasPermission(LocalPlayer(), "Delete All Private Messages")) then
-- 			category.panel.deleteAllButton:SetPos(width - (category.panel.deleteAllButton:GetWide() + 100), height - (category.panel.deleteAllButton:GetTall() + 14));
-- 		end;
-- 	end;
-- end;

-- plugin:AddSubCategory("Intelligence", category);

-- serverguard.netstream.Hook("sgGetPrivateMessages", function(data)
-- 	category.panel.list:Clear();

-- 	category.panel.statusLabel:SetText("Total private messages: "..tostring(#data));
-- 	category.panel.statusLabel:SizeToContents();

-- 	for k, v in pairs(data) do
-- 		local item = category.panel.list:AddItem(v.id, v.sender, v.receiver, v.message);

-- 		function item:OnMousePressed()
-- 			local menu, option = DermaMenu(), nil;
-- 				menu:SetSkin("serverguard");
-- 				option = menu:AddOption("More Info", function() 
-- 					util.CreateDialog("Message", string.format("From %s (%s) to %s (%s).\n\n%s", v.sender, v.sender_steamid, v.receiver, v.receiver_steamid, v.message),
-- 						function()

-- 						end, "Close"
-- 					);
-- 				end);
-- 				option:SetImage("icon16/information.png");
-- 				option = menu:AddOption("Delete", function() 
-- 					util.CreateDialog("Notice", "Are you sure you want to delete this private message?",
-- 						function()
-- 							serverguard.netstream.Start("sgRemovePrivateMessage", v.id);
-- 						end, "&Yes",
-- 						function()
-- 						end, "No"
-- 					);
-- 				end);
-- 				option:SetImage("icon16/delete.png");
-- 			menu:Open();
-- 		end;

-- 		item.sender_steamid, item.receiver_steamid = v.sender_steamid, v.receiver_steamid;
-- 		item.id = v.id;
-- 	end;

-- 	plugin.messages = data;
-- end);