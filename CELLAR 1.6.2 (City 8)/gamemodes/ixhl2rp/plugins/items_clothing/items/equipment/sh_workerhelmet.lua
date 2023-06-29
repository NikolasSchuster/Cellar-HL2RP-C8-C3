ITEM.name = "Строительная каска"
ITEM.model = Model("models/cellar/items/workerhelmet.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Эта каска была сделана из довольно качественного пластика и способна защитить от падения с крыши разных инструментов или кирпичей, а также, возможно, заблокировать пару ударов кулаком. Жаль, что от пуль не спасает."
ITEM.slot = EQUIP_HEAD
ITEM.bodyGroups = {
	[4] = 3,
}
ITEM.iconCam = {
	pos = Vector(290.53433227539, 243.74395751953, 178.93858337402),
	ang = Angle(25, 220, 0),
	fov = 1.4059522438969,
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 1,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0,
	[5] = 0,
}
ITEM.CanBreakDown = false