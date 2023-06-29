ITEM.name = "CID карта сотрудника ГСР"
ITEM.model = Model("models/vintagethief/cellarproject/cid_card.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0, 0, 12),
	ang = Angle(90, 0, -45),
	fov = 45,
}
ITEM.cardType = 2
ITEM.access = {
	["DATAFILE_MINOR"] = true,
	["cmbCitAll*"] = true,
	["cmbCwuAll*"] = true
}