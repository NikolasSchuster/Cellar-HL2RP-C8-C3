function PLUGIN:LoadFonts(font, genericFont)
	surface.CreateFont("ixAttributesFont", {
		font = "Roboto Lt",
		size = 20,
		extended = true,
		weight = 200
	})

	surface.CreateFont("ixAttributesBoldFont", {
		font = "Roboto Lt",
		size = 20,
		extended = true,
		weight = 200
	})
end

function PLUGIN:CanCreateCharacterInfo(suppress)
	suppress.attributes = true
end

local function CalculateWidestName(tbl)
	local highest = 0
	do
		local highs = {}
		for k, v in pairs(tbl) do
			surface.SetFont("ixAttributesFont")
			local w1 = surface.GetTextSize(L(v.name))
			highs[#highs+1] = w1

			highest = math.max(unpack(highs))
		end
	end

	return highest
end

function PLUGIN:CreateCharacterInfoCategory(self)
	local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

	if (character) then
		self.stats = self:Add("ixStatsPanel")
		self.stats:Dock(TOP)
		self.stats:DockMargin(0, 0, 0, 8)

		self.attributes = self.stats:Add("ixStatsPanelCategory")
		self.attributes:SetText(L("attributes"):upper())
		self.attributes:Dock(LEFT)

		self.skills = self.stats:Add("ixStatsPanelCategory")
		self.skills:SetText(L("skills"):upper())
		self.skills:Dock(FILL)
		self.skills:DockMargin(20, 0, 0, 0)

		local boost = character:GetSpecialBoosts()
		local skillboost = character:GetSkillBoosts()
		local w1 = CalculateWidestName(ix.specials.list)
		local w2 = CalculateWidestName(ix.skills.list)

		local bFirst = true

		self.attributes.offset = w1 * 1.2
		self.attributes:SetWide(w1 * 2)
		
		for k, v in SortedPairsByMemberValue(ix.specials.list, "weight") do
			local attributeBoost = 0

			if (boost[k]) then
				for _, bValue in pairs(boost[k]) do
					attributeBoost = attributeBoost + bValue
				end
			end

			local bar = self.attributes:Add("ixStatBar")
			bar:Dock(TOP)

			if (!bFirst) then
				bar:DockMargin(4, 1, 0, 0)
			else
				bar:DockMargin(4, 0, 0, 0)
				bFirst = false
			end

			local value = character:GetSpecial(k, 0)

			if (attributeBoost) then
				bar:SetValue(value - attributeBoost or 0)
			else
				bar:SetValue(value)
			end

			local maximum = v.maxValue or 10
			bar:SetMax(maximum)
			bar:SetReadOnly()
			bar:SetText(L(v.name), value, maximum)
			bar:SetDesc(L(v.description))

			if (attributeBoost) then
				bar:SetBoost(attributeBoost)
			end
		end

		self.limbs = self.attributes:Add("EditablePanel")
		self.limbs:Dock(TOP)
		self.limbs:DockMargin(0, 0, 0, 8)
		self.limbs:SetTall(260)

		self.limbsS = self.limbs:Add("ixLimbStatus")
		self.limbsS:SetPos(self:GetWide() / 6.25 - 60, 260 / 2 - 240 / 2)

		self.attributes:SizeToContents()

		self.skills.offset = w2 * 1.25
		self.skills:SetWide(w2 * 2)

		local bFirst = true

		for i = 1, 6 do
			self.skills.categories = self.skills.categories or {}
			self.skills.categories[i] = self.skills:Add("ixStatsPanel")
			self.skills.categories[i].offset = self.skills.offset
			self.skills.categories[i]:Dock(TOP)
			self.skills.categories[i]:DockMargin(0, 0, 0, 8)
		end

		local categories = {}
		for k, v in pairs(ix.skills.list) do
			categories[v.category] = categories[v.category] or {}
			categories[v.category][k] = L(v.name)
		end

		for k, v in pairs(categories) do
			for z, x in SortedPairs(v) do
				v = ix.skills.list[z]
				local sboost = 0

				if (skillboost[z]) then
					for _, bValue in pairs(skillboost[z]) do
						sboost = sboost + bValue
					end
				end

				local bar = self.skills.categories[k]:Add("ixStatBar")
				bar:Dock(TOP)


				if (!bFirst) then
					bar:DockMargin(4, 1, 4, 0)
				else
					bar:DockMargin(4, 0, 4, 0)
					bFirst = false
				end

				local value = character:GetSkillModified(z)

				if (sboost) then
					bar:SetValue(value - sboost or 0)
				else
					bar:SetValue(value)
				end

				local maximum = v:GetMaximum(character, character:GetSkills())
				bar.skill = z
				bar.xp = true
				bar:SetMax(maximum)
				bar:SetReadOnly()
				bar:SetText(L(v.name), Format("%i / %i", value, maximum))
				bar:SetDesc(L(v.description))

				if (sboost) then
					bar:SetBoost(sboost)
				end
			end
		end

		local y = 0
		for i = 1, 6 do
			self.skills.categories[i]:SizeToContents()

			local _, top, _, bottom = self.skills.categories[i]:GetDockMargin()
			y = y + self.skills.categories[i]:GetTall() + top + bottom
		end

		if (self.attributes:GetTall() < (y + 4)) then
			self.attributes:SetTall(0)
		end

		self.skills:SetTall(self.skills:GetTall() + y + 4)

		self.stats:SizeToContents()
	end
end