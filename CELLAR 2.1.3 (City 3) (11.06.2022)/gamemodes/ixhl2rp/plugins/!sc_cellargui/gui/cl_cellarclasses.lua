PANEL = {}
local background = Material('cellar/main/tab/backgroundtabmirrored.png')
local television = Material('cellar/main/tvtexture.png')
local staticborder = Material('cellar/main/tab/tabbordersmirrored.png')

function PANEL:Init()
	if IsValid(ix.gui.classes) then
		ix.gui.classes:Remove()
	end

	ix.gui.classes = self

	self:SetSize(self:GetParent():GetSize())

	self.list = vgui.Create("DPanelList", self)
	self.list:SetPos(ScrW() - ScrW() * .916, ScrH() - ScrH() * .90)
	self.list:SetSize(1000, 0)
	self.list:SizeTo(ScrW() * .8333, ScrH() * .7778, .5, .1, .1)
	self.list:EnableVerticalScrollbar()
	self.list:SetSpacing(5)
	self.list:SetPadding(5)

	self.classPanels = {}
	self:LoadClasses()

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
	LocalPlayer():EmitSound('Helix.Whoosh')
	LocalPlayer():EmitSound('cellar.tab.amb2')

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

function PANEL:LoadClasses()
	self.list:Clear()

	for k, v in ipairs(ix.class.list) do
		local no, why = ix.class.CanSwitchTo(LocalPlayer(), k)
		local itsFull = ("class is full" == why)

		if (no or itsFull) then
			local panel = vgui.Create("ixClassPanel", self.list)
			panel:SetClass(v)
			table.insert(self.classPanels, panel)

			self.list:AddItem(panel)
		end
	end
end


function PANEL:Paint(w, h)
	local vignette = ix.util.GetMaterial("helix/gui/vignette.png")
    local helpframe = Material('cellar/main/tab/helpframe1604x754.png')

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

    local animslide1 = TimedSin(.32, ScrH() * .8391/1.666, ScrH() * .8391*1.49, 0)
    local animsize1 = TimedCos(.32, 15, 25, 0)

    surface.SetDrawColor(Color(56, 207, 248, 25))
	surface.DrawLine(self.list:GetX() - 7, animslide1 + 5, self.list:GetWide() * 1.10233 + 7, animslide1 + 5)
	surface.DrawLine(self.list:GetX() - 7, animslide1 + 6, self.list:GetWide() * 1.10233 + 7, animslide1 + 6)

    surface.SetDrawColor(Color(56, 207, 248, 255))
	surface.DrawRect(self.list:GetX() - 8, animslide1, 1, animsize1)
	surface.DrawRect(self.list:GetWide() * 1.10233 + 8, animslide1, 1, animsize1)

    local scoreboarder = Material('cellar/main/tab/scoreboarder1642x880.png')
    surface.SetDrawColor(color_white)
    surface.SetMaterial(scoreboarder)
    surface.DrawTexturedRect(ScrW() - ScrW() * .9276, ScrH() - ScrH() * .915, ScrW() * .8547, ScrH() * .8148)
    

end

function PANEL:OnKeyCodePressed(key)
	self.noAnchor = CurTime() + 0.5

    if (key == KEY_TAB) then 
		LocalPlayer():StopSound('cellar.info.amb')
		LocalPlayer():EmitSound('Helix.Whoosh')
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

vgui.Register("cellar.tab.classes", PANEL, "EditablePanel")

net.Receive("ixClassUpdate", function()
	local client = net.ReadEntity()

	if (ix.gui.classes and ix.gui.classes:IsVisible()) then
		if (client == LocalPlayer()) then
			ix.gui.classes:LoadClasses()
		else
			for _, v in ipairs(ix.gui.classes.classPanels) do
				local data = v.data

				v:SetNumber(#ix.class.GetPlayers(data.index))
			end
		end
	end
end)

if IsValid(ix.gui.classes) then
	ix.gui.classes:Remove()
	ix.gui.classes = nil
end