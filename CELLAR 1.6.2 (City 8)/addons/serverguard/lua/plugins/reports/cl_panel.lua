--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

surface.CreateFont("serverguard.reports.name", {
	font = "Helvetica",
	size = 14,
	weight = 800
});

surface.CreateFont("serverguard.reports.text", {
	font = "Tahoma",
	size = 12,
	weight = 400
});

local plugin = plugin or {};
local category = {};

category.name = "Reports";
category.material = "serverguard/menuicons/icon_envelope.png";
category.permissions = "Manage Reports";

function category:Create(base)
	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("View reports");
	base.panel:Dock(FILL);

	category.list = base.panel:Add("tiger.list");
	category.list:DockMargin(0, 0, 0, 24);
	category.list:Dock(FILL);

	function category.list:Paint(w, h) end;

	base.refreshButton = base.panel:Add("tiger.button");
	base.refreshButton:SetPos(4, 4);
	base.refreshButton:SetText("Refresh");
	base.refreshButton:SizeToContents();
	base.refreshButton.DoClick = function(panel)
		self:Update();
	end;

	if (serverguard.player:HasPermission(LocalPlayer(), "Delete All Reports")) then
		base.deleteAllButton = base.panel:Add("tiger.button");
		base.deleteAllButton:SetPos(4, 4);
		base.deleteAllButton:SetText("Delete all");
		base.deleteAllButton:SizeToContents();

		function base.deleteAllButton:DoClick()
			util.CreateDialog("Notice", "Are you sure you want to delete all reports?",
			function()
				serverguard.netstream.Start("sgRequestRemoveAllReports", true);

				category.list:Clear();

				category.statusLabel:SetText("Total reports: 0");
				category.statusLabel:SizeToContents();
				
				timer.Simple(FrameTime() * 8, function() category.list:GetCanvas():InvalidateLayout() end);
			end, "&Yes",
			function()
			end, "No"
		);
		end;
	end;

	function base.panel:PerformLayout(width, height)
		base.refreshButton:SetPos(width - (base.refreshButton:GetWide() + 24), height - (base.refreshButton:GetTall() + 14));

		if (serverguard.player:HasPermission(LocalPlayer(), "Delete All Reports")) then
			base.deleteAllButton:SetPos(0, height - (base.deleteAllButton:GetTall() + 14));
			base.deleteAllButton:MoveLeftOf(base.refreshButton, 14);
		end;

		category.statusLabel:SetPos(25, height - (category.statusLabel:GetTall() + 18));
	end;

	category.statusLabel = base.panel:Add("DLabel");
	category.statusLabel:SetFont("tiger.button");
	category.statusLabel:SetText("");
	category.statusLabel:SetSkin("serverguard");
end;

local reportsCount = 0;

function category:Update(base)
	self:ClearReports();
	
	serverguard.netstream.Start("sgRequestReports", true);
end;

function category:ClearReports()
	self.list:Clear();
	self.list.list:PerformLayout();

	reportsCount = 0;
end;

function category:GetCount()
	return math.abs(reportsCount);
end;

function category:UpdateReports(data)

	local panel = vgui.Create("tiger.panel");
	panel:SetMouseInputEnabled(true);
	panel:DockMargin(0, 0, 24, 8);
	panel:Dock(TOP);
	panel:SetZPos(reportsCount);

	panel.id = data.id;
	
	local str = "";
	local width = 0;
	
	local exploded = string.Explode(" ", data.text);
	local seperator = " ";
	
	if (#exploded <= 2) then
		exploded = string.ToTable(data.text);
		seperator = "";
	end;
	
	local start = 1;
	local ending = 1;
	
	while ending <= #exploded do
		local text = table.concat(exploded, seperator, start, ending);
		
		if (width + util.GetTextSize("serverguard.reports.text", text) >= 692) then
			local previous = ending - 1;
			
			if (previous < start) then
				str = str .. text .. "\n";
				
				start = ending + 1;
				ending = start;
			else
				str = str .. table.concat(exploded, seperator, start, previous) .. "\n";

				start = ending;
				ending = start;
			end;
			
			width = 0;
		else
			ending = ending + 1;
			
			if (ending > #exploded) then
				str = str .. text;

				width = width + util.GetTextSize("serverguard.reports.text", text);
			end;
		end;
	end;
	
	local spacing = string.Explode("\n", str);
	local height = 12 * #spacing;
	height = height + 52;
	
	panel:SetTall(42);

	function panel:PaintOver(w, h)
		local theme = serverguard.themes.GetCurrent();
		
		draw.SimpleText(data.name, "serverguard.reports.name", 15, 14, Color(0, 119, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
		
		local x = util.GetTextSize("serverguard.reports.name", data.name);
		x = x + 15;
		
		if (data.answered) then
			local newTime = string.FormattedTime(os.time() - data.answered, "%02i:%02i:%02i" )
			draw.SimpleText("•  " .. data.steamID .. "  •  " .. data.time .. " • Claimed by " .. data.member, "serverguard.reports.text", x + 4, 15, Color(109, 109, 109, 240), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
		else
			draw.SimpleText("•  " .. data.steamID .. "  •  " .. data.time, "serverguard.reports.text", x + 4, 15, Color(109, 109, 109, 240), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
		end

		if (self:GetTall() > 42) then
			draw.DrawText(str, "serverguard.reports.text", 15, 38, theme.tiger_list_panel_label, TEXT_ALIGN_LEFT);
		end;
	end;

	function panel:OnMouseReleased(keyCode)
		if (keyCode != MOUSE_RIGHT) then
			return;
		end;

		local menu = DermaMenu();
			menu:SetSkin("serverguard");

			menu:AddOption("Copy Steam ID", function()
				SetClipboardText(data.steamID);
			end);

			menu:AddOption("Copy Text", function()
				SetClipboardText(data.text);
			end);

			// Maybe better to let all staff members use actions?
			if (data.member) and (data.sSteamID) then
				local ourID = LocalPlayer():SteamID();

				if (ourID == data.sSteamID) then
					local subMenu = menu:AddSubMenu( "Tools" );
						subMenu:SetSkin("serverguard");

						subMenu:AddOption("Teleport", function()
							local actionData = {}
							actionData.id = data.id
							actionData.action = "goto"

							serverguard.netstream.Start("sgToolsReport", actionData)
						end)
						subMenu:AddOption("Bring", function()
							local actionData = {}
							actionData.id = data.id
							actionData.action = "bring"

							serverguard.netstream.Start("sgToolsReport", actionData)
						end)
						subMenu:AddOption("Message");
				end
			end
		menu:Open();
	end;
	
	local expand = panel:Add("DImageButton");
	expand:SetImage("icon16/bullet_arrow_down.png");
	expand:SetSize(16, 16);
	
	function expand:DoClick()
		if (panel:GetTall() == 42) then
			panel:SetTall(height);
			
			self:SetImage("icon16/bullet_arrow_up.png");
		else
			panel:SetTall(42);
			
			self:SetImage("icon16/bullet_arrow_down.png");
		end;
	end;

	if !(data.member) then
		local answer = panel:Add("DImageButton");
		answer:SetImage("icon16/bullet_green.png");
		answer:SetSize(16, 16);
		answer:SetToolTipSG("Answer Report");
		panel.answer = answer

		function answer:DoClick()
			util.CreateDialog("Notice", "Are you sure you want to answer this report?",
				function()
					serverguard.netstream.Start("sgAnswerReport", panel.id);

					timer.Simple(0.5, function()
						category:Update();
					end)
					
				end, "&Yes",
				function()
				end, "No"
			);
		end
	end
	
	local remove = panel:Add("DImageButton");
	remove:SetImage("icon16/bullet_red.png");
	remove:SetSize(16, 16);
	remove:SetToolTipSG("Remove report");
	
	function remove:DoClick()
		util.CreateDialog("Notice", "Are you sure you want to delete this report?",
			function()
				serverguard.netstream.Start("sgRemoveReport", panel.id);
				
				panel:Remove();

				-- We do it this way so it matches with the amount of panels.
				category.statusLabel:SetText("Total reports: " .. tostring(#category.list:GetCanvas():GetChildren() - 1));
				category.statusLabel:SizeToContents();
				
				timer.Simple(FrameTime() * 8, function() category.list:GetCanvas():InvalidateLayout() end);
			end, "&Yes",
			function()
			end, "No"
		);
	end;
	
	function panel:PerformLayout()
		local w = self:GetWide();
		
		if (self.answer) then
			self.answer:SetPos(w - 45, 14);
		end

		remove:SetPos(w - 24, 14);
		
		expand:SetPos(0, 14);
		expand:MoveLeftOf(self.answer or remove, 2);
	end;
	
	self.list:AddPanel(panel);
end;

plugin:AddSubCategory("Intelligence", category);

serverguard.netstream.Hook("sgSendReportChunk", function(data)
	local id = data.id;
	local name = data.name;
	local steamID = data.steamID;
	local text = data.text;
	local member = data.member
	local answered = data.answered
	local staffSteamID = data.staffSteamID

	local time = os.date("%m-%d-%y %H:%M", data.time);
	local report = {id = id, name = name, steamID = steamID, text = text, time = time, member = member or nil, answered = answered or nil, sSteamID = staffSteamID or nil};

	if (hook.Call("serverguard.reports.Add", nil, report)) then return; end;

	category:UpdateReports(report);
	
	reportsCount = reportsCount - 1;

	category.statusLabel:SetText("Total reports: " .. tostring(category:GetCount()));
	category.statusLabel:SizeToContents();

	serverguard.netstream.Start("sgRequestReportChunk", true);
end);

serverguard.netstream.Hook("sgRemoveAllReports", function()
	category:ClearReports();
end);