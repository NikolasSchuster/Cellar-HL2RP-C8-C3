ITEM.name = "Продвинутая маска"
ITEM.description = "Продвинутая маска-противогаз Гражданской Обороны без визора и с упрощенной системой фильтрации."
ITEM.model = Model("models/vintagethief/items/cca/mask_01.mdl")
ITEM.rarity = 2
ITEM.bodyGroups = {
	[2] = 2,
}
ITEM.Filters = {
	["filter_epic"] = false,
	["filter_good"] = true,
	["filter_medium"] = true,
	["filter_standard"] = false
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 10,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0,
	[5] = 0,
}
ITEM.CPMask = true
ITEM.visorLevel = 1
ITEM.withOutfit = true