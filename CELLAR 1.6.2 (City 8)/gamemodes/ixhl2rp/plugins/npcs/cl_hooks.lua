local PLUGIN = PLUGIN

function PLUGIN:LoadFonts()
	surface.CreateFont("dlgTitle", {
		font = "Roboto Light",
		size = math.max(ScreenScale(11), 18),
		weight = 300,
		extended = true,
		antialias = true
	})

	surface.CreateFont("dlgText", {
		font = "Roboto Light",
		size = math.max(ScreenScale(8), 14),
		weight = 300,
		extended = true,
		antialias = true,
		italic = true
	})

	surface.CreateFont("dlgButton", {
		font = "Roboto Light",
		size = math.max(ScreenScale(8), 16),
		weight = 300,
		extended = true,
		antialias = true
	})
end