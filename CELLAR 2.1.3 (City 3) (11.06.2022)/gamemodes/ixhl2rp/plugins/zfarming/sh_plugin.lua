local PLUGIN = PLUGIN

PLUGIN.name = "Farming"
PLUGIN.author = "Vintage Thief, maxxoft"
PLUGIN.description = "Adds the ability to grow plants."


ix.util.Include("sv_hooks.lua")

ix.config.Add("phasetime", 4, "Time a plant needs to get a point to grow to the next phase.", nil, {
	data = {min = 1, max = 3600},
	category = "farming"
})

ix.config.Add("phaserate", 1, "How much a plant gains growth points on timer tick.", nil, {
	data = {min = 1, max = 100},
	category = "farming"
})

ix.config.Add("phaseamount", 10, "How many points a plant needs to get on the next phase.", nil, {
	data = {min = 10, max = 100},
	category = "farming"
})


ix.config.Add("phases", 4, "How many phases a plant needs to fully grow.", nil, {
	data = {min = 2, max = 8},
	category = "farming"
})

ix.lang.AddTable("english", {
	categoryFarming = "Farming"
})

ix.lang.AddTable("russian", {
	categoryFarming = "Фермерство"
})

PLUGIN.growmodels = {
	[1] = "models/props/de_train/bush2.mdl",
	[2] = "models/props/de_inferno/bushgreensmall.mdl",
	[2] = "models/props_foliage/bush2.mdl"
}