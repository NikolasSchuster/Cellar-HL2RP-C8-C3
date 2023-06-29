ITEM.name = "Взломанная карта доступа"
ITEM.model = Model("models/vintagethief/cellarproject/cid_card.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Внешне похоже на обычную карту доступа, однако с боковой стороны видны следы пайки и странная чиповка."
ITEM.category = "categoryVintage"
ITEM.iconCam = {
	pos = Vector(0, 0, 12),
	ang = Angle(90, 0, -45),
	fov = 45,
}

ITEM.cardType = 3
ITEM.access = {
	["cmbCit*"] = true,
	["cmbCwu*"] = true,
	["cmbMpfAll*"] = true,
}