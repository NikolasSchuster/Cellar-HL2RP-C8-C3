ITEM.name = "Продвинутая маска с визором"
ITEM.description = "Продвинутая маска-противогаз Гражданской Обороны с визором и упрощенной системой фильтрации."
ITEM.model = Model("models/vintagethief/items/cca/mask_04.mdl")
ITEM.rarity = 2
ITEM.bodyGroups = {
	[4] = 5,
	[6] = 1
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
ITEM.WeaponSkillBuff = 3
ITEM.CPMask = true
ITEM.visorLevel = 2