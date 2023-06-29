ITEM.name = "Комплект униформы бойца НОАК Тип 3"
ITEM.description = "Стандартный комплект униформы бойца НОАК Тип 3."
ITEM.category = "НОАК"
ITEM.model = "models/props_c17/SuitCase001a.mdl"
ITEM.slot = EQUIP_TORSO
ITEM.isOutfit = true
ITEM.width = 2
ITEM.height = 2
ITEM.CanBreakDown = false
ITEM.genderReplacement = {
	[GENDER_MALE] = "models/cellar/characters/city3/pla/male/male_pla.mdl",
	[GENDER_FEMALE] = "models/cellar/characters/city3/pla/female/female_pla.mdl"
}
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[2] = 1,
	[3] = 1,
	[4] = 1,
	[5] = 4,
	[8] = 1,
}

ITEM.Stats = {
	[HITGROUP_GENERIC] = 10,
	[HITGROUP_HEAD] = 16,
	[HITGROUP_CHEST] = 30,
	[HITGROUP_STOMACH] = 20,
	[4] = 10, -- hands
	[5] = 10, -- legs
}
ITEM.rarity = 3
ITEM.thermalIsolation = 4
