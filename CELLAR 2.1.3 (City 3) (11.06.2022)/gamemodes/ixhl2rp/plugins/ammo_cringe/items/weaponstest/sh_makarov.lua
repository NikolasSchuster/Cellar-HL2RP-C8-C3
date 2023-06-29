ITEM.name = "Makarov"
ITEM.description = "Пистолет Макарова или ПМ - это самозарядный пистолет калибра 9х18 мм, разработанный Николаем Макаровым. В 1951 году он стал стандартным оружием вооруженных сил и милиции Советского Союза. Пистолет Макарова оставался на вооружении советской армии и милиции вплоть до распада СССР в 1991 году."
ITEM.model = "models/weapons/arccw_ins2/w_makarov.mdl"
ITEM.class = "arccw_makarov"
ITEM.weaponCategory = "sidearm"
ITEM.classes = {CLASS_EMP, CLASS_EOW}
ITEM.flag = "V"
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	ang	= Angle(0.33879372477531, 270.15808105469, 0),
	fov	= 5.0470897275697,
	pos	= Vector(0, 200, -1)
}

ITEM.Attack = 5
ITEM.DistanceSkillMod = {
	[1] = 8,
	[2] = 4,
	[3] = 1,
	[4] = -6
}
ITEM.Info = {
	Type = nil,
	Skill = "guns",
	Distance = {
		[1] = 5,
		[2] = 3,
		[3] = 0,
		[4] = -7
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 29,
		Shock = {111, 2000},
		Blood = {30, 140},
		Bleed = 50
	}
}