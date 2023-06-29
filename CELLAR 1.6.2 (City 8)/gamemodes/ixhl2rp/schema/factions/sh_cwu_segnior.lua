FACTION.name = "Старший сотрудник ГСР"
FACTION.description = "Вы представляете собой организацию, обеспечивающая занятость населения."
FACTION.color = Color(255, 215, 0, 255)
FACTION.isDefault = false
FACTION.bHumanVoices = true
FACTION.bCanUseRations = true
FACTION.bAllowDatafile = true
FACTION.scoreboardClass = "scCWU"
FACTION.models = {
	[1] = {
		"models/cellar/characters/oldcitizens/male_01.mdl",
		"models/cellar/characters/oldcitizens/male_02.mdl",
		"models/cellar/characters/oldcitizens/male_03.mdl",
		"models/cellar/characters/oldcitizens/male_04.mdl",
		"models/cellar/characters/oldcitizens/male_05.mdl",
		"models/cellar/characters/oldcitizens/male_06.mdl",
		"models/cellar/characters/oldcitizens/male_07.mdl",
		"models/cellar/characters/oldcitizens/male_08.mdl",
		"models/cellar/characters/oldcitizens/male_09.mdl",
		"models/cellar/characters/oldcitizens/male_10.mdl",
		"models/cellar/characters/oldcitizens/male_11.mdl",
		"models/cellar/characters/oldcitizens/male_12.mdl",
		"models/cellar/characters/oldcitizens/male_13.mdl",
		"models/cellar/characters/oldcitizens/male_14.mdl",
		"models/cellar/characters/oldcitizens/male_15.mdl",
		"models/cellar/characters/oldcitizens/male_16.mdl",
		"models/cellar/characters/oldcitizens/male_17.mdl",
		"models/cellar/characters/oldcitizens/male_18.mdl"
	},
	[2] = {
		"models/cellar/characters/oldcitizens/female_01.mdl",
		"models/cellar/characters/oldcitizens/female_02.mdl",
		"models/cellar/characters/oldcitizens/female_03.mdl",
		"models/cellar/characters/oldcitizens/female_04.mdl",
		"models/cellar/characters/oldcitizens/female_05.mdl",
		"models/cellar/characters/oldcitizens/female_06.mdl",
		"models/cellar/characters/oldcitizens/female_07.mdl",
		"models/cellar/characters/oldcitizens/female_08.mdl",
		"models/cellar/characters/oldcitizens/female_09.mdl",
		"models/cellar/characters/oldcitizens/female_10.mdl",
		"models/cellar/characters/oldcitizens/female_11.mdl",
		"models/cellar/characters/oldcitizens/female_12.mdl",
		"models/cellar/characters/oldcitizens/female_13.mdl",
		"models/cellar/characters/oldcitizens/female_14.mdl",
		"models/cellar/characters/oldcitizens/female_15.mdl",
		"models/cellar/characters/oldcitizens/female_16.mdl",
		"models/cellar/characters/oldcitizens/female_17.mdl",
		"models/cellar/characters/oldcitizens/female_18.mdl",
	},
}

function FACTION:GetModels(client, gender)
	return self.models[gender]
end

function FACTION:GetRationType(character)
	return Schema:GetCitizenRationTypes(character)
end

function FACTION:OnCharacterCreated(client, character)
	character:CreateIDCard("card_cwu")
end

FACTION_CWU_2 = FACTION.index

Schema:SetFactionGroup(FACTION_CWU_2, FACTION_GROUP_CWU)