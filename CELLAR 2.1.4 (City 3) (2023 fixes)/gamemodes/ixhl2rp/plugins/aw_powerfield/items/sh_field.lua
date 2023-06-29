local PLUGIN = PLUGIN
ITEM.name = "Forcefield"
ITEM.description = "Simple Forcefield"
ITEM.model = "models/alyx_emptool_prop.mdl"
ITEM.price = 250
ITEM.weight = 0.1

ITEM.functions.Use = {
	name = "Place",
	OnRun = function(item)
		PLUGIN:PlaceField(item)
		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and !item.noDrop
	end
}
function ITEM:GetDescription()
	return self.description.."\n".."Fields in stock: "..self:GetData("fieldinstock",3)
end
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(75.51887512207, 63.375328063965, 46.839912414551),
	ang = Angle(25, 220, 0),
	fov = 5.2858618008586
}

ITEM.exRender = false