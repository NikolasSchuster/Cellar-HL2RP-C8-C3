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
	self.label:SetFont("cellar.derma")
	self.label:SetTextColor(cellar_blue)
	self.label:DockMargin(0, 0, 0, 8)
	self.label:SetTextInset(8, 0)
	self.label:SetContentAlignment(4)
	self.label:Dock(TOP)
	self.label.Paint = function(me, w, h)

		draw.RoundedBox(0, 0, 0, 3, h, cellar_blue)
		--draw.RoundedBox(0, 1, 1, 2, h - 2, cellar_blue)
	end
end

function PANEL:SetText(value)
	self.label:SetText(value:utf8upper())
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
	local w, h = width, height
	local arrow = Material('cellar/main/tab/arrow.png')
	draw.SimpleText(self.label:GetText(), "cellar.derma.blur", 6, 0, cellar_blur_blue, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	/*surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(0, 0, width, self.label:GetTall() + 2)*/

	surface.SetDrawColor(cellar_blue)
	--draw.RoundedBox(0, 0, h - 1, w, 1, cellar_blue)

	local label = Material('cellar/main/tab/charstatsline.png')
	surface.SetDrawColor(color_white)
	surface.SetMaterial(label)

end

vgui.Register("ixStatsPanelCategory", PANEL, "EditablePanel")