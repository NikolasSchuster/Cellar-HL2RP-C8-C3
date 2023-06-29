local PANEL = {}

function PANEL:Init()

end

function PANEL:SizeToContents()
	local height = 0

	for _, v in ipairs(self:GetChildren()) do
		if (IsValid(v) and v:IsVisible()) then
			local _, top, _, bottom = v:GetDockMargin()

			height = height + v:GetTall() + top + bottom
		end
	end

	self:SetTall(height)
end

function PANEL:Paint(width, height)

end

vgui.Register("ixStatsPanel", PANEL, "EditablePanel")


PANEL = {}

function PANEL:Init()
	self.label = self:Add("DLabel")
	self.label:SetFont("ixMenuButtonLabelFont")
	self.label:DockMargin(5, 0, 0, 8)
	self.label:Dock(TOP)
end

function PANEL:SetText(value)
	self.label:SetText(value)
	self.label:SizeToContents()
end

function PANEL:SizeToContents()
	local height = 0

	for _, v in ipairs(self:GetChildren()) do
		if (IsValid(v) and v:IsVisible()) then
			local _, top, _, bottom = v:GetDockMargin()

			height = height + v:GetTall() + top + bottom
		end
	end

	self:SetTall(height)
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(0, 0, width, self.label:GetTall() + 2)
end

vgui.Register("ixStatsPanelCategory", PANEL, "EditablePanel")