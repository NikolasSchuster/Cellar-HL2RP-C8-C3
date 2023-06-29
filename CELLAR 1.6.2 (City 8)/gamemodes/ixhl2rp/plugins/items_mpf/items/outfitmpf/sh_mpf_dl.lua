ITEM.name = "Униформа дивизионного лидера ГО"
ITEM.description = "Униформа дивизионного лидера Гражданской Обороны с бронемаской."
ITEM.genderReplacement = {
	[GENDER_MALE] = "models/cellar/characters/metropolice/male.mdl",
	[GENDER_FEMALE] = "models/cellar/characters/metropolice/female.mdl"
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 15,
	[HITGROUP_CHEST] = 10,
	[HITGROUP_STOMACH] = 10,
	[4] = 10, -- hands
	[5] = 10, -- legs
}
ITEM.WeaponSkillBuff = 5
ITEM.uniform = 3
ITEM.primaryVisor = Vector(0.1, 0, 2)
ITEM.secondaryVisor = Vector(0.1, 0, 2)
ITEM.specialization = nil
ITEM.bodyGroups = {
	[6] = 2
}