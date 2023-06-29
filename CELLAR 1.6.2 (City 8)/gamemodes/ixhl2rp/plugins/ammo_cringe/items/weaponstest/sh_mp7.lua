ITEM.name = "МП7"
ITEM.description = "Автомат немецкого производства, который поныне находится на вооружении у сил Гражданской Обороны и сил Патруля. В отличии от пистолета, обладает более вместительным магазином и более высокой убойной мощью. Единственный недостаток - большой разброс пуль, а также частично трудная сборка самого автомата."
ITEM.model = "models/weapons/w_smg1.mdl"
ITEM.class = "arccw_smg1"
ITEM.weaponCategory = "primary"
ITEM.classes = {CLASS_EMP, CLASS_EOW}
ITEM.flag = "V"
ITEM.width = 3
ITEM.height = 2
ITEM.iconCam = {
	ang	= Angle(-0.020070368424058, 270.40155029297, 0),
	fov	= 7.2253324508038,
	pos	= Vector(0, 200, -1)
}
ITEM.Attack = 7
ITEM.DistanceSkillMod = {
	[1] = 5,
	[2] = 1,
	[3] = -2,
	[4] = -5
}
ITEM.Info = {
	Type = nil,
	Skill = "guns",
	Distance = {
		[1] = 5,
		[2] = 1,
		[3] = -2,
		[4] = -5
	},
	Dmg = {
		Attack = nil,
		AP = ITEM.Attack,
		Limb = 30,
		Shock = {110, 2200},
		Blood = {25, 100},
		Bleed = 50
	}
}


