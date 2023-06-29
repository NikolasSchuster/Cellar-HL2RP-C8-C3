ITEM.name = "Монтировка"
ITEM.description = "Цельнометаллическая монтировка, скованная в пучине войны, которой не суждено закончиться. Обладает приличным весом, боевым окрасом и смыслом, который многим еще только предстоит узнать, если те доживут до момента в будущем, который обязательно случится."
ITEM.model = "models/weapons/w_crowbar.mdl"
ITEM.class = "arccw_crowbar"
ITEM.weaponCategory = "melee"
ITEM.width = 3
ITEM.height = 1
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
		Limb = 33,
		Shock = {111, 2000},
		Blood = {25, 100},
		Bleed = 75
	}
}