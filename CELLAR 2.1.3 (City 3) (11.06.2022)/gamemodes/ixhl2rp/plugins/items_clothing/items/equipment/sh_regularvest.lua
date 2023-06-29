ITEM.name = "Бронежилет кустарного производства"
ITEM.model = "models/cellar/items/city3/clothing/vest.mdl"
ITEM.width = 3 -- ширина
ITEM.height = 2 -- высота
ITEM.description = "Это - самое непонятное изделие, созданное кустарным способом неизвестными личностями. Не понятно, чем они руководствовались, но размеры и количество пластин, используемых тут, просто зашкаливает."
ITEM.slot = EQUIP_TORSO -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
    [4] = 11,
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 2 -- (от 1 до 4)
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 0,
	[HITGROUP_CHEST] = 10,
	[HITGROUP_STOMACH] = 5,
	[4] = 0,
	[5] = 0,
}