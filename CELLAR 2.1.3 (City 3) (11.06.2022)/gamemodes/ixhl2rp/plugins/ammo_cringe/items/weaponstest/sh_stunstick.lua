ITEM.name = "Парализатор"
ITEM.description = "Стандартный парализатор сотрудника Гражданской Обороны. Его медная катушка на кончике искрится белыми молниями, если переключить рычажок питания на ручке. Мощность дубинки при помощи маленькой кнопки с боку можно отрегулировать до 100 Киловольт. Бьет больно и часто."
ITEM.model = "models/weapons/w_stunbaton.mdl"
ITEM.class = "arccw_stunstick"
ITEM.weaponCategory = "melee"
ITEM.width = 3
ITEM.height = 1
ITEM.impulse = true
ITEM.iconCam = {
	pos = Vector(0, 200, 0),
	ang = Angle(0, 270, 0),
	fov = 8,
}
ITEM.Info = {
	Type = 1,
	Skill = "meleeguns",
	Dmg = {
		Attack = 1,
		Limb = 10,
		Shock = {28, 2000},
		Blood = {6, 25},
		Bleed = 5
	}
}