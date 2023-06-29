
local PLUGIN = PLUGIN
PLUGIN.meta = PLUGIN.meta or {}

local RECIPE = PLUGIN.meta.recipe or {}
RECIPE.__index = RECIPE
RECIPE.name = "undefined"
RECIPE.description = "undefined"
RECIPE.uniqueID = "undefined"
RECIPE.category = "Разное"

function RECIPE:GetName()
	return self.name
end

function RECIPE:GetDescription()
	return self.description
end

function RECIPE:GetSkin()
	return self.skin
end

function RECIPE:GetModel()
	return self.model
end

function RECIPE:PreHook(name, func)
	if (!self.preHooks) then
		self.preHooks = {}
	end

	self.preHooks[name] = func
end

function RECIPE:PostHook(name, func)
	if (!self.postHooks) then
		self.postHooks = {}
	end

	self.postHooks[name] = func
end

function RECIPE:OnCanSee(client)
	local character = client:GetCharacter()

	if (!character) then
		return false
	end

	if (self.preHooks and self.preHooks["OnCanSee"]) then
		local a, b, c, d, e, f = self.preHooks["OnCanSee"](self, client)

		if (a != nil) then
			return a, b, c, d, e, f
		end
	end

	if (self.flag and !character:HasFlags(self.flag)) then
		return false
	end

	if (self.postHooks and self.postHooks["OnCanSee"]) then
		local a, b, c, d, e, f = self.postHooks["OnCanSee"](self, client)

		if (a != nil) then
			return a, b, c, d, e, f
		end
	end

	return true
end

function RECIPE:OnCanCraft(client)
	local character = client:GetCharacter()

	if (!character) then
		return false
	end

	if (self.preHooks and self.preHooks["OnCanCraft"]) then
		local a, b, c, d, e, f = self.preHooks["OnCanCraft"](self, client)

		if (a != nil) then
			return a, b, c, d, e, f
		end
	end

	local inventory = character:GetInventory()
	local bHasItems, bHasTools
	local missing = ""

	if (self.flag and !character:HasFlags(self.flag)) then
		return false, "@CraftMissingFlag", self.flag
	end

	if self.station and IsValid(client.ixStation) and client.ixStation:GetStationTable().uniqueID != self.station then
		local stationInfo = PLUGIN.craft.stations[self.station]

		return false, "Необходимо использовать %s!", stationInfo.GetName and stationInfo:GetName() or L(stationInfo.name)
	end

	if istable(self.skill) then
		local skill = self.skill[1]
		local skillTable = ix.skills.list[skill]

		if skillTable then
			local needed = tonumber(self.skill[2])
			local ourSkill = character:GetSkillModified(skill)

			if ourSkill < needed then
				if IsValid(client) then
					return false, "Необходим навык %s!", string.format("%s %s", L(skillTable.name, client), needed)
				else
					return false, "Необходим навык %s!", string.format("%s %s", L(skillTable.name), needed)
				end
			end
		end
	end

	for uniqueID, amount in pairs(self.requirements or {}) do
		if (inventory:GetItemCount(uniqueID) < amount) then
			local itemTable = ix.item.Get(uniqueID)
			bHasItems = false

			missing = missing..(itemTable and itemTable.name or uniqueID)..", "
		end
	end

	if istable(self.requirementsChoose) then
		local hasItems = {}

		for id, entry in ipairs(self.requirementsChoose) do
			hasItems[id] = hasItems[id] or 0
			
			for _, itemTable in pairs(inventory:GetItems()) do
				if entry[1][itemTable.uniqueID] and hasItems[id] < entry[2] then
					hasItems[id] = hasItems[id] + 1
				end
			end

			if hasItems[id] < entry[2] then
				bHasItems = false

				missing = missing..entry[3]..", "
			end
		end
	end

	if (missing != "") then
		missing = missing:sub(1, -3)
	end

	if (bHasItems == false) then
		return false, "Нет необходимых предметов: %s", missing
	end

	for _, uniqueID in pairs(self.tools or {}) do
		if (!inventory:HasItem(uniqueID)) then
			local itemTable = ix.item.Get(uniqueID)
			bHasTools = false

			missing = itemTable and itemTable.name or uniqueID

			break
		end
	end

	if (bHasTools == false) then
		return false, "Нет необходимых инструментов %s", missing
	end

	if (self.postHooks and self.postHooks["OnCanCraft"]) then
		local a, b, c, d, e, f = self.postHooks["OnCanCraft"](self, client)

		if (a != nil) then
			return a, b, c, d, e, f
		end
	end

	return true
end

if (SERVER) then
	function RECIPE:OnCraft(client)
		local bCanCraft, failString, c, d, e, f = self:OnCanCraft(client)

		if (bCanCraft == false) then
			return false, failString, c, d, e, f
		end

		if (self.preHooks and self.preHooks["OnCraft"]) then
			local a, b, c, d, e, f = self.preHooks["OnCraft"](self, client)

			if (a != nil) then
				return a, b, c, d, e, f
			end
		end

		local character = client:GetCharacter()
		local inventory = character:GetInventory()

		local xp = 0

		if (self.requirements) then
			local removedItems = {}

			for _, itemTable in pairs(inventory:GetItems()) do
				local uniqueID = itemTable.uniqueID

				if (self.requirements[uniqueID]) then
					local amountRemoved = removedItems[uniqueID] or 0
					local amount = self.requirements[uniqueID]

					if (amountRemoved < amount) then
						xp = xp + (itemTable.cost or 0)

						itemTable:Remove()

						removedItems[uniqueID] = amountRemoved + 1
					end
				end
			end
		end

		if self.requirementsChoose then
			local removedItems = {}

			for id, entry in ipairs(self.requirementsChoose) do
				local amount = entry[2]

				for _, itemTable in pairs(inventory:GetItems()) do
					local uniqueID = itemTable.uniqueID

					if entry[1][uniqueID] then
						local amountRemoved = removedItems[id] or 0

						if amountRemoved < amount then
							xp = xp + (itemTable.cost or 0)

							itemTable:Remove()

							removedItems[id] = amountRemoved + 1
						end
					end
				end
			end
		end

		if self.skill then
			for k, v in pairs(self.tools or {}) do
				xp = xp + ((ix.item.list[v] or {}).cost or 0)
			end

			if self.xp then
				xp = self.xp
			end

			character:DoAction("craft_"..self.skill[1], xp)
		end

		for uniqueID, amount in pairs(self.results or {}) do
			if (istable(amount)) then
				if (amount["min"] and amount["max"]) then
					amount = math.random(amount["min"], amount["max"])
				else
					amount = amount[math.random(1, #amount)]
				end
			end

			for i = 1, amount do
				if (!inventory:Add(uniqueID)) then
					ix.item.Spawn(uniqueID, client)
				end
			end
		end


		if (self.postHooks and self.postHooks["OnCraft"]) then
			local a, b, c, d, e, f = self.postHooks["OnCraft"](self, client)

			if (a != nil) then
				return a, b, c, d, e, f
			end
		end

		return true, "Вы успешно создали %s!", self.GetName and self:GetName() or self.name
	end
end

PLUGIN.meta.recipe = RECIPE
