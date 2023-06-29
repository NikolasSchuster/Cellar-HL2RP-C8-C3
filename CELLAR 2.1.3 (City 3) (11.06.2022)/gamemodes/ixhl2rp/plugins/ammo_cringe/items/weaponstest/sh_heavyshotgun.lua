ITEM.name = "Импульсный дробовик"
ITEM.description = "Тяжелый импульсный дробовик производства Вселенского Союза. Очень разрушительное оружие в тесных пространствах."
ITEM.model = "models/hlvr/weapons/w_shotgun_heavy/w_shotgun_heavy_hlvr.mdl"
ITEM.class = "arccw_heavyshotgun"
ITEM.weaponCategory = "primary"
ITEM.width = 3
ITEM.height = 2
ITEM.hasLock = true
ITEM.impulse = true
ITEM.iconCam = {
	pos = Vector(-200, 5.289870262146, 1.5059641599655),
	ang = Angle(0, -0, 0),
	fov = 9.8072509180853,
}
ITEM.Attack = 13
ITEM.DistanceSkillMod = {
	[1] = 8,
	[2] = 1,
	[3] = -3,
	[4] = -6
}
ITEM.Info = {
	Type = nil,
	Skill = "impulse",
	Distance = {
		[1] = 8,
		[2] = 1,
		[3] = -3,
		[4] = -6
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 34,
		Shock = {600, 30000},
		Blood = {220, 800},
		Bleed = 5
	}
}