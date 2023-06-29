ITEM.name = "Нож"
ITEM.description = "Этот нож был сделан довольно топорно и неаккуратно, но свою функцию он явно будет выполнять. Если совершить удар в правильную точку на теле то эта топорность в создании сможет даже послужить хорошую службу, ибо осколки от этого ножа останутся в ране врага."
ITEM.model = "models/weapons/tfa_nmrih/w_me_kitknife.mdl"
ITEM.class = "arccw_knife"
ITEM.weaponCategory = "melee"
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0.81613248586655, 207.92877197266, 8.187873840332),
	ang = Angle(0, -90, 90),
	fov = 5,
}
ITEM.Info = {
	Type = 2,
	Skill = "meleeguns",
	Dmg = {
		Attack = 1,
		Limb = 10,
		Shock = {166, 1000},
		Blood = {37, 150},
		Bleed = 95
	}
}