ITEM.name = "Base Armband"
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = ""
ITEM.category = "categoryMPFArmbands"
ITEM.armband = 0

ITEM.combine = {}
ITEM.combine.Transfer = {
	name = "Надеть повязку",
	icon = "icon16/briefcase.png",
	OnRun = function(from, to) 
		to:SetData("armband", from.armband)
	end,
	OnCanRun = function(from, to) 
		if to.uniform then
			return true
		end

		return false
	end
}