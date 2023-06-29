
local PLUGIN = PLUGIN

PLUGIN.name = "Item List"
PLUGIN.author = "Zombine"
PLUGIN.description = "Adds a Q-menu tab for all items."

ix.flag.Add("G", "Access to item spawn.")

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
