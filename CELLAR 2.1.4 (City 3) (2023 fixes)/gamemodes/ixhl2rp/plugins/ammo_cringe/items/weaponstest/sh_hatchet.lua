ITEM.name = "Топорик"
ITEM.description = "Маленький топорик с пошатывающейся деревянной рукоядью. Заточен плохо, но, в принципе, в этом есть один плюс - в случае попадания по незащищенным частям тела он сможет гарантировать множество порезов, а также то, что части металла смогут застрять в теле врага. К слову, кидаться им не стоит - слишком тяжелый даже для маленького топорика."
ITEM.model = "models/weapons/tfa_nmrih/w_me_hatchet.mdl"
ITEM.class = "arccw_hatchet"
ITEM.weaponCategory = "melee"
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(196.55116271973, 163.98435974121, 119.02098846436),
	ang = Angle(25, 220, 91.802291870117),
	fov = 4.7505054378407,
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