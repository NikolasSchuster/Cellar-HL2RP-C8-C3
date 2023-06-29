ITEM.name = "Противогаз 'Чистильщика'"
ITEM.model = "models/cellar/items/city3/clothing/worker_helmet.mdl"
ITEM.width = 2 -- ширина
ITEM.height = 2 -- высота
ITEM.description = "Маска, способная напомнить о самых страшных событиях, которые уже произошли или только будут происходить в будущем."
ITEM.slot = EQUIP_MASK -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- 	какие бодигруппы на какие сетаются
	[1] = 8,
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 1 -- (от 1 до 4)
ITEM.Filters = {
	["filter_epic"] = true,
	["filter_good"] = true,
	["filter_medium"] = true,
	["filter_standard"] = false
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 1,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0,
	[5] = 0,
}

function ITEM:CanEquip(client, slot)
	return !tobool(client:GetCharacter():GetEquipment():GetItemAtSlot("head"))
end