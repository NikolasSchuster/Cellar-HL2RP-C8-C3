ITEM.name = "Штаны с бронепластинами"
ITEM.model = "models/cellar/items/city3/clothing/pants_padded.mdl"
ITEM.width = 2 -- ширина
ITEM.height = 2 -- высота
ITEM.description = "Обычные джинсы с приделанными к ним бронепластинами. Некоторые из них сокрыты внутри самой ткани штанов, из-за чего пришлось пожертвовать термоизоляцией. Зато пулеизоляция хотя-бы минимальная, но имеется."
ITEM.slot = EQUIP_LEGS -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
    [7] = 3,
}
ITEM.CanBreakDown = true -- можно ли порвать на тряпки
ITEM.thermalIsolation = 1 -- (от 1 до 4)
ITEM.Stats = {
    [HITGROUP_GENERIC] = 0,
    [HITGROUP_HEAD] = 0,
    [HITGROUP_CHEST] = 0,
    [HITGROUP_STOMACH] = 0,
    [4] = 0,
    [5] = 5,
}