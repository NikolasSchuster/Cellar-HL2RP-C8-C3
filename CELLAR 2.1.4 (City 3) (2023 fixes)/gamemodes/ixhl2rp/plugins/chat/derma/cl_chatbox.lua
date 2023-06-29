local PLUGIN = ix.plugin.list["chatbox"]
local PANEL = {}
local animationTime = 0.5
local chatBorder = 32
local sizingBorder = 20

AccessorFunc(PANEL, "bActive", "Active", FORCE_BOOL)

function PANEL:Init()
	ix.gui.chat = self

	self:SetSize(self:GetDefaultSize())
	self:SetPos(self:GetDefaultPosition())

	local entryPanel = self:Add("Panel")
	entryPanel:SetZPos(1)
	entryPanel:Dock(BOTTOM)
	entryPanel:DockMargin(4, 0, 4, 4)

	self.entry = entryPanel:Add("ixChatboxEntry")
	self.entry:Dock(FILL)
	self.entry.OnValueChange = ix.util.Bind(self, self.OnTextChanged)
	self.entry.OnKeyCodeTyped = ix.util.Bind(self, self.OnKeyCodeTyped)
	self.entry.OnEnter = ix.util.Bind(self, self.OnMessageSent)

	self.prefix = entryPanel:Add("ixChatboxPrefix")
	self.prefix:Dock(LEFT)

	self.preview = self:Add("ixChatboxPreview")
	self.preview:SetZPos(2) -- ensure the preview is docked above the text entry
	self.preview:Dock(BOTTOM)
	self.preview:SetTargetHeight(self.entry:GetTall())

	self.tabs = self:Add("ixChatboxTabs")
	self.tabs:Dock(FILL)
	self.tabs.OnTabChanged = ix.util.Bind(self, self.OnTabChanged)

	self.autocomplete = self.tabs:Add("ixChatboxAutocomplete")
	self.autocomplete:Dock(FILL)
	self.autocomplete:DockMargin(4, 3, 4, 4) -- top margin is 3 to account for tab 1px border
	self.autocomplete:SetZPos(3)

	self.alpha = 0
	self:SetActive(false)

	-- luacheck: globals chat
	chat.GetChatBoxPos = function()
		return self:GetPos()
	end

	chat.GetChatBoxSize = function()
		return self:GetSize()
	end
end

function PANEL:GetDefaultSize()
	return ScrW() * 0.4, ScrH() * 0.375
end

function PANEL:GetDefaultPosition()
	return chatBorder, ScrH() - self:GetTall() - chatBorder
end

DEFINE_BASECLASS("Panel")
function PANEL:SetAlpha(amount, duration)
	self:CreateAnimation(duration or animationTime, {
		index = 1,
		target = {alpha = amount},
		easing = "outQuint",

		Think = function(animation, panel)
			BaseClass.SetAlpha(panel, panel.alpha)
		end
	})
end

function PANEL:SizingInBounds()
	local screenX, screenY = self:LocalToScreen(0, 0)
	local mouseX, mouseY = gui.MousePos()

	return mouseX > screenX + self:GetWide() - sizingBorder and mouseY > screenY + self:GetTall() - sizingBorder
end

function PANEL:DraggingInBounds()
	local _, screenY = self:LocalToScreen(0, 0)
	local mouseY = gui.MouseY()

	return mouseY > screenY and mouseY < screenY + self.tabs.buttons:GetTall()
end

function PANEL:SetActive(bActive)
	if (bActive) then
		self:SetAlpha(255)
		self:MakePopup()
		self.entry:RequestFocus()

		input.SetCursorPos(self:LocalToScreen(-1, -1))

		hook.Run("StartChat")
		self.prefix:SetText(hook.Run("GetChatPrefixInfo", ""))
	else
		self:SetAlpha(0)
		self:SetMouseInputEnabled(false)
		self:SetKeyboardInputEnabled(false)

		self.autocomplete:SetVisible(false)
		self.preview:SetVisible(false)
		self.entry:SetText("")
		self.preview:SetCommand("")
		self.prefix:SetText(hook.Run("GetChatPrefixInfo", ""))

		CloseDermaMenus()
		gui.EnableScreenClicker(false)

		hook.Run("FinishChat")
	end

	local tab = self.tabs:GetActiveTab()

	if (tab) then
		-- we'll scroll to bottom even if we're opening since the SetVisible for the textentry will shift things a bit
		tab:ScrollToBottom()
	end

	self.bActive = tobool(bActive)
end

function PANEL:SetupTabs(tabs)
	if (!tabs or table.IsEmpty(tabs)) then
		self.tabs:AddTab(L("chat"), {})
		self.tabs:SetActiveTab(L("chat"))

		return
	end

	for id, filter in pairs(tabs) do
		self.tabs:AddTab(id, filter)
	end

	self.tabs:SetActiveTab(next(tabs))
end

function PANEL:SetupPosition(info)
	local x, y, width, height

	if (!istable(info)) then
		x, y = self:GetDefaultPosition()
		width, height = self:GetDefaultSize()
	else
		-- screen size may have changed so we'll need to clamp the values
		width = math.Clamp(info[3], 32, ScrW() - chatBorder * 2)
		height = math.Clamp(info[4], 32, ScrH() - chatBorder * 2)
		x = math.Clamp(info[1], 0, ScrW() - width)
		y = math.Clamp(info[2], 0, ScrH() - height)
	end

	self:SetSize(width, height)
	self:SetPos(x, y)

	PLUGIN:SavePosition()
end

function PANEL:OnMousePressed(key)
	if (key == MOUSE_RIGHT) then
		local menu = DermaMenu()
			menu:AddOption(L("chatNewTab"), function()
				if (IsValid(ix.gui.chatTabCustomize)) then
					ix.gui.chatTabCustomize:Remove()
				end

				local panel = vgui.Create("ixChatboxTabCustomize")
				panel.OnTabCreated = ix.util.Bind(self, self.OnTabCreated)
			end)

			menu:AddOption(L("chatMarkRead"), function()
				for _, v in pairs(self.tabs:GetTabs()) do
					v:GetButton():SetUnread(false)
				end
			end)

			menu:AddSpacer()

			menu:AddOption(L("chatReset"), function()
				local x, y = self:GetDefaultPosition()
				local width, height = self:GetDefaultSize()

				self:SetSize(width, height)
				self:SetPos(x, y)

				ix.option.Set("chatPosition", "")
				hook.Run("ChatboxPositionChanged", x, y, width, height)
			end)

			menu:AddOption(L("chatResetTabs"), function()
				for id, _ in pairs(self.tabs:GetTabs()) do
					self.tabs:RemoveTab(id)
				end

				ix.option.Set("chatTabs", "")
			end)
		menu:Open()
		menu:MakePopup()

		return
	end

	if (key != MOUSE_LEFT) then
		return
	end

	-- capture the mouse if we're in bounds for sizing this panel
	if (self:SizingInBounds()) then
		self.bSizing = true
		self:MouseCapture(true)
	elseif (self:DraggingInBounds()) then
		local mouseX, mouseY = self:ScreenToLocal(gui.MousePos())

		-- mouse offset relative to the panel
		self.DragOffset = {mouseX, mouseY}
		self:MouseCapture(true)
	end
end

function PANEL:OnMouseReleased()
	self:MouseCapture(false)
	self:SetCursor("arrow")

	-- save new position/size if we were dragging/resizing
	if (self.bSizing or self.DragOffset) then
		PLUGIN:SavePosition()

		self.bSizing = nil
		self.DragOffset = nil

		-- resize chat messages to fit new width
		self:InvalidateChildren(true)

		local x, y = self:GetPos()
		local width, height = self:GetSize()

		hook.Run("ChatboxPositionChanged", x, y, width, height)
	end
end

function PANEL:Think()
	if (gui.IsGameUIVisible() and self.bActive) then
		if (self.bSizing or self.DragOffset) then
			self:OnMouseReleased(MOUSE_LEFT) -- make sure we aren't still sizing/dragging anything
		end

		self:SetActive(false)
		return
	end

	if (!self.bActive) then
		return
	end

	local mouseX = math.Clamp(gui.MouseX(), 0, ScrW())
	local mouseY = math.Clamp(gui.MouseY(), 0, ScrH())

	if (self.bSizing) then
		local x, y = self:GetPos()
		local width = math.Clamp(mouseX - x, chatBorder, ScrW() - chatBorder * 2)
		local height = math.Clamp(mouseY - y, chatBorder, ScrH() - chatBorder * 2)

		self:SetSize(width, height)
		self:SetCursor("sizenwse")
	elseif (self.DragOffset) then
		local x = math.Clamp(mouseX - self.DragOffset[1], 0, ScrW() - self:GetWide())
		local y = math.Clamp(mouseY - self.DragOffset[2], 0, ScrH() - self:GetTall())

		self:SetPos(x, y)
	elseif (self:SizingInBounds()) then
		self:SetCursor("sizenwse")
	elseif (self:DraggingInBounds()) then
		-- we have to set the cursor on the list panel since that's the actual hovered panel
		self.tabs.buttons:SetCursor("sizeall")
	else
		self:SetCursor("arrow")
	end
end

function PANEL:Paint(width, height)
	local tab = self.tabs:GetActiveTab()
	local alpha = self:GetAlpha()

	derma.SkinFunc("PaintChatboxBackground", self, width, height)

	if (tab) then
		-- manually paint active tab since messages handle their own alpha lifetime
		surface.SetAlphaMultiplier(1)
			tab:PaintManual()
		surface.SetAlphaMultiplier(alpha / 255)
	end

	if (alpha > 0) then
		hook.Run("PostChatboxDraw", width, height, self:GetAlpha())
	end
end

-- get the command of the current chat class in the textentry if possible
function PANEL:GetTextEntryChatClass(text)
	text = text or self.entry:GetText()

	local chatType = ix.chat.Parse(LocalPlayer(), text, true)

	if (chatType and chatType != "ic") then
		-- OOC is the only one with two slashes as its prefix, so we'll make a special case for it here
		if (chatType == "ooc") then
			return "ooc"
		end

		local class = ix.chat.classes[chatType]

		if (istable(class.prefix)) then
			for _, v in ipairs(class.prefix) do
				if (v:sub(1, 1) == "/") then
					return v:sub(2):lower()
				end
			end
		elseif (class.prefix:sub(1, 1) == "/") then
			return class.prefix:sub(2):lower()
		end
	end
end

-- chatbox panel hooks
-- called when the textentry value changes
function PANEL:OnTextChanged(text)
	hook.Run("ChatTextChanged", text)

	local preview = self.preview
	local autocomplete = self.autocomplete
	local chatClassCommand = self:GetTextEntryChatClass(text)

	self.prefix:SetText(hook.Run("GetChatPrefixInfo", text))

	if (chatClassCommand) then
		preview:SetCommand(chatClassCommand)
		preview:SetVisible(true)
		preview:UpdateArguments(text)

		autocomplete:SetVisible(false)
		return
	end

	local start, _, command = text:find("(/(%w+)%s)")
	command = ix.command.list[tostring(command):utf8sub(2, tostring(command):utf8len() - 1):utf8lower()]

	-- update preview if we've found a command
	if (start == 1 and command) then
		preview:SetCommand(command.uniqueID)
		preview:SetVisible(true)
		preview:UpdateArguments(text)

		-- we don't need the autocomplete because we have a command already typed out
		autocomplete:SetVisible(false)
		return
	-- if there's a slash then we're probably going to be (or are currently) typing out a command
	elseif (text:utf8sub(1, 1) == "/") then
		command = text:match("(/(%w+))") or "/"

		preview:SetVisible(false) -- we don't have a valid command yet
		autocomplete:Update(command:utf8sub(2))
		autocomplete:SetVisible(true)

		return
	end

	if (preview:GetCommand() != "") then
		preview:SetCommand("")
		preview:SetVisible(false)
	end

	if (autocomplete:IsVisible()) then
		autocomplete:SetVisible(false)
	end
end

DEFINE_BASECLASS("DTextEntry")
function PANEL:OnKeyCodeTyped(key)
	if (key == KEY_TAB) then
		if (self.autocomplete:IsOpen() and #self.autocomplete:GetCommands() > 0) then
			local newText = self.autocomplete:SelectNext()

			self.entry:SetText(newText)
			self.entry:SetCaretPos(newText:utf8len())
		end

		return true
	end

	return BaseClass.OnKeyCodeTyped(self.entry, key)
end

-- called when player types something and presses enter in the textentry
function PANEL:OnMessageSent()
	local text = self.entry:GetText()

	if (text:find("%S")) then
		local lastEntry = ix.chat.history[#ix.chat.history]

		-- only add line to textentry history if it isn't the same message
		if (lastEntry != text) then
			if (#ix.chat.history >= 20) then
				table.remove(ix.chat.history, 1)
			end

			ix.chat.history[#ix.chat.history + 1] = text
		end

		net.Start("ixChatMessage")
			net.WriteString(text)
		net.SendToServer()
	end

	self:SetActive(false) -- textentry is set to "" in SetActive
end

-- called when the player changes the currently active tab
function PANEL:OnTabChanged(panel)
	panel:InvalidateLayout(true)
	panel:ScrollToBottom()
end

-- called when the player creates a new tab
function PANEL:OnTabCreated(id, filter)
	self.tabs:AddTab(id, filter)
	PLUGIN:SaveTabs()
end

-- called when the player updates a tab's filter
function PANEL:OnTabUpdated(id, filter, newID)
	local tab = self.tabs:GetTabs()[id]

	if (!tab) then
		return
	end

	tab:SetFilter(filter)
	self.tabs:RenameTab(id, newID)

	PLUGIN:SaveTabs()
end

-- called when a tab's button was right-clicked
function PANEL:OnTabRightClick(button, tab, id)
	local menu = DermaMenu()
		menu:AddOption(L("chatCustomize"), function()
			if (IsValid(ix.gui.chatTabCustomize)) then
				ix.gui.chatTabCustomize:Remove()
			end

			local panel = vgui.Create("ixChatboxTabCustomize")
			panel:PopulateFromTab(id, tab:GetFilter())
			panel.OnTabUpdated = ix.util.Bind(self, self.OnTabUpdated)
		end)

		menu:AddSpacer()

		menu:AddOption(L("chatCloseTab"), function()
			self.tabs:RemoveTab(id)
			PLUGIN:SaveTabs()
		end)
	menu:Open()
	menu:MakePopup() -- HACK: mouse input doesn't work when created immediately after opening chatbox
end

-- called when a message needs to be added to applicable tabs
function PANEL:AddMessage(...)
	local class = CHAT_CLASS and CHAT_CLASS.uniqueID or "notice"
	local activeTab = self.tabs:GetActiveTab()

	-- track whether or not the message was filtered out in the active tab
	local bShown = false

	if (activeTab and !activeTab:GetFilter()[class]) then
		activeTab:AddLine({...}, true, class)
		bShown = true
	end

	for _, v in pairs(self.tabs:GetTabs()) do
		if (v:GetID() == activeTab:GetID()) then
			continue -- we already added it to the active tab
		end

		if (!v:GetFilter()[class]) then
			v:AddLine({...}, true, class)

			-- mark other tabs as unread if we didn't show the message in the active tab
			if (!bShown) then
				v:GetButton():SetUnread(true)
			end
		end
	end

	if (bShown) then
		chat.PlaySound()
	end
end

vgui.Register("ixChatbox", PANEL, "EditablePanel")