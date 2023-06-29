ITEM.name = "USP Match"
ITEM.description = "Стандартный пистолет, который используют силы Гражданской Обороны. Калибр 9mm прекрасно справляется с не бронированными и, что самое важное, безоружными целями. Типичный дизайн этого пистолета помогает с легкостью найти для него самые разные составные части, а калибр, который этот пистолет использует, довольно распространен. Идеально оружие для маленьких шалостей."
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "arccw_uspmatch"
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

ITEM.Attack = 3
ITEM.DistanceSkillMod = {
	[1] = 7,
	[2] = 3,
	[3] = 0,
	[4] = -7
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
		Limb = 26,
		Shock = {111, 2200},
		Blood = {25, 100},
		Bleed = 50
	}
}