ITEM.name = "SPAS-12"
ITEM.description = "Стандартный дробовик, который используется силами Гражданской Обороны и солдатами Патруля для боев на ближней дистанции. Патроны, которые используются для этого дробовика, обладают множеством дробинок, которые способны достать до врага даже на большой дистанции, но за подобное придется заплатить малой убойной силой. В остальном же - это идеальное оружие, чтобы убивать тех, кто решил испытать вас на ближней дистанции."
ITEM.model = "models/weapons/w_shotgun.mdl"
ITEM.class = "arccw_spas12"
ITEM.weaponCategory = "primary"
ITEM.classes = {CLASS_EOW}
ITEM.width = 3
ITEM.height = 1
ITEM.iconCam = {
    pos = Vector(0, 200, 1),
    ang = Angle(0, 270, 0),
    fov = 10
}

ITEM.Attack = 9
ITEM.DistanceSkillMod = {
	[1] = 5,
	[2] = 0,
	[3] = -2,
	[4] = -5
}
ITEM.Info = {
	Type = nil,
	Skill = "guns",
	Distance = {
		[1] = 5,
		[2] = 0,
		[3] = -2,
		[4] = -5
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 34,
		Shock = {555, 25000},
		Blood = {250, 500},
		Bleed = 75
	}
}