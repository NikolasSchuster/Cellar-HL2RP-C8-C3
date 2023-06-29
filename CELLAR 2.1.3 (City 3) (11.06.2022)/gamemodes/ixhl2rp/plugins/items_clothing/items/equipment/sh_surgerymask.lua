ITEM.name = "Медицинская маска"
ITEM.model = "models/cellar/items/surgerymask.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "С помощью этой маски можно прикрыть свой рот и нос от попадания разного рода пыли и грязи, но самый главный смысл этой маски - не дать распространяться болезни. Ученые Альянса доказали, что ношение маски может помочь с борьбе с распространением вирусных заболеваний, но у сотрудников Гражданской Обороны по этому поводу другое мнение. Просто так такое нельзя носить!"
ITEM.slot = EQUIP_MASK
ITEM.bodyGroups = {
	[2] = 1,
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