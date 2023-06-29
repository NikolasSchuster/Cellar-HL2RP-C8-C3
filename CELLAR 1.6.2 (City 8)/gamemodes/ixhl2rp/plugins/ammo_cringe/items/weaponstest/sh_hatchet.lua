ITEM.name = "Топорик"
ITEM.description = "Маленький топорик с пошатывающейся деревянной рукоядью. Заточен плохо, но, в принципе, в этом есть один плюс - в случае попадания по незащищенным частям тела он сможет гарантировать множество порезов, а также то, что части металла смогут застрять в теле врага. К слову, кидаться им не стоит - слишком тяжелый даже для маленького топорика."
ITEM.model = "models/weapons/tfa_nmrih/w_me_hatchet.mdl"
ITEM.class = "arccw_hatchet"
ITEM.weaponCategory = "melee"
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(2.5060362815857, 242.77778625488, -0.53251588344574),
	ang = Angle(0, -90, 90),
	fov = 5,
}
ITEM.Attack = 2
ITEM.Info = {
	Type = 2,
	Skill = "meleeguns",
	Dmg = {
		Attack = 2,
		Limb = 12,
		Shock = {222, 2000},
		Blood = {50, 200},
		Bleed = 95
	}
}