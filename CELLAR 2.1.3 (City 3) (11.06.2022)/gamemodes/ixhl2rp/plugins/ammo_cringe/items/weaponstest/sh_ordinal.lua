ITEM.name = "Пулемет Ординала"
ITEM.description = "Тяжелый пулемет производства Вселенского Союза, предназначенный для использования отрядами подавления Солдат Патруля."
ITEM.model = "models/hlvr/weapons/w_suppressor/suppressor_weapon_hlvr.mdl"
ITEM.class = "arccw_ordinal"
ITEM.weaponCategory = "primary"
ITEM.rarity = 3
ITEM.width = 5
ITEM.height = 2
ITEM.hasLock = true
ITEM.impulse = true
ITEM.iconCam = {
	pos = Vector(404, 340, 250),
	ang = Angle(24, -139, -19),
	fov = 4,
}
ITEM.Attack = 18
ITEM.DistanceSkillMod = {
	[1] = 5,
	[2] = 3,
	[3] = 1,
	[4] = -2
}
ITEM.Info = {
	Type = nil,
	Skill = "impulse",
	Distance = {
		[1] = 5,
		[2] = 3,
		[3] = 1,
		[4] = -2
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 60,
		Shock = {100, 1900},
		Blood = {30, 360},
		Bleed = 5
	}
}


