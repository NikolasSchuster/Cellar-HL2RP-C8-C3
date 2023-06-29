ix.loot = {}
ix.loot.stored = ix.loot.stored or {}

local LOOT_STORE = {}
LOOT_STORE.__index = LOOT_STORE
LOOT_STORE.IsLootStore = true
LOOT_STORE.chance = 0

function LOOT_STORE:__tostring()
	return "LOOTSTORE"
end

function LOOT_STORE:Roll(rate, client)
	if self.chance > 100 then
		return true
	end

	return (self.chance * (rate and 1 or 1)) > math.Rand(0, 100) --GetDropRate(itemTable:GetData("Rarity"))
end

local LOOT_GROUP = {}
LOOT_GROUP.__index = LOOT_GROUP
LOOT_GROUP.IsLootGroup = true

function LOOT_GROUP:__tostring()
	return "LOOTGROUP"
end

function LOOT_GROUP:AddEntry(data)
	if data.chance != 0 then
		self.explicitlyChanced[#self.explicitlyChanced + 1] = data
	else
		self.equalChanced[#self.equalChanced + 1] = data
	end
end

function LOOT_GROUP:Roll(client)
	if self.explicitlyChanced then
		local total = 0 
		for i, loot in ipairs(self.explicitlyChanced) do
			total = total + loot.chance 
		end

		local roll = math.Rand(0, math.max(total, 100))

		for i, loot in ipairs(self.explicitlyChanced) do
			if loot.chance >= 100 then
				return loot
			end

			roll = roll - loot.chance

			if roll < 0 then
				return loot
			end
		end
	end

	if self.equalChanced then
		local loot = self.equalChanced[math.random(1, #self.equalChanced)]
		return (loot and loot or nil)
	end

	return
end

local LOOT_TEMPLATE = {}
LOOT_TEMPLATE.__index = LOOT_TEMPLATE
LOOT_TEMPLATE.groups = {}
LOOT_TEMPLATE.entries = {}
LOOT_TEMPLATE.uniqueID = "base_loottemplate"

function LOOT_TEMPLATE:__tostring()
	return "LOOTTEMPLATE["..self.uniqueID.."]"
end

function LOOT_TEMPLATE:AddEntry(lootTable)
	if lootTable.IsLootGroup then
		self.groups[#self.groups + 1] = lootTable
	elseif lootTable.IsLootStore then
		self.entries[#self.entries + 1] = lootTable
	end
end

function LOOT_TEMPLATE:Process(loot, rate, client)
	for k, v in ipairs(self.entries) do
		if !v:Roll(rate, client) then continue end
		
		loot[#loot + 1] = v.id
	end

	for k, v in ipairs(self.groups) do
		local class = v:Roll(client)

		if class then
			loot[#loot + 1] = class.id
		end
	end

	return loot
end

function LOOT_TEMPLATE:Register()
	ix.loot.Register(self)
end

function ix.loot.NewLoot(itemID, chance)
	local object = setmetatable({}, LOOT_STORE)
	object.id = itemID or "error"
	object.chance = tonumber(chance) or 0

	return object
end

function ix.loot.NewLootGroup()
	local object = setmetatable({}, LOOT_GROUP)
	object.explicitlyChanced = {}
	object.equalChanced = {}

	return object
end

function ix.loot.NewLootTemplate(uniqueID)
	if !uniqueID or !isstring(uniqueID) then 
		return 
	end
	
	local object = setmetatable({}, LOOT_TEMPLATE)
	object.uniqueID = uniqueID
	object.groups = {}
	object.entries = {}

	return object
end

function ix.loot.Register(loottemplate)
	ix.loot.stored[loottemplate.uniqueID] = loottemplate

	return loottemplate.uniqueID
end

function ix.loot.Get(id)
	return ix.loot.stored[id]
end