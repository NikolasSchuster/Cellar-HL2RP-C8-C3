ITEM.name = "Серый ватник"
ITEM.model = "models/cellar/items/city3/clothing/top_05.mdl"
ITEM.width = 2 -- ширина
ITEM.height = 2 -- высота
ITEM.description = "Ватник серого цвета, который плотно прилегает к вашему телу. Помимо этого, несмотря на невзрачность и старость, он очень хорошо согревает даже в самую холодную погоду."
ITEM.slot = EQUIP_TORSO -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
    [5] = 4,
}
ITEM.CanBreakDown = true -- можно ли порвать на тряпки
ITEM.thermalIsolation = 3 -- (от 1 до 4)