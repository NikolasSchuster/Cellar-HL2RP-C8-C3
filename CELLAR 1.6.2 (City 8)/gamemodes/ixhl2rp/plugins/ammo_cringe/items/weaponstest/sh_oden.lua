ITEM.name = "Штурмовой автомат"
ITEM.description = "Экспериментальная штурмовая винтовка крупного калибра выполненная из металла и пластика под нужды групп зачистки ульев, но в серию так и не пошла. Выглядит внушительно, весит соответствующе."
ITEM.model = "models/weapons/cod_mw2019/w_oden_mammaledition.mdl"
ITEM.class = "arccw_oden"
ITEM.weaponCategory = "primary"
ITEM.width = 2
ITEM.height = 2
ITEM.Attack = 19
ITEM.rarity = 3
ITEM.category = "Уникальное"
ITEM.DistanceSkillMod = {
	[1] = 4,
	[2] = 4,
	[3] = 4,
	[4] = -3
}
ITEM.Info = {
	Type = nil,
	Skill = "guns",
	Distance = {
		[1] = 4,
		[2] = 4,
		[3] = 4,
		[4] = -3
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 70,
		Shock = {100, 3000},
		Blood = {80, 800},
		Bleed = 75
	}
}
