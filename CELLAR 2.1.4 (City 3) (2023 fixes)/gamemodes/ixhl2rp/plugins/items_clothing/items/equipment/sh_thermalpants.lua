ITEM.name = "Утепленные штаны"
ITEM.model = "models/cellar/items/city3/clothing/pants_03.mdl"
ITEM.width = 2 -- ширина
ITEM.height = 2 -- высота
ITEM.description = "На первый взгляд - обычные джинсы и ничем непримечательны, но при должном ношении или вскрытии оказывается, что они были утеплены при помощи самодельных пуховых вставок, из-за чего в них довольно тепло."
ITEM.slot = EQUIP_LEGS -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
    [7] = 2,
}
ITEM.CanBreakDown = true -- можно ли порвать на тряпки
ITEM.thermalIsolation = 4 -- (от 1 до 4)