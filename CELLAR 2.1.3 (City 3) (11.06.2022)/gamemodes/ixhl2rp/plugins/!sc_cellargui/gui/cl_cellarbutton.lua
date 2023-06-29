DEFINE_BASECLASS("DButton")
local PANEL = {}
local btnHeight = 40
local buttonnew = Material("cellar/main/button_cellar.png")
local buttonnewhover = Material("cellar/main/button_cellar_hovered_blue.png")
local buttonnewtoggled = Material("cellar/main/cellar_button_toggled.png")
local icons = {
	Material("cellar/main/new.png"),
	Material("cellar/main/chars.png"),
	Material("cellar/main/info.png"),
	Material("cellar/main/content.png"),
	Material("cellar/main/exit.png"),
}
surface.CreateFont("cellar.main.btn", {
	font = "Nagonia",
	extended = true,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.main.btn.blur", {
	font = "Nagonia",
	extended = true,
	size = 24,
	weight = 500,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})
function PANEL:Init()
	self.BaseClass.SetText(self, "")

	self:SetSize(300, 40)

	self:SetTextColor(cellar_blue)
	self:SetFont("cellar.main.btn")
	self:SetTextInset(40 + 13, 0)
	--self:SetContentAlignment(4)

	self.text = ""
	self.icon = 0
end
function PANEL:SetText(value)
	self.text = value
end

function PANEL:SetIcon(ico)
	self.icon = math.Clamp(ico, 0, #icons)
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
	local x = 40


    if self:IsHovered() then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(buttonnewtoggled)
    else    
        surface.SetDrawColor(color_white)
        surface.SetMaterial(buttonnew)
    end
    surface.DrawTexturedRect(0, 0, w, h)



	surface.SetFont("cellar.main.btn")
	local textW, textH = surface.GetTextSize(self.text)
	local x, y = 40 + 13, h / 2 - textH / 2

    local hovered = self:IsHovered() and cellar_red

	surface.SetTextColor(hovered or cellar_blur_blue)
	surface.SetTextPos(x, y)
	surface.SetFont("cellar.main.btn.blur")
	surface.DrawText(self.text)

	surface.SetFont("cellar.main.btn")
	surface.SetTextColor(hovered or cellar_blue)
	surface.SetTextPos(x, y)
	surface.DrawText(self.text, true)

	if self.icon > 0 then
		surface.SetDrawColor(color_black)
		surface.SetMaterial(icons[self.icon])
		surface.DrawTexturedRect(4, h / 2 - 16, 32, 32)
	end
end

/*function PANEL:PaintBackground(width, height)
	surface.SetDrawColor(ColorAlpha(self.backgroundColor, self.currentBackgroundAlpha))
	surface.DrawRect(0, 0, width, height)
end*/

vgui.Register("cellar.newbtn", PANEL, "DButton")


DEFINE_BASECLASS("DButton")
local PANEL = {}
local btnHeight = 40
local buttonnew = Material("cellar/main/cellar_buttonlist.png")
local buttonnewhover = Material("cellar/main/cellar_buttonlisthover.png")
local buttonnewtoggled = Material("cellar/main/cellar_buttonlisttoggle.png")
local icons = {
	Material("cellar/main/new.png"),
	Material("cellar/main/chars.png"),
	Material("cellar/main/info.png"),
	Material("cellar/main/content.png"),
	Material("cellar/main/exit.png"),
}
function PANEL:Init()
	self.BaseClass.SetText(self, "")

	self:SetSize(300, 40)

	self:SetTextColor(cellar_blue)
	self:SetFont("cellar.main.btn")
	self:SetTextInset(13, 0)
	--self:SetContentAlignment(4)

	self.text = ""
	self.icon = 0
end
function PANEL:SetText(value)
	self.text = value
end

function PANEL:SetIcon(ico)
	self.icon = math.Clamp(ico, 0, #icons)
end

function PANEL:OnCursorEntered()
	LocalPlayer():EmitSound("Helix.Rollover")
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
	local x = 40


    /*if self.isActive then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(buttonnewtoggled)
    else*/if self:IsHovered() then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(buttonnewtoggled)
    else    
        surface.SetDrawColor(color_white)
        surface.SetMaterial(buttonnew)
    end
    surface.DrawTexturedRect(0, 0, w, h)



	surface.SetFont("cellar.main.btn")
	local textW, textH = surface.GetTextSize(self.text)
	local x, y = 13, h / 2 - textH / 2

    local active = self.isActive and cellar_red
	local hovered = self:IsHovered() and cellar_red
    --local hovered = self:IsHovered() and Color(37, 135, 161)

	surface.SetTextColor(hovered or cellar_blur_blue)
	surface.SetTextPos(x, y)
	surface.SetFont("cellar.main.btn.blur")
	surface.DrawText(self.text)

	surface.SetFont("cellar.main.btn")
	surface.SetTextColor(hovered or cellar_blue)
	surface.SetTextPos(x, y)
	surface.DrawText(self.text, true)

	if self.icon > 0 then
		surface.SetDrawColor(color_black)
		surface.SetMaterial(icons[self.icon])
		surface.DrawTexturedRect(4, h / 2 - 16, 32, 32)
	end
end

vgui.Register("cellar.btnlist", PANEL, "DButton")