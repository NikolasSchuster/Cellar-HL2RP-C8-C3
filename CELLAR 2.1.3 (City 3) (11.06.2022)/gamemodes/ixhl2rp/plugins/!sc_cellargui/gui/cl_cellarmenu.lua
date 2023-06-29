PANEL = {}
local console = Material("cellar/main/console")
local clrConsole = Color(102, 150, 190, 64)
local testBG = Material("cellar/main/bg/00.png")
local testBG2 = Material("cellar/main/bg/01.png")
local shadow = Material("cellar/main/shadow.png")
local warning = Material("cellar/main/warning.png")
local background = Material('cellar/main/tab/backgroundalpha.png')
local television = Material('cellar/main/tvtexture.png')
local staticborder = Material('cellar/main/tab/bigborder.png')
local infoicon = Material("cellar/main/info.png")


function PANEL:Init()
	if IsValid(cellar_tab) then

		cellar_tab:Remove()
		cellar_tab = nil
	end

	cellar_tab = self

	local parent = self:GetParent()
	self.closing = false
	self.noAnchor = CurTime() + 0.4
	self.anchorMode = true
	local frameH, frameW, animTime, animDelay, animEase = ScrW(), ScrH(), .8, 0, .1
	self:Center()
	local isAnimating = true
	self:SetSize(0, 0)
	self:SetAlpha(0)
	self:AlphaTo(255, 1.2, 0)
	self:SizeTo(frameH, frameW, animTime, animDelay, animEase, function()
		isAnimating = false
	end)
	self.Think = function(me)
		if isAnimating then
		me:Center()
		end
	end
	self:MakePopup()
	LocalPlayer():EmitSound('cellar.tab.amb')
	

	self.buttonpanel = self:Add("Panel")
	self.buttonpanel:Center()
	local isAnimating = true
	self.buttonpanel:SetSize(ScrW(), ScrH())
	self.buttonpanel:SetAlpha(0)
	self.buttonpanel:AlphaTo(255, 2.3, 0)
	self.buttonpanel.Think = function(me)
		if isAnimating then
			me:Center()
		end
	end
	self.buttonpanel.Paint = function(me)
		if LocalPlayer():IsSuperAdmin() then
			draw.SimpleText("МЕНЮ", "cellar.tab", ScrW() - ScrW()/2, ScrH() - ScrH()/1.37 - 40 - 20, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("МЕНЮ", "cellar.tab.blur", ScrW() - ScrW()/2, ScrH() - ScrH()/1.37 - 40 - 20, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("МЕНЮ", "cellar.tab", ScrW() - ScrW()/2, ScrH() - ScrH()/1.6 - 40 - 20, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("МЕНЮ", "cellar.tab.blur", ScrW() - ScrW()/2, ScrH() - ScrH()/1.6 - 40 - 20, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local info = self.buttonpanel:Add("DButton")
	if LocalPlayer():IsSuperAdmin() then
		info:SetPos(ScrW() - ScrW()/2 - 16, ScrH() - ScrH()/1.37 - 120)
	else
		info:SetPos(ScrW() - ScrW()/2 - 16, ScrH() - ScrH()/1.36)
	end
	info:SetText("")
	info:SetSize(32, 32)
	info.OnCursorEntered = function(me)
		if me:IsHovered() then
			LocalPlayer():EmitSound("Helix.Rollover")
		end
	end
	info.DoClick = function(me)
		LocalPlayer():EmitSound('Helix.Press')
		--vgui.Create("cellar.tab.info")
		local info1 = cellar_tab:Add('cellar.tab.info')
		--info1:MakePopup()
		if not IsValid(self) then
			info1:Remove()
		end
		
	end
	info.Paint = function(self, w, h)
		local bHovered = self:IsHovered() and Color(255, 30, 30, 35)
		draw.RoundedBox(255, 0, 0, w, h, bHovered or Color(56, 207, 248, 35))
		surface.SetDrawColor(ColorAlpha(color_black, 255))
		surface.SetMaterial(infoicon)
		surface.DrawTexturedRect(0, 0, w, h)
	end


	if LocalPlayer():IsSuperAdmin() then

		local config = self.buttonpanel:Add("cellar.btnlist")
		config:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH()/1.4 - 40)
		config:SetText("КОНФИГУРАЦИЯ")
		config:SetSize(0, 40)
		config:SizeTo(300, 40, .3, (.1 * 1))
		config.Think = function(me)
			if self.closing then
				me:SizeTo(0, 40, .2, .9)
			end
		end
		config.DoClick = function(me)
			vgui.Create('cellar.tab.config')
			self:Remove()
		end

		local plugins = self.buttonpanel:Add("cellar.btnlist")
		plugins:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH()/1.4 - 40 + 43 * (1))
		plugins:SetText("ПЛАГИНЫ")
		plugins:SetSize(0, 40)
		plugins:SizeTo(300, 40, .3, (.1 * 2))
		plugins.Think = function(me)
			if self.closing then
				me:SizeTo(0, 40, .2, .8)
			end
		end
		plugins.DoClick = function(me)
			vgui.Create('cellar.tab.plugins')
			self:Remove()
		end
	end
	
	local help = self.buttonpanel:Add("cellar.btnlist")
	help:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH()/1.65 - 40)
	help:SetText("ПОМОЩЬ")
	help:SetSize(0, 40)
	help:SizeTo(300, 40, .3, (.1 * 3))
	help.Think = function(me)
		if self.closing then
			me:SizeTo(0, 40, .2, .7)
		end
	end
	help.DoClick = function(me)
		vgui.Create('cellar.tab.help')
		self:Remove()
	end

	local inventory = self.buttonpanel:Add("cellar.btnlist")
	inventory:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH()/1.65 - 40 + 43 * (1))
	inventory:SetText("ИНВЕНТАРЬ")
	inventory:SetSize(0, 40)
	inventory:SizeTo(300, 40, .3, (.1 * 4))
	inventory.Think = function(me)
		if self.closing then
			me:SizeTo(0, 40, .2, .6)
		end
	end
	inventory.DoClick = function(me)
		vgui.Create('cellar.tab.inv')
		self:Remove()
	end

	local players = self.buttonpanel:Add("cellar.btnlist")
	players:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH()/1.65 - 40 + 43 * (2))
	players:SetText("ИГРОКИ")
	players:SetSize(0, 40)
	players:SizeTo(300, 40, .3, (.1 * 5))
	players.Think = function(me)
		if self.closing then
			me:SizeTo(0, 40, .2, .5)
		end
	end
	players.DoClick = function(me)
		vgui.Create('cellar.tab.scoreboard')
		self:Remove()
	end

	local you = self.buttonpanel:Add("cellar.btnlist")
	you:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH()/1.65 - 40 + 43 * (3))
	you:SetText("ПЕРСОНАЖ")
	you:SetSize(0, 40)
	you:SizeTo(300, 40, .3, (.1 * 6))
	you.Think = function(me)
		if self.closing then
			me:SizeTo(0, 40, .2, .4)
		end
	end
	you.DoClick = function(me)
		vgui.Create('cellar.tab.information')
		self:Remove()
	end

	local craft = self.buttonpanel:Add("cellar.btnlist")
	craft:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH()/1.65 - 40 + 43* (4))
	craft:SetText("КРАФТИНГ")
	craft:SetSize(0, 40)
	craft:SizeTo(300, 40, .3, (.1 * 7))
	craft.Think = function(me)
		if self.closing then
			me:SizeTo(0, 40, .2, .3)
		end
	end
	craft.DoClick = function(me)
		vgui.Create('cellar.tab.crafting')
		self:Remove()
	end

	local settings = self.buttonpanel:Add("cellar.btnlist")
	settings:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH()/1.65 - 40 + 43 * (5))
	settings:SetText("НАСТРОЙКИ")
	settings:SetSize(0, 40)
	settings:SizeTo(300, 40, .3, (.1 * 8))
	settings.Think = function(me)
		if self.closing then
			me:SizeTo(0, 40, .2, .2)
		end
	end
	settings.DoClick = function()
		vgui.Create('cellar.tab.settings')
		self:Remove()
	end

	local main = self.buttonpanel:Add("cellar.btnlist")
	main:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH()/1.65 + 43 * (6))
	main:SetText('ГЛАВНОЕ МЕНЮ')
	main:SetSize(0, 40)
	main:SizeTo(300, 40, .3, (.1 * 9))
	main.Think = function(me)
		if self.closing then
			me:SizeTo(0, 40, .2, .1)
		end
	end
	main.DoClick = function()
		self:Remove()
		vgui.Create("ixCharMenu")
	end

	local close = self.buttonpanel:Add("cellar.btnlist")
	close:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH()/1.65 + 43 * (7))
	close:SetText('ЗАКРЫТЬ')
	close:SetSize(0, 40)
	close:SizeTo(300, 40, .3, (.1 * 10))
	close.Think = function(me)
		if self.closing then
			me:SizeTo(0, 40, .2, 0)
		end
		if isAnimating then
			self:Center()
		end
	end
	close.DoClick = function()
		self:Remove()
	end
	----------------------------------
end

function PANEL:Paint(w, h)
	local vignette = ix.util.GetMaterial("helix/gui/vignette.png")
	-- Glowing
	if !self.paint_manual then
		
	end

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

end

function PANEL:OnKeyCodePressed(key)
	self.noAnchor = CurTime() + 0.5

	if (key == KEY_TAB) then
		self:Remove()
	end
end

function PANEL:Think()
	local bTabDown = input.IsKeyDown(KEY_TAB)

	if (bTabDown and (self.noAnchor or CurTime() + 0.4) < CurTime() and self.anchorMode) then
		self.closing = true
		self.anchorMode = false
		self:Remove()
	end

	if (gui.IsGameUIVisible()) then
		self:Remove()
	end
end

function PANEL:Remove()
	self.closing = true
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)

	CloseDermaMenus()
	gui.EnableScreenClicker(false)

	local frameH, frameW, animTime, animDelay, animEase = 0, 0, .8, .5, -1
	self:SetSize(ScrW(), ScrH())
	local isAnimating = true
	self:SizeTo(frameH, frameW, animTime, animDelay, animEase, function()
		isAnimating = false
	end)
	self:AlphaTo(0, .6, 0)
	self.buttonpanel:AlphaTo(0, 1.1, 0)
	timer.Simple(.55, function() self:SetVisible(false) end)
	LocalPlayer():StopSound('cellar.tab.amb')
	LocalPlayer():StopSound('cellar.info.amb')
	surface.PlaySound('cellar/ui/droneoutro25.mp3')
end

vgui.Register("cellar.tab", PANEL, "EditablePanel")

if IsValid(cellar_tab) then
	cellar_tab:Remove()
end

