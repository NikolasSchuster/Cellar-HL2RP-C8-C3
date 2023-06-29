ITEM.name = "RPG-7"
ITEM.description = "Российский переносной, многоразовый, неуправляемый, наплечный, противотанковый реактивный гранатомет. Прочность, простота, низкая стоимость и эффективность РПГ-7 сделали его самым широко используемым противотанковым оружием в мире."
ITEM.model = "models/weapons/arccw/c_bo1_rpg7.mdl"
ITEM.class = "arccw_bo1_rpg7"
ITEM.weaponCategory = "primary"
ITEM.width = 5
ITEM.rarity = 5
ITEM.height = 2
ITEM.iconCam = {
	ang	= Angle(-0.020070368424058, 270.40155029297, 0),
	fov	= 7.2253324508038,
	pos	= Vector(0, 200, -1)
}
ITEM.Attack = 50
ITEM.DistanceSkillMod = {
	[1] = 5,
	[2] = 5,
	[3] = 5,
	[4] = 5
}
ITEM.Info = {
	Type = nil,
	Skill = "guns",
	Distance = {
		[1] = 5,
		[2] = 5,
		[3] = 5,
		[4] = 5
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 666,
		Shock = {3000, 5000},
		Blood = {4000, 6000},
		Bleed = 99
	}
}


