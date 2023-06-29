ITEM.name = "Ушанка с символикой НОАК"
ITEM.model = "models/cellar/items/city3/clothing/ushanka.mdl"
ITEM.width = 1 -- ширина
ITEM.height = 1 -- высота
ITEM.description = "Обычная теплая ушанка с символикой НОАК."
ITEM.slot = EQUIP_HEAD -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[4] = 4,
	[8] = 1,
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 4 -- (от 1 до 4)