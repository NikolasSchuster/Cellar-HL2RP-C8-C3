ITEM.name = "CID карта сотрудника ГО"
ITEM.model = Model("models/vintagethief/cellarproject/cid_card.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0, 0, 12),
	ang = Angle(90, 0, -45),
	fov = 45,
}
ITEM.cardType = 3
ITEM.access = {
	["DATAFILE_MEDIUM"] = true,
	["cmbCit*"] = true,
	["cmbCwu*"] = true,
	["cmbMpfAll*"] = true,
}
ITEM.DefaultRank = 1 -- 1: MPF; 2: RL