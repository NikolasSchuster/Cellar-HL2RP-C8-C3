local PLUGIN = PLUGIN;

-- Datafile management panel. Allows one to remove/edit entries.
local PANEL = {};

function PANEL:Init()
	self:SetTitle("");

	self:SetSize(700, 400);
	self:SetDeleteOnClose(true);
	self:Center();

	self:MakePopup();

	self.List = vgui.Create("DListView", self);
	self.List:Dock(FILL);
	self.List:AddColumn("date");
	self.List:AddColumn("category");
	self.List:AddColumn("text");
	self.List:AddColumn("points");
	self.List:AddColumn("poster");

	self.Delete = vgui.Create("cwDfButton", self);
	self.Delete:SetText("Delete Entry");
	self.Delete:SetMetroColor(Color(200, 50, 0, 255))
	self.Delete:Dock(BOTTOM);
	self.Delete:DockMargin(0, 5, 0, 0);
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 150));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(255, 255, 255, 100));
	surface.DrawOutlinedRect(0, 0, w, h);
end;

function PANEL:SetPlayer(player)
	self.Player = player;
end;

function PANEL:PopulateEntries(datafile)
	self:SetTitle(self.Player:Name() .. "'s datafile");

	for _, v in pairs(datafile) do
		self.List:AddLine(
			v.unix_time,
			v.category,
			v.text,
			v.points,
			v.poster_name
		);
	end;

	self.Delete.DoClick = function()
		local key = self.List:GetSelectedLine();

		if (key) then
			local date = self.List:GetLine(key):GetValue(1);
			local category = self.List:GetLine(key):GetValue(2);
			local text = self.List:GetLine(key):GetValue(3);

			PLUGIN:RemoveEntry(self.Player, key, date, category, text);
			self.List:RemoveLine(key);
		end;
	end;
end;

vgui.Register("cwDfManageFile", PANEL, "DFrame");
