ITEM.name = "Шлем OPS-Core Fast LE"
ITEM.description = [[Баллистический шлем произведенный компанией Ops-Core, 
популярный у спецподразделений всего мира. Имеет хорошие технические параметры, 
и очень легок. Может быть модифицирован различными 
компонентами, фонарями, приборами ночного видения, тепловизорами.]]
ITEM.model = Model("models/union_of_freedom/helmet4.mdl")
ITEM.rarity = 2
ITEM.bodyGroups = {
	[0] = 3,
}
ITEM.Filters = {
	["filter_epic"] = true,
	["filter_good"] = true,
	["filter_medium"] = true,
	["filter_standard"] = true
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 10,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0,
	[5] = 0,
}
ITEM.WeaponSkillBuff = 2
ITEM.CPMask = false
ITEM.visorLevel = 2
ITEM.withOutfit = true