ITEM.base = "base_equipment"
ITEM.name = "Base Cit Armbands"
ITEM.description = ""
ITEM.category = "categoryCitArmbands"
ITEM.model = "models/cellar/items/armband_citizen.mdl"
ITEM.slot = EQUIP_RESERVED1
ITEM.isOutfit = true
ITEM.width = 1
ITEM.height = 1
ITEM.CanBreakDown = false
ITEM.rarity = 1
ITEM.iconCam = {
	pos = Vector(0, 0, 9.487096786499),
	ang = Angle(91.083457946777, -49.069404602051, 0),
	fov = 45,
}
ITEM.bodyGroups = {
	[4] = 1,
}
ITEM.skin = 0
ITEM.armband = 0

function ITEM:OnItemEquipped(client)
	client:SetNWInt("sg_armcit", self.armband)
end

function ITEM:OnItemUnequipped(client) 
	client:SetNWInt("sg_armcit", 0)
end