-- luacheck: globals FACTION_SYNTH

FACTION.name = "Synth"
FACTION.description = "A synth."
FACTION.color = Color(200, 80, 80)
FACTION.bCreature = true
FACTION.useFullName = true
FACTION.whitelist = true
FACTION.noGas = true
FACTION.bNoNeeds = true
FACTION.tempImmunity = true
--FACTION.weapons = {"ix_thermalgoggles"}
FACTION.npcRelations = {
	["npc_turret_floor"] = D_LI,
	["npc_combine_camera"] = D_LI,
	["npc_turret_ceiling"] = D_LI,
	["npc_rollermine"] = D_LI,
	["npc_helicopter"] = D_LI,
	["npc_combinegunship"] = D_LI,
	["npc_strider"] = D_LI,
	["npc_metropolice"] = D_LI,
	["npc_hunter"] = D_LI
}
FACTION.isCombineFaction = true
FACTION.models = {
	"models/hunter.mdl"
}
FACTION.genders = {1}
FACTION.listenChannels = {
	["freq_overwatch"] = 1,
	["freq_tac"] = 1,
	["freq_combine"] = 1,
	["freq_cab"] = 1
}

function FACTION:GetModels(player, character)
	return self.models
end

function FACTION:GetName(player, character)
	return "C17:#-T.SYNTH-HNT-" .. Schema:ZeroNumber(math.random(1, 999), 3)
end

FACTION_SYNTH = FACTION.index
