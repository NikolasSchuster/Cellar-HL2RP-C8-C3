ITEM.name = "Травматический пистолет"
ITEM.description = "Этот пистолет явно отличается от других. Он был довольно легок, а при стрельбе из него не выходит какого-либо дыма. Выглядит стильно, но судя по его частям он не может убить - лишь ранить, нанеся огромное количество гематом на тело врага. Главное - не целиться в глаза и другие мягкие части тела!"
ITEM.model = "models/weapons/bordelzio/arccw/hkvp70/wmodel/w_hk_vp70.mdl"
ITEM.class = "arccw_traumapistol"
ITEM.weaponCategory = "sidearm"
ITEM.width = 2
ITEM.height = 1
ITEM.Attack = 1
ITEM.DistanceSkillMod = {
	[1] = 10,
	[2] = 5,
	[3] = -4,
	[4] = -9
}
ITEM.Info = {
	Type = nil,
	Skill = "guns",
	Distance = {
		[1] = 10,
		[2] = 5,
		[3] = -4,
		[4] = -9
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 1,
		Shock = {375, 4500},
		Blood = {1, 1},
		Bleed = 0
	}
}