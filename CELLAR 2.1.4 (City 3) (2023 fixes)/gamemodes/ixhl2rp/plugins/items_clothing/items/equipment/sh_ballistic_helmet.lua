ITEM.name = "Баллистический шлем"
ITEM.model = "models/cellar/items/city3/clothing/helmet.mdl"
ITEM.width = 1 -- ширина
ITEM.height = 1 -- высота
ITEM.description = "Довольно гладкий шлем, который, возможно, сможет защитить вашу черепушку от одной-двух пуль, если они самого малого калибра, летели до вас за киллометр и на пути к вам пули развалились на мелкие части. В остальных случаях никто, кроме Бога вам не поможет."
ITEM.slot = EQUIP_HEAD -- слот ( EQUIP_MASK EQUIP_HEAD EQUIP_LEGS EQUIP_HANDS EQUIP_TORSO )
ITEM.bodyGroups = { -- какие бодигруппы на какие сетаются
	[1] = 5
}
ITEM.CanBreakDown = false -- можно ли порвать на тряпки
ITEM.thermalIsolation = 1 -- (от 1 до 4)
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 9,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0,
	[5] = 0,
}