ITEM.name = "Бронированный шлем ГО"
ITEM.description = "Наилучшее изобретение на вооружении сил CCA, тактический шлем с умным интерфейсом, который хорошо защищает от пуль и помогает ориентироваться в бою."
ITEM.model = Model("models/items/mask_05.mdl")
ITEM.rarity = 3
ITEM.bodyGroups = {
	[1] = 1,
	[2] = 6
}
ITEM.Filters = {
	["filter_epic"] = true,
	["filter_good"] = true,
	["filter_medium"] = true,
	["filter_standard"] = false
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 18,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0,
	[5] = 0,
}
ITEM.WeaponSkillBuff = 5
ITEM.CPMask = true
ITEM.visorLevel = 2
ITEM.withOutfit = true