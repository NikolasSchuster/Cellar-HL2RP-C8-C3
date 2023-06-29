ITEM.name = "Униформа медика ГО с визором"
ITEM.description = "Униформа медика Гражданской Обороны с визором."
ITEM.genderReplacement = {
	[GENDER_MALE] = "models/cellar/characters/metropolice/male.mdl",
	[GENDER_FEMALE] = "models/cellar/characters/metropolice/female.mdl"
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 5,
	[HITGROUP_CHEST] = 10,
	[HITGROUP_STOMACH] = 5,
	[4] = 5,
	[5] = 5,
}
ITEM.ReplaceOnDeath = "Униформа медика с бронежилетом"
ITEM.WeaponSkillBuff = 3
ITEM.uniform = 1
ITEM.primaryVisor = Vector(0.75, 0.2, 0.1)
ITEM.secondaryVisor = Vector(0.75, 0.2, 0.1)
ITEM.specialization = "m"
ITEM.bodyGroups = {
	[2] = 1,
	[6] = 3
}