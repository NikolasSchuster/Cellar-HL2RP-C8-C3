-- config manager
local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:SetSearchEnabled(true)

	self:Populate()
end

local darkblue = Color(43, 157, 189, 43)
local lightblue = Color(56, 207, 248)

function PANEL:Populate()
	-- gather categories
	local categories = {}
	local categoryIndices = {}

	for k, v in pairs(ix.config.stored) do
		local index = v.data and v.data.category or "misc"

		categories[index] = categories[index] or {}
		categories[index][k] = v
	end

	-- sort by category phrase
	for k, _ in pairs(categories) do
		categoryIndices[#categoryIndices + 1] = k
	end

	table.sort(categoryIndices, function(a, b)
		return L(a) < L(b)
	end)

	-- add panels
	for _, category in ipairs(categoryIndices) do
		local categoryPhrase = L(category):utf8upper()
		local cat = self:AddCategory(categoryPhrase)
		cat.Paint = function(me, w, h)
			draw.RoundedBox(0, 0, 0, w, h, darkblue)
			-- left & right --
			draw.RoundedBox(0, 0, 0, 1, h, lightblue)
			draw.RoundedBox(0, w - 1, 0, 1, h, lightblue)
			draw.RoundedBox(0, 1, 0, 1, h, darkblue)
			draw.RoundedBox(0, w - 2, 0, 1, h, darkblue)
			-- bottom --
			draw.RoundedBox(0, 0, h - 1, w, 1, lightblue)
			draw.RoundedBox(0, 0, h - 2, w, 1, lightblue)
			draw.RoundedBox(0, 0, h - 3, w, 1, darkblue)
			-- top --
			draw.RoundedBox(0, 0, 0, w, 2, lightblue)

			-- frame --
			draw.RoundedBox(0, w/4.675, 0, w - w/2.3375, 2, lightblue)
			draw.RoundedBox(0, w/4.65, 1, w - w/2.325, 2, darkblue)
			draw.RoundedBox(0, w/4.625, 3, w - w/2.3125, 2, darkblue)
			draw.RoundedBox(0, w/4.6, 5, w - w/2.3, 2, darkblue)
			draw.RoundedBox(0, w/4.575, 7, w - w/2.2875, 2, darkblue)
			draw.RoundedBox(0, w/4.55, 9, w - w/2.275, 2, darkblue)
			draw.RoundedBox(0, w/4.525, 11, w - w/2.2625, 2, darkblue)
			draw.RoundedBox(0, w/4.5, 13, w - w/2.25 - 1, 2, darkblue)
			draw.RoundedBox(0, w/4.465, 15, w - w/2.2325 + 1, 2, darkblue)
			draw.RoundedBox(0, w/4.445, 17, w - w/2.2225, 2, darkblue)
			draw.RoundedBox(0, w/4.420, 19, w - w/2.21, 2, darkblue)
			draw.RoundedBox(0, w/4.395, 21, w - w/2.1975, 2, darkblue)
			draw.RoundedBox(0, w/4.370, 23, w - w/2.185, 2, darkblue)
			draw.RoundedBox(0, w/4.345, 25, w - w/2.1725 + 1, 2, darkblue)
			draw.RoundedBox(0, w/4.320, 27, w - w/2.16 + 1, 2, darkblue)
			surface.SetDrawColor(lightblue)
			surface.DrawLine(w/4.675, 0, w/4.320, 29)
			surface.DrawLine(w/4.675 - 1, 0, w/4.320, 28)
			surface.SetDrawColor(lightblue)
			surface.DrawLine(w - w/4.675 - 1, 0, w - w/4.32 - 2, 29)
			surface.DrawLine(w - w/4.675 - 2, 0, w - w/4.32 - 2, 28)
			surface.DrawLine(w/4.320, 29, w - w/4.32 - 1, 29)
			surface.DrawLine(w/4.320, 28, w - w/4.32 - 1, 28)


			surface.SetTextColor(Color(56, 61, 248, 225))
			surface.SetFont('cellar.derma.blur')
			surface.SetTextPos(w * .5 - surface.GetTextSize(categoryPhrase) * .5, 3)
			surface.DrawText(categoryPhrase)


			surface.SetTextColor(lightblue)
			surface.SetFont('cellar.derma')
			surface.SetTextPos(w * .5 - surface.GetTextSize(categoryPhrase) * .5, 3)
			surface.DrawText(categoryPhrase)

		end

		-- we can use sortedpairs since configs don't have phrases to account for
		for k, v in SortedPairs(categories[category]) do
			if (isfunction(v.hidden) and v.hidden()) then
				continue
			end

			local data = v.data.data
			local type = v.type
			local value = ix.util.SanitizeType(type, ix.config.Get(k))

			local row = self:AddRow(type, categoryPhrase)
			--row:SetText(ix.util.ExpandCamelCase(k))
			row:SetText(ix.util.ExpandCamelCase(k))
			row.Paint = function(self, w, h)
				draw.SimpleText(ix.util.ExpandCamelCase(k), 'cellar.derma.medium.blur', 4, h/2, Color(56, 61, 248, 225), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			-- type-specific properties
			if (type == ix.type.number) then
				row:SetMin(data and data.min or 0)
				row:SetMax(data and data.max or 1)
				row:SetDecimals(data and data.decimals or 0)
			end

			row:SetValue(value, true)
			row:SetShowReset(value != v.default, k, v.default)

			row.OnValueChanged = function(panel)
				local newValue = ix.util.SanitizeType(type, panel:GetValue())

				panel:SetShowReset(newValue != v.default, k, v.default)

				net.Start("ixConfigSet")
					net.WriteString(k)
					net.WriteType(newValue)
				net.SendToServer()
			end

			row.OnResetClicked = function(panel)
				panel:SetValue(v.default, true)
				panel:SetShowReset(false)

				net.Start("ixConfigSet")
					net.WriteString(k)
					net.WriteType(v.default)
				net.SendToServer()
			end

			row:GetLabel():SetHelixTooltip(function(tooltip)
				local title = tooltip:AddRow("name")
				title:SetImportant()
				title:SetText(k)
				title:SizeToContents()
				title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

				local description = tooltip:AddRow("description")
				description:SetText(v.description)
				description:SizeToContents()
			end)
		end
	end

	self:SizeToContents()
end

vgui.Register("ixConfigManager", PANEL, "ixSettings")

-- plugin manager
PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:SetSearchEnabled(true)

	self.loadedCategory = L("loadedPlugins"):utf8upper()
	self.unloadedCategory = L("unloadedPlugins"):utf8upper()
	

	if (!ix.gui.bReceivedUnloadedPlugins) then
		net.Start("ixConfigRequestUnloadedList")
		net.SendToServer()
	end

	self:Populate()
end

function PANEL:OnPluginToggled(uniqueID, bEnabled)
	net.Start("ixConfigPluginToggle")
		net.WriteString(uniqueID)
		net.WriteBool(bEnabled)
	net.SendToServer()
end

function PANEL:Populate()
	local loaded = self:AddCategory(self.loadedCategory)
	loaded.Paint = function(me, w, h)
		draw.RoundedBox(0, 0, 0, w, h, darkblue)
		-- left & right --
		draw.RoundedBox(0, 0, 0, 1, h, lightblue)
		draw.RoundedBox(0, w - 1, 0, 1, h, lightblue)
		draw.RoundedBox(0, 1, 0, 1, h, darkblue)
		draw.RoundedBox(0, w - 2, 0, 1, h, darkblue)
		-- bottom --
		draw.RoundedBox(0, 0, h - 1, w, 1, lightblue)
		draw.RoundedBox(0, 0, h - 2, w, 1, lightblue)
		draw.RoundedBox(0, 0, h - 3, w, 1, darkblue)
		-- top --
		draw.RoundedBox(0, 0, 0, w, 2, lightblue)

		-- frame --
		draw.RoundedBox(0, w/4.675, 0, w - w/2.3375, 2, lightblue)
		draw.RoundedBox(0, w/4.65, 1, w - w/2.325, 2, darkblue)
		draw.RoundedBox(0, w/4.625, 3, w - w/2.3125, 2, darkblue)
		draw.RoundedBox(0, w/4.6, 5, w - w/2.3, 2, darkblue)
		draw.RoundedBox(0, w/4.575, 7, w - w/2.2875, 2, darkblue)
		draw.RoundedBox(0, w/4.55, 9, w - w/2.275, 2, darkblue)
		draw.RoundedBox(0, w/4.525, 11, w - w/2.2625, 2, darkblue)
		draw.RoundedBox(0, w/4.5, 13, w - w/2.25 - 1, 2, darkblue)
		draw.RoundedBox(0, w/4.465, 15, w - w/2.2325 + 1, 2, darkblue)
		draw.RoundedBox(0, w/4.445, 17, w - w/2.2225, 2, darkblue)
		draw.RoundedBox(0, w/4.420, 19, w - w/2.21, 2, darkblue)
		draw.RoundedBox(0, w/4.395, 21, w - w/2.1975, 2, darkblue)
		draw.RoundedBox(0, w/4.370, 23, w - w/2.185, 2, darkblue)
		draw.RoundedBox(0, w/4.345, 25, w - w/2.1725 + 1, 2, darkblue)
		draw.RoundedBox(0, w/4.320, 27, w - w/2.16 + 1, 2, darkblue)
		surface.SetDrawColor(lightblue)
		surface.DrawLine(w/4.675, 0, w/4.320, 29)
		surface.DrawLine(w/4.675 - 1, 0, w/4.320, 28)
		surface.SetDrawColor(lightblue)
		surface.DrawLine(w - w/4.675 - 1, 0, w - w/4.32 - 2, 29)
		surface.DrawLine(w - w/4.675 - 2, 0, w - w/4.32 - 2, 28)
		surface.DrawLine(w/4.320, 29, w - w/4.32 - 1, 29)
		surface.DrawLine(w/4.320, 28, w - w/4.32 - 1, 28)


		surface.SetTextColor(Color(56, 61, 248, 225))
		surface.SetFont('cellar.derma.blur')
		surface.SetTextPos(w * .5 - surface.GetTextSize(self.loadedCategory) * .5, 3)
		surface.DrawText(self.loadedCategory)


		surface.SetTextColor(lightblue)
		surface.SetFont('cellar.derma')
		surface.SetTextPos(w * .5 - surface.GetTextSize(self.loadedCategory) * .5, 3)
		surface.DrawText(self.loadedCategory)
	end
	local unloaded = self:AddCategory(self.unloadedCategory)
	unloaded.Paint = function(me, w, h)
		draw.RoundedBox(0, 0, 0, w, h, darkblue)
		-- left & right --
		draw.RoundedBox(0, 0, 0, 1, h, lightblue)
		draw.RoundedBox(0, w - 1, 0, 1, h, lightblue)
		draw.RoundedBox(0, 1, 0, 1, h, darkblue)
		draw.RoundedBox(0, w - 2, 0, 1, h, darkblue)
		-- bottom --
		draw.RoundedBox(0, 0, h - 1, w, 1, lightblue)
		draw.RoundedBox(0, 0, h - 2, w, 1, lightblue)
		draw.RoundedBox(0, 0, h - 3, w, 1, darkblue)
		-- top --
		draw.RoundedBox(0, 0, 0, w, 2, lightblue)

		-- frame --
		draw.RoundedBox(0, w/4.675, 0, w - w/2.3375, 2, lightblue)
		draw.RoundedBox(0, w/4.65, 1, w - w/2.325, 2, darkblue)
		draw.RoundedBox(0, w/4.625, 3, w - w/2.3125, 2, darkblue)
		draw.RoundedBox(0, w/4.6, 5, w - w/2.3, 2, darkblue)
		draw.RoundedBox(0, w/4.575, 7, w - w/2.2875, 2, darkblue)
		draw.RoundedBox(0, w/4.55, 9, w - w/2.275, 2, darkblue)
		draw.RoundedBox(0, w/4.525, 11, w - w/2.2625, 2, darkblue)
		draw.RoundedBox(0, w/4.5, 13, w - w/2.25 - 1, 2, darkblue)
		draw.RoundedBox(0, w/4.465, 15, w - w/2.2325 + 1, 2, darkblue)
		draw.RoundedBox(0, w/4.445, 17, w - w/2.2225, 2, darkblue)
		draw.RoundedBox(0, w/4.420, 19, w - w/2.21, 2, darkblue)
		draw.RoundedBox(0, w/4.395, 21, w - w/2.1975, 2, darkblue)
		draw.RoundedBox(0, w/4.370, 23, w - w/2.185, 2, darkblue)
		draw.RoundedBox(0, w/4.345, 25, w - w/2.1725 + 1, 2, darkblue)
		draw.RoundedBox(0, w/4.320, 27, w - w/2.16 + 1, 2, darkblue)
		surface.SetDrawColor(lightblue)
		surface.DrawLine(w/4.675, 0, w/4.320, 29)
		surface.DrawLine(w/4.675 - 1, 0, w/4.320, 28)
		surface.SetDrawColor(lightblue)
		surface.DrawLine(w - w/4.675 - 1, 0, w - w/4.32 - 2, 29)
		surface.DrawLine(w - w/4.675 - 2, 0, w - w/4.32 - 2, 28)
		surface.DrawLine(w/4.320, 29, w - w/4.32 - 1, 29)
		surface.DrawLine(w/4.320, 28, w - w/4.32 - 1, 28)


		surface.SetTextColor(Color(56, 61, 248, 225))
		surface.SetFont('cellar.derma.blur')
		surface.SetTextPos(w * .5 - surface.GetTextSize(self.unloadedCategory) * .5, 3)
		surface.DrawText(self.unloadedCategory)


		surface.SetTextColor(lightblue)
		surface.SetFont('cellar.derma')
		surface.SetTextPos(w * .5 - surface.GetTextSize(self.unloadedCategory) * .5, 3)
		surface.DrawText(self.unloadedCategory)
	end

	-- add loaded plugins
	for k, v in SortedPairsByMemberValue(ix.plugin.list, "name") do
		local row = self:AddRow(ix.type.bool, self.loadedCategory)
		row.id = k

		row.setting:SetEnabledText(L("on"):utf8upper())
		row.setting:SetDisabledText(L("off"):utf8upper())
		row.setting:SizeToContents()

		-- if this plugin is not in the unloaded list currently, then it's queued for an unload
		row:SetValue(!ix.plugin.unloaded[k], true)
		row:SetText(v.name)
		row.Paint = function(me, w, h)
			draw.SimpleText(v.name, 'cellar.derma.medium.blur', 4, h/2, Color(56, 61, 248, 225), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		row.OnValueChanged = function(panel, bEnabled)
			self:OnPluginToggled(k, bEnabled)
		end

		row:GetLabel():SetHelixTooltip(function(tooltip)
			local title = tooltip:AddRow("name")
			title:SetImportant()
			title:SetText(v.name)
			title:SizeToContents()
			title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

			local description = tooltip:AddRow("description")
			description:SetText(v.description)
			description:SizeToContents()
		end)
	end

	self:UpdateUnloaded(true)
	self:SizeToContents()
end

function PANEL:UpdatePlugin(uniqueID, bEnabled)
	for _, v in pairs(self:GetRows()) do
		if (v.id == uniqueID) then
			v:SetValue(bEnabled, true)
		end
	end
end

-- called from Populate and from the ixConfigUnloadedList net message
function PANEL:UpdateUnloaded(bNoSizeToContents)
	for _, v in pairs(self:GetRows()) do
		if (ix.plugin.unloaded[v.id]) then
			v:SetValue(false, true)
		end
	end

	for k, _ in SortedPairs(ix.plugin.unloaded) do
		if (ix.plugin.list[k]) then
			-- if this plugin is in the loaded plugins list then it's queued for an unload - don't display it in this category
			continue
		end

		local row = self:AddRow(ix.type.bool, self.unloadedCategory)
		row:SetText(k)
		row:SetValue(false, true)

		row.OnValueChanged = function(panel, bEnabled)
			self:OnPluginToggled(k, bEnabled)
		end
	end

	if (!bNoSizeToContents) then
		self:SizeToContents()
	end
end

vgui.Register("ixPluginManager", PANEL, "ixSettings")
