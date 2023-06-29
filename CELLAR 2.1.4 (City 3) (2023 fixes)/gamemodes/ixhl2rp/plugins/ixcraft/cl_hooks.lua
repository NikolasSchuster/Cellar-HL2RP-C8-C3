
local PLUGIN = PLUGIN

function PLUGIN:BuildCraftingMenu()
	if (table.IsEmpty(self.craft.GetCategories(LocalPlayer()))) then
		return false
	end
end

function PLUGIN:PopulateRecipeTooltip(tooltip, recipe)
	local canCraft, failString, c, d, e, f = recipe:OnCanCraft(LocalPlayer())

	local item

	for class, _ in pairs(recipe.results) do
		item = ix.item.list[class]
		break
	end

	local name = tooltip:AddRow("name")
	name:SetImportant()
	name:SetText(recipe.category..": "..(recipe.GetName and recipe:GetName() or L(recipe.name)))
	name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
	name:SizeToContents()

	if (!canCraft) then
		local errorRow = tooltip:AddRow("errorRow")
		errorRow:SetText(string.format(failString, c))
		errorRow:SetBackgroundColor(Color(255,24,0))
		errorRow:SizeToContents()
	end

	local description = tooltip:AddRow("description")
	description:SetText(L(item.description) or (recipe.GetDescription and recipe:GetDescription() or L(recipe.description)))
	description:SizeToContents()

	local xp = 0

	if (recipe.tools) then
		local tools = tooltip:AddRow("tools")
		tools:SetText("Инструменты")
		tools:SetBackgroundColor(Color(150,150,25))
		tools:SizeToContents()

		local toolString = ""

		for _, v in pairs(recipe.tools) do
			local itemTable = ix.item.Get(v)
			local itemName = v

			if (itemTable) then
			    itemName = itemTable.GetName and itemTable:GetName() or itemTable.name
			    xp = xp + (itemTable.cost or 0)
			end

			toolString = toolString..itemName..", "
		end

		if (toolString != "") then
			local tools = tooltip:AddRow("toolList")
			tools:SetText("- "..string.sub(toolString, 0, #toolString-2))
			tools:SizeToContents()
		end
	end

	local requirements = tooltip:AddRow("requirements")
	requirements:SetText("Рецепт")
	requirements:SetBackgroundColor(Color(25,150,150))
	requirements:SizeToContents()

	local requirementString = ""

	if recipe.requirements then
		for k, v in pairs(recipe.requirements) do
			local itemTable = ix.item.Get(k)
			local itemName = k

			if (itemTable) then
			    itemName = itemTable.GetName and itemTable:GetName() or itemTable.name
			    xp = xp + ((itemTable.cost or 0) * v)
			end

			requirementString = requirementString..v.."x "..itemName..", "
		end
	end

	if recipe.requirementsChoose then
		for id, entry in ipairs(recipe.requirementsChoose) do
			local count = 0
			local xpPer = 0
			for k, v in pairs(entry[1]) do
				local itemTable = ix.item.Get(k)

				if (itemTable) then
					count = count + 1
					xpPer = xpPer + (itemTable.cost or 0)
				end
			end

			xp = xp + ((xpPer * entry[2]) / count)

			requirementString = requirementString..entry[2].."x "..entry[3]..", "
		end
	end

	if (requirementString != "") then
		local requirement = tooltip:AddRow("ingredientList")
		requirement:SetText("- "..string.sub(requirementString, 0, #requirementString-2))
		requirement:SizeToContents()
	end

	if recipe.station then
		local stationInfo = self.craft.stations[recipe.station]

		if stationInfo then
			local station = tooltip:AddRow("station")
			station:SetText(string.format("- %s %s", "Необходимо находиться рядом с", stationInfo.GetName and stationInfo:GetName() or L(stationInfo.name)))
			station:SizeToContents()
		end
	end

	local skillName = ""

	if istable(recipe.skill) then
		local skill = recipe.skill[1]
		local skillTable = ix.skills.list[skill]

		if skillTable then
			skillName = L(skillTable.name)

			local value = recipe.skill[2]
			local s = tooltip:AddRow("skill")
			s:SetText(string.format("- %s %s %s", "Навык", skillName, value))
			s:SizeToContents()
		end
	end

	local result = tooltip:AddRow("result")
	result:SetText("Создаёт")
	result:SetBackgroundColor(derma.GetColor("Warning", tooltip))
	result:SizeToContents()

	local resultString = ""

	for k, v in pairs(recipe.results) do
		local itemTable = ix.item.Get(k)
		local itemName = k
		local amount = v

		if (itemTable) then
		    itemName = itemTable.GetName and itemTable:GetName() or itemTable.name
		end

		if (istable(v)) then
			if (v["min"] and v["max"]) then
				amount = v["min"].."-"..v["max"]
			else
				amount = v[1].."-"..v[#v]
			end
		end

		resultString = resultString..amount.."x "..itemName..", "
	end

	if (resultString != "") then
		local result = tooltip:AddRow("resultList")
		result:SetText("- "..string.sub(resultString, 0, #resultString-2))
		result:SizeToContents()
	end

	if istable(recipe.skill) then
		local int = LocalPlayer():GetCharacter():GetSpecial("in") or 1
		local intFactor = 0.15 + math.Clamp(math.Remap(int, 1, 5, 0, 0.85), 0, 0.85) + math.Clamp(math.Remap(int, 5, 10, 0, 0.5), 0, 0.5)

		if recipe.xp then
			xp = recipe.xp
		end
			
		local result = tooltip:AddRow("xp")
		result:SetText("- +"..string.format("%i опыта в навыке %s", xp * intFactor, skillName))
		result:SizeToContents()
	end

	if (recipe.PopulateTooltip) then
		recipe:PopulateTooltip(tooltip)
	end
end

function PLUGIN:PopulateStationTooltip(tooltip, station)
	local name = tooltip:AddRow("name")
	name:SetImportant()
	name:SetText(station.GetName and station:GetName() or L(station.name))
	name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
	name:SizeToContents()

	local description = tooltip:AddRow("description")
	description:SetText(station.GetDescription and station:GetDescription() or L(station.description))
	description:SizeToContents()

	if (station.PopulateTooltip) then
		station:PopulateTooltip(tooltip)
	end
end
