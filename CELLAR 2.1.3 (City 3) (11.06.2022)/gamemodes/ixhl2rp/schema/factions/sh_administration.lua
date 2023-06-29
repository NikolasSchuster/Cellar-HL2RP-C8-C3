FACTION.name = "Сотрудник ГА"
FACTION.description = "Человеческое представительство Альянса на нашей планете."
FACTION.color = Color(255, 200, 100, 255)
FACTION.bHumanVoices = true
FACTION.bCanUseRations = true
FACTION.bAllowDatafile = true
FACTION.models = {
	[1] = {
		"models/cellar/characters/oldsuits/male_01_closed_tie.mdl",
		"models/cellar/characters/oldsuits/male_02_closed_tie.mdl",
		"models/cellar/characters/oldsuits/male_03_closed_tie.mdl",
		"models/cellar/characters/oldsuits/male_04_closed_tie.mdl",
		"models/cellar/characters/oldsuits/male_05_closed_tie.mdl",
		"models/cellar/characters/oldsuits/male_06_closed_tie.mdl",
		"models/cellar/characters/oldsuits/male_07_closed_tie.mdl",
		"models/cellar/characters/oldsuits/male_08_closed_tie.mdl",
		"models/cellar/characters/oldsuits/male_09_closed_tie.mdl"
	},
	[2] = {
		"models/cellar/characters/oldsuits/female_01.mdl",
		"models/cellar/characters/oldsuits/female_02.mdl",
		"models/cellar/characters/oldsuits/female_03.mdl",
		"models/cellar/characters/oldsuits/female_04.mdl",
		"models/cellar/characters/oldsuits/female_06.mdl",
		"models/cellar/characters/oldsuits/female_07.mdl",
		"models/cellar/characters/oldsuits/female_fang.mdl",
		"models/cellar/characters/oldsuits/female_hawke.mdl",
		"models/cellar/characters/oldsuits/female_rochelle.mdl",
		"models/cellar/characters/oldsuits/female_wraith.mdl",
		"models/cellar/characters/oldsuits/female_zoey.mdl"
	},
}

FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.scoreboardClass = "scCityAdm"

function FACTION:GetModels(client, gender)
	return self.models[gender]
end

function FACTION:GetRationType(character)
	return Schema:GetCitizenRationTypes(character)
end

function FACTION:OnCharacterCreated(client, character)
	character:CreateIDCard("card_ca")
end

FACTION.npcRelations = {
    ["npc_turret_floor"] = D_NU,
    ["npc_combine_camera"] = D_NU,
    ["npc_turret_ceiling"] = D_NU,
    ["npc_rollermine"] = D_NU,
    ["npc_helicopter"] = D_NU,
    ["npc_combinegunship"] = D_NU,
    ["npc_strider"] = D_NU,
    ["npc_metropolice"] = D_LI,
    ["npc_hunter"] = D_NU,
	["npc_combine_s"] = D_NU,
	["CombinePrison"] = D_NU,
	["CombineElite"] = D_NU,
    ["npc_manhack"] = D_LI
}

FACTION_ADMIN = FACTION.index
