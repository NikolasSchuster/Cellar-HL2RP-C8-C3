local PLUGIN = PLUGIN

PLUGIN.name = "Recycle Factory"
PLUGIN.author = "SchwarzKruppzo, Alan Wake"
PLUGIN.description = "Adds the recycle factories."

PLUGIN.VariantsUse = {
	Запустить = function(ent) if !ent:GetIsWorking() then ent:StartWork() end end,
	Остановить = function(ent) if ent:GetIsWorking() then ent:StopWork() end end,
	Выгрузить = function(ent) ent:Eject() end,
}

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
	netstream.Hook("aw_recyclemenu",function(data)
		local menu = DermaMenu()
		for k,v in pairs(PLUGIN.VariantsUse) do
			menu:AddOption(k,function() netstream.Start("aw_recyclemenuresult",{data,k}) end)
		end
		menu:Open(ScrW() / 2, ScrH() / 2)
	end)
end