local PLUGIN = PLUGIN

PLUGIN.name = "Chat Counter"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = ""

if CLIENT then
	function PLUGIN:LoadFonts(font, genericFont)
		surface.CreateFont("ixChatCounter", {
			font = genericFont,
			size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1),
			extended = true,
			weight = 300,
			antialias = true,
			italic = true
		})
	end
end