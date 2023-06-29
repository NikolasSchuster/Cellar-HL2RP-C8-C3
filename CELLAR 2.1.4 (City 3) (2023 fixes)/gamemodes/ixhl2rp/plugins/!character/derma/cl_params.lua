local function EmitChange(pitch)
	LocalPlayer():EmitSound("weapons/ar2/ar2_empty.wav", 75, pitch or 150, 0.25)
end

-- alternative num slider
local PANEL = {}

AccessorFunc(PANEL, "labelPadding", "LabelPadding", FORCE_NUMBER)

function PANEL:Init()
	self.labelPadding = 8

	surface.SetFont("ixAttributesFont")
	local totalWidth = surface.GetTextSize("999") -- start off with 3 digit width

	self.label = self:Add("DLabel")
	self.label:Dock(RIGHT)
	self.label:SetWide(totalWidth + self.labelPadding)
	self.label:SetContentAlignment(5)
	self.label:SetFont("ixAttributesFont")
	self.label.Paint = function(panel, width, height)
		surface.SetDrawColor(derma.GetColor("DarkerBackground", self))
		surface.DrawRect(0, 0, width, height)
	end
	self.label.SizeToContents = function(panel)
		surface.SetFont(panel:GetFont())
		local textWidth = surface.GetTextSize(panel:GetText())

		if (textWidth > totalWidth) then
			panel:SetWide(textWidth + self.labelPadding)
		elseif (panel:GetWide() > totalWidth + self.labelPadding) then
			panel:SetWide(totalWidth + self.labelPadding)
		end
	end

	self.slider = self:Add("ixSlider")
	self.slider:Dock(FILL)
	self.slider:DockMargin(0, 0, 4, 0)
	self.slider.OnValueChanged = function(panel)
		self:OnValueChanged()
	end
	self.slider.OnValueUpdated = function(panel)
		self.label:SetText(tostring(panel:GetValue()))
		self.label:SizeToContents()

		self:OnValueUpdated()
	end
end

function PANEL:GetLabel()
	return self.label
end

function PANEL:GetSlider()
	return self.slider
end

function PANEL:SetValue(value, bNoNotify)
	value = tonumber(value) or self.slider:GetMin()

	self.slider:SetValue(value, bNoNotify)
	self.label:SetText(tostring(self.slider:GetValue()))
	self.label:SizeToContents()
end

function PANEL:GetValue()
	return self.slider:GetValue()
end

function PANEL:GetFraction()
	return self.slider:GetFraction()
end

function PANEL:GetVisualFraction()
	return self.slider:GetVisualFraction()
end

function PANEL:SetMin(value)
	self.slider:SetMin(value)
end

function PANEL:SetMax(value)
	self.slider:SetMax(value)
end

function PANEL:GetMin()
	return self.slider:GetMin()
end

function PANEL:GetMax()
	return self.slider:GetMax()
end

function PANEL:SetDecimals(value)
	self.slider:SetDecimals(value)
end

function PANEL:GetDecimals()
	return self.slider:GetDecimals()
end

-- called when changed by user
function PANEL:OnValueChanged()
end

-- called when changed while dragging bar
function PANEL:OnValueUpdated()
end

vgui.Register("ixParamNumSlider", PANEL, "Panel")

-- number setting
PANEL = {}

function PANEL:Init()
	self.setting = self:Add("ixParamNumSlider")
	self.setting.nextUpdate = 0
	self.setting:Dock(RIGHT)
	self.setting.OnValueChanged = function(panel)
		self:OnValueChanged(self:GetValue())
	end
	self.setting.OnValueUpdated = function(panel)
		local fraction = panel:GetFraction()

		if (fraction == 0) then
			EmitChange(75)
			return
		elseif (fraction == 1) then
			EmitChange(120)
			return
		end

		if (SysTime() > panel.nextUpdate) then
			EmitChange(85 + fraction * 15)
			panel.nextUpdate = SysTime() + 0.05
		end
	end

	local panel = self.setting:GetLabel()
	panel:SetCursor("hand")
	panel:SetMouseInputEnabled(true)
	panel.OnMousePressed = function(_, key)
		if (key == MOUSE_LEFT) then
			self:OpenEntry()
		end
	end
end

function PANEL:OpenEntry()
	if (IsValid(self.entry)) then
		self.entry:Remove()
		return
	end

	self.entry = vgui.Create("ixParamRowNumberEntry")
	self.entry:Attach(self)
	self.entry:SetValue(self:GetValue(), true)
	self.entry.OnValueChanged = function(panel)
		local value = math.Round(panel:GetValue(), self:GetDecimals())

		if (value != self:GetValue()) then
			self:SetValue(value, true)
			self:OnValueChanged(value)
		end
	end
end

function PANEL:SetValue(value, bNoNotify)
	self.setting:SetValue(value, bNoNotify)
end

function PANEL:GetValue()
	return self.setting:GetValue()
end

function PANEL:SetMin(value)
	self.setting:SetMin(value)
end

function PANEL:SetMax(value)
	self.setting:SetMax(value)
end

function PANEL:SetDecimals(value)
	self.setting:SetDecimals(value)
end

function PANEL:GetDecimals()
	return self.setting:GetDecimals()
end

function PANEL:PerformLayout(width, height)
	self.setting:SetWide(width * 0.5)
end

vgui.Register("ixParamRowNumber", PANEL, "ixParamRow")

DEFINE_BASECLASS("Panel")
PANEL = {}

AccessorFunc(PANEL, "bDeleteSelf", "DeleteSelf", FORCE_BOOL)

function PANEL:Init()
	surface.SetFont("ixAttributesFont")
	local width, height = surface.GetTextSize("999999")

	self.m_bIsMenuComponent = true
	self.bDeleteSelf = true

	self.realHeight = 200
	self.height = 200
	self:SetSize(width, height)
	self:DockPadding(4, 4, 4, 4)

	self.textEntry = self:Add("ixTextEntry")
	self.textEntry:SetNumeric(true)
	self.textEntry:SetFont("ixAttributesFont")
	self.textEntry:Dock(FILL)
	self.textEntry:RequestFocus()
	self.textEntry.OnEnter = function()
		self:Remove()
	end

	self:MakePopup()
	RegisterDermaMenuForClose(self)
end

function PANEL:SetValue(value, bInitial)
	value = tostring(value)
	self.textEntry:SetValue(value)

	if (bInitial) then
		self.textEntry:SetCaretPos(value:utf8len())
	end
end

function PANEL:GetValue()
	return tonumber(self.textEntry:GetValue()) or 0
end

function PANEL:Attach(panel)
	self.attached = panel
end

function PANEL:Think()
	local panel = self.attached

	if (IsValid(panel)) then
		local width, height = self:GetSize()
		local x, y = panel:LocalToScreen(0, 0)

		self:SetPos(
			math.Clamp(x + panel:GetWide() - width, 0, ScrW() - width),
			math.Clamp(y + panel:GetTall(), 0, ScrH() - height)
		)
	end
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(derma.GetColor("DarkerBackground", self))
	surface.DrawRect(0, 0, width, height)
end

function PANEL:OnValueChanged()
end

function PANEL:OnValueUpdated()
end

function PANEL:Remove()
	if (self.bClosing) then
		return
	end

	self:OnValueChanged()

	-- @todo open/close animations
	self.bClosing = true
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	BaseClass.Remove(self)
end

vgui.Register("ixParamRowNumberEntry", PANEL, "EditablePanel")

-- alternative checkbox
PANEL = {}

AccessorFunc(PANEL, "bChecked", "Checked", FORCE_BOOL)
AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "labelPadding", "LabelPadding", FORCE_NUMBER)

PANEL.GetValue = PANEL.GetChecked

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")

	self.enabledText = L("yes"):utf8upper()
	self.disabledText = L("no"):utf8upper()
	self.font = "ixAttributesFont"
	self.labelPadding = 8
	self.animationOffset = 0
	self.animationTime = 0.5
	self.bChecked = false

	self:SizeToContents()
end

function PANEL:SizeToContents()
	BaseClass.SizeToContents(self)

	surface.SetFont(self.font)
	self:SetWide(math.max(surface.GetTextSize(self.enabledText), surface.GetTextSize(self.disabledText)) + self.labelPadding)
end

-- can be overidden to change audio params
function PANEL:GetAudioFeedback()
	return "weapons/ar2/ar2_empty.wav", 75, self.bChecked and 150 or 125, 0.25
end

function PANEL:EmitFeedback()
	LocalPlayer():EmitSound(self:GetAudioFeedback())
end

function PANEL:SetChecked(bChecked, bInstant)
	self.bChecked = tobool(bChecked)

	self:CreateAnimation(bInstant and 0 or self.animationTime, {
		index = 1,
		target = {
			animationOffset = bChecked and 1 or 0
		},
		easing = "outElastic"
	})

	if (!bInstant) then
		self:EmitFeedback()
	end
end

function PANEL:OnMousePressed(code)
	if (code == MOUSE_LEFT) then
		self:SetChecked(!self.bChecked)
		self:DoClick()
	end
end

function PANEL:DoClick()
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(derma.GetColor("DarkerBackground", self))
	surface.DrawRect(0, 0, width, height)

	local offset = self.animationOffset
	surface.SetFont("ixAttributesFont")

	local text = L("no"):upper()
	local textWidth, textHeight = surface.GetTextSize(text)
	local y = offset * -textHeight

	surface.SetTextColor(250, 60, 60, 255)
	surface.SetTextPos(width * 0.5 - textWidth * 0.5, y + height * 0.5 - textHeight * 0.5)
	surface.DrawText(text)

	text = L("yes"):upper()
	y = y + textHeight
	textWidth, textHeight = surface.GetTextSize(text)

	surface.SetTextColor(30, 250, 30, 255)
	surface.SetTextPos(width * 0.5 - textWidth * 0.5, y + height * 0.5 - textHeight * 0.5)
	surface.DrawText(text)
end

vgui.Register("ixParamCheckBox", PANEL, "EditablePanel")

-- bool setting
PANEL = {}

function PANEL:Init()
	self.setting = self:Add("ixParamCheckBox")
	self.setting:Dock(RIGHT)
	self.setting.DoClick = function(panel)
		self:OnValueChanged(self:GetValue())
	end
end

function PANEL:SetValue(bValue)
	bValue = tobool(bValue)

	self.setting:SetChecked(bValue, true)
end

function PANEL:GetValue()
	return self.setting:GetChecked()
end

vgui.Register("ixParamRowBool", PANEL, "ixParamRow")

-- settings row
PANEL = {}

AccessorFunc(PANEL, "backgroundIndex", "BackgroundIndex", FORCE_NUMBER)
AccessorFunc(PANEL, "bShowReset", "ShowReset", FORCE_BOOL)

function PANEL:Init()
	self:DockPadding(4, 4, 4, 4)

	self.text = self:Add("DLabel")
	self.text:Dock(LEFT)
	self.text:SetFont("ixAttributesFont")
	self.text:SetExpensiveShadow(1, color_black)

	self.backgroundIndex = 0
end

function PANEL:SetShowReset(value, name, default)
	value = tobool(value)

	if (value and !IsValid(self.reset)) then
		self.reset = self:Add("DButton")
		self.reset:SetFont("ixSmallTitleIcons")
		self.reset:SetText("x")
		self.reset:SetTextColor(ColorAlpha(derma.GetColor("Warning", self), 100))
		self.reset:Dock(LEFT)
		self.reset:DockMargin(4, 0, 0, 0)
		self.reset:SizeToContents()
		self.reset.Paint = nil
		self.reset.DoClick = function()
			self:OnResetClicked()
		end
		self.reset:SetHelixTooltip(function(tooltip)
			local title = tooltip:AddRow("title")
			title:SetImportant()
			title:SetText(L("resetDefault"))
			title:SetBackgroundColor(derma.GetColor("Warning", self))
			title:SizeToContents()

			local description = tooltip:AddRow("description")
			description:SetText(L("resetDefaultDescription", tostring(name), tostring(default)))
			description:SizeToContents()
		end)
	elseif (!value and IsValid(self.reset)) then
		self.reset:Remove()
	end

	self.bShowReset = value
end

function PANEL:Think()
	if (IsValid(self.reset)) then
		self.reset:SetVisible(self:IsHovered() or self:IsOurChild(vgui.GetHoveredPanel()))
	end
end

function PANEL:OnResetClicked()
end

function PANEL:GetLabel()
	return self.text
end

function PANEL:SetText(text)
	self.text:SetText(text)
	self:SizeToContents()
end

function PANEL:GetText()
	return self.text:GetText()
end

-- implemented by row types
function PANEL:GetValue()
end

function PANEL:SetValue(value)
end

-- meant for array types to populate combo box values
function PANEL:Populate(key, info)
end

-- called when value is changed by user
function PANEL:OnValueChanged(newValue)
end

function PANEL:SizeToContents()
	local _, top, _, bottom = self:GetDockPadding()

	self.text:SizeToContents()
	self:SetTall(self.text:GetTall() + top + bottom)
	self.ixRealHeight = self:GetTall()
	self.ixHeight = self.ixRealHeight
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintSettingsRowBackground", self, width, height)
end

vgui.Register("ixParamRow", PANEL, "EditablePanel")