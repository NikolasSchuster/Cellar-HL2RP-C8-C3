ITEM.name = "Ration Base"
ITEM.model = Model("models/weapons/w_package.mdl")
ITEM.description = "A ration item."
ITEM.category = "categoryRation"
ITEM.supplements = "supplements_minimal"
ITEM.water = "water"
ITEM.extra = nil
ITEM.randomTable = {}

ITEM.functions.Open = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local character = client:GetCharacter()

		if (itemTable.cash) then
			character:GiveMoney(itemTable.cash)
		end

		local items = {}

		if (itemTable.supplements) then
			items[#items + 1] = itemTable.supplements
		end

		if (itemTable.water) then
			items[#items + 1] = itemTable.water
		end

		if (istable(itemTable.extra) or isstring(itemTable.extra)) then
			items[#items + 1] = istable(itemTable.extra) and itemTable.extra[math.random(1, #itemTable.extra)] or itemTable.extra
		end

		for _, tbl in ipairs(itemTable.randomTable) do
			if (math.random(1, tbl.chance) == 2) then
				items[#items + 1] = istable(tbl.items) and tbl.items[math.random(1, #tbl.items)] or tbl.items
				break
			end
		end

		for _, v in ipairs(items) do
			if (!character:GetInventory():Add(v)) then
				ix.item.Spawn(v, client)
			end
		end

		local data = {["D"] = itemTable.PrintName}
		if !character:GetInventory():Add("empty_ration", nil, data) then
			ix.item.Spawn("empty_ration", client, nil, nil, data)
		end
	end
}
