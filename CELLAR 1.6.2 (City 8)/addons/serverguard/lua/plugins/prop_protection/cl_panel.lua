--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

local category = {};

category.name = "Prop protection";
category.material = "serverguard/menuicons/icon_prop_protection.png";

category.blacklist = {
	list = {},
	queue = {}
};
category.nextBlacklistQueueTime = CurTime();

local blacklistSendQueue = {};

local function CreateBuddiesPanel(base)
	local buddiesPanel = base:Add("tiger.panel");
	buddiesPanel:SetTitle("Add or remove buddies");
	buddiesPanel:Dock(FILL);

	buddiesPanel.list = buddiesPanel:Add("tiger.list");
	buddiesPanel.list:Dock(FILL);
	buddiesPanel.list:AddColumn("PLAYER", 400);
	buddiesPanel.list:AddColumn("FRIEND", 20);

	hook.Call("serverguard.panel.BuddiesList", nil, buddiesPanel.list);

	function buddiesPanel.list:Think()
		local players = player.GetHumans();

		for i = 1, #players do
			local pPlayer = players[i];
			
			if (!IsValid(pPlayer.propProtection) and pPlayer != LocalPlayer()) then
				local panel = self:AddItem(serverguard.player:GetName(pPlayer));
				
				panel.player = pPlayer;
				panel.steamID = pPlayer:SteamID();
				
				function panel:Think()
					if (!IsValid(self.player)) then
						self:Remove();
						
						buddiesPanel.list:GetCanvas():InvalidateLayout();
		
						timer.Simple(FrameTime() *2, function()
							buddiesPanel.list:OnSort();
						end);
					end;
				end;
				
				function panel:OnMousePressed(code)
					local isFriend = false;
					local friends = g_serverGuard.prop_protection.buddies;
					
					for k, steamID in pairs(friends) do
						if (steamID == panel.steamID) then
							isFriend = true;
							
							break;
						end;
					end;
					
					local menu = DermaMenu();
						menu:SetSkin("serverguard");
						
						if (!isFriend) then
							local option = menu:AddOption("Add friend", function()
								serverguard.netstream.Start("sgPropProtectionUploadFriends", {panel.steamID, false});
								
								table.insert(g_serverGuard.prop_protection.buddies, panel.steamID);

								hook.Call("CPPIFriendsChanged", nil, LocalPlayer(), g_serverGuard.prop_protection.buddies);
								
								serverguard.config.Save("prop_protection", g_serverGuard.prop_protection.buddies);
							end);
							
							option:SetImage("icon16/accept.png");
						else
							local option = menu:AddOption("Remove friend", function()
								serverguard.netstream.Start("sgPropProtectionUploadFriends", {panel.steamID, true});
								
								for i = 1, #friends do
									local steamID = friends[i];
									
									if (steamID == panel.steamID) then
										table.remove(g_serverGuard.prop_protection.buddies, i);
										
										break;
									end;
								end;
								
								self.image:SetImage("icon16/cancel.png");
								self.image:SetSort(0);
							end);
							
							option:SetImage("icon16/cancel.png");
						end;
						
						if (serverguard.player:HasPermission(LocalPlayer(), "Manage Prop-Protection")) then
							local option = menu:AddOption("Cleanup props", function()
								serverguard.netstream.Start("sgPropProtectionCleanProps", panel.steamID);
							end);
							
							option:SetImage("icon16/cancel.png");
						end;
					menu:Open();
				end;
				
				local nameLabel = panel:GetLabel(1);
				
				nameLabel:SetUpdate(function(self)
					if (IsValid(pPlayer)) then
						if (self:GetText() != serverguard.player:GetName(pPlayer)) then
							self:SetText(serverguard.player:GetName(pPlayer));
						end;
					end;
				end);
				
				panel.image = vgui.Create("DImage");
				panel.image:SetSize(16, 16);
				panel.image:SetImage("icon16/cancel.png");

				function panel.image:Think()
					local friends = g_serverGuard.prop_protection.buddies;
					
					for k, steamID in pairs(friends) do
						if (steamID == panel.steamID) then
							if (self:GetImage() == "icon16/cancel.png") then
								self:SetImage("icon16/accept.png");
								self:SetSort(1);
							end;
						end;
					end;
				end;
				
				function panel.image:PerformLayout()
					local w, h = self:GetSize();
					local column = panel:GetThing(2).column;
					local x = column:GetPos();
					
					self:SetPos(x +column:GetWide() / 2 - w / 2, column:GetTall() / 2 - h / 2);
				end;
				
				panel:AddItem(panel.image);
				
				pPlayer.propProtection = panel;
			end;
		end;
	end;
end;

function category:Create(categoryBase)
	local managePermission = serverguard.player:HasPermission(LocalPlayer(), "Manage Prop-Protection");
	local blacklistPermission = serverguard.player:HasPermission(LocalPlayer(), "Manage Prop Blacklist");

	if (!managePermission and !blacklistPermission) then
		CreateBuddiesPanel(categoryBase);

		return;
	end;

	categoryBase.base = categoryBase:Add("tiger.base");
	categoryBase.base:SetFooterEnabled(false);
	categoryBase.base:UseSmallPanels(true);
	categoryBase.base:Dock(FILL);

	categoryBase.base:AddSection("Buddies", "serverguard/menuicons/icon_buddies.png", function(panelBase)
		if (!panelBase.created) then -- Create()
			CreateBuddiesPanel(panelBase);

			panelBase.created = true;
		end;
	end);
	
	if (serverguard.player:HasPermission(LocalPlayer(), "Manage Prop Blacklist")) then
		categoryBase.base:AddSection("Blacklist", "serverguard/menuicons/icon_blacklist.png", function(panelBase)
			if (!panelBase.created) then -- Create()
				local blacklistPanel = panelBase:Add("tiger.panel");
				blacklistPanel:SetTitle("Manage prop blacklist");
				blacklistPanel:Dock(FILL);
				blacklistPanel:DockPadding(24, 24, 24, 48);

				local scrollPanel = blacklistPanel:Add("tiger.scrollpanel");
				scrollPanel:SetDrawBorder(true);
				scrollPanel:Dock(FILL);

				category.blacklistLayout = scrollPanel:Add("DIconLayout");
				category.blacklistLayout:Dock(TOP);

				category.blacklistLayout:SetSpaceX(4);
				category.blacklistLayout:SetSpaceY(4);
				category.blacklistLayout:SetBorder(6);

				-- we queue creation so we don't lag the user by potentially creating a lot of panels, also useful for animation
				category.blacklistLayout.Think = function(_panel)
					if (category.blacklist and #category.blacklist.queue > 0 and CurTime() >= category.nextBlacklistQueueTime) then
						local theme = serverguard.themes.GetCurrent();
						local amount = math.min(#category.blacklist.queue, 1);

						if (#category.blacklist.queue > 1000) then -- load more panels at a time if there are a lot of props
							amount = math.min(#category.blacklist.queue, 9);
						end;

						for i = 1, amount do
							local model = category.blacklist.queue[i];
							local iconBase = _panel:Add("DPanel");

							iconBase.model = model;
							iconBase:SetSize(64, 64);
							iconBase.Paint = function(_self, width, height)
								draw.RoundedBox(4, 0, 0, width, height, theme.tiger_base_bg);
							end;

							iconBase.icon = vgui.Create("SpawnIcon", iconBase);
							iconBase.icon:SetSize(64, 64);
							iconBase.icon:SetModel(model);
							iconBase.icon:SetToolTip(nil);
							iconBase.icon:SetToolTipSG(model);
							iconBase.icon.DoClick = function(_icon)
								local menu = DermaMenu();
									menu:SetSkin("serverguard");

									local option = menu:AddOption("Copy model path", function()
										SetClipboardText(model);
									end);

									option:SetImage("icon16/page_copy.png");

									option = menu:AddOption("Remove from blacklist", function()
										category:RemoveBlacklistProp(model, true);
									end);

									option:SetImage("icon16/delete.png");
								menu:Open();
							end;

							iconBase:SetAlpha(0);
							iconBase:AlphaTo(255, 0.5, 0);
						end;

						for i = 1, amount do
							table.remove(category.blacklist.queue, i);
						end;

						category.nextBlacklistQueueTime = CurTime() + FrameTime();
					end;
				end;

				local add = blacklistPanel:Add("tiger.button");
				add:SetPos(4, 4);
				add:SetText("Add model");
				add:SizeToContents();
				add.DoClick = function(_panel)
					util.CreateStringRequest("Add prop to blacklist",
						function(text)
							if (text != "") then
								category:AddBlacklistProp(text, true);
							end;
						end, "Add",
						function(text)
						end, "Cancel"
					);
				end;

				local remove = blacklistPanel:Add("tiger.button");
				remove:SetPos(4, 4);
				remove:SetText("Remove model");
				remove:SizeToContents();
				remove.DoClick = function(_panel)
					util.CreateStringRequest("Remove prop from blacklist",
						function(text)
							if (text != "") then
								category:RemoveBlacklistProp(text, true);
							end;
						end, "Add",
						function(text)
						end, "Cancel"
					);
				end;

				local refresh = blacklistPanel:Add("tiger.button");
				refresh:SetPos(4, 4);
				refresh:SetText("Refresh");
				refresh:SizeToContents();
				refresh.DoClick = function(_panel)
					blacklistSendQueue = {};
					serverguard.netstream.Start("sgPropProtectionGetBlacklist", true);
				end;


				blacklistPanel.PerformLayout = function(_panel)
					local width, height = _panel:GetSize();
					
					refresh:SetPos(width - (refresh:GetWide() + 24), height - (refresh:GetTall() + 14));
					
					add:SetPos(0, height - (add:GetTall() + 14));
					add:MoveLeftOf(refresh, 14);

					remove:SetPos(0, height - (remove:GetTall() + 14));
					remove:MoveLeftOf(add, 14);
				end;

				serverguard.netstream.Start("sgPropProtectionGetBlacklist", true);
				panelBase.created = true;
			end;
		end);
	end;

	if (serverguard.player:HasPermission(LocalPlayer(), "Manage Prop-Protection")) then
		categoryBase.base:AddSection("Settings", "serverguard/menuicons/icon_settings.png", function(panelBase)
			if (!panelBase.created) then -- Create()
				local configPanel = panelBase:Add("tiger.panel");
				configPanel:SetTitle("Manage prop protection");
				configPanel:Dock(FILL);

				local configList = configPanel:Add("tiger.list");
				configList:SetTall(152);
				configList:Dock(TOP);

				for k, v in pairs(plugin.config:GetTable()) do
					local checkbox = vgui.Create("tiger.checkbox");
					configList:AddPanel(checkbox);

					checkbox:Dock(TOP);
					checkbox:SetText(v.description);
					checkbox:BindToConfig("propprotection", k);
				end;
				
				local cleanProps = configPanel:Add("tiger.button");
				cleanProps:SetText("Cleanup all disconnected players props");
				cleanProps:SizeToContents();
				cleanProps:DockMargin(0, 8, 0, 0);
				cleanProps:Dock(TOP);
				
				function cleanProps:DoClick()
					serverguard.netstream.Start("sgPropProtectionCleanDisconnectedProps", true);
				end;

				panelBase.created = true;
			else -- Update()
				serverguard.netstream.Start("sgPropProtectionRequestConfig", true);
			end;
		end, "Manage Prop-Protection");
	end;

	categoryBase.base:SetSectionSelected("Buddies");
end;

function category:AddBlacklistProp(model, bSend)
	if (!table.HasValue(self.blacklist.list, model)) then
		table.insert(self.blacklist.list, model);
		table.insert(self.blacklist.queue, model);
	end;

	if (bSend) then -- we send anyway; server will handle notifies
		serverguard.netstream.Start("sgPropProtectionAddBlacklist", model);
	end;
end;

function category:RemoveBlacklistProp(model, bSend)
	table.RemoveByValue(self.blacklist.list, model);
	table.RemoveByValue(self.blacklist.queue, model);

	for k, v in ipairs(self.blacklistLayout:GetChildren()) do
		if (v.icon and IsValid(v.icon) and v.model == model) then
			v:AlphaTo(0, 0.5, 0, function()
				v:Remove();
			end);
		end;
	end;

	if (bSend) then
		serverguard.netstream.Start("sgPropProtectionRemoveBlacklist", model);
	end;
end;

plugin:AddCategory(category);

plugin:Hook("PopulatePropMenu", "prop_protection.PopulatePropMenu", function() -- HACK
	plugin.oldContentFunction = spawnmenu.GetContentType("model");

	spawnmenu.AddContentType("model", function(container, object)
		local icon = plugin.oldContentFunction(container, object);

		if (icon.OpenMenu) then
			icon.oldOpenMenu = icon.OpenMenu;

			icon.OpenMenu = function(panel)
				icon.oldOpenMenu(panel);

				if (serverguard.player:HasPermission(LocalPlayer(), "Manage Prop Blacklist")) then
					local model = object.model;

					local menu = vgui.Create("DMenu");

					if (table.HasValue(category.blacklist.list, model)) then
						menu:AddOption("Remove from prop blacklist", function()
							category:RemoveBlacklistProp(object.model, true);
						end);
					else
						menu:AddOption("Add to prop blacklist", function()
							category:AddBlacklistProp(object.model, true);
						end);
					end;

					menu:Open();
					menu:SetPos(gui.MouseX() - menu:GetWide(), gui.MouseY());
				end;
			end;
		end;
	end);
end);

serverguard.netstream.Hook("sgPropProtectionGetBlacklistChunk", function(data)
	if (category and IsValid(category.blacklistLayout)) then
		category.blacklistLayout:Clear();
	end;
    
	category.blacklist.list = table.Copy(data);
	category.blacklist.queue = data;
end);