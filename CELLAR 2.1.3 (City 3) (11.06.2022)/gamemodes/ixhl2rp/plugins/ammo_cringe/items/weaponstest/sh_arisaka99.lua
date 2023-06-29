ITEM.name = "Arisaka Type 99"
ITEM.description = "Стандартная пехотная винтовка Императорской армии и флота Японии во время Второй мировой войны. По сравнению с другими винтовками того времени, она относительно легкая и стреляет патроном меньшего размера."
ITEM.model = "models/weapons/arccw/w_waw_arisaka.mdl"
ITEM.class = "arccw_waw_arisaka"
ITEM.weaponCategory = "primary"
ITEM.width = 5
ITEM.height = 2
ITEM.rarity = 3
ITEM.iconCam = {
	ang	= Angle(-0.020070368424058, 270.40155029297, 0),
	fov	= 7.2253324508038,
	pos	= Vector(0, 200, -1)
}
ITEM.Attack = 16
ITEM.DistanceSkillMod = {
	[1] = 5,
	[2] = 5,
	[3] = 3,
	[4] = 1
}
ITEM.Info = {
	Type = nil,
	Skill = "guns",
	Distance = {
		[1] = 5,
		[2] = 5,
		[3] = 3,
		[4] = 1
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 60,
		Shock = {200, 2000},
		Blood = {60, 666},
		Bleed = 70
	}
}


