ITEM.name = "Mk 48 Mod 1"
ITEM.description = "Бельгийский легкий пулемет. Уменьшенная версия Mk 46 Mod 0, стреляет более мощным патроном 7,62x51 мм НАТО. Используется военно-морскими силами США, USSOCOM и индийскими силами специального назначения."
ITEM.model = "models/weapons/w_mach_m249para.mdl"
ITEM.class = "arccw_bo2_mk48"
ITEM.weaponCategory = "primary"
ITEM.classes = {CLASS_EMP, CLASS_EOW}
ITEM.flag = "V"
ITEM.width = 5
ITEM.height = 3
ITEM.iconCam = {
    pos = Vector(-1.5029327869415, 206.0539855957, 4.587676525116),
    ang = Angle(0, 270, 0),
    fov = 12.119995321953,
}
ITEM.Attack = 16
ITEM.DistanceSkillMod = {
	[1] = 5,
	[2] = 4,
	[3] = 3,
	[4] = -2
}
ITEM.Info = {
	Type = nil,
	Skill = "guns",
	Distance = {
		[1] = 5,
		[2] = 4,
		[3] = 3,
		[4] = -2
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 40,
		Shock = {220, 2200},
		Blood = {90, 580},
		Bleed = 80
	}
}


