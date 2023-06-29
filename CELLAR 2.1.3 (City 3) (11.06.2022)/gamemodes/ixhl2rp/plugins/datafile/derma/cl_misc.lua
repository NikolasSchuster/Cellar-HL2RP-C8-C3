
local PANEL = {};

function PANEL:Init()
	self:SetTitle("Add Civil Record");
	self:MakePopup();

	self:SetSize(300, 250);
	self:Center();

	self.Restricted = false;

	self.Entry = vgui.Create("cwDfDTextEntry", self);
	self.Entry:Dock(FILL);
	self.Entry:SetMultiline(true);
	self.Entry:DockMargin(0, 0, 0, 2.5);

	self.Number = vgui.Create("DNumberWang", self)
	self.Number:Dock(BOTTOM);
	self.Number:DockMargin(0, 2.5, 0, 2.5);
	self.Number:SetMinMax(-999, 999);

	self.Submit = vgui.Create("cwDfButton", self);
	self.Submit:SetText("Submit")
	self.Submit:SetZPos(-1)
	self.Submit:Dock(BOTTOM);
	self.Submit:DockMargin(0, 2.5, 0, 2.5);
	self.Submit:SetMetroColor(Color(231, 76, 60, 100));
end;

function PANEL:SendInformation(target)
	self.Submit.DoClick = function()
		local category = "civil";
		local text = self.Entry:GetText();
		local points = self.Number:GetValue();

		netstream.Start("CmbAddDatafileEntry", target, category, text, points);

		self:Close();
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 150));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(231, 76, 60, 100));
	surface.DrawOutlinedRect(0, 0, w, h);
end;

vgui.Register("cwDfCivilEntryCmb", PANEL, "DFrame");

-- Civil Record panel.
local PANEL = {};

function PANEL:Init()
	self:SetTitle("Add Civil Record");
	self:MakePopup();

	self:SetSize(300, 250);
	self:Center();

	self.Restricted = false;

	self.Entry = vgui.Create("cwDfDTextEntry", self);
	self.Entry:Dock(FILL);
	self.Entry:SetMultiline(true);
	self.Entry:DockMargin(0, 0, 0, 2.5);

	self.Submit = vgui.Create("cwDfButton", self);
	self.Submit:SetText("Submit")
	self.Submit:SetZPos(-1)
	self.Submit:Dock(BOTTOM);
	self.Submit:DockMargin(0, 2.5, 0, 2.5);
	self.Submit:SetMetroColor(Color(231, 76, 60, 100));
end;

function PANEL:SendInformation(target)
	self.Submit.DoClick = function()
		local category = "civil";
		local text = self.Entry:GetText();

		netstream.Start("AddDatafileEntry", target, category, text, 0);

		self:Close();
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 150));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(231, 76, 60, 100));
	surface.DrawOutlinedRect(0, 0, w, h);
end;

vgui.Register("cwDfCivilEntry", PANEL, "DFrame");

-- Medical record panel.
PANEL = {};

function PANEL:Init()
	self:SetTitle("Add Medical Record");
	self:MakePopup();

	self:SetSize(300, 250);
	self:Center();

	self.Restricted = false;

	self.Entry = vgui.Create("cwDfDTextEntry", self);
	self.Entry:Dock(FILL);
	self.Entry:SetMultiline(true);
	self.Entry:DockMargin(0, 0, 0, 2.5);

	self.Submit = vgui.Create("cwDfButton", self);
	self.Submit:SetText("Submit")
	self.Submit:Dock(BOTTOM);
	self.Submit:DockMargin(0, 2.5, 0, 2.5);
	self.Submit:SetMetroColor(Color(39, 174, 96, 100));
end;

function PANEL:SendInformation(target)
	self.Submit.DoClick = function()
		local category = "med";
		local text = self.Entry:GetText();

		netstream.Start("AddDatafileEntry", target, category, text, 0);

		self:Close();
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 150));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(39, 174, 96, 100));
	surface.DrawOutlinedRect(0, 0, w, h);
end;

vgui.Register("cwDfMedicalEntry", PANEL, "DFrame");

-- Note entry panel.
PANEL = {};

function PANEL:Init()
	self:SetTitle("Add Note");
	self:MakePopup();

	self:SetSize(300, 250);
	self:Center();

	self.Restricted = false;

	self.Entry = vgui.Create("cwDfDTextEntry", self);
	self.Entry:Dock(FILL);
	self.Entry:SetMultiline(true);
	self.Entry:DockMargin(0, 0, 0, 2.5);

	self.Submit = vgui.Create("cwDfButton", self);
	self.Submit:SetText("Submit")
	self.Submit:Dock(BOTTOM);
	self.Submit:DockMargin(0, 2.5, 0, 2.5);
	self.Submit:SetMetroColor(Color(41, 128, 185, 100));
end;

function PANEL:SendInformation(target)
	self.Submit.DoClick = function()
		local category = "union";
		local text = self.Entry:GetText();

		netstream.Start("AddDatafileEntry", target, category, text, 0);

		self:Close();
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 150));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(41, 128, 185, 100));
	surface.DrawOutlinedRect(0, 0, w, h);
end;

vgui.Register("cwDfNoteEntry", PANEL, "DFrame");

-- Registry entry panel.
PANEL = {};

function PANEL:Init()
	self:SetTitle("Add Registration Record");
	self:MakePopup();

	self:SetSize(300, 80);
	self:Center();

	self.Restricted = false;

	self.Entry = vgui.Create("cwDfDTextEntry", self);
	self.Entry:Dock(FILL);
	self.Entry:SetMultiline(false);
	self.Entry:DockMargin(0, 0, 0, 2.5);

	self.Submit = vgui.Create("cwDfButton", self);
	self.Submit:SetText("Submit")
	self.Submit:Dock(BOTTOM);
	self.Submit:DockMargin(0, 2.5, 0, 2.5);
	self.Submit:SetMetroColor(Color(231, 180, 60, 100));
end;

function PANEL:SendInformation(target)
	self.Submit.DoClick = function()
		local text = self.Entry:GetText();

		if #text > 0 then
			netstream.Start("SetRegistryEntry", target, text);
		end

		self:Close();
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 150));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(231, 180, 60, 100));
	surface.DrawOutlinedRect(0, 0, w, h);
end;

vgui.Register("cwDfRegistryEntry", PANEL, "DFrame");

-- Black/grey text entry.
PANEL = {};

function PANEL:Paint(w, h)
	surface.SetDrawColor(47, 47, 47, 255);
	surface.DrawRect(0, 0, w, h);

	self:DrawTextEntryText(Color(240, 240, 240), Color(255, 100, 100), Color(255, 255, 255));
end;

vgui.Register("cwDfDTextEntry", PANEL, "DTextEntry");
