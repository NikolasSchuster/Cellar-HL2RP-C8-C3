DEFINE_BASECLASS("DButton")
local PANEL = {}
local button = Material("cellar/main/cellar_buttonlistmirrored.png")
local buttonhover = Material("cellar/main/cellar_buttonlisttogglemirrored.png")
function PANEL:Init()
	self.BaseClass.SetText(self, "")

	self:SetSize(300, 40)

	self:SetTextColor(cellar_blue)
	self:SetFont("cellar.main.btn")
	self:SetTextInset(300 - 13, 0)
	--self:SetContentAlignment(4)

	self.text = ""
end
function PANEL:SetText(value)
	self.text = value
end

function PANEL:OnCursorEntered()
	LocalPlayer():EmitSound("Helix.Rollover")
end

function PANEL:OnMousePressed(code)
	if (self:GetDisabled()) then
		return
	end

	LocalPlayer():EmitSound("Helix.Press")

	if (code == MOUSE_LEFT and self.DoClick) then
		self:DoClick(self)
	elseif (code == MOUSE_RIGHT and self.DoRightClick) then
		self:DoRightClick(self)
	end
end

function PANEL:Paint(w, h)

    if self:IsHovered() then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(buttonhover)
    else    
        surface.SetDrawColor(color_white)
        surface.SetMaterial(button)
    end
    surface.DrawTexturedRect(0, 0, w, h)



	surface.SetFont("cellar.main.btn")
	local textW, textH = surface.GetTextSize(self.text)
	local x, y = w - 13 - textW, h / 2 - textH / 2

	local hovered = self:IsHovered() and cellar_red

	surface.SetTextColor(hovered or cellar_blur_blue)
	surface.SetTextPos(x, y)
	surface.SetFont("cellar.main.btn.blur")
	surface.DrawText(self.text)

	surface.SetFont("cellar.main.btn")
	surface.SetTextColor(hovered or cellar_blue)
	surface.SetTextPos(x, y)
	surface.DrawText(self.text, true)
end

vgui.Register("cellar.btnlistmirrored", PANEL, "DButton")