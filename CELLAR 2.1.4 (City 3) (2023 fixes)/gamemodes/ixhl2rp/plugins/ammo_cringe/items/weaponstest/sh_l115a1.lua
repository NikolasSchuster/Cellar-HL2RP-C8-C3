ITEM.name = "L115A1"
ITEM.description = "Высококалиберная снайперская винтовка, разработанная для полицейских и военных подразделений, работающих в холодную погоду. Известна тем, что в свое время установила рекорд самого дальнего снайперского выстрела в истории."
ITEM.model = "models/weapons/arccw/c_bo1_awm.mdl"
ITEM.class = "arccw_bo1_l96"
ITEM.weaponCategory = "primary"
ITEM.width = 5
ITEM.rarity = 5
ITEM.height = 2
ITEM.iconCam = {
	ang	= Angle(-0.020070368424058, 270.40155029297, 0),
	fov	= 7.2253324508038,
	pos	= Vector(0, 200, -1)
}
ITEM.Attack = 17
ITEM.DistanceSkillMod = {
	[1] = 5,
	[2] = 5,
	[3] = 5,
	[4] = 4
}
ITEM.Info = {
	Type = nil,
	Skill = "guns",
	Distance = {
		[1] = 5,
		[2] = 5,
		[3] = 5,
		[4] = 4
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 150,
		Shock = {200, 2000},
		Blood = {300, 700},
		Bleed = 90
	}
}


