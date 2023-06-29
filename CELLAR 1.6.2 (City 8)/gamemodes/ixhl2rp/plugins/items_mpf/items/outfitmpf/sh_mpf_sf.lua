ITEM.name = "Униформа офицера-спецназа ГО"
ITEM.description = "Униформа офицера-спецназа Гражданской Обороны с разгрузкой и бронемаской."
ITEM.genderReplacement = {
	[GENDER_MALE] = "models/cellar/characters/metropolice/male.mdl",
	[GENDER_FEMALE] = "models/cellar/characters/metropolice/female.mdl"
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 15,
	[HITGROUP_CHEST] = 10,
	[HITGROUP_STOMACH] = 10,
	[4] = 5, -- hands
	[5] = 5, -- legs
}
ITEM.ReplaceOnDeath = "Зеленая рубаха с бронежилетом MOLLE"
ITEM.WeaponSkillBuff = 5
ITEM.uniform = 2
ITEM.primaryVisor = Vector(1, 5, 1)
ITEM.secondaryVisor = Vector(0.1, 0.5, 0.1)
ITEM.specialization = "sF"
ITEM.bodyGroups = {
	[2] = 1,
	[3] = 1,
	[4] = 1,
	[6] = 2
}