local PLUGIN = PLUGIN

PLUGIN.name = "Recycle Factory"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = "Adds the recycle factories."

ix.util.Include("sv_hooks.lua")

if CLIENT then
	function PLUGIN:LoadFonts()
		surface.CreateFont("_GR_CMB_FONT_1", {
			font = "Default",
			size = 13,
			weight = 1000,
			antialias = false,
			underline = false,
		})
		surface.CreateFont("_GR_CMB_FONT_2", {
			font = "Default",
			size = 11,
			weight = 1000,
			antialias = false,
			underline = false,
		})
		surface.CreateFont("_GR_CMB_FONT_3", {
			font = "Verdana",
			size = 10,
			weight = 800,
			antialias = false,
			underline = false,
		})
		surface.CreateFont("_GR_CMB_FONT_4", {
			font = "System",
			size = 40,
			weight = 1000,
			antialias = false,
			underline = false,
		})
	end
end