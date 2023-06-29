
-- tooltip
local PANEL = {}

function PANEL:Init()
	self:SetFont("ixSmallFont")
	self:SetText("You do not have access to any voice lines!")
	self:SetContentAlignment(5)
	self:SetTextColor(color_white)
	self:SetExpensiveShadow(1, color_black)
	self:DockMargin(0, 0, 0, 8)
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(ColorAlpha(derma.GetColor("Error", self), 160))
	surface.DrawRect(0, 0, width, height)
end

vgui.Register("ixVoicesNotice", PANEL, "DLabel")

-- voices panel
PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:DockPadding(8, 8, 8, 8)

	self.notice = self:Add("ixVoicesNotice")
	self.notice:Dock(TOP)

	self.searchEntry = self:Add("ixIconTextEntry")
	self.searchEntry:Dock(TOP)
	self.searchEntry:RequestFocus()
	self.searchEntry.OnEnter = function(panel)
		self:Display()
		panel:RequestFocus()
	end

	self.canvas = self:Add("DScrollPanel")
	self.canvas:Dock(FILL)

	self.classes = {}
	self.entryCount = 0 -- how many entries we need to process
	self.processed = 1 -- how many entries we've processed so far
	self.processAmount = 8 -- how many entries to process per frame
	self.fraction = 0 -- percentage of entries we've processed

	-- gather voice entries for processing
	for k, v in pairs(Schema.voices.classes) do
		if (v.condition(LocalPlayer())) then
			self.classes[#self.classes + 1] = k
			self.entryCount = self.entryCount + Schema.voices.GetCount(k)
		end
	end

	if (#self.classes < 1) then
		self.notice:SetText("You do not have access to any voice lines!")
		self.notice:SizeToContents()
		self.notice:SetTall(self.notice:GetTall() + 16)

		return
	else
		self.notice:SetVisible(false)
	end

	table.sort(self.classes, function(a, b)
		return a < b
	end)

	self:Display()
end

function PANEL:Display()
	self.canvas:Clear()

	self.processed = 1
	self.fraction = 0
	self.thread = coroutine.create(self.Process, self)
end

function PANEL:Process()
	local filter = self.searchEntry:GetValue():lower()

	for _, class in ipairs(self.classes) do
		local category = self.canvas:Add("Panel")
		category:Dock(TOP)
		category:DockMargin(0, 0, 0, 8)
		category:DockPadding(8, 8, 8, 8)
		category.Paint = function(_, width, height)
			surface.SetDrawColor(Color(0, 0, 0, 66))
			surface.DrawRect(0, 0, width, height)
		end

		local categoryLabel = category:Add("DLabel")
		categoryLabel:SetFont("ixMediumLightFont")
		categoryLabel:SetText(class:upper())
		categoryLabel:Dock(FILL)
		categoryLabel:SetTextColor(color_white)
		categoryLabel:SetExpensiveShadow(1, color_black)
		categoryLabel:SizeToContents()
		category:SizeToChildren(true, true)

		for command, info in SortedPairs(Schema.voices.stored[class]) do
			self.processed = self.processed + 1

			if (self.processed % self.processAmount == 0) then
				coroutine.yield()
			end

			if (!command:lower():find(filter, nil, true)) then
				continue
			end

			local title = self.canvas:Add("DLabel")
			title:SetFont("ixMediumLightFont")
			title:SetText(command:upper())
			title:Dock(TOP)
			title:SetTextColor(ix.config.Get("color"))
			title:SetExpensiveShadow(1, color_black)
			title:SetMouseInputEnabled(true)
			title:SetCursor("hand")
			title:SizeToContents()
			title.OnMousePressed = function(_, key)
				if (key == MOUSE_LEFT) then
					SetClipboardText(command)
				end
			end

			local description = self.canvas:Add("DLabel")
			description:SetFont("ixSmallFont")
			description:SetText(info.text)
			description:Dock(TOP)
			description:SetTextColor(color_white)
			description:SetExpensiveShadow(1, color_black)
			description:SetWrap(true)
			description:SetAutoStretchVertical(true)
			description:SizeToContents()
			description:DockMargin(0, 0, 0, 8)
		end
	end
end

function PANEL:Paint(width, height)
	if (self:IsPlayingTweenAnimation(1)) then
		surface.SetDrawColor(ix.config.Get("color"))
		surface.DrawRect(0, 0, width * self.fraction, 4)
	end
end

function PANEL:Think()
	if (self.thread and coroutine.status(self.thread) != "dead") then
		coroutine.resume(self.thread, self)

		self:CreateAnimation(0.25, {
			index = 1,
			target = {fraction = self.processed / self.entryCount},
			easing = "outQuint"
		})
	end
end

vgui.Register("ixVoices", PANEL, "Panel")

-- add to help menu
hook.Add("PopulateHelpMenu", "ixVoices", function(tabs)
	tabs["voices"] = function(container)
		container:DisableScrolling()
		container:Add("ixVoices")
	end
end)
