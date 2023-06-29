
PLUGIN.name = "Item Flipping"
PLUGIN.author = "LegAz"
PLUGIN.description = "Adds ability to swap items width and height if they are not the same."

ix.util.Include("sh_inits.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("cl_item_ent.lua")

function PLUGIN:OnReloaded()
	for _, v in pairs(ix.item.instances) do
		ix.item.FixFlip(v)
	end
end
