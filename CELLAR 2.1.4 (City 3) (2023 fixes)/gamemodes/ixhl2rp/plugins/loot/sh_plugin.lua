local PLUGIN = PLUGIN

PLUGIN.name = "Loot System"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = "Adds a enhanced loot system."

ix.util.Include("sh_config.lua")
ix.util.Include("meta/sv_loottable.lua")
ix.util.Include("sv_hooks.lua")

if SERVER then
	do
		local directory = PLUGIN.folder.."/loottemplates"

		for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
			ix.util.Include(directory.."/"..v)
		end
	end
end