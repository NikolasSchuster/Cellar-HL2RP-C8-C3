ITEM.name = "Униформа 'Чистильщика'"
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.width = 3 -- ширина
ITEM.height = 2 -- высота
ITEM.description = "Мешковатый комбенизон, используемый рабочими при работе в особых условиях, будь то заражение Зена, очередная инфекция или другие аномалии."
ITEM.slot = EQUIP_TORSO -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- 	какие бодигруппы на какие сетаются
	[4] = 14,
	[6] = 4,
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 3 -- (от 1 до 4)

--запретить надевать если есть штаны на ногах иначе будет скрытый бафф момент, а также добавить термалку для ног сюда также на 3

function ITEM:CanTransferEquipment(oldinv, newinv, slot)
	if slot != self.slot then return false end
	local client = newinv:GetOwner()
	return !(newinv:GetItemAtSlot(EQUIP_LEGS))
end