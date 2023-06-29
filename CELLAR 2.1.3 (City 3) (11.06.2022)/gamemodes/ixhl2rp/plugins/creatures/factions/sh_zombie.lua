-- luacheck: globals FACTION_ZOMBIE

FACTION.name = "Zombie"
FACTION.description = "A zombie."
FACTION.color = Color(200, 80, 80)
FACTION.bCreature = true
FACTION.useFullName = true
FACTION.whitelist = true
FACTION.bSubscriber = true
FACTION.noGas = true
FACTION.bNoNeeds = true
FACTION.tempImmunity = true
FACTION.npcRelations = {
	["npc_zombie"] = D_LI,
	["npc_poisonzombie"] = D_LI,
	["npc_zombie_torso"] = D_LI,
	["npc_headcrab_black"] = D_LI,
	["npc_headcrab"] = D_LI,
	["npc_fastzombie_torso"] = D_LI,
	["npc_fastzombie"] = D_LI,
	["npc_headcrab_fast"] = D_LI,
	["npc_zombine"] = D_LI,
	["npc_antlion"] = D_HT,
	["npc_antlionguard"] = D_HT
}
FACTION.defaultLevel = 3
FACTION.models = {
	"models/zombie/classic.mdl",
	{"models/zombie/classic.mdl", nil, "01"},
}
FACTION.genders = {1}

function FACTION:GetModels(client, character)
	return self.models
end

FACTION_ZOMBIE = FACTION.index
