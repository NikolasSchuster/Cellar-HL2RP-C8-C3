ITEM.name = "Берет с символикой НОАК"
ITEM.model = "models/cellar/items/city3/clothing/beret.mdl"
ITEM.width = 1 -- ширина
ITEM.height = 1 -- высота
ITEM.description = "Военный берет черного цвета с символикой НОАК."
ITEM.slot = EQUIP_HEAD -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[4] = 5,
	[8] = 1,
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 1 -- (от 1 до 4)