ITEM.name = "Бронежилет ГО 2 класса защиты"
ITEM.model = "models/cellar/items/city3/clothing/refuge_molle.mdl"
ITEM.width = 3 -- ширина
ITEM.height = 2 -- высота
ITEM.description = "Усовершенствованный бронежилет сил ГО, снятый с одного из убитых сотрудников. Плотно облегает грудь и способен остановить большой калибр."
ITEM.slot = EQUIP_TORSO -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[5] = 13,
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 2 -- (от 1 до 4)
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 0,
	[HITGROUP_CHEST] = 15,
	[HITGROUP_STOMACH] = 7,
	[4] = 0,
	[5] = 0,
}