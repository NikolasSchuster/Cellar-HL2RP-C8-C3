ITEM.name = "Dominator"
ITEM.description = "Уникальный энергетический пулемет ручной сборки. Гравировка в области приклада: Made by John Law and Michael Frauch"
ITEM.model = "models/weapons/arccw/fml/w_volked_pkp.mdl"
ITEM.class = "arccw_dominator"
ITEM.weaponCategory = "primary"
ITEM.rarity = 2
ITEM.width = 5
ITEM.height = 2
ITEM.Attack = 19
ITEM.category = "Уникальное"
ITEM.DistanceSkillMod = {
	[1] = 5,
	[2] = 5,
	[3] = 2,
	[4] = -3
}
ITEM.Info = {
	Type = nil,
	Skill = "impulse",
	Distance = {
		[1] = 5,
		[2] = 5,
		[3] = 2,
		[4] = -3
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 30,
		Shock = {120, 1600},
		Blood = {40, 400},
		Bleed = 50
	}
}


