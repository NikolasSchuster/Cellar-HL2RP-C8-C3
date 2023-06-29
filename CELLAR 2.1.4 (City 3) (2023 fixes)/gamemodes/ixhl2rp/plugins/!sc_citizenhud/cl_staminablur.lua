PANEL = {}
function PANEL:Init()

    if IsValid(cellar_citizenhud_stamina) then
        cellar_citizenhud_stamina:Remove()
    end

    cellar_citizenhud_stamina = self

    self.critAlpha = TimedSin(.65, 45, 155, 0)
    self.frameInside = ColorAlpha(cellar_darker_blue, 107)
    self.frameCritInside = ColorAlpha(cellar_red, critAlpha)
    self.hinside = nil
    self.tinside = nil
    self.client = LocalPlayer()
    self.removed = false

    self:SetAlpha(0)
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)
    self:AlphaTo(255, 1.5, .1)
    self:ParentToHUD()

end

function PANEL:Paint(w, h)
    DrawBlurIndependent(self)
end

function PANEL:Think()
end

function PANEL:Remove()
    self:AlphaTo(0, 1.5, .1, function()
        self.removed = true
    end)
end

vgui.Register('cellar.citizenhud.stamina', PANEL, "DPanel")