ITEM.name = "Противогаз M40"
ITEM.model = Model("models/cellar/items/city3/clothing/m40.mdl")
ITEM.width = 1 -- ширина
ITEM.height = 1 -- высота
ITEM.description = "Американский противогаз, разработанный во времена войны во Вьетнаме. Удобный и крепкий."
ITEM.slot = EQUIP_MASK -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[2] = 4
}
ITEM.rarity = 1
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.Filters = {
	["filter_epic"] = true,
	["filter_good"] = true,
	["filter_medium"] = true,
	["filter_standard"] = true
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 5,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0,
	[5] = 0,
}

function ITEM:CanEquip(client, slot)
	return !tobool(client:GetCharacter():GetEquipment():GetItemAtSlot("head"))
end