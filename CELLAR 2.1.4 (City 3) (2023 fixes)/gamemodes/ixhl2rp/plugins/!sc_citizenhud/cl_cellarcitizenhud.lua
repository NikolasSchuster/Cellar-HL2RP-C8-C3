ICON_FRAME_SIZE = 32
ICON_SIZE = 16


PANEL = {}
function PANEL:Init()

    if IsValid(cellar_citizenhud_needs) then
        cellar_citizenhud_needs:Remove()
    end

    cellar_citizenhud_needs = self

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.frameInside = ColorAlpha(cellar_darker_blue, 107)
    self.frameCritInside = ColorAlpha(cellar_red, critAlpha)
    self.hinside = nil
    self.tinside = nil
    self.hColorInside = nil
    self.tColorInside = nil
    self.client = LocalPlayer()
    self.removed = false

    self:SetAlpha(65)
    self:SetSize(ICON_FRAME_SIZE * 2 + 16, ICON_FRAME_SIZE)
    self:SetPos(ScrW() * .5 - ICON_FRAME_SIZE - 4, 0 - ICON_FRAME_SIZE - 8)
    self:MoveTo(ScrW() * .5 - ICON_FRAME_SIZE - 4, 8, .5, .3, .1)
    self:AlphaTo(255, .5, .7)
    self:ParentToHUD()

    self.hunger = self:Add('DPanel')
    self.hunger:SetPos(0, 0)
    self.hunger:SetSize(ICON_FRAME_SIZE, ICON_FRAME_SIZE)
    self.hunger.Paint = function(me, w, h)
        local icon = Material('cellar/main/hud/hunger.png')

        if self.hinside < 0.3 then
            self.hColorInside = LerpColor(self.critAlpha/100, color_yellow, self.frameCritInside)
        elseif self.hinside < 0.6 then
            self.hColorInside = LerpColor(self.critAlpha/100, self.frameInside, color_yellow)
        else
            self.hColorInside = self.frameInside
        end

        surface.SetDrawColor(self.hColorInside)

        surface.SetMaterial(icon)
        surface.DrawTexturedRectRotated(w * .5, h * .5, ICON_SIZE, ICON_SIZE, 0)

        surface.DrawRect(w - 1, h * .33, 1, h)
        surface.DrawRect(0, 0, 1, h * .66)
        surface.DrawLine(w * .66, 0, w - 1, h * .33)

        surface.DrawRect(0, 0, w * .66, 1)
        surface.DrawRect(w * .33, h - 1, w, 1)
        surface.DrawLine(0, h * .66, w * .33, h - 1)
    end

    self.thirst = self:Add('DPanel')
    self.thirst:SetPos(ICON_FRAME_SIZE + 8, 0)
    self.thirst:SetSize(ICON_FRAME_SIZE, ICON_FRAME_SIZE)
    self.thirst.Paint = function(me, w, h)
        local icon = Material('cellar/main/hud/thirst.png')

        if self.tinside < 0.3 then
            self.tColorInside = LerpColor(self.critAlpha/100, color_yellow, self.frameCritInside)
        elseif self.tinside < 0.6 then
            self.tColorInside = LerpColor(self.critAlpha/100, self.frameInside, color_yellow)
        else
            self.tColorInside = self.frameInside
        end

        surface.SetDrawColor(self.tColorInside)

        surface.SetMaterial(icon)
        surface.DrawTexturedRectRotated(w * .5, h * .5, ICON_SIZE, ICON_SIZE, 0)

        surface.DrawRect(w * .33, 0, w, 1)
        surface.DrawRect(0, h * .33, 1, h)
        surface.DrawLine(0, h * .33, w * .33, 0)

        surface.DrawRect(0, h - 1, w * .66, 1)
        surface.DrawRect(w - 1, 0, 1, h * .66)
        surface.DrawLine(w * .66 - 1, h - 1, w - 1, h * .66 - 1)
    end

end

function PANEL:Paint(w, h)
end

function PANEL:Think()

    self.critAlpha = TimedSin(.65, 45, 155, 0)

    self.hinside = LocalPlayer():GetCharacter():GetHunger()/100
    self.tinside = LocalPlayer():GetCharacter():GetThirst()/100

end

function PANEL:Remove()
    self:AlphaTo(65, .5, .1)
    self:MoveTo(self:GetX(), 0 - ICON_FRAME_SIZE - 8, .5, .7, .3, function()
        self:SetVisible(false)
        self.removed = true
    end)
end

vgui.Register('cellar.citizenhud.needs', PANEL, "DPanel")




PANEL = {}
function PANEL:Init()

    if IsValid(cellar_citizenhud_rad) then
        cellar_citizenhud_rad:Remove()
    end

    cellar_citizenhud_rad = self

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.frameInside = ColorAlpha(cellar_darker_blue, 107)
    self.frameCritInside = ColorAlpha(cellar_red, critAlpha)
    self.hinside = nil
    self.tinside = nil
    self.client = LocalPlayer()
    self.removed = false

    self:SetAlpha(65)
    self:SetSize(ICON_FRAME_SIZE * 4 + 24, ICON_FRAME_SIZE)
    self:SetPos(ScrW() * .5 - ICON_FRAME_SIZE * 2 - 12, 0 - ICON_FRAME_SIZE - 8)
    self:MoveTo(ScrW() * .5 - ICON_FRAME_SIZE * 2 - 12, 8, .5, .3, .1)
    self:AlphaTo(255, .5, .7)
    self:ParentToHUD()

    self.geiger = self:Add('DPanel')
    self.geiger:SetPos(0, 0)
    self.geiger:SetSize(ICON_FRAME_SIZE, ICON_FRAME_SIZE)
    self.geiger.Paint = function(me, w, h)
        local icon = Material('cellar/main/hud/geiger.png')

        surface.SetDrawColor(self.hinside > 0.3 and self.hinside < 0.6 and LerpColor(self.critAlpha/100, self.frameInside, color_yellow) or self.hinside > 0.6 and LerpColor(self.critAlpha/100, color_yellow, self.frameCritInside) or self.frameInside)

        surface.SetMaterial(icon)
        surface.DrawTexturedRectRotated(w * .5, h * .5, ICON_SIZE, ICON_SIZE, 0)

        surface.DrawRect(w - 1, h * .33, 1, h)
        surface.DrawRect(0, 0, 1, h * .66)
        surface.DrawLine(w * .66, 0, w - 1, h * .33)

        surface.DrawRect(0, 0, w * .66, 1)
        surface.DrawRect(w * .33, h - 1, w, 1)
        surface.DrawLine(0, h * .66, w * .33, h - 1)
    end

    self.filter = self:Add('DPanel')
    self.filter:SetPos(self:GetWide() - ICON_FRAME_SIZE, 0)
    self.filter:SetSize(ICON_FRAME_SIZE, ICON_FRAME_SIZE)
    self.filter.Paint = function(me, w, h)
        local icon = Material('cellar/main/hud/filter.png')

        surface.SetDrawColor(self.tinside > 0.3 and self.tinside < 0.6 and LerpColor(self.critAlpha/100, self.frameInside, color_yellow) or self.tinside < 0.3 and LerpColor(self.critAlpha/100, color_yellow, self.frameCritInside) or self.frameInside)

        surface.SetMaterial(icon)
        surface.DrawTexturedRectRotated(w * .5, h * .5, ICON_SIZE, ICON_SIZE, 0)

        surface.DrawRect(w * .33, 0, w, 1)
        surface.DrawRect(0, h * .33, 1, h)
        surface.DrawLine(0, h * .33, w * .33, 0)

        surface.DrawRect(0, h - 1, w * .66, 1)
        surface.DrawRect(w - 1, 0, 1, h * .66)
        surface.DrawLine(w * .66 - 1, h - 1, w - 1, h * .66 - 1)
    end

end

function PANEL:Paint(w, h)
end

function PANEL:Think()

    local radLevel = LocalPlayer():GetNetVar("radDmg") or 0
	local geiger = character:HasGeigerCounter()
    local filter = character:HasWearedFilter()

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.hinside = radLevel/100
    self.tinside = filter and filter:GetFilterQuality()/filter.filterQuality

end

function PANEL:Remove()
    self:AlphaTo(65, .5, .1)
    self:MoveTo(self:GetX(), 0 - ICON_FRAME_SIZE - 8, .5, .7, .3, function()
        self:SetVisible(false)
        self.removed = true
    end)
end

vgui.Register('cellar.citizenhud.rad', PANEL, "DPanel")


PANEL = {}
function PANEL:Init()

    if IsValid(cellar_citizenhud_temperature) then
        cellar_citizenhud_temperature:Remove()
    end

    cellar_citizenhud_temperature = self

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.frameInside = ColorAlpha(cellar_blue, 107)
    self.frameCritInside = ColorAlpha(cellar_red, critAlpha)
    self.hinside = nil
    self.tinside = nil
    self.client = LocalPlayer()
    self.removed = false

    self:SetAlpha(65)
    self:SetSize(ICON_FRAME_SIZE * 3, ICON_FRAME_SIZE)
    self:SetPos(ScrW() * .016, ScrH() * .03 + ICON_FRAME_SIZE + 8)
    self:AlphaTo(255, .5, .7)
    self:ParentToHUD()

    self.temperature = self:Add('DPanel')
    self.temperature:SetPos(0, 0)
    self.temperature:SetSize(ICON_FRAME_SIZE, ICON_FRAME_SIZE)
    self.temperature.Paint = function(me, w, h)
        local icon = Material('cellar/main/hud/snowflake.png')

        surface.SetDrawColor(self.tinside < 0.6 and LerpColor(self.critAlpha/100, self.frameInside, color_yellow) or self.tinside < 0.3 and LerpColor(self.critAlpha/100, color_yellow, self.frameCritInside) or self.frameInside)

        surface.SetMaterial(icon)
        surface.DrawTexturedRectRotated(w * .5, h * .5, ICON_SIZE, ICON_SIZE, 0)

        surface.DrawRect(0, 0, w * .66, 1)
        surface.DrawRect(0, 0, 1, h)
        surface.DrawRect(0, h - 1, w, 1)
        surface.DrawRect(w - 1, h * .33, 1, h * .66)
        surface.DrawLine(w * .66, 0, w, h * .33)


    end

end

function PANEL:Paint(w, h)
end

function PANEL:Think()

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.tinside = LocalPlayer():GetLocalVar("coldCounter", 0) / 100

end

function PANEL:Remove()
    self:AlphaTo(65, .5, .1, function()
        self:SetVisible(false)
        self.removed = true
    end)
end

vgui.Register('cellar.citizenhud.temperature', PANEL, "DPanel")