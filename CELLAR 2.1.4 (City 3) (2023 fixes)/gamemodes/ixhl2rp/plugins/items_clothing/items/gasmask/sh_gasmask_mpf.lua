ITEM.name = "Маска без визора"
ITEM.description = "Стандартная маска-противогаз Гражданской Обороны без визора."
ITEM.model = Model("models/vintagethief/items/cca/mask_00.mdl")
ITEM.rarity = 2
ITEM.bodyGroups = {
	[2] = 1
}
ITEM.Filters = {
	["filter_epic"] = false,
	["filter_good"] = true,
	["filter_medium"] = true,
	["filter_standard"] = false
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 7,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0,
	[5] = 0,
}
ITEM.CPMask = true
ITEM.visorLevel = 1
ITEM.withOutfit = true