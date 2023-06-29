--[[ ВНИМАНИЕ, ПАНЕЛЬ ОСНОВАНА НА helix/core/derma/cl_inventoy.lua, ixhl2rp/plugins/!!inventoryenhances/derma/cl_equipmentframe.lua И НЕ БУДЕТ РАБОТАТЬ КОРРЕКТНО БЕЗ ВЫШЕУКАЗАННЫХ ФАЙЛОВ]]--

PANEL = {}
local background = Material('cellar/main/tab/backgroundtab.png')
local television = Material('cellar/main/tvtexture.png')
local staticborder = Material('cellar/main/tab/tabborders.png')
local infoicon = Material("cellar/main/info.png")

function PANEL:Init()
	if IsValid(cellar_tab_inv) then
		cellar_tab_inv:Remove()
	end

	cellar_tab_inv = self

	local parent = self:GetParent()
	self.closing = false
	self.noAnchor = CurTime() + 0.4
	self.anchorMode = true
	self.opened = true
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
	self.bNextUse = nil
	LocalPlayer():EmitSound("cellar.tab.amb2")
	LocalPlayer():EmitSound('Helix.Whoosh')

    self.canvas = self:Add("Panel")
    self.canvas:SetPos(ScrW() - ScrW() * .85, ScrH() - ScrH() * .85)
    self.canvas:SetSize(1000, 0)
    self.canvas:SizeTo(ScrW() * .8333, ScrH() * .6944, .5, .1, .1)


    local characterPanel = self.canvas:Add("DPanel")
	characterPanel.Paint = function() end
	characterPanel:SetSize(400, self.canvas:GetTall())
	characterPanel:Dock(LEFT)
	/*characterPanel.Paint = function(self, w, h)
		local tsin2 = TimedSin(.5, 0, 220, 100)
		surface.SetDrawColor(56, 207, 248, 255)
		surface.DrawRect(self:GetWide() * .38 + tsin2, 550, 50, 20)
	end*/

	ix.gui.containerCharPanel = characterPanel

	local inventoryPanel = self.canvas:Add("DPanel")
	inventoryPanel.Paint = function() end
	inventoryPanel:SetSize(self.canvas:GetWide(), self.canvas:GetTall())
	inventoryPanel:Dock(FILL)

	local equipPanel = characterPanel:Add("ixEquipment")
	equipPanel:SetCharacter(LocalPlayer():GetCharacter())

	local canvas = inventoryPanel:Add("DTileLayout")
	
	local canvasLayout = canvas.PerformLayout
	canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
	canvas:SetBorder(0)
	canvas:SetSpaceX(2)
	canvas:SetSpaceY(2)
	canvas:Dock(FILL)

	ix.gui.menuInventoryContainer = canvas

	local panel = canvas:Add("ixInventory")
	panel:SetPos(0, 0)
	panel:SetDraggable(true)
	panel:SetSizable(false)
	panel:SetTitle(nil)
	panel.Paint = function(self, w, h)
		local frame = Material('cellar/main/tab/invborder.png')
		surface.SetDrawColor(color_white)
		surface.SetMaterial(frame)
		surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
	end
	panel.bNoBackgroundBlur = true
	--panel.childPanels = {}

	local inventory = LocalPlayer():GetCharacter():GetInventory()

	if (inventory) then
		panel:SetInventory(inventory)
	end

	ix.gui.inv1 = panel

	if (ix.option.Get("openBags", true)) then
		for _, v in pairs(inventory:GetItems()) do
			if (!v.isBag) then
				continue
			end

			v.functions.View.OnClick(v)
		end
	end

	canvas.PerformLayout = canvasLayout
	canvas:Layout()

--[[
	local panel2 = canvas:Add("ixEquipment")
	panel2:SetPos(0, 0)
	panel2:SetDraggable(false)
	panel2:SetSizable(false)
	panel2:SetTitle(nil)
	panel2.bNoBackgroundBlur = true

	local inventory2 = LocalPlayer():GetCharacter():GetEquipment()

	if (inventory2) then
		panel2:SetInventory(inventory2)
	end
]]
	ix.gui["inv"..LocalPlayer():GetCharacter():GetEquipID()] = equipPanel


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

	surface.SetDrawColor(ColorAlpha(color_white, 255))

end

function PANEL:OnKeyCodePressed(key)
	self.noAnchor = CurTime() + 0.5

	if (key == KEY_I) then 
		LocalPlayer():StopSound('cellar.info.amb')
		LocalPlayer():EmitSound('Helix.Whoosh')
		self:Remove()
    elseif (key == KEY_TAB) then 
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
	self.opened = false
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	self.bNextUse = CurTime() + 0.3

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

	ix.gui.menuInventoryContainer = nil
	ix.gui.inv1 = nil
	canvasLayout = nil
end

vgui.Register("cellar.tab.inv", PANEL, "EditablePanel")

hook.Add("PostRenderVGUI", "ixInvHelper", function()
	local pnl = ix.gui.inv1

	hook.Run("PostDrawInventory", pnl)
end)



-- Fixing trouble with inventory opening while typing in chat
local chatopened
function PLUGIN:StartChat(TeamChat)
	if TeamChat then
		chatopened = true
	else
		chatopened = true
	end
end

function PLUGIN:FinishChat()
	chatopened = false
end

-- Inventory button bind
function PLUGIN:Think()
	if (IsValid(vgui.GetHoveredPanel()) or gui.IsGameUIVisible()) then
		return
	end

	local invdown = input.IsKeyDown(KEY_I)
	if IsValid(cellar_tab_inv) then
		if cellar_tab_inv.opened then
			return
		end

		if cellar_tab_inv.bNextUse <= CurTime() then
			if invdown then
				if not LocalPlayer():GetCharacter() then
					return 
				end
				vgui.Create('cellar.tab.inv')
				cellar_tab_inv.bNextUse = CurTime() + 0.3
			end
		end
	elseif not IsValid(cellar_tab_inv) and invdown then
		if not LocalPlayer():GetCharacter() then
			return 
		end
		vgui.Create('cellar.tab.inv')
	end

end

if IsValid(cellar_tab_inv) then
	cellar_tab_inv:Remove()
	cellar_tab_inv = nil
end

