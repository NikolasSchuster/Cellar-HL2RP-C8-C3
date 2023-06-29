local PLUGIN = PLUGIN;

local colours = {
	white = Color(180, 180, 180, 255),
	red = Color(231, 76, 60, 255),
	green = Color(39, 174, 96),
	blue = Color(41, 128, 185, 255),
	yellow = Color(231, 180, 60, 255),
};


-- Main datafile panel.
local PANEL = {};

function PANEL:Init()
	self:SetTitle("");

	self:SetSize(950, 570);
	self:SetDeleteOnClose(true);
	self:Center();

	self:MakePopup();
	self.Status = "";

	-- Creation of all elements, text is set in the population functions.
	self.TopPanel = vgui.Create("cwDfPanel", self);

	-- TODO: Add the CID here!
	self.NameLabel = vgui.Create("DLabel", self.TopPanel);
	self.NameLabel:SetTextColor(Color(255, 255, 255));
	self.NameLabel:SetFont("DermaLarge");
	self.NameLabel:Dock(TOP);
	self.NameLabel:DockMargin(5, 5, 0, 0);
	self.NameLabel:SizeToContents(true);

	self.InfoPanel = vgui.Create("cwDfInfoPanel", self.TopPanel);

	self.HeaderPanel = vgui.Create("cwDfHeaderPanel", self);
	self.Entries = vgui.Create("cwDfEntriesPanel", self);

	-- Lower button panel.
	self.dButtons = vgui.Create("cwDfPanel", self);
	self.dButtons:Dock(BOTTOM);
	self.dButtons:SetTall(35);

	-- Upper button panel.
	self.uButtons = vgui.Create("cwDfPanel", self);
	self.uButtons:Dock(BOTTOM);
	self.uButtons:SetTall(35);

	-- Upper buttons. Population will be done below.
	self.uLeftButton = vgui.Create("cwDfButton", self.uButtons);
	self.uLeftButton:SetText("ADD NOTE");
	self.uLeftButton:SetMetroColor(colours.blue);
	self.uLeftButton:Dock(LEFT);

	self.uMiddleButton = vgui.Create("cwDfButton", self.uButtons);
	self.uMiddleButton:SetText("ADD CIVIL RECORD");
	self.uMiddleButton:SetMetroColor(colours.red);
	self.uMiddleButton:Dock(FILL);

	self.uRightButton = vgui.Create("cwDfButton", self.uButtons);
	self.uRightButton:SetText("ADD MEDICAL RECORD");
	self.uRightButton:SetMetroColor(colours.green);
	self.uRightButton:Dock(RIGHT);

	self.uMiddle2Button = vgui.Create("cwDfButton", self.uButtons);
    self.uMiddle2Button:SetText("ADD REGISTRATION RECORD");
    self.uMiddle2Button:SetMetroColor(colours.yellow);
    self.uMiddle2Button:Dock(RIGHT);

	-- Bottom buttons.
	self.dLeftButton = vgui.Create("cwDfButton", self.dButtons);
	self.dLeftButton:SetText("UPDATE LAST SEEN");
	self.dLeftButton:Dock(LEFT);

	self.dMiddleButton = vgui.Create("cwDfButton", self.dButtons);
	self.dMiddleButton:SetText("CHANGE CIVIL STATUS");
	self.dMiddleButton:Dock(FILL);

	self.dRightButton = vgui.Create("cwDfButton", self.dButtons);
	self.dRightButton:SetText("ADD BOL");
	self.dRightButton:Dock(RIGHT);

	self.dMiddle2Button = vgui.Create("cwDfButton", self.dButtons);
    self.dMiddle2Button:SetText("REMOVE REGISTRATION");
    self.dMiddle2Button:Dock(RIGHT);
end;

function PANEL:Rebuild()
	self:SetTitle(Format("Datafile: CitizenID #%s RegID #%s", self.Data[2] or "Unknown", self.Data[3] or "Unknown"));
	self.NameLabel:SetText(self.Data[1] or "Unknown")

	self.Entries.Left:Clear();
	self.Entries.Middle:Clear();
	self.Entries.Middle2:Clear();
	self.Entries.Right:Clear();

	self:PopulateDatafile();
	self:PopulateGenericData();
end;

function PANEL:SetPlayer(player)
	self.Player = player;
end;

-- Populate the datafile with the entries.
function PANEL:PopulateDatafile()
	for _, v in pairs(self.DataFile) do
		local text = v.text;
		local date = os.date("%H:%M:%S - %d/%m/%Y", v.unix_time);
		local poster = v.poster_name;
		local points = tonumber(v.points);
		local color = istable(v.poster_color) and v.poster_color or util.JSONToTable(v.poster_color);

		if (v.category == "union") then
			local entry = vgui.Create("cwDfEntry", self.Entries.Left);

			entry:SetEntryText(text, date, "~ " .. poster, points, color);
		elseif (v.category == "civil") then
			local entry = vgui.Create("cwDfEntry", self.Entries.Middle);

			entry:SetEntryText(text, date, "~ " .. poster, points, color);
		elseif (v.category == "med") then
			local entry = vgui.Create("cwDfEntry", self.Entries.Right);

			entry:SetEntryText(text, date, "~ " .. poster, points, color);
		elseif (v.category == "reg") then
			local entry = vgui.Create("cwDfEntry", self.Entries.Middle2);

			entry:SetEntryText(text, date, "~ " .. poster, points, color);
		end;
	end;
end;

function PANEL:PopulatePoints(points)
	self.InfoPanel.MiddleTextLabel:SetText(points)

	if (tonumber(points) < 0) then
		self.InfoPanel.MiddleTextLabel:SetTextColor(Color(255, 100, 100, 255))
	elseif (tonumber(points) > 0) then
		self.InfoPanel.MiddleTextLabel:SetTextColor(Color(150, 255, 50, 255))
	else
		self.InfoPanel.MiddleTextLabel:SetTextColor(Color(220, 220, 220, 255))
	end
end

-- Update the frame with all the relevant information.
function PANEL:PopulateGenericData()
	local bIsCombine = (self.GenericData.rank or 0) >= 1;
	local bIsAntiCitizen = false;
	local bHasBOL = self.GenericData.bol;
	local civilStatus = self.GenericData.status;
	local lastSeen = os.date("%H:%M:%S - %d/%m/%Y", self.GenericData.last_seen);

	-- The logic here can be done far better.
	if (bIsCombine) then
		self.InfoPanel.MiddleHeaderLabel:SetText("POINTS");
	end;

	self.InfoPanel:SetInfoText(civilStatus, lastSeen, self.GenericData.aparts);

	if (self.GenericData.status == "Anti-Citizen") then
		bIsAntiCitizen = true;
	end;

	if (bHasBOL) then
		self.Status = "yellow";
		self.dRightButton:SetText("REMOVE BOL");
	else
		self.Status = "";
		self.dRightButton:SetText("ADD BOL")
	end;

	if (bIsAntiCitizen) then
		self.Status = "red";
	elseif (bIsCombine) then
		self.Status = "blue";
	end;

	self.dRightButton.DoClick = function()
		netstream.Start("SetBOL", self.Data[4]);
	end;

	self.dLeftButton.DoClick = function()
		netstream.Start("UpdateLastSeen", self.Data[4]);
	end;

	self.uLeftButton.DoClick = function()
		local entryPanel = vgui.Create("cwDfNoteEntry");
		entryPanel:SendInformation(self.Data[4]);
	end;

	self.uMiddleButton.DoClick = function()
		local entryPanel = vgui.Create(bIsCombine and "cwDfCivilEntryCmb" or "cwDfCivilEntry");
		entryPanel:SendInformation(self.Data[4]);
	end;

	self.uMiddle2Button.DoClick = function()
        local entryPanel = vgui.Create("cwDfRegistryEntry");
        entryPanel:SendInformation(self.Data[4]);
    end;

    self.dMiddle2Button.DoClick = function()
        netstream.Start("SetRegistryEntry", self.Data[4]);
    end;

	self.uRightButton.DoClick = function()
		local entryPanel = vgui.Create("cwDfMedicalEntry");
		entryPanel:SendInformation(self.Data[4]);
	end;

	local CivilStatus = {
		[1] = "Anti-Citizen",
		[2] = "Citizen",
		[3] = "Black",
		[4] = "Brown",
		[5] = "Red",
		[6] = "Blue",
		[7] = "Green",
		[8] = "Gold",
		[9] = "Platinum"
	}

	local Ranks = {
		[1] = "Regular",
		[2] = "Rank Leader"
	}

	self.dMiddleButton.DoClick = function()
		self.Menu = DermaMenu();

		for k, v in ipairs(CivilStatus) do
			self.Menu:AddOption(v.." ("..(k - 1)..")", function()
				PLUGIN:UpdateCivilStatus(self.Data[4], v);
			end);
		end;

		self.Menu:Open();
	end;

	if (bIsCombine) then
		self.dMiddleButton.DoRightClick = function()
			self.Menu = DermaMenu()

			for k, v in ipairs(Ranks) do
				self.Menu:AddOption(v.." ("..(k - 1)..")", function()
					PLUGIN:UpdateRankStatus(self.Data[4], k)
				end)
			end

			self.Menu:Open()
		end;

		self.dMiddleButton:SetText("CHANGE CIVIL STATUS (LMB) / RANK (RMB)")
	end
end;

function PANEL:Paint(w, h)
	local sineToColor = math.abs(math.sin(RealTime() * 1.5) * 255);
	local color;

	if (self.Status == "yellow") then
		color = Color(sineToColor, sineToColor, 0, 200);
	elseif (self.Status == "red") then
		color = Color(sineToColor, 0, 0, 200);
	elseif (self.Status == "blue") then
		color = Color(0, 100, 200, 200);
	else
		color = Color(170, 170, 170, 255);
	end;

	surface.SetDrawColor(color);
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(40, 40, 40, 150));
	surface.DrawRect(0, 0, w, h);
end;

vgui.Register("cwFullDatafile", PANEL, "DFrame");


-- Top panel/darker panel.
PANEL = {};

function PANEL:Init()
	self:Dock(TOP);
	self:SetTall(85);
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 255));
	surface.DrawRect(0, 0, w, h);
end;

vgui.Register("cwDfPanel", PANEL, "DPanel");


-- Header panel. Shows what category each tab is in.
PANEL = {};

function PANEL:Init()
	self:Dock(TOP);
	self:DockMargin(0, 3, 0, 0);
	self:SetTall(35);

	self.Header1 = vgui.Create("DLabel", self);
	self.Header1:SetText("NOTES");
	self.Header1:SetTextColor(colours.blue);
	self.Header1:SetFont("MiddleLabels");
	self.Header1:Dock(FILL);
	self.Header1:DockMargin(7, 0, 0, 0);
	self.Header1:SetContentAlignment(4);

	self.Header2 = vgui.Create("DLabel", self);
	self.Header2:SetText("CIVIL RECORD");
	self.Header2:SetTextColor(colours.red);
	self.Header2:SetFont("MiddleLabels");
	self.Header2:Dock(FILL);
	self.Header2:DockMargin(0, 0, 245, 0);
	self.Header2:SetContentAlignment(5);

	self.Header3 = vgui.Create("DLabel", self);
    self.Header3:SetText("REGISTRY RECORD");
    self.Header3:SetTextColor(colours.yellow);
    self.Header3:SetFont("MiddleLabels");
    self.Header3:Dock(FILL);
    self.Header3:DockMargin(0, 0, -245, 0);
    self.Header3:SetContentAlignment(5);

	self.Header4 = vgui.Create("DLabel", self);
	self.Header4:SetText("MEDICAL RECORD");
	self.Header4:SetTextColor(colours.green);
	self.Header4:SetFont("MiddleLabels");
	self.Header4:Dock(FILL);
	self.Header4:DockMargin(0, 0, 7, 0);
	self.Header4:SetContentAlignment(6);
end;

function PANEL:MakeRestricted(bRestrict)
	if (bRestrict) then
		self.Header2:Remove();
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 255));
	surface.DrawRect(0, 0, w, h);
end;

vgui.Register("cwDfHeaderPanel", PANEL, "DPanel");

-- Panel that will contain the entries & the 3 scroll bars.
PANEL = {};

function PANEL:Init()
	self:Dock(FILL);

	self.Left = vgui.Create("cwDfScrollPanel", self);
	self.Left:Dock(LEFT);

	self.Middle = vgui.Create("cwDfScrollPanel", self);
	self.Middle:Dock(FILL);

	self.Right = vgui.Create("cwDfScrollPanel", self);
	self.Right:Dock(RIGHT);

	self.Middle2 = vgui.Create("cwDfScrollPanel", self);
    self.Middle2:SetWide(222)
    self.Middle2:Dock(RIGHT);
end;

function PANEL:MakeRestricted(bRestrict)
	if (bRestrict) then
		self.Middle:Remove();
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 255));
	surface.DrawRect(0, 0, w, h);
end;

vgui.Register("cwDfEntriesPanel", PANEL, "DPanel");

-- Darker scroll panel.
PANEL = {};

function PANEL:Init()
	self:SetWide(225);
	self:DockMargin(5, 0, 5, 0)

	self.SBar = self:GetVBar();

	self.SBar.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(38, 38, 38, 255));
		surface.DrawRect(0, 0, w, h);
	end;

	self.SBar.btnGrip.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(47, 47, 47, 255));
		surface.DrawRect(0, 0, w, h);
	end;

	self.SBar.btnUp.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(30, 30, 30, 255));
		surface.DrawRect(0, 0, w, h);
	end;

	self.SBar.btnDown.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(30, 30, 30, 255));
		surface.DrawRect(0, 0, w, h);
	end;
end;

vgui.Register("cwDfScrollPanel", PANEL, "DScrollPanel");

-- Darker buttons.
PANEL = {};

function PANEL:Init()
	self:SetTextColor(Color(180, 180, 180, 255));
	self:SetWide(225);
	self:DockMargin(5, 2.5, 5, 2.5);

	-- Reason why I'm doing the colours this way is because I don't want any filthy logic in my Paint function.
	self.MetroColor = colours.white;
	self.ButtonColor = Color(47, 47, 47, 255);
end;

function PANEL:SetMetroColor(color)
	self.MetroColor = color;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(self.ButtonColor);
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(self.MetroColor);
	surface.DrawRect(0, h - 2, w, 2);
end;

function PANEL:OnCursorEntered(w, h)
	self.ButtonColor = Color(38, 38, 38, 255);
end;

function PANEL:OnCursorExited(w, h)
	self.ButtonColor = Color(47, 47, 47, 255);
end;

vgui.Register("cwDfButton", PANEL, "DButton");

-- Entry for one of the scroll panels.
PANEL = {};

function PANEL:Init()
	self:SetZPos(1);
	self:SetTall(50);
	self:Dock(TOP);
	self:DockMargin(0, 5, 5, 0);

	self.PosterColor = Color(180, 180, 180, 255);

	self.Text = vgui.Create("DLabel", self);
	self.Text:SetTextColor(Color(220, 220, 220, 255))
	self.Text:SetText("");
	self.Text:SetWrap(true);
	self.Text:Dock(FILL);
	self.Text:DockMargin(5, 0, 0, 0);
	self.Text:SetContentAlignment(5);

	self.Date = vgui.Create("DLabel", self);
	self.Date:SetTextColor(Color(150, 150, 150));
	self.Date:SetText("");
	self.Date:SetWrap(true);
	self.Date:Dock(TOP);
	self.Date:DockMargin(5, 5, 0, 0);
	self.Date:SetContentAlignment(7);

	self.Poster = vgui.Create("DLabel", self);
	self.Poster:SetWrap(true);
	self.Poster:SetTextColor(self.PosterColor);
	self.Poster:Dock(BOTTOM);
	self.Poster:DockMargin(5, 0, 0, 5);
	self.Poster:SetContentAlignment(1);

	self.Points = vgui.Create("DLabel", self.Date);
	self.Points:SetWrap(true);
	self.Points:SetWide(20)
	self.Points:Dock(RIGHT);
	self.Points:DockMargin(0, 0, 0, 0);
	self.Points:SetContentAlignment(9);
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(47, 47, 47, 255));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(self.PosterColor);
	surface.DrawRect(0, h - 2, w, 2);
end;

function PANEL:SetEntryText(noteText, dateText, posterText, pointsText, posterColor)
	if (posterColor) then
		self.PosterColor = posterColor;
		self.Poster:SetTextColor(self.PosterColor);
	end;

	self.Text:SetText(noteText);
	self.Date:SetText(dateText);
	self.Poster:SetText(posterText);
	self.Points:SetText(pointsText);

	if (pointsText < 0) then
		self.Points:SetTextColor(Color(255, 100, 100, 255))
	elseif (pointsText > 0) then
		self.Points:SetTextColor(Color(150, 255, 50, 255))
	else
		self.Points:SetText("");
		self.Points:SetTextColor(Color(220, 220, 220, 255))
	end;

	self:SetTall(60 + (string.len(self.Text:GetText()) / 28) * 11);
end;

vgui.Register("cwDfEntry", PANEL, "DPanel");

-- Info panel. Panel below the name of the player.
PANEL = {};

function PANEL:Init()
	self:Dock(TOP);
	self:SetTall(50);

	self.LeftHeaderLabel = vgui.Create("DLabel", self);
	self.LeftHeaderLabel:SetText("CIVIL STATUS");
	self.LeftHeaderLabel:SetContentAlignment(4)
	self.LeftHeaderLabel:SetTextColor(Color(0, 150, 150, 255));
	self.LeftHeaderLabel:SetFont("TopBoldLabel");
	self.LeftHeaderLabel:Dock(FILL);
	self.LeftHeaderLabel:DockMargin(5, 5, 0, 0);

	self.MiddleHeaderLabel = vgui.Create("DLabel", self);
	self.MiddleHeaderLabel:SetText(""); //("POINTS");
	self.MiddleHeaderLabel:SetContentAlignment(5)
	self.MiddleHeaderLabel:SetTextColor(Color(231, 76, 60, 255));
	self.MiddleHeaderLabel:SetFont("TopBoldLabel");
	self.MiddleHeaderLabel:Dock(FILL);
	self.MiddleHeaderLabel:DockMargin(5, 5, 250, 0);

	self.MiddleHeader2Label = vgui.Create("DLabel", self);
    self.MiddleHeader2Label:SetText("REGISTERED AT");
    self.MiddleHeader2Label:SetContentAlignment(5)
    self.MiddleHeader2Label:SetTextColor(Color(231, 180, 60, 255));
    self.MiddleHeader2Label:SetFont("TopBoldLabel");
    self.MiddleHeader2Label:Dock(FILL);
    self.MiddleHeader2Label:DockMargin(5, 5, -235, 0);

	self.RightHeaderLabel = vgui.Create("DLabel", self);
	self.RightHeaderLabel:SetText("LAST SEEN");
	self.RightHeaderLabel:SetContentAlignment(6)
	self.RightHeaderLabel:SetTextColor(Color(150, 150, 96, 255));
	self.RightHeaderLabel:SetFont("TopBoldLabel");
	self.RightHeaderLabel:Dock(FILL);
	self.RightHeaderLabel:DockMargin(0, 5, 5, 0);

	self.TextPanel = vgui.Create("DPanel", self);
	self.TextPanel:Dock(BOTTOM);
	self.TextPanel:SetTall(25)
	self.TextPanel.Paint = function() return false end;

	self.LeftTextLabel = vgui.Create("DLabel", self.TextPanel);
	self.LeftTextLabel:SetTextColor(Color(220, 220, 220, 255));
	self.LeftTextLabel:SetContentAlignment(4)
	self.LeftTextLabel:Dock(FILL);
	self.LeftTextLabel:DockMargin(5, 5, 5, 5);

	self.MiddleTextLabel = vgui.Create("DLabel", self.TextPanel);
	self.MiddleTextLabel:SetText("");
	self.MiddleTextLabel:SetTextColor(Color(0, 0, 0, 255));
	self.MiddleTextLabel:SetContentAlignment(5)
	self.MiddleTextLabel:Dock(FILL);
	self.MiddleTextLabel:DockMargin(5, 5, 225, 5);

	self.Middle2TextLabel = vgui.Create("DLabel", self.TextPanel);
    self.Middle2TextLabel:SetTextColor(Color(255, 255, 255, 255));
    self.Middle2TextLabel:SetContentAlignment(5)
    self.Middle2TextLabel:Dock(FILL);
    self.Middle2TextLabel:DockMargin(5, 5, -220, 5);

	self.RightTextLabel = vgui.Create("DLabel", self.TextPanel);
	self.RightTextLabel:SetTextColor(Color(220, 220, 220, 255));
	self.RightTextLabel:SetContentAlignment(6)
	self.RightTextLabel:Dock(FILL);
	self.RightTextLabel:DockMargin(5, 5, 5, 5);
end;

function PANEL:SetInfoText(civilStatus, lastSeen, reg)
	self.LeftTextLabel:SetText(civilStatus);
	self.RightTextLabel:SetText(lastSeen);
	self.Middle2TextLabel:SetText(reg or "");
end;

function PANEL:Paint()
	return false;
end;

vgui.Register("cwDfInfoPanel", PANEL, "DPanel");
