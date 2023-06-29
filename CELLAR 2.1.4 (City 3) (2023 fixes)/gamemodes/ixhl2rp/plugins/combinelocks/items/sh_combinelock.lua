ITEM.name = "Combine Lock"
ITEM.description = "A metal apparatus applied to doors."
ITEM.model = Model("models/props_combine/combine_lock01.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.iconCam = {
	pos = Vector(-0.5, 50, 2),
	ang = Angle(0, 270, 0),
	fov = 25.29
}

ITEM.functions.Place = {
	OnClick = function(item)
		Derma_StringRequest("Access", "What would you like to set the access to?", "cmbMpfAll", function(access)
			netstream.Start("ixCombineLockPlace", item:GetID(), access)
		end)
	end,

	OnRun = function()
		return false
	end
}
