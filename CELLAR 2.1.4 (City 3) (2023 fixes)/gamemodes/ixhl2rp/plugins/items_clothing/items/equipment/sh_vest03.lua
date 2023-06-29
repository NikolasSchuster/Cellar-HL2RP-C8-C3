ITEM.name = "Бронежилет ГО 3 класса защиты"
ITEM.model = "models/cellar/items/city3/clothing/refuge_vest.mdl"
ITEM.width = 3 -- ширина
ITEM.height = 2 -- высота
ITEM.description = "Усовершенствованный бронежилет сил ГО, снятый с одного из убитых сотрудников. Плотно облегает грудь и способен остановить большой калибр. Помимо этого включает в себя элементы защиты для рук."
ITEM.slot = EQUIP_TORSO -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[5] = 15,
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 2 -- (от 1 до 4)
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 0,
	[HITGROUP_CHEST] = 20,
	[HITGROUP_STOMACH] = 8,
	[4] = 8,
	[5] = 0,
}
