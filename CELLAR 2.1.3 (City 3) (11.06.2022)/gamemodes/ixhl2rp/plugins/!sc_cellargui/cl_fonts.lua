function PLUGIN:LoadFonts(font, genericFont)
	surface.CreateFont( "CharCreationBoldTitle", {
		font = "Open Sans Extrabold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = 36,
		weight = 550,
		antialias = true,
	} )
	
	surface.CreateFont( "WNMenuTitle", {
		font = "Geometria", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = 70,
		weight = 850,
		antialias = true,
	} )
	
	surface.CreateFont( "WNSmallerMenuTitle", {
		font = "Open Sans Extrabold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = 42,
		weight = 550,
		antialias = true,
	} )
	
	surface.CreateFont( "WNSmallerMenuTitleNoBold", {
		font = "Open Sans", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = 42,
		weight = 550,
		antialias = true,
	} )
	
	surface.CreateFont( "WNMenuSubtitle", {
		font = "Geometria", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = 28,
		weight = 300,
		antialias = true,
	} )
	
	surface.CreateFont( "WNMenuFont", {
		font = "Open Sans", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = 20,
		weight = 550,
		antialias = true,
	} )
	
	surface.CreateFont( "WNBackFont", {
		font = "Open Sans", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = 16,
		weight = 550,
		antialias = true,
	} )

	surface.CreateFont( "MenuFont", {
		font = "Open Sans",
		extended = true,
		size = 18,
		weight = 550,
		antialias = true,
	} )
	
	surface.CreateFont( "MenuFontBold", {
		font = "Open Sans Bold",
		extended = true,
		size = 18,
		weight = 550,
		antialias = true,
	} )

	surface.CreateFont( "SubtitleFont", {
		font = "Open Sans",
		extended = true,
		size = 14,
		weight = 550,
		antialias = true,
	} )

	surface.CreateFont( "TitlesFont", {
		font = "Open Sans Bold",
		extended = true,
		size = 24,
		weight = 550,
		antialias = true,
	} )

	surface.CreateFont( "TitlesFontNoBold", {
		font = "Open Sans",
		extended = true,
		size = 22,
		weight = 550,
		antialias = true,
	} )

	surface.CreateFont( "SmallerTitleFont", {
		font = "Open Sans Bold",
		extended = true,
		size = 20,
		weight = 550,
		antialias = true,
	} )

	surface.CreateFont( "SmallerTitleFontNoBold", {
		font = "Open Sans",
		extended = true,
		size = 20,
		weight = 550,
		antialias = true,
	} )
	
	surface.CreateFont( "HUDFontLarge", {
		font = "Open Sans Bold",
		extended = true,
		size = 56,
		weight = 550,
		antialias = true,
	} )
	
	surface.CreateFont( "HUDFontExtraLarge", {
		font = "Open Sans Bold",
		extended = true,
		size = 72,
		weight = 550,
		antialias = true,
	} )

	surface.CreateFont("CharCreateStage", {
		font = "Open Sans",
		extended = true,
		size = 20,
		weight = 200,
		antialias = true,
	})
	surface.CreateFont("ixStageTextEntry", {
		font = "Open Sans",
		extended = true,
		size = 18,
		weight = 200,
		antialias = true,
	})
	surface.CreateFont("CharCreateButton", {
		font = "Open Sans",
		extended = true,
		size = 16,
		weight = 200,
		antialias = true,
	})
end