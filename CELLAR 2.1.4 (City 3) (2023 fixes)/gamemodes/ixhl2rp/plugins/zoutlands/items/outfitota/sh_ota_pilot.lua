ITEM.name = "Комплект брони пилота Патруля"
ITEM.description = ""
ITEM.model = "models/props_c17/SuitCase001a.mdl"
ITEM.genderReplacement = {
	[GENDER_MALE] = "models/cellar/characters/city3/overwatch/ota_regular.mdl",
	[GENDER_FEMALE] = "models/cellar/characters/city3/overwatch/ota_regular.mdl"
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 10,
	[HITGROUP_HEAD] = 14,
	[HITGROUP_CHEST] = 20,
	[HITGROUP_STOMACH] = 10,
	[4] = 10, -- hands
	[5] = 10, -- legs
}
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[1] = 1,
}
ITEM.RadResist = 99.75
ITEM.primaryVisor = Vector(0.15, 0.8, 2)
ITEM.secondaryVisor = Vector(0.15, 0.8, 2)
ITEM.rarity = 2
ITEM.thermalIsolation = 4