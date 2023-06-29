DEFINE_BASECLASS("DButton")
local PANEL = {}
local button = Material("cellar/main/tab/closebutton16x16.png")
local buttonhover = Material("cellar/main/tab/closebuttonhovered.png")
function PANEL:Init()
	self.BaseClass.SetText(self, "")

	self:SetSize(16, 16)
	self:SetTextColor(cellar_blue)
	self:SetFont("cellar.main.btn")
end

function PANEL:OnMousePressed(code)
	if (self:GetDisabled()) then
		return
	end

    --print(self.isActive)
    self.isActive = not self.isActive
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
end

vgui.Register("cellar.closebutton", PANEL, "DButton")
