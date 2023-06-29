local ICON_SIZE = 16
local BAR_HEIGHT = 100

-- bar manager
-- this manages positions for bar panels
local PANEL = {}

AccessorFunc(PANEL, "padding", "Padding", FORCE_NUMBER)

function PANEL:Init()
	self:SetSize(ScrW() * 0.35, ScrH())
	self:SetPos(ICON_SIZE * 1.5, ICON_SIZE * 1.5)
	self:ParentToHUD()

	self.bars = {}
	self.padding = 16

	-- add bars that were registered before manager creation
	for _, v in ipairs(ix.bar.list) do
		v.panel = self:AddBar(v.index, v.icon, v.priority)
	end
end

function PANEL:GetAll()
	return self.bars
end

function PANEL:Clear()
	for k, v in ipairs(self.bars) do
		v:Remove()

		table.remove(self.bars, k)
	end
end

function PANEL:AddBar(index, icon, priority)
	local panel = self:Add("ixInfoBar")
	panel:SetSize(ICON_SIZE, BAR_HEIGHT * 2)
	panel:SetVisible(false)
	panel:SetID(index)
	panel:SetIcon(isstring(icon) and icon or false)
	panel:SetPriority(priority)

	self.bars[#self.bars + 1] = panel
	self:Sort()

	return panel
end

function PANEL:RemoveBar(panel)
	local toRemove

	for k, v in ipairs(self.bars) do
		if (v == panel) then
			toRemove = k
			break
		end
	end

	if (toRemove) then
		table.remove(self.bars, toRemove)
	end

	panel:Remove()
	self:Sort()
end

-- sort bars by priority
function PANEL:Sort()
	table.sort(self.bars, function(a, b)
		return a:GetPriority() < b:GetPriority()
	end)
end

-- update target Y positions
function PANEL:Organize()
	local currentX = 0

	for _, v in ipairs(self.bars) do
		if (!v:IsVisible()) then
			continue
		end

		v:SetPos(currentX, 0)

		currentX = currentX + self.padding + v:GetWide()
	end

	self:SetSize(currentX, self:GetTall())
end

function PANEL:Think()
	local menu = (IsValid(ix.gui.characterMenu) and !ix.gui.characterMenu:IsClosing()) and ix.gui.characterMenu
		or IsValid(ix.gui.menu) and ix.gui.menu
	local fraction = menu and 1 - menu.currentAlpha / 255 or 1

	self:SetAlpha(255 * fraction)

	-- don't update bars when not visible
	if (fraction == 0) then
		return
	end

	local curTime = CurTime()
	local bShouldHide = hook.Run("ShouldHideBars")
	local bAlwaysShow = ix.option.Get("alwaysShowBars", false)

	for _, v in ipairs(self.bars) do
		local info = ix.bar.list[v:GetID()]
		local realValue = info.GetValue()

		realValue = realValue or 0
		if (bShouldHide or realValue == false) then
			v:SetVisible(false)
			continue
		end

		if (v:GetDelta() != realValue) then
			v:SetLifetime(curTime + 5)
		end

		if (realValue <= 0 and !info.visible and !bAlwaysShow and !hook.Run("ShouldBarDraw", info)) then
			v:SetVisible(false)
			continue
		end

		v:SetVisible(true)
		v:SetValue(realValue)
		v:SetIcon(isstring(info.icon) and info.icon or false)
	end

	self:Organize()
end

function PANEL:OnRemove()
	self:Clear()
end

vgui.Register("ixInfoBarManager", PANEL, "Panel")

PANEL = {}

AccessorFunc(PANEL, "index", "ID", FORCE_NUMBER)
AccessorFunc(PANEL, "color", "Color")
AccessorFunc(PANEL, "priority", "Priority", FORCE_NUMBER)
AccessorFunc(PANEL, "value", "Value", FORCE_NUMBER)
AccessorFunc(PANEL, "delta", "Delta", FORCE_NUMBER)
AccessorFunc(PANEL, "lifetime", "Lifetime", FORCE_NUMBER)

local barBackground = Color(100, 100, 100, 150)
function PANEL:Init()
	self.value = 0
	self.delta = 0
	self.lifetime = 0

	self.icon = self:Add("DImage")
	self.icon:SetImage("willardnetworks/hud/cross.png")
	self.icon:Dock(TOP)
	self.icon:SetSize(16, 16)
	self.icon:DockPadding(0, 4, 0, 0)
	
	self.bar = self:Add("DPanel")
	self.bar:Dock(TOP)
	self.bar:DockMargin(6, 10, 6, 0)
	self.bar:SetTall(BAR_HEIGHT)
	self.bar.Paint = function(this, width, height)
		surface.SetDrawColor(barBackground)
		surface.DrawRect(0, 0, width, height)

		local delta = math.min(self.delta, 1)

		height = height * delta + 1

		surface.SetDrawColor(color_white)
		surface.DrawRect(0, BAR_HEIGHT - (height - 1), width, height)
	end
end

function PANEL:SetIcon(icon)
	if icon then
		self.icon:SetImage(icon)
		self.icon:SetVisible(true)
	else
		self.icon:SetVisible(false)
	end
end

function PANEL:Think()
	local value = math.Approach(self.delta, self.value, FrameTime())
	-- fix for smooth bar changes (increase of 0.01 every 0.1sec for example)
	if (value == self.value and self.delta != self.value and self.value != 0 and self.value != 1) then
		value = self.delta
	end

	self.delta = value
end

function PANEL:Paint(width, height)

end

vgui.Register("ixInfoBar", PANEL, "Panel")

if (IsValid(ix.gui.bars)) then
	ix.gui.bars:Remove()
	ix.gui.bars = vgui.Create("ixInfoBarManager")
end
