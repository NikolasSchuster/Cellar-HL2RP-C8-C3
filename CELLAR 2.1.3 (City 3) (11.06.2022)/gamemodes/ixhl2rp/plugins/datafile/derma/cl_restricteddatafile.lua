local PLUGIN = PLUGIN;

local colours = {
	white = Color(180, 180, 180, 255),
	red = Color(231, 76, 60, 255),
	green = Color(39, 174, 96),
	blue = Color(41, 128, 185, 255),
	yellow = Color(231, 180, 60, 255),
};

-- Header panel. Shows what category each tab is in.
local PANEL = {};

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
    self.Header2:SetText("REGISTRY RECORD");
    self.Header2:SetTextColor(colours.yellow);
    self.Header2:SetFont("MiddleLabels");
    self.Header2:Dock(FILL);
    self.Header2:DockMargin(0, 0, 0, 0);
    self.Header2:SetContentAlignment(5);

	self.Header3 = vgui.Create("DLabel", self);
	self.Header3:SetText("MEDICAL RECORD");
	self.Header3:SetTextColor(colours.green);
	self.Header3:SetFont("MiddleLabels");
	self.Header3:Dock(FILL);
	self.Header3:DockMargin(0, 0, 7, 0);
	self.Header3:SetContentAlignment(6);
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 255));
	surface.DrawRect(0, 0, w, h);
end;

vgui.Register("cwDfHeaderPanelR", PANEL, "DPanel");

-- Panel that will contain the entries & the 3 scroll bars.
local PANEL = {};

function PANEL:Init()
    self:Dock(FILL);

    self.Left = vgui.Create("cwDfScrollPanel", self);
    self.Left:Dock(LEFT);

    self.Middle = vgui.Create("cwDfScrollPanel", self);
    self.Middle:Dock(FILL);

    self.Right = vgui.Create("cwDfScrollPanel", self);
    self.Right:Dock(RIGHT);
end;

function PANEL:Paint(w, h)
    surface.SetDrawColor(Color(40, 40, 40, 255));
    surface.DrawRect(0, 0, w, h);
end;

vgui.Register("cwDfEntriesPanelR", PANEL, "DPanel");

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
    self.MiddleHeaderLabel:SetText("REGISTERED AT");
    self.MiddleHeaderLabel:SetContentAlignment(5)
    self.MiddleHeaderLabel:SetTextColor(Color(231, 180, 60, 255));
    self.MiddleHeaderLabel:SetFont("TopBoldLabel");
    self.MiddleHeaderLabel:Dock(FILL);
    self.MiddleHeaderLabel:DockMargin(5, 5, 0, 0);

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
    self.MiddleTextLabel:SetTextColor(Color(255, 255, 255, 255));
    self.MiddleTextLabel:SetContentAlignment(5)
    self.MiddleTextLabel:Dock(FILL);
    self.MiddleTextLabel:DockMargin(5, 5, 5, 5);

	self.RightTextLabel = vgui.Create("DLabel", self.TextPanel);
	self.RightTextLabel:SetTextColor(Color(220, 220, 220, 255));
	self.RightTextLabel:SetContentAlignment(6)
	self.RightTextLabel:Dock(FILL);
	self.RightTextLabel:DockMargin(5, 5, 5, 5);
end;

function PANEL:SetInfoText(civilStatus, lastSeen, reg)
	self.LeftTextLabel:SetText(civilStatus);
	self.RightTextLabel:SetText(lastSeen);
	self.MiddleTextLabel:SetText(reg or "");
end;

function PANEL:Paint()
	return false;
end;

vgui.Register("cwDfInfoPanelR", PANEL, "DPanel");

-- Main datafile panel.
local PANEL = {};

function PANEL:Init()
	self:SetTitle("");

	self:SetSize(700, 570);
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

	self.InfoPanel = vgui.Create("cwDfInfoPanelR", self.TopPanel);

	self.HeaderPanel = vgui.Create("cwDfHeaderPanelR", self);

	self.Entries = vgui.Create("cwDfEntriesPanelR", self);

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
    self.uMiddleButton:SetText("ADD REGISTRATION RECORD");
    self.uMiddleButton:SetMetroColor(colours.yellow);
    self.uMiddleButton:Dock(FILL);

	self.uRightButton = vgui.Create("cwDfButton", self.uButtons);
	self.uRightButton:SetText("ADD MEDICAL RECORD");
	self.uRightButton:SetMetroColor(colours.green);
	self.uRightButton:Dock(RIGHT);

	-- Bottom buttons.
	self.dLeftButton = vgui.Create("cwDfButton", self.dButtons);
	self.dLeftButton:SetText("UPDATE LAST SEEN");
	self.dLeftButton:Dock(LEFT);

	self.dMiddleButton = vgui.Create("cwDfButton", self.dButtons);
    self.dMiddleButton:SetText("REMOVE REGISTRATION");
    self.dMiddleButton:Dock(FILL);

	self.dRightButton = vgui.Create("cwDfButton", self.dButtons);
	self.dRightButton:SetText("");
	self.dRightButton:Dock(RIGHT);
    self.dRightButton:SetDisabled(true)
end;

function PANEL:Rebuild()
	self:SetTitle(Format("Datafile: CitizenID #%s RegID #%s", self.Data[2] or "Unknown", self.Data[3] or "Unknown"));
	self.NameLabel:SetText(self.Data[1] or "Unknown")

	self.Entries.Left:Clear();
	self.Entries.Middle:Clear();
	self.Entries.Right:Clear();

	self:PopulateDatafile();
	self:PopulateGenericData();
end;

function PANEL:SetPlayer(player)
	self.Player = player;
end;

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
		elseif (v.category == "med") then
			local entry = vgui.Create("cwDfEntry", self.Entries.Right);

			entry:SetEntryText(text, date, "~ " .. poster, points, color);
		elseif (v.category == "reg") then
			local entry = vgui.Create("cwDfEntry", self.Entries.Middle);

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

function PANEL:PopulateGenericData()
	--local bIsCombine = self.Player:IsCombine();
	local bIsAntiCitizen;
	local bHasBOL = self.GenericData.bol;
	local civilStatus = self.GenericData.status;
	local lastSeen = os.date("%H:%M:%S - %d/%m/%Y", self.GenericData.last_seen);

	self.InfoPanel:SetInfoText(civilStatus, lastSeen, self.GenericData.aparts);

	if (self.GenericData.status == "Anti-Citizen") then
		bIsAntiCitizen = true;
	end;

	if (bHasBOL) then
		self.Status = "yellow";
	elseif (bIsAntiCitizen) then
		self.Status = "red";
	--elseif (bIsCombine) then
	--	self.Status = "blue";
	end;

	self.dLeftButton.DoClick = function()
		netstream.Start("UpdateLastSeen", self.Data[4]);
	end;

	self.uLeftButton.DoClick = function()
		local entryPanel = vgui.Create("cwDfNoteEntry");
		entryPanel:SendInformation(self.Data[4]);
	end;

	self.uRightButton.DoClick = function()
		local entryPanel = vgui.Create("cwDfMedicalEntry");
		entryPanel:SendInformation(self.Data[4]);
	end;

	self.uMiddleButton.DoClick = function()
		local entryPanel = vgui.Create("cwDfRegistryEntry");
		entryPanel:SendInformation(self.Data[4]);
	end;

	self.dMiddleButton.DoClick = function()
        netstream.Start("SetRegistryEntry", self.Data[4]);
    end;
end;

function PANEL:Paint(w, h)
	local sineToColor = math.abs(math.sin(RealTime() * 1.5) * 255);
	local color;

	if (self.Status == "yellow") then
		color = Color(sineToColor, sineToColor, 0, 200);

	elseif (self.Status == "red") then
		color = Color(sineToColor, 0, 0, 200);

	elseif (self.Status == "blue") then
		color = Color(0, 200, 200, 200)
	else
		color = Color(170, 170, 170, 255);
	end;

	surface.SetDrawColor(color);
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(Color(40, 40, 40, 150));
	surface.DrawRect(0, 0, w, h);
end;

vgui.Register("cwRestrictedDatafile", PANEL, "DFrame");
