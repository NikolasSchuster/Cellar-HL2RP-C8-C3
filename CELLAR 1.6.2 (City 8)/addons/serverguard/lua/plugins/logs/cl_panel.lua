--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local logData = {};
local bVisible = true;
local chunksLoaded = {};

local loadingTexture = Material("icon16/arrow_rotate_anticlockwise.png");
surface.CreateFont("serverguard.logs", {font = "Arial", size = 14, weight = 400});

local category = {};

category.name = "Server logs";
category.material = "serverguard/menuicons/icon_logs.png";
category.permissions = "Server logs";

function category:Create(base)
	base.panel = base:Add("tiger.panel")
	base.panel:SetTitle("Server logs")
	base.panel:Dock(FILL)
	
	base.panel.list = base.panel:Add("tiger.list")
	base.panel.list:Dock(FILL)
	base.panel.list:DockPadding(4, 54, 4, 4)

	base.panel.list.rotate = 0;
	base.panel.list.oldPaint = base.panel.list.Paint;
	function base.panel.list:Paint(w,h)
		base.panel.list:oldPaint(w,h);
		if !bVisible then
			draw.MaterialRotated(w/2-8, h/2-8, 16, 16, color_white, loadingTexture, self.rotate);
			self.rotate = self.rotate + 140 * FrameTime();
								
			if (self.rotate >= 360) then
				self.rotate = 0;
			end;
		end;
	end;

	function base.panel.list:Rebuild()
		local data = logData[plugin.logFolder][plugin.logFile];
		local length = #data;
		local sorted = {};
				
		if (plugin.search and plugin.search:GetValue() != "") then
			local text = plugin.search:GetValue();
			
			for i = 1, length do
				if (string.find(data[i], text)) then
					table.insert(sorted, data[i]);
				end
			end
			
			if (#sorted > 0) then
				data = sorted;
			end
		end
			
		self:Clear();

		for k, v in pairs(data) do
			local label = vgui.Create("DLabel");
			label:SetText(v);
			label:Dock(TOP);
			label:DockMargin(0, 2, 0, 0);
			label:SetSkin("serverguard");
			label:SetFont("serverguard.logs");
			label:SetWrap(true);
			label:SetContentAlignment(7);
			label:SetAutoStretchVertical(true);
			label:InvalidateLayout(true);
			label:SetVisible(bVisible);
			chunksLoaded[#chunksLoaded+1] = label;
				
			serverguard.themes.AddPanel(label, "tiger_tooltip_label");
				
			self:AddPanel(label);
		end;
	end;

	function base.panel.list:AddChunk(logFolder, logFile, data)
		if (plugin.logFolder == logFolder and plugin.logFile == logFile) then
			local label = vgui.Create("DLabel");
			label:SetText(data);
			label:Dock(TOP);
			label:DockMargin(0, 2, 0, 0);
			label:SetSkin("serverguard");
			label:SetFont("serverguard.logs");
			label:SetWrap(true);
			label:SetContentAlignment(7);
			label:SetAutoStretchVertical(true);
			label:InvalidateLayout(true);
			label:SetVisible(bVisible);
			chunksLoaded[#chunksLoaded+1] = label;

			serverguard.themes.AddPanel(label, "tiger_tooltip_label");
				
			self:AddPanel(label);
		end;
	end;

	category.basePanel = base.panel;
	
	plugin.folderList = base.panel.list:Add("DComboBox");
	plugin.folderList:SetSize(150, 22);
	plugin.folderList:SetPos(14, 14);
	plugin.folderList:SetText("Date");
	plugin.folderList:SetFont("tiger.button");
	plugin.folderList:SetSkin("serverguard");
	
	function plugin.folderList:OnSelect(index, value, data)
		base.panel.list:Clear();
		
		for logFile, _ in pairs(logData[data]) do
			logData[data][logFile] = {};
		end;

		serverguard.netstream.Start("sgRequestLogData", data);
		
		if (self.buttons) then
			for k, v in pairs(self.buttons) do
				if (IsValid(v)) then
					v:Remove();
				end;
			end;
		end;
		
		self.buttons = {};
		
		local x = 184;
		
		for logFile, _ in pairs(logData[data]) do
			local button = base.panel.list:Add("tiger.button");
			button:SetPos(x, 14);
			button:SetText("Logfile " .. logFile);
			button:SizeToContents();
			
			button.data = {folder = data, logFile = logFile};
			
			x = x + button:GetWide() + 8;
		
			table.insert(self.buttons, button);
			
			function button:DoClick()
				local data = self.data;
				
				plugin.logFolder = data.folder;
				plugin.logFile = data.logFile;
				
				base.panel.list:Rebuild();
				
				timer.Simple(0.1, function()
					base.panel.list:GetVBar():AnimateTo(base.panel.list:GetCanvas():GetTall(), 0.5, 0, 0.5);
				end);
			end;
		end;
	end;
	
	function plugin.folderList:OpenMenu(pControlOpener)
		DComboBox.OpenMenu(self, pControlOpener);

		if (IsValid(self.Menu)) then
			self.Menu:SetSkin("serverguard");
		end;
	end;
	
	serverguard.netstream.Start("sgRequestLogFolders", true);
end;

plugin:AddSubCategory("Information", category);

local function MakeChunksVisible(bVisible)
	for k,label in pairs(chunksLoaded) do
		if (label and IsValid(label)) then
			label:SetVisible(bVisible);
		end;
	end;
end;

serverguard.netstream.Hook("sgSendLogChunk", function(data)
	local logFolder = data[1];
	local logFile= data[2];

	if (type(data[3]) == "string") then
		bVisible = false;
		MakeChunksVisible(false);

		local text = data[3]:sub(1,-2);

		table.insert(logData[logFolder][logFile], text);

		serverguard.netstream.Start("sgRequestLogChunk", {
			logFolder, logFile
		});

		category.basePanel.list:AddChunk(logFolder, logFile, text);
	elseif (data[3] == true) then
		--last chunk
		bVisible = true;
		MakeChunksVisible(true);
	end;
end);

serverguard.netstream.Hook("sgSendLogFolders", function(data)
	local folder = data[1];
	local length = data[2];

	logData[folder] = logData[folder] or {}

	for i = 1, length do
		logData[folder][i] = {}
	end
	
	if (IsValid(plugin.folderList)) then
		plugin.folderList:AddChoice(folder, folder)
	end
end);