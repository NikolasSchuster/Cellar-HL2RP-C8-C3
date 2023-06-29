ITEM.name = "Защищенные штаны НОАК"
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.width = 2 -- ширина
ITEM.height = 2 -- высота
ITEM.description = "Военные штаны НОАК с утепленной подкладкой и защитным наколенником на правое колено."
ITEM.slot = EQUIP_LEGS -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
    [2] = 1,
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 3 -- (от 1 до 4)
ITEM.Stats = {
    [HITGROUP_GENERIC] = 0,
    [HITGROUP_HEAD] = 0,
    [HITGROUP_CHEST] = 0,
    [HITGROUP_STOMACH] = 0,
    [4] = 0,
    [5] = 5,
}