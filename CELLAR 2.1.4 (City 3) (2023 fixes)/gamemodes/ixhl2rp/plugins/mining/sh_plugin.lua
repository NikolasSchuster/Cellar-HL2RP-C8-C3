local PLUGIN = PLUGIN

PLUGIN.name = "Mining"
PLUGIN.description = "Resource mining system."
PLUGIN.author = "maxxoft"


ix.util.Include("sv_hooks.lua")

ix.config.Add("baseVeinDamage", 10, "Base damage to a vein (multiplied by STR attribute).", nil, {
	data = {min = 1, max = 100},
	category = "farming"
})

ix.config.Add("veinRounds", 2, "How many times a vein will drop resources before being fully drained.", nil, {
	data = {min = 1, max = 10},
	category = "farming"
})

ix.config.Add("miningStamina", 10, "How many stamina points to consume per pickaxe hit.", nil, {
	data = {min = 0, max = 30},
	category = "farming"
})

ix.config.Add("veinDrainedTimer", 500, "How much time it takes for a vein to be restored (in seconds).", nil, {
	data = {min = 60, max = 3600},
	category = "farming"
})

ix.config.Add("miningDurabilityDrain", 1, "How many durability points will be drained per hit.", nil, {
	data = {min = 0, max = 30},
	category = "farming"
})

ix.lang.AddTable("english", {
	categoryMining = "Mining",
	ironOre = "Iron ore",
	coal = "Black coal"
})

ix.lang.AddTable("russian", {
	categoryMining = "Добыча",
	ironOre = "Железная руда",
	coal = "Каменный уголь"
})

ix.command.Add("SpawnOre", {
	description = "Spawns ore at your crosshair position.",
	privilege = "Helix - Manage Ore",
	adminOnly = true,
	arguments = {ix.type.string},
	OnRun = function(self, client, oreID)
		print("Triggered command!")
		print(oreID)
		if ix.item.list[oreID] then
			print("if passed")
			local pos = client:GetShootPos()
			local ent = ents.Create("ix_mining_vein")
			ent:SetOreClass(oreID)
			ent:Spawn()
			ent:SetPos(pos)
			print(ent)
		end
	end
})

PLUGIN.veinModels = {
	"models/props_mining/caverocks_cluster01.mdl",
	"models/props_mining/caverocks_cluster02.mdl"
}
