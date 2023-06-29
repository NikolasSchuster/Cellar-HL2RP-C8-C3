
ITEM.name = "Customizable Outfit"
ITEM.base = "base_outfit"

ITEM:AddProperty("outfitCategory", ix.type.string, "outfit")
ITEM:AddProperty("replacement", ix.type.string, "models/gman.mdl")

function ITEM:OnRegistered()
	self.base = "base_customizable_items" -- hack
end
