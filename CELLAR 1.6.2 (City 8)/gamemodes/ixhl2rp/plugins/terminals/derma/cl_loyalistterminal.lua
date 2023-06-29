
local PLUGIN = PLUGIN

-- terminal button
local PANEL = {}

AccessorFunc(PANEL, "m_sText", "Text", FORCE_STRING)
AccessorFunc(PANEL, "m_BgHighlightColor", "BGHighlightColor")
AccessorFunc(PANEL, "m_TextHighlightColor", "TextHighlightColor")
AccessorFunc(PANEL, "m_BgColor", "BackgroundColor")
AccessorFunc(PANEL, "m_TextColor", "TextColor")
AccessorFunc(PANEL, "m_bHovered", "Hovered", FORCE_BOOL)
AccessorFunc(PANEL, "m_bPressed", "Pressed", FORCE_BOOL)
AccessorFunc(PANEL, "m_Font", "Font", FORCE_STRING)

surface.CreateFont("TerminalButtonText", {
	font = "Harmonia Sans Pro Cyr",
	size = 30,
	antialias = true,
	weight = 0
})

local pressColor = Color(210, 210, 210)

local function DrawOutlinedRect(x, y, w, h, thickness, clr)
	surface.SetDrawColor(clr)

	for i = 0, thickness - 1 do
		surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2)
	end
end

function PANEL:Init()

end

function PANEL:OnCursorEntered()
	if (self:GetHovered()) then return end

	self:SetHovered(true)
	surface.PlaySound("terminals/button_rollover.ogg")
end

function PANEL:OnCursorExited()
	if (!self:GetHovered()) then return end

	self:SetHovered(false)
end

function PANEL:OnMousePressed(key)
	if (key == MOUSE_LEFT) then
		self:SetPressed(true)

		if (self.DoClick) then
			self:DoClick()
		end
	end
end

function PANEL:OnMouseReleased(key)
	if (key == MOUSE_LEFT) then
		self:SetPressed(false)
	end
end

function PANEL:Paint(w, h)
	local bHovered = self:GetHovered()
	local text = self:GetText()
	local bgColor = self:GetPressed() and pressColor or (bHovered and self:GetBGHighlightColor() or self:GetBackgroundColor())
	local textColor = bHovered and self:GetTextHighlightColor() or self:GetTextColor()

	surface.SetDrawColor(bgColor)
	surface.DrawRect(0, 0, w, h)

	draw.SimpleText(text, self:GetFont() or "TerminalButtonText", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	render.PushFilterMag(TEXFILTER.POINT)
	render.PushFilterMin(TEXFILTER.POINT)
	DrawOutlinedRect(0, 0, w, h, 2, Color(100, 100, 100))
	render.PopFilterMin()
	render.PopFilterMag()
end

vgui.Register("ixLoyalistTerminalButton", PANEL)

-- terminal spinner
PANEL = {}

local function SawTooth(freq, offset, min, max)
	return max - (((CurTime() * freq) + offset) % 1) * (max - min)
end

local function DrawCenteredRect(x, y, width, height)
	surface.DrawRect(x - width * 0.5, y - height * 0.5, width, height)
end

function PANEL:Init()
	self.color = color_white
	self.freq = 1
end

function PANEL:SetColor(col)
	self.color = col
end

function PANEL:SetFrequency(freq)
	self.freq = tonumber(freq) or 1
end

function PANEL:SetLarge(bLarge)
	self.bLarge = tobool(bLarge)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(self.color)

	if (!self.bLarge) then
		local cubeSize = w * 0.5
		-- Top left
		local curve = SawTooth(self.freq, 0.75, cubeSize * 0.25, cubeSize)

		DrawCenteredRect(w * 0.25, h * 0.25, curve, curve)

		-- Top right
		curve = SawTooth(self.freq, 0.5, cubeSize * 0.25, cubeSize)

		DrawCenteredRect(w * 0.75, h * 0.25, curve, curve)

		-- Bottom right
		curve = SawTooth(self.freq, 0.25, cubeSize * 0.25, cubeSize)

		DrawCenteredRect(w * 0.75, h * 0.75, curve, curve)

		-- Bottom left
		curve = SawTooth(self.freq, 0, cubeSize * 0.25, cubeSize)

		DrawCenteredRect(w * 0.25, h * 0.75, curve, curve)
	else
		local curid = 0
		local cubeSize = (w * 0.25)

		for i = 0, 3 do
			if ((i + 1) % 2 == 0) then
				for ii = 3, 0, -1 do
					local size = SawTooth(self.freq, -(curid / 16), cubeSize / 3, cubeSize)
					local posx = ii * cubeSize + cubeSize * 0.5
					local posy = i * cubeSize + cubeSize * 0.5

					DrawCenteredRect(posx, posy, size, size)

					curid = curid + 1
				end
			else
				for ii = 0, 3 do
					local size = SawTooth(self.freq, -(curid / 16), cubeSize / 3, cubeSize)
					local posx = ii * cubeSize + cubeSize * 0.5
					local posy = i * cubeSize + cubeSize * 0.5

					DrawCenteredRect(posx, posy, size, size)

					curid = curid + 1
				end
			end
		end
	end
end

vgui.Register("ixLoyalistTerminalSpinner", PANEL)

-- terminal panel
PANEL = {}
local scale = 0.07
local screenWidth, screenHeight = 56, 32.7
local scaledWidth, scaledHeight = screenWidth / scale, screenHeight / scale

surface.CreateFont("TerminalTitleLight", {
	font = "Harmonia Sans Pro Cyr Light",
	size = 80,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalSubTitleLight", {
	font = "Harmonia Sans Pro Cyr Light",
	size = 60,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalSubTitle", {
	font = "Harmonia Sans Pro Cyr",
	size = 60,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalSubTitleLightAlt", {
	font = "Harmonia Sans Pro Cyr Light",
	size = 50,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalTitle", {
	font = "Harmonia Sans Pro Cyr",
	size = 80,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalLarge", {
	font = "Harmonia Sans Pro Cyr",
	size = 100,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalTextLight", {
	font = "Harmonia Sans Pro Cyr Light",
	size = 45,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalText", {
	font = "Harmonia Sans Pro Cyr",
	size = 45,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalTextSmall3", {
	font = "Harmonia Sans Pro Cyr",
	size = 25,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalTextSmall4", {
	font = "Harmonia Sans Pro Cyr",
	size = 20,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalClock", {
	font = "Harmonia Sans Pro Cyr Light",
	size = 25,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalLargePointsLarge", {
	font = "Harmonia Sans Pro Cyr",
	size = 85,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalTextPointsBig", {
	font = "Harmonia Sans Pro Cyr Light",
	size = 40,
	antialias = true,
	weight = 0
})

surface.CreateFont("TerminalTextPointsSmalll", {
	font = "Harmonia Sans Pro Cyr Light",
	size = 25,
	antialias = true,
	weight = 0
})

local inset = 80
local gradWidth = 250
local gradHeight = 600
local offWhite = Color(235, 246, 250)
local cmb = Material("vgui/terminals/cmb.png", "smooth")
local semiBlue = Color(120, 133, 142)
local pointColor = Color(81, 170, 189)
local pixelMat = Material("vgui/terminals/pixel.png", "noclamp")
local spinnerSize = 256
local dGrad = Material("vgui/gradient-u")

local function DistanceToPlane(object_pos, plane_pos, plane_forward)
	plane_forward:Normalize()
	local vec = object_pos - plane_pos

	return plane_forward:Dot( vec )
end

function PANEL:Init()
	self:SetSize(scaledWidth, scaledHeight)
	self.components = {}

	self.mainMenu = true
	self:ShowMainMenu()
end

function PANEL:AddComponent(class, parent)
	local component = vgui.Create(class, parent or self)

	if (IsValid(component)) then
		table.insert(self.components, component)
		component:SetPaintedManually(true)
	end

	return component
end

function PANEL:CalcName(text, maxWidth)
	surface.SetFont("TerminalSubTitleLight")

	for i = 1, #text do
		local str = text:sub(1, i)
		local tW, _ = surface.GetTextSize(str)

		if (tW > maxWidth) then
			return text:sub(1, math.max(i - 3, 1)) .. "..."
		end
	end

	return text
end

function PANEL:Error(message)
	local errWidth, errHeight = self:GetWide() * 0.5, self:GetTall() / 1.4

	self.error = self:AddComponent("Panel")
	self.error:Dock(FILL)
	self.error:SetZPos(1000)
	self.error.Paint = function(s, w, h)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, w, h)
	end
	self.error.bError = true

	self.errorBox = self:AddComponent("Panel", self.error)
	self.errorBox.bError = true
	self.errorBox:SetSize(errWidth, errHeight)
	self.errorBox:SetPos(self:GetWide() * 0.5 - errWidth * 0.5, self:GetTall() * 0.5 - errHeight * 0.5)
	self.errorBox.Paint = function(s, w, h)
		surface.SetDrawColor(139, 0, 0)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(180, 0, 0)
		surface.DrawRect(0, 0, w, 25)

		surface.SetDrawColor(0, 0, 0, 100)
		surface.SetMaterial(dGrad)
		surface.DrawTexturedRect(0, 25, w, 10)

		draw.SimpleText("ERROR", "TerminalClock", w * 0.5, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.DrawText(message, "TerminalClock", w * 0.5, h * 0.35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local buttonWide, buttonTall = errWidth * 0.5, 55
	self.errButton = self:AddComponent("ixLoyalistTerminalButton", self.errorBox)
	self.errButton.bError = true
	self.errButton:SetSize(buttonWide, buttonTall)
	self.errButton:SetFont("TerminalClock")
	self.errButton:SetBackgroundColor(Color(139, 0, 0))
	self.errButton:SetBGHighlightColor(Color(230, 0, 0))
	self.errButton:SetTextColor(color_white)
	self.errButton:SetTextHighlightColor(color_white)
	self.errButton:SetText("OK")
	self.errButton:SetMouseInputEnabled(true)
	self.errButton:SetPos(errWidth * 0.5 - buttonWide * 0.5, errHeight - buttonTall * 1.2)

	self.errButton.grace = CurTime() + 0.2
	self.errButton.DoClick = function(button)
		if (button.grace > CurTime()) then return end

		if (IsValid(self.error)) then
			self.error:Remove()
			self.error = nil
		end

		self.grace = CurTime() + 0.2
		surface.PlaySound("terminals/click.wav")
	end
end

function PANEL:ShowInfoPanel(loadTime)
	if (IsValid(self.spinner)) then
		self.spinner:Remove()
		self.spinner = nil
	end

	if (IsValid(self.menuPanel)) then
		self.menuPanel:Remove()
	end

	self.mainMenu = false
	self.loading = false

	if (loadTime) then
		if (self.spinner) then
			self.spinner:Remove()
		end

		self.name = self:CalcName(LocalPlayer():Name():upper(), self:GetWide() - 165)

		self.loading = true
		self.spinner = self:AddComponent("ixLoyalistTerminalSpinner")
		self.spinner:SetSize(spinnerSize, spinnerSize)
		self.spinner:SetPos(self:GetWide() * 0.5 - spinnerSize * 0.5, self:GetTall() * 0.5 - spinnerSize * 0.5)
		self.spinner:SetLarge(true)
		self.spinner:SetFrequency(0.7)
		self.spinner:SetPaintedManually(true)

		timer.Simple(loadTime, function()
			if (!IsValid(self)) then
				return
			end

			self:ShowInfoPanel()
		end)

		return
	end

	self.infoPanel = self:AddComponent("Panel")
	self.infoPanel:SetAlpha(0)
	self.infoPanel:Dock(FILL)
	self.infoPanel.Paint = function(s, w, h)
		surface.SetMaterial(cmb)
		surface.DrawTexturedRect(0, 25, 62, 62)
		draw.SimpleText(self.name or LocalPlayer():Name(), "TerminalSubTitleLight", 80, 25, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		surface.SetDrawColor(semiBlue)
		surface.DrawRect(80, 80, w - 80 * 2, 2)
		surface.DrawRect(80, 85, w - 80 * 2, 2)

		draw.SimpleText("CIVIL STATUS: "..PLUGIN.status, "TerminalTextSmall3", 80, 90, semiBlue, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("REGISTERED AT: "..PLUGIN.aparts, "TerminalTextSmall4", 80, 112, semiBlue, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		draw.SimpleText("You have", "TerminalTextPointsBig", w * 0.2, h * 0.35, semiBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(PLUGIN.nRecords, "TerminalLargePointsLarge", w * 0.2, h * 0.5, pointColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("documented notes", "TerminalTextPointsSmalll", w * 0.2, h * 0.65, semiBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.SimpleText("You have", "TerminalTextPointsBig", w * 0.5, h * 0.35, semiBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(PLUGIN.cRecords, "TerminalLargePointsLarge", w * 0.5, h * 0.5, pointColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("civil records", "TerminalTextPointsSmalll", w * 0.5, h * 0.65, semiBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.SimpleText("You have", "TerminalTextPointsBig", w * 0.8, h * 0.35, semiBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(PLUGIN.mRecords, "TerminalLargePointsLarge", w * 0.8, h * 0.5, pointColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("medical records", "TerminalTextPointsSmalll", w * 0.8, h * 0.65, semiBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local buttonWide, buttonTall = self:GetWide() / 2.8, 60
	self.requestButton = self:AddComponent("ixLoyalistTerminalButton", self.infoPanel)
	self.requestButton:SetSize(buttonWide, buttonTall)
	self.requestButton:SetFont("TerminalButtonText")
	self.requestButton:SetBackgroundColor(Color(197, 206, 213))
	self.requestButton:SetBGHighlightColor(Color(240, 240, 240))
	self.requestButton:SetTextColor(Color(70, 70, 70))
	self.requestButton:SetTextHighlightColor(Color(44, 42, 61))
	self.requestButton:SetPaintedManually(true)
	self.requestButton:SetText("Request Officers")
	self.requestButton:SetMouseInputEnabled(true)
	self.requestButton:SetPos(self:GetWide() * 0.5 - buttonWide * 0.5, self:GetTall() - buttonTall - 60)
	self.requestButton.DoClick = function(button)
		if (CurTime() < (button.nextClick or 0)) then return end
		if (CurTime() < (self.grace or 0)) then return end

		button.nextClick = CurTime() + 1
		self.grace = CurTime() + 0.2

		surface.PlaySound("terminals/click.wav")

		if (CurTime() < (LocalPlayer().nextRequest or 0)) then
			self:Error(Format("ERR: Must wait %s second(s) before\nrequesting another officer!", math.floor(LocalPlayer().nextRequest - CurTime())))

			return
		end

		LocalPlayer().nextRequest = CurTime() + 300

		net.Start("ixTerminalRequest")
		net.SendToServer()
	end

	self.requestButton:SetAlpha(0)
	self.requestButton:SetParent(self.infoPanel)

	self.infoPanel:AlphaTo(255, 0.2, 0)
	self.requestButton:AlphaTo(255, 0.2, 0)

	timer.Simple(10, function() if (IsValid(self)) then self:ShowMainMenu() end end)
end

function PANEL:ShowMainMenu(loadTime)
	if (IsValid(self.spinner)) then
		self.spinner:Remove()
		self.spinner = nil
	end

	if (IsValid(self.infoPanel)) then
		self.infoPanel:Remove()
	end

	self.mainMenu = true
	self.loading = false

	if (loadTime) then
		if (self.spinner) then
			self.spinner:Remove()
		end

		self.loading = true
		self.spinner = self:AddComponent("ixLoyalistTerminalSpinner")
		self.spinner:SetSize(spinnerSize, spinnerSize)
		self.spinner:SetPos(self:GetWide() * 0.5 - spinnerSize * 0.5, self:GetTall() * 0.5 - spinnerSize * 0.5)
		self.spinner:SetLarge(true)
		self.spinner:SetFrequency(0.7)
		self.spinner:SetPaintedManually(true)

		timer.Simple(loadTime, function()
			if (!IsValid(self)) then
				return
			end

			self:ShowMainMenu()
		end)

		return
	end

	self.menuPanel = self:AddComponent("Panel")
	self.menuPanel:SetAlpha(0)
	self.menuPanel:Dock(FILL)
	self.menuPanel.Paint = function(s, w, h)
		surface.SetDrawColor(143, 160, 170, 180)
		surface.DrawRect(0, 80, w, 80)
		draw.SimpleText("INFO TERMINAL", "TerminalTitleLight", w * 0.5, 80, offWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		draw.SimpleText("Tap to begin", "TerminalSubTitleLightAlt", w * 0.5, h * 0.5, semiBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.menuPanel:AlphaTo(255, 0.2, 0)
end

function PANEL:OnMousePressed(key)
	if (key == MOUSE_LEFT and self.mainMenu and !self.loading and !IsValid(self.error) and CurTime() > (self.grace or 0)) then
		surface.PlaySound("terminals/button_push.ogg")

		local item
		local character = LocalPlayer():GetCharacter()

		if (character) then
			item = character:GetIDCard()

			if (item) then
				self:ShowInfoPanel(1.2)

				net.Start("ixTerminalRetrieveInfo")
				net.SendToServer()
			end
		end

		if (!item) then
			self:Error("ERR: 13, NO CARD SWIPED")
		end
	end
end

do
	local function definecanvas(ref)
		ix.util.ResetStencilValues()
		render.SetStencilEnable(true)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)
		render.SetStencilWriteMask(254)
		render.SetStencilTestMask(254)
		render.SetStencilReferenceValue(ref or 43)
	end

	local function drawon()
		render.SetStencilCompareFunction(STENCIL_EQUAL)
	end

	local function stopcanvas()
		render.SetStencilEnable(false)
	end

	local grad = Material("vgui/gradient-l")
	local hand = Material("vgui/terminals/reticle_finger.png", "smooth")
	local regOffset = 11.3

	function PANEL:DrawScreen(w, h)
		for k, v in pairs(self.components) do
			if (v and v.bError) then continue end

			if (IsValid(v)) then
				v:PaintManual()
			else
				self.components[k] = nil
			end
		end

		if (IsValid(self.error)) then
			self.error:PaintManual()
		end

		if (!vgui.IsPointingPanel(self)) then return end

		local cursorX, cursorY = gui.MouseX(), gui.MouseY()

		surface.SetMaterial(hand)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(cursorX - regOffset, cursorY - 2.8, 30, 30)
	end

	function PANEL:Paint(w, h)
		local dist = self.Origin and DistanceToPlane(EyePos(), self.Origin, self.Normal) or nil

		if (!dist) then return end

		local alpha = (1 - dist / 55) * 125

		definecanvas()
		surface.SetDrawColor(197, 206, 213)
		surface.DrawRect(0, 0, w, h)
		drawon()

		render.PushFilterMag(TEXFILTER.ANISOTROPIC)
		render.PushFilterMin(TEXFILTER.ANISOTROPIC)

		-- Header bar
		local timeInfo = os.date("%H:%M", os.time())
		surface.SetDrawColor(113, 130, 140, 220)
		surface.DrawRect(0, 0, w, 25)
		draw.SimpleText(timeInfo, "TerminalClock", w - 20, 0, offWhite, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		-- Main drawing --

		self:DrawScreen(w, h)

		-- Post-Processing

		surface.SetDrawColor(20, 20, 130, 120)
		surface.SetMaterial(grad)
		-- Top left
		surface.DrawTexturedRectRotated(inset, inset, gradWidth, gradHeight, -45)
		-- Top right
		surface.DrawTexturedRectRotated(w - inset, inset, gradWidth, gradHeight, -135)
		-- Bottom right
		surface.DrawTexturedRectRotated(w - inset, h - inset, gradWidth, gradHeight, 135)
		-- Bottom left
		surface.DrawTexturedRectRotated(inset, h - inset, gradWidth, gradHeight, 45)

		local scrollMod = (CurTime() * 450) % (h + 300)
		local scrollMod2 = ((CurTime() * 450) + 400) % (h + 300)

		surface.SetDrawColor(245, 255, 255, 7)
		surface.DrawRect(0, h - scrollMod, w, 200)
		surface.DrawRect(0, h - scrollMod2, w, 200)

		surface.SetDrawColor(0, 0, 0, alpha)
		surface.SetMaterial(pixelMat)
		surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, w, h)

		render.PopFilterMin()
		render.PopFilterMag()
		stopcanvas()
	end
end

vgui.Register("ixLoyalistTerminal", PANEL)
