ITEM.name = "Боевое обмундирование НОАК Тип 3"
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.width = 2 -- ширина
ITEM.height = 2 -- высота
ITEM.description = "Боевое обмундирование НОАК, совмещает в себе защитные и практичные свойства для ведения боевых действий."
ITEM.slot = EQUIP_TORSO -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[3] = 1,
	[5] = 5,
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 8,
	[HITGROUP_HEAD] = 0,
	[HITGROUP_CHEST] = 20,
	[HITGROUP_STOMACH] = 10,
	[4] = 0, -- hands
	[5] = 0, -- legs
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 3 -- (от 1 до 4)