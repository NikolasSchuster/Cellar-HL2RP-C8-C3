ITEM.name = "Шлем вертолетчика НОАК"
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.width = 1 -- ширина
ITEM.height = 1 -- высота
ITEM.description = "Шлем для пилота вертолета НОАК, краска немного выцвела."
ITEM.slot = EQUIP_HEAD -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[4] = 7,
	[8] = 1,
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 3 -- (от 1 до 4)
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 7,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0,
	[5] = 0,
}