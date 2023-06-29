ITEM.name = "Лицевая повязка"
ITEM.model = "models/cellar/items/city3/clothing/balaclava.mdl"
ITEM.width = 1 -- ширина
ITEM.height = 1 -- высота
ITEM.description = "Лицевая повязка, которая ранее была очень модным шарфиком. Немного подрезав и разорвав ее, получилась довольно теплая повязка, которая поможет украть лицо от дуновенияф холодного ветра и случайно залетевшей в затылок сосульки."
ITEM.slot = EQUIP_HEAD -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[2] = 2,
}
ITEM.CanBreakDown = true -- можно ли порвать на тряпки
ITEM.thermalIsolation = 4 -- (от 1 до 4)

function ITEM:CanEquip(client, slot)
	return !tobool(client:GetCharacter():GetEquipment():GetItemAtSlot("face"))
end