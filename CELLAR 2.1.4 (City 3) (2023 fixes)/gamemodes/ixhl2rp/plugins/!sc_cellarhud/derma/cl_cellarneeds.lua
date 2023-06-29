local ICON_SIZE = 16
local ICONFRAME_SIZE = 32
local BAR_WIDTH = 384
local BAR_HEIGHT = 8
local animTime = 2.3
local alphaTime = .6
local PLUGIN = PLUGIN


PANEL = {}
function PANEL:Init()

    if IsValid(cellar_needs_hunger) then
        cellar_needs_hunger:Remove()
    end

    cellar_needs_hunger = self

    self.removed = false
    self.contentvalue = 1

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.barBackground = ColorAlpha(cellar_darker_blue, 43)
    self.barCritBackground = ColorAlpha(cellar_red, 25)
    self.barInside = ColorAlpha(cellar_darker_blue, 107)
    self.barCritInside = ColorAlpha(cellar_red, critAlpha)
    self.barBorders = ColorAlpha(cellar_blue, 155)
    self.barCritBorders = ColorAlpha(cellar_red, 225)
    self.barIcon = ColorAlpha(cellar_blue, 43)
    self.barCritIcon = ColorAlpha(cellar_red, 43)


    self:SetPos(ScrW() - 8 - ICONFRAME_SIZE - 8 - BAR_WIDTH - 2, ScrH() * .25)
    self:SetSize(8 + ICONFRAME_SIZE + 8 + BAR_WIDTH + 2, 36)
    self:SetAlpha(0)
    self:AlphaTo(255, alphaTime, .1)
    self:ParentToHUD()

    self.icon = self:Add('DPanel')
    self.icon:SetPos(self:GetWide() - 8 - ICONFRAME_SIZE, 2)
    self.icon:SetSize(ICONFRAME_SIZE, ICONFRAME_SIZE)
    self.icon.Paint = function(me, w, h)
        local icon = Material('cellar/main/hud/hunger.png')
        
        surface.SetDrawColor(self.contentvalue <= 0.25 and LerpColor(self.critAlpha/100, ColorAlpha(cellar_blue, 135), self.barCritInside) or ColorAlpha(cellar_blue, 135))
        surface.SetMaterial(icon)
        surface.DrawTexturedRectRotated(w * .5, h * .5, ICON_SIZE, ICON_SIZE, 0)

        surface.DrawRect(w - 1, h * .33, 1, h)
        surface.DrawRect(0, 0, 1, h * .66)
        surface.DrawLine(w * .66, 0, w - 1, h * .33)

        surface.DrawRect(0, 0, w * .66, 1)
        surface.DrawRect(w * .33, h - 1, w, 1)
        surface.DrawLine(0, h * .66, w * .33, h - 1)
        
    end

    self.line = self:Add('DPanel')
    self.line:SetPos(self:GetWide() - 8 - ICONFRAME_SIZE - 8 - 12, 2)
    self.line:SetSize(12, 32)
    self.line:MoveTo(0, 2, animTime, .7, .1)
    self.line:SizeTo(self:GetWide() - 16 - ICONFRAME_SIZE, 32, animTime, .7, .1)
    self.line.Paint = function(me, w, h)

        surface.SetDrawColor(self.contentvalue <= 0.25 and LerpColor(self.critAlpha/100, self.barBackground, self.barCritBackground) or self.barBackground)
        surface.DrawRect(5, 0, w, 1)
        surface.DrawRect(4, 1, w, 1)
        surface.DrawRect(3, 2, w, 1)
        surface.DrawRect(2, 3, w, 1)
        surface.DrawRect(1, 4, w, 1)
        surface.DrawRect(0, 5, w, (h * .375)/2)

        surface.DrawRect(0, 12, w, 1)
        surface.DrawRect(0, 12, 1, 4)
        surface.DrawRect(w - 1, 12, 1, 4)

        surface.DrawRect(w * .1, 12, 1, 3)
        surface.DrawRect(w * .2, 12, 1, 3)
        surface.DrawRect(w * .3, 12, 1, 3)
        surface.DrawRect(w * .4, 12, 1, 3)
        surface.DrawRect(w * .5, 12, 1, 3)
        surface.DrawRect(w * .6, 12, 1, 3)
        surface.DrawRect(w * .7, 12, 1, 3)
        surface.DrawRect(w * .8, 12, 1, 3)
        surface.DrawRect(w * .9, 12, 1, 3)


        
        surface.SetDrawColor(self.contentvalue <= 0.25 and LerpColor(self.critAlpha/100, self.barInside, self.barCritInside) or self.barInside)
        w = w * self.contentvalue + 1
        surface.DrawRect(5 + BAR_WIDTH - (w - 3), 0, w, 1)
        surface.DrawRect(4 + BAR_WIDTH - (w - 3), 1, w, 1)
        surface.DrawRect(3 + BAR_WIDTH - (w - 3), 2, w, 1)
        surface.DrawRect(2 + BAR_WIDTH - (w - 3), 3, w, 1)
        surface.DrawRect(1 + BAR_WIDTH - (w - 3), 4, w, 1)
        surface.DrawRect(0 + BAR_WIDTH - (w - 3), 5, w + 2, (h * .375)/2)

        surface.DrawLine(BAR_WIDTH - (w - 3), 16, BAR_WIDTH - (w - 3), 24)
        if self.contentvalue >= 0.048 then
            local percentvalue = math.Round(self.contentvalue, 2) * 100
            draw.SimpleText((percentvalue).."%", "cellar.hud.micro", BAR_WIDTH - (w - 3) + 2, 26, self.contentvalue < 0.25 and LerpColor(self.critAlpha/100, color_white, cellar_red) or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            draw.SimpleText((percentvalue).."%", "cellar.hud.micro.blur", BAR_WIDTH - (w - 3) + 2, 26, self.contentvalue < 0.25 and LerpColor(self.critAlpha/100, Color(40, 40, 40), cellar_red) or Color(40, 40, 40), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end


    end

end

function PANEL:Think()
    self.contentvalue = Lerp(2.5 * FrameTime(), self.contentvalue, LocalPlayer():GetCharacter():GetHunger()/100)
end

function PANEL:Paint(w, h)

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.barCritInside = ColorAlpha(cellar_red, critAlpha)

end

function PANEL:Remove()
    self.removed = true

    self.line:MoveTo(self:GetWide() - 8 - ICONFRAME_SIZE - 8 - 12, 2, animTime, .1, .1)
    self.line:SizeTo(10, 32, animTime, .1, .1)

    self:SetAlpha(255)
    self:AlphaTo(0, alphaTime, animTime)
    timer.Simple(animTime + alphaTime + .1, function() self:SetVisible(false) end)
end

vgui.Register('cellar.needs.hunger', PANEL, "Panel")



PANEL = {}
function PANEL:Init()

    if IsValid(cellar_needs_thirst) then
        cellar_needs_thirst:Remove()
    end

    cellar_needs_thirst = self

    self.removed = false
    self.contentvalue = 1

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.barBackground = ColorAlpha(cellar_darker_blue, 43)
    self.barCritBackground = ColorAlpha(cellar_red, 25)
    self.barInside = ColorAlpha(cellar_darker_blue, 107)
    self.barCritInside = ColorAlpha(cellar_red, critAlpha)
    self.barBorders = ColorAlpha(cellar_blue, 155)
    self.barCritBorders = ColorAlpha(cellar_red, 225)
    self.barIcon = ColorAlpha(cellar_blue, 43)
    self.barCritIcon = ColorAlpha(cellar_red, 43)


    self:SetPos(ScrW() - 8 - ICONFRAME_SIZE - 8 - BAR_WIDTH - 2, ScrH() * .25 + 40)
    self:SetSize(8 + ICONFRAME_SIZE + 8 + BAR_WIDTH + 2, 36)
    self:SetAlpha(0)
    self:AlphaTo(255, alphaTime, .1)
    self:ParentToHUD()

    self.icon = self:Add('DPanel')
    self.icon:SetPos(self:GetWide() - 8 - ICONFRAME_SIZE, 2)
    self.icon:SetSize(ICONFRAME_SIZE, ICONFRAME_SIZE)
    self.icon.Paint = function(me, w, h)
        local icon = Material('cellar/main/hud/thirst.png')
        
        surface.SetDrawColor(self.contentvalue <= 0.25 and LerpColor(self.critAlpha/100, ColorAlpha(cellar_blue, 135), self.barCritInside) or ColorAlpha(cellar_blue, 135))
        surface.SetMaterial(icon)
        surface.DrawTexturedRectRotated(w * .5, h * .5, ICON_SIZE, ICON_SIZE, 0)

        surface.DrawRect(w - 1, h * .33, 1, h)
        surface.DrawRect(0, 0, 1, h * .66)
        surface.DrawLine(w * .66, 0, w - 1, h * .33)

        surface.DrawRect(0, 0, w * .66, 1)
        surface.DrawRect(w * .33, h - 1, w, 1)
        surface.DrawLine(0, h * .66, w * .33, h - 1)
        
    end

    self.line = self:Add('DPanel')
    self.line:SetPos(self:GetWide() - 8 - ICONFRAME_SIZE - 8 - 12, 2)
    self.line:SetSize(12, 32)
    self.line:MoveTo(0, 2, animTime, .7, .1)
    self.line:SizeTo(self:GetWide() - 16 - ICONFRAME_SIZE, 32, animTime, .7, .1)
    self.line.Paint = function(me, w, h)

        surface.SetDrawColor(self.contentvalue <= 0.25 and LerpColor(self.critAlpha/100, self.barBackground, self.barCritBackground) or self.barBackground)
        surface.DrawRect(5, 0, w, 1)
        surface.DrawRect(4, 1, w, 1)
        surface.DrawRect(3, 2, w, 1)
        surface.DrawRect(2, 3, w, 1)
        surface.DrawRect(1, 4, w, 1)
        surface.DrawRect(0, 5, w, (h * .375)/2)

        surface.DrawRect(0, 12, w, 1)
        surface.DrawRect(0, 12, 1, 4)
        surface.DrawRect(w - 1, 12, 1, 4)

        surface.DrawRect(w * .1, 12, 1, 3)
        surface.DrawRect(w * .2, 12, 1, 3)
        surface.DrawRect(w * .3, 12, 1, 3)
        surface.DrawRect(w * .4, 12, 1, 3)
        surface.DrawRect(w * .5, 12, 1, 3)
        surface.DrawRect(w * .6, 12, 1, 3)
        surface.DrawRect(w * .7, 12, 1, 3)
        surface.DrawRect(w * .8, 12, 1, 3)
        surface.DrawRect(w * .9, 12, 1, 3)


        
        surface.SetDrawColor(self.contentvalue <= 0.25 and LerpColor(self.critAlpha/100, self.barInside, self.barCritInside) or self.barInside)
        w = w * self.contentvalue + 1
        surface.DrawRect(5 + BAR_WIDTH - (w - 3), 0, w, 1)
        surface.DrawRect(4 + BAR_WIDTH - (w - 3), 1, w, 1)
        surface.DrawRect(3 + BAR_WIDTH - (w - 3), 2, w, 1)
        surface.DrawRect(2 + BAR_WIDTH - (w - 3), 3, w, 1)
        surface.DrawRect(1 + BAR_WIDTH - (w - 3), 4, w, 1)
        surface.DrawRect(0 + BAR_WIDTH - (w - 3), 5, w + 2, (h * .375)/2)

        surface.DrawLine(BAR_WIDTH - (w - 3), 16, BAR_WIDTH - (w - 3), 24)
        if self.contentvalue >= 0.048 then
            local percentvalue = math.Round(self.contentvalue, 2) * 100
            draw.SimpleText((percentvalue).."%", "cellar.hud.micro", BAR_WIDTH - (w - 3) + 2, 26, self.contentvalue < 0.25 and LerpColor(self.critAlpha/100, color_white, cellar_red) or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            draw.SimpleText((percentvalue).."%", "cellar.hud.micro.blur", BAR_WIDTH - (w - 3) + 2, 26, self.contentvalue < 0.25 and LerpColor(self.critAlpha/100, Color(40, 40, 40), cellar_red) or Color(40, 40, 40), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end


    end

end

function PANEL:Think()
    self.contentvalue = Lerp(2.5 * FrameTime(), self.contentvalue, LocalPlayer():GetCharacter():GetThirst()/100)
end

function PANEL:Paint(w, h)

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.barCritInside = ColorAlpha(cellar_red, critAlpha)

end

function PANEL:Remove()
    self.removed = true

    self.line:MoveTo(self:GetWide() - 8 - ICONFRAME_SIZE - 8 - 12, 2, animTime, .1, .1)
    self.line:SizeTo(10, 32, animTime, .1, .1)

    self:SetAlpha(255)
    self:AlphaTo(0, alphaTime, animTime)
    timer.Simple(animTime + alphaTime + .1, function() self:SetVisible(false) end)
end

vgui.Register('cellar.needs.thirst', PANEL, "Panel")



PANEL = {}
function PANEL:Init()

    if IsValid(cellar_needs_geiger) then
        cellar_needs_geiger:Remove()
    end

    if not LocalPlayer():GetCharacter():HasGeigerCounter() then
        cellar_needs_geiger:Remove()
    end

    cellar_needs_geiger = self

    self.removed = false
    self.contentvalue = 1

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.barBackground = ColorAlpha(cellar_darker_blue, 43)
    self.barCritBackground = ColorAlpha(cellar_red, 25)
    self.barInside = ColorAlpha(cellar_darker_blue, 107)
    self.barCritInside = ColorAlpha(cellar_red, critAlpha)
    self.barBorders = ColorAlpha(cellar_blue, 155)
    self.barCritBorders = ColorAlpha(cellar_red, 225)
    self.barIcon = ColorAlpha(cellar_blue, 43)
    self.barCritIcon = ColorAlpha(cellar_red, 43)


    self:SetPos(ScrW() - 8 - ICONFRAME_SIZE - 8 - BAR_WIDTH - 2, ScrH() * .25 + 80)
    self:SetSize(8 + ICONFRAME_SIZE + 8 + BAR_WIDTH + 2, 36)
    self:SetAlpha(0)
    self:AlphaTo(255, alphaTime, .1)
    self:ParentToHUD()

    self.icon = self:Add('DPanel')
    self.icon:SetPos(self:GetWide() - 8 - ICONFRAME_SIZE, 2)
    self.icon:SetSize(ICONFRAME_SIZE, ICONFRAME_SIZE)
    self.icon.Paint = function(me, w, h)
        local icon = Material('cellar/main/hud/geiger.png')
        
        surface.SetDrawColor(self.contentvalue >= 0.25 and LerpColor(self.critAlpha/100, ColorAlpha(cellar_blue, 135), self.barCritInside) or ColorAlpha(cellar_blue, 135))
        surface.SetMaterial(icon)
        surface.DrawTexturedRectRotated(w * .5, h * .5, ICON_SIZE, ICON_SIZE, 0)

        surface.DrawRect(w - 1, h * .33, 1, h)
        surface.DrawRect(0, 0, 1, h * .66)
        surface.DrawLine(w * .66, 0, w - 1, h * .33)

        surface.DrawRect(0, 0, w * .66, 1)
        surface.DrawRect(w * .33, h - 1, w, 1)
        surface.DrawLine(0, h * .66, w * .33, h - 1)
        
    end

    self.line = self:Add('DPanel')
    self.line:SetPos(self:GetWide() - 8 - ICONFRAME_SIZE - 8 - 12, 2)
    self.line:SetSize(12, 32)
    self.line:MoveTo(0, 2, animTime, .7, .1)
    self.line:SizeTo(self:GetWide() - 16 - ICONFRAME_SIZE, 32, animTime, .7, .1)
    self.line.Paint = function(me, w, h)

        surface.SetDrawColor(self.contentvalue >= 0.25 and LerpColor(self.critAlpha/100, self.barBackground, self.barCritBackground) or self.barBackground)
        surface.DrawRect(5, 0, w, 1)
        surface.DrawRect(4, 1, w, 1)
        surface.DrawRect(3, 2, w, 1)
        surface.DrawRect(2, 3, w, 1)
        surface.DrawRect(1, 4, w, 1)
        surface.DrawRect(0, 5, w, (h * .375)/2)

        surface.DrawRect(0, 12, w, 1)
        surface.DrawRect(0, 12, 1, 4)
        surface.DrawRect(w - 1, 12, 1, 4)

        surface.DrawRect(w * .1, 12, 1, 3)
        surface.DrawRect(w * .2, 12, 1, 3)
        surface.DrawRect(w * .3, 12, 1, 3)
        surface.DrawRect(w * .4, 12, 1, 3)
        surface.DrawRect(w * .5, 12, 1, 3)
        surface.DrawRect(w * .6, 12, 1, 3)
        surface.DrawRect(w * .7, 12, 1, 3)
        surface.DrawRect(w * .8, 12, 1, 3)
        surface.DrawRect(w * .9, 12, 1, 3)


        
        surface.SetDrawColor(self.contentvalue >= 0.25 and LerpColor(self.critAlpha/100, self.barInside, self.barCritInside) or self.barInside)
        w = w * self.contentvalue + 1
        surface.DrawRect(5 + BAR_WIDTH - (w - 3), 0, w, 1)
        surface.DrawRect(4 + BAR_WIDTH - (w - 3), 1, w, 1)
        surface.DrawRect(3 + BAR_WIDTH - (w - 3), 2, w, 1)
        surface.DrawRect(2 + BAR_WIDTH - (w - 3), 3, w, 1)
        surface.DrawRect(1 + BAR_WIDTH - (w - 3), 4, w, 1)
        surface.DrawRect(0 + BAR_WIDTH - (w - 3), 5, w + 2, (h * .375)/2)

        surface.DrawLine(BAR_WIDTH - (w - 3), 16, BAR_WIDTH - (w - 3), 24)
        if self.contentvalue >= 0.048 then
            local percentvalue = math.Round(self.contentvalue, 2) * 100
            draw.SimpleText((percentvalue).."%", "cellar.hud.micro", BAR_WIDTH - (w - 3) + 2, 26, self.contentvalue >= 0.25 and LerpColor(self.critAlpha/100, color_white, cellar_red) or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            draw.SimpleText((percentvalue).."%", "cellar.hud.micro.blur", BAR_WIDTH - (w - 3) + 2, 26, self.contentvalue >= 0.25 and LerpColor(self.critAlpha/100, Color(40, 40, 40), cellar_red) or Color(40, 40, 40), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end


    end

end

function PANEL:Think()
    local radLevel = LocalPlayer():GetNetVar("radDmg") or 0
	local geiger = LocalPlayer():GetCharacter():HasGeigerCounter()
    if geiger then
        self.contentvalue = Lerp(2.5 * FrameTime(), self.contentvalue, radLevel/100)
    end
end

function PANEL:Paint(w, h)

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.barCritInside = ColorAlpha(cellar_red, critAlpha)

end

function PANEL:Remove()
    self.removed = true

    self.line:MoveTo(self:GetWide() - 8 - ICONFRAME_SIZE - 8 - 12, 2, animTime, .1, .1)
    self.line:SizeTo(10, 32, animTime, .1, .1)

    self:SetAlpha(255)
    self:AlphaTo(0, alphaTime, animTime)
    timer.Simple(animTime + alphaTime + .1, function() self:SetVisible(false) end)
end

vgui.Register('cellar.needs.geiger', PANEL, "Panel")




PANEL = {}
function PANEL:Init()

    if IsValid(cellar_needs_filter) then
        cellar_needs_filter:Remove()
    end

    if !LocalPlayer():GetCharacter():HasWearedFilter() then
        cellar_needs_filter:Remove()
    end

    cellar_needs_filter = self

    self.removed = false
    self.contentvalue = 1

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.barBackground = ColorAlpha(cellar_darker_blue, 43)
    self.barCritBackground = ColorAlpha(cellar_red, 25)
    self.barInside = ColorAlpha(cellar_darker_blue, 107)
    self.barCritInside = ColorAlpha(cellar_red, critAlpha)
    self.barBorders = ColorAlpha(cellar_blue, 155)
    self.barCritBorders = ColorAlpha(cellar_red, 225)
    self.barIcon = ColorAlpha(cellar_blue, 43)
    self.barCritIcon = ColorAlpha(cellar_red, 43)


    self:SetPos(ScrW() - 8 - ICONFRAME_SIZE - 8 - BAR_WIDTH - 2, ScrH() * .25 + 120)
    self:SetSize(8 + ICONFRAME_SIZE + 8 + BAR_WIDTH + 2, 36)
    self:SetAlpha(0)
    self:AlphaTo(255, alphaTime, .1)
    self:ParentToHUD()

    self.icon = self:Add('DPanel')
    self.icon:SetPos(self:GetWide() - 8 - ICONFRAME_SIZE, 2)
    self.icon:SetSize(ICONFRAME_SIZE, ICONFRAME_SIZE)
    self.icon.Paint = function(me, w, h)
        local icon = Material('cellar/main/hud/filter.png')
        
        surface.SetDrawColor(self.contentvalue <= 0.25 and LerpColor(self.critAlpha/100, ColorAlpha(cellar_blue, 135), self.barCritInside) or ColorAlpha(cellar_blue, 135))
        surface.SetMaterial(icon)
        surface.DrawTexturedRectRotated(w * .5, h * .5, ICON_SIZE, ICON_SIZE, 0)

        surface.DrawRect(w - 1, h * .33, 1, h)
        surface.DrawRect(0, 0, 1, h * .66)
        surface.DrawLine(w * .66, 0, w - 1, h * .33)

        surface.DrawRect(0, 0, w * .66, 1)
        surface.DrawRect(w * .33, h - 1, w, 1)
        surface.DrawLine(0, h * .66, w * .33, h - 1)
        
    end

    self.line = self:Add('DPanel')
    self.line:SetPos(self:GetWide() - 8 - ICONFRAME_SIZE - 8 - 12, 2)
    self.line:SetSize(12, 32)
    self.line:MoveTo(0, 2, animTime, .7, .1)
    self.line:SizeTo(self:GetWide() - 16 - ICONFRAME_SIZE, 32, animTime, .7, .1)
    self.line.Paint = function(me, w, h)

        surface.SetDrawColor(self.contentvalue <= 0.25 and LerpColor(self.critAlpha/100, self.barBackground, self.barCritBackground) or self.barBackground)
        surface.DrawRect(5, 0, w, 1)
        surface.DrawRect(4, 1, w, 1)
        surface.DrawRect(3, 2, w, 1)
        surface.DrawRect(2, 3, w, 1)
        surface.DrawRect(1, 4, w, 1)
        surface.DrawRect(0, 5, w, (h * .375)/2)

        surface.DrawRect(0, 12, w, 1)
        surface.DrawRect(0, 12, 1, 4)
        surface.DrawRect(w - 1, 12, 1, 4)

        surface.DrawRect(w * .1, 12, 1, 3)
        surface.DrawRect(w * .2, 12, 1, 3)
        surface.DrawRect(w * .3, 12, 1, 3)
        surface.DrawRect(w * .4, 12, 1, 3)
        surface.DrawRect(w * .5, 12, 1, 3)
        surface.DrawRect(w * .6, 12, 1, 3)
        surface.DrawRect(w * .7, 12, 1, 3)
        surface.DrawRect(w * .8, 12, 1, 3)
        surface.DrawRect(w * .9, 12, 1, 3)


        
        surface.SetDrawColor(self.contentvalue <= 0.25 and LerpColor(self.critAlpha/100, self.barInside, self.barCritInside) or self.barInside)
        w = w * self.contentvalue + 1
        surface.DrawRect(5 + BAR_WIDTH - (w - 3), 0, w, 1)
        surface.DrawRect(4 + BAR_WIDTH - (w - 3), 1, w, 1)
        surface.DrawRect(3 + BAR_WIDTH - (w - 3), 2, w, 1)
        surface.DrawRect(2 + BAR_WIDTH - (w - 3), 3, w, 1)
        surface.DrawRect(1 + BAR_WIDTH - (w - 3), 4, w, 1)
        surface.DrawRect(0 + BAR_WIDTH - (w - 3), 5, w + 2, (h * .375)/2)

        surface.DrawLine(BAR_WIDTH - (w - 3), 16, BAR_WIDTH - (w - 3), 24)
        if self.contentvalue >= 0.048 then
            local percentvalue = math.Round(self.contentvalue, 2) * 100
            draw.SimpleText((percentvalue).."%", "cellar.hud.micro", BAR_WIDTH - (w - 3) + 2, 26, self.contentvalue < 0.25 and LerpColor(self.critAlpha/100, color_white, cellar_red) or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            draw.SimpleText((percentvalue).."%", "cellar.hud.micro.blur", BAR_WIDTH - (w - 3) + 2, 26, self.contentvalue < 0.25 and LerpColor(self.critAlpha/100, Color(40, 40, 40), cellar_red) or Color(40, 40, 40), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end


    end

end

function PANEL:Think()
    local filter = LocalPlayer():GetCharacter():HasWearedFilter()
    if filter then
        self.contentvalue = Lerp(2.5 * FrameTime(), self.contentvalue, filter:GetFilterQuality()/filter.filterQuality)
    end
end

function PANEL:Paint(w, h)

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.barCritInside = ColorAlpha(cellar_red, critAlpha)

end

function PANEL:Remove()
    self.removed = true

    self.line:MoveTo(self:GetWide() - 8 - ICONFRAME_SIZE - 8 - 12, 2, animTime, .1, .1)
    self.line:SizeTo(10, 32, animTime, .1, .1)

    self:SetAlpha(255)
    self:AlphaTo(0, alphaTime, animTime)
    timer.Simple(animTime + alphaTime + .1, function() self:SetVisible(false) end)
end

vgui.Register('cellar.needs.filter', PANEL, "Panel")