ITEM.name = "Берет"
ITEM.model = "models/cellar/items/city3/clothing/beret.mdl"
ITEM.width = 1 -- ширина
ITEM.height = 1 -- высота
ITEM.description = "Стильный берет для стильных людей! Не обладает какими-либо термоизоляционными особенностями, но выглядит довольно приятно."
ITEM.slot = EQUIP_HEAD -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[1] = 2
}
ITEM.CanBreakDown = true -- можно ли порвать на тряпки
ITEM.thermalIsolation = 1 -- (от 1 до 4)