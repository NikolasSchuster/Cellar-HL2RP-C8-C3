local PLUGIN = PLUGIN

PLUGIN.name = "Medicine Items"
PLUGIN.description = "Adds a medical consumable items."
PLUGIN.author = "SchwarzKruppzo"

ix.bed = ix.bed or {}
ix.bed.stored = ix.bed.stored or {}

function ix.bed.Register(model, data)
	ix.bed.stored[model] = data
end

ix.util.Include("sh_definitions.lua")
ix.util.Include("sv_hooks.lua")
