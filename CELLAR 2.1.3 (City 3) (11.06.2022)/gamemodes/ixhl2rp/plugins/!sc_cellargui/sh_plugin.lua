local PLUGIN = PLUGIN

PLUGIN.name = "Advanced Cellar UI"
PLUGIN.author = "Sectorial.Commander"
PLUGIN.description = "Advanced Game User Interface & Animations specially for Cellar Project."
PLUGIN.version = 1.2

cellar_blur_blue = Color(56, 61, 248, 225)
cellar_blue = Color(56, 207, 248)
cellar_red = Color(255, 30, 30, 225)
cellar_darker_blue = Color(43, 157, 189)

ix.util.Include('gui/cl_cellarbutton.lua')
ix.util.Include('gui/cl_cellarmenu.lua')
ix.util.Include('gui/cl_watermark.lua')
ix.util.Include('gui/cl_cellarinventory.lua')
ix.util.Include('gui/cl_cellartabframe.lua')
ix.util.Include('gui/cl_cellarclosebutton.lua')
ix.util.Include('gui/cl_cellarbuttonmirrored.lua')
ix.util.Include('gui/cl_cellarcharactercard.lua')
ix.util.Include('gui/cl_cellarhelp.lua')
ix.util.Include('gui/cl_cellarscoreboard.lua')
ix.util.Include('gui/cl_cellarsettings.lua')
ix.util.Include('gui/cl_cellarconfig.lua')
ix.util.Include('gui/cl_cellarplugins.lua')
ix.util.Include('gui/cl_cellarcrafting.lua')
ix.util.Include('gui/cl_cellarinformation.lua')
ix.util.Include('gui/cl_cellarclasses.lua')

ix.util.Include('languages/sh_russian.lua')
