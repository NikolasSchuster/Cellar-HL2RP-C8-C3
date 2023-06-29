ITEM.name = "Лицевая повязка"
ITEM.model = "models/cellar/items/city3/clothing/facewrap2.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Плотная тканевая повязка, которая надежно защитит ваше лицо от лишних глаз. От ветра, тем не менее, практически не помогает - скорее всего, подобная ткань предусмотрена не для термоизоляции."
ITEM.slot = EQUIP_MASK
ITEM.bodyGroups = {
	[2] = 2,
}
ITEM.iconCam = {
	pos = Vector(0, 200, -0.49698188900948),
	ang = Angle(0, 270, 0),
	fov = 1.8941635831843,
}
ITEM.CanBreakDown = false

function ITEM:CanEquip(client, slot)
	local equipment = client:GetCharacter():GetEquipment()
	return !(equipment:HasItem("facial_bandage", {equip = true}))
end