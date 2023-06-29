ITEM.name = "Бронежилет Солдата Патруля"
ITEM.model = "models/cellar/items/city3/clothing/combine_armor_vest.mdl"
ITEM.width = 3 -- ширина
ITEM.height = 3 -- высота
ITEM.description = "Бронежилет, снятый с убитого солдата Патруля. Очень тяжелый и неповоротливый, но может, возможно, остановить подавляющее большинство пуль."
ITEM.slot = EQUIP_TORSO -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[5] = 14,
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 2 -- (от 1 до 4)
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 0,
	[HITGROUP_CHEST] = 25,
	[HITGROUP_STOMACH] = 10,
	[4] = 0,
	[5] = 0,
}