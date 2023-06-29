local PLUGIN = PLUGIN

PLUGIN.name = "Plugin for collecting water"
PLUGIN.author = "Vintage Thief"
PLUGIN.description = ""

ix.util.Include("sv_hooks.lua")

ix.config.Add("watertimer", 5, "How ofter water will collect (in seconds)", nil, {
    data = {min = 1, max = 3600},
    category = "watercollector"
})

ix.config.Add("waterlimit", 5, "How much water can be in a container.", nil, {
    data = {min = 1, max = 10000},
    category = "watercollector"
})

ix.config.Add("watertick", 2, "How much water you collect on time.", nil, {
    data = {min = 1, max = 100},
    category = "watercollector"
})


PLUGIN.emptycont = {
	["empty_can"] = 6,
	["empty_glass_bottle"] = 8,
	["empty_plastic_bottle"] = 12,
	["empty_plastic_can"] = 12,
	["empty_tin_can"] = 6
}

PLUGIN.fullcont = {
	["empty_can"] = "can_with_water", -- +
	["empty_glass_bottle"] = "purified_water", -- +
	["empty_plastic_bottle"] = "plastic_bottle_of_water", -- +
	["empty_plastic_can"] = "plastic_jar_of_water", -- +
	["empty_tin_can"] = "tin_can_of_water" -- +
}