--[[ ВНИМАНИЕ, ПАНЕЛЬ ОСНОВАНА НА gamemodes/helix/core/derma/cl_help.lua И НЕ БУДЕТ РАБОТАТЬ КОРРЕКТНО БЕЗ ВЫШЕУКАЗАННОГО ФАЙЛА]]--

PANEL = {}
local background = Material('cellar/main/tab/backgroundtabmirrored.png')
local television = Material('cellar/main/tvtexture.png')
local staticborder = Material('cellar/main/tab/tabbordersmirrored.png')

function PANEL:Init()
	if IsValid(cellar_tab_help) then
		cellar_tab_help:Remove()
	end

	cellar_tab_help = self

	local parent = self:GetParent()
	self.closing = false
	self.noAnchor = CurTime() + 0.4
	self.anchorMode = true
	local frameH, frameW, animTime, animDelay, animEase = ScrW(), ScrH(), 1, 0, .1
	local isAnimating = true
	self:MakePopup()
	self:SetSize(0, ScrH())
    self:SetPos(ScrW(), ScrH() - ScrH())
	self:SetAlpha(0)
	self:AlphaTo(255, .5, 0)
	self:SizeTo(frameH, frameW, animTime, animDelay, animEase, function()
		isAnimating = false
	end)
    self:MoveTo(0, 0, .8, .1, .1)
	LocalPlayer():EmitSound("cellar.tab.amb2")
	LocalPlayer():EmitSound('Helix.Whoosh')

    self.canvas = self:Add("Panel")
    self.canvas:SetPos(ScrW() - ScrW() * .916, ScrH() - ScrH() * .90)
    self.canvas:SetSize(1000, 0)
    self.canvas:SizeTo(ScrW() * .8333, ScrH() * .7778, .5, .1, .1)
    self.canvas.Paint = function(me, w, h)
    end

    local helppanel = self.canvas:Add('ixHelpMenu')

    local menu = self:Add("cellar.btnlist")
	menu:SetPos(ScrW() - ScrW()/2 - 301, ScrH() - ScrH() * .0888)
	menu:SetText('МЕНЮ')
	menu:SetSize(300, 0)
	menu:SizeTo(300, 40, .3, (0.1))
	menu.Think = function(me)
		if self.closing then
			me:SizeTo(300, 0, .2, 0)
		end
	end
	menu.DoClick = function()
        vgui.Create('cellar.tab')
		self:Remove()
	end

	local close = self:Add("cellar.btnlistmirrored")
	close:SetPos(ScrW() - ScrW()/2 + 1, ScrH() - ScrH() * .0888)
	close:SetText('ЗАКРЫТЬ')
	close:SetSize(300, 0)
	close:SizeTo(300, 40, .3, (0.1))
	close.Think = function(me)
		if self.closing then
			me:SizeTo(300, 0, .2, 0)
		end
	end
	close.DoClick = function()
		self:Remove()
	end
	----------------------------------
end

function PANEL:Paint(w, h)
	local vignette = ix.util.GetMaterial("helix/gui/vignette.png")
    local helpframe = Material('cellar/main/tab/helpframe1604x754.png')
    local logo128 = Material('cellar/main/cellardoor128.png')

	DrawBlurIndependent(self)
	surface.SetDrawColor(ColorAlpha(color_white, 190))
	surface.SetMaterial(background)
	surface.DrawTexturedRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(color_black, 170))
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(color_white, 90))
	surface.SetMaterial(television)
	surface.DrawTexturedRect(0, 0, w, h)


	surface.SetDrawColor(ColorAlpha(color_white, 240))
	surface.SetMaterial(staticborder)
	surface.DrawTexturedRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(color_black, 255))
	surface.SetMaterial(vignette)
	surface.DrawTexturedRect(0, 0, w, h)

	local scoreboarder = Material('cellar/main/tab/scoreboarder1642x880.png')
    surface.SetDrawColor(color_white)
    surface.SetMaterial(scoreboarder)
    surface.DrawTexturedRect(ScrW() - ScrW() * .9276, ScrH() - ScrH() * .915, ScrW() * .8547, ScrH() * .8148)

    /*surface.SetDrawColor(Color(56, 207, 248, 45))
    surface.SetMaterial(logo128)
    surface.DrawTexturedRect(ScrW() * .6146, ScrH() * .7222, 128, 128)

   	surface.SetTextColor(Color(56, 207, 248, 45))
    surface.SetFont('cellar.help.logo.blur')
    surface.SetTextPos(ScrW() * .6146 + 128 - 12, ScrH() * .7454)
    surface.DrawText('CELLAR PROJECT.')

    surface.SetTextColor(Color(56, 207, 248, 45))
    surface.SetFont('cellar.help.logo')
    surface.SetTextPos(ScrW() * .6146 + 128 - 12, ScrH() * .7454)
    surface.DrawText('CELLAR PROJECT.')

    surface.SetTextColor(Color(195, 30, 30, 170, 10))
    surface.SetFont('cellar.logo.2.blur')
    surface.SetTextPos(ScrW() * .6146 + 128 - 10, ScrH() * .7963)
    surface.DrawText('A SERIOUS HALF-LIFE 2 ROLEPLAY SERVER')

    surface.SetTextColor(Color(195, 30, 30, 170, 10))
    surface.SetFont('cellar.logo.2')
    surface.SetTextPos(ScrW() * .6146 + 128 - 10, ScrH() * .7963)
    surface.DrawText('A SERIOUS HALF-LIFE 2 ROLEPLAY SERVER')*/

	local animslide1 = TimedSin(.32, ScrH() * .8391/1.7, ScrH() * .8391*1.49, 0)
    local animsize1 = TimedCos(.32, 15, 25, 0)

    surface.SetDrawColor(Color(56, 207, 248, 25))
	surface.DrawLine(self.canvas:GetX() - 7, animslide1 + 5, self.canvas:GetWide() * 1.10233 + 7, animslide1 + 5)
	surface.DrawLine(self.canvas:GetX() - 7, animslide1 + 6, self.canvas:GetWide() * 1.10233 + 7, animslide1 + 6)

    surface.SetDrawColor(Color(56, 207, 248, 255))
	surface.DrawRect(self.canvas:GetX() - 8, animslide1, 1, animsize1)
	surface.DrawRect(self.canvas:GetWide() * 1.10233 + 8, animslide1, 1, animsize1)

end

function PANEL:OnKeyCodePressed(key)
	self.noAnchor = CurTime() + 0.5

    if (key == KEY_TAB) then 
		LocalPlayer():StopSound('cellar.info.amb')
		--LocalPlayer():EmitSound('otherclosing25.mp3')
		self:Remove()
	end
end

function PANEL:Think()
	local bTabDown = input.IsKeyDown(KEY_TAB)
    local esc, console = input.IsKeyDown(KEY_ESCAPE), input.IsKeyDown(KEY_FIRST)

	if (bTabDown and (self.noAnchor or CurTime() + 0.4) < CurTime() and self.anchorMode) then
		self.closing = true
		self.anchorMode = false
		self:Remove()
	end

	if (esc or console) and (gui.IsGameUIVisible()) then
		self:Remove()
	end
end

function PANEL:Remove()
	self.closing = true
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)

	CloseDermaMenus()
	gui.EnableScreenClicker(false)
    local isAnimating = true
    self:MoveTo(ScrW() + ScrW(), ScrH() - ScrH(), 2, .1, .1, function()
        isAnimating = false
		timer.Simple(.1, function() self:SetVisible(false) end)
    end)
	self:SetSize(ScrW(), ScrH())
	self:AlphaTo(35, .15, 0)
	LocalPlayer():StopSound('cellar.tab.amb2')
	
end

vgui.Register("cellar.tab.help", PANEL, "EditablePanel")

if IsValid(cellar_tab_help) then
	cellar_tab_help:Remove()
	cellar_tab_help = nil
end

