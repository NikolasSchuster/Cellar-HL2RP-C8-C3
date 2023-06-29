ITEM.name = "Комплект униформы бойца НОАК Тип 1"
ITEM.description = "Стандартный комплект униформы бойца НОАК Тип 1."
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
	[5] = 5,
	[8] = 1,
}

ITEM.Stats = {
	[HITGROUP_GENERIC] = 10,
	[HITGROUP_HEAD] = 14,
	[HITGROUP_CHEST] = 20,
	[HITGROUP_STOMACH] = 10,
	[4] = 10, -- hands
	[5] = 10, -- legs
}
ITEM.rarity = 1
ITEM.thermalIsolation = 4