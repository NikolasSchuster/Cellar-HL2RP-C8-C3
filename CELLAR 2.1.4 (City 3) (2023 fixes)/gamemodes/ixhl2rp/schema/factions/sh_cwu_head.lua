FACTION.name = "Директор ГСР"
FACTION.description = "Вы представляете собой организацию, обеспечивающая занятость населения."
FACTION.color = Color(255, 215, 0, 255)
FACTION.isDefault = false
FACTION.bHumanVoices = true
FACTION.bCanUseRations = true
FACTION.bAllowDatafile = true
FACTION.scoreboardClass = "scCWU"
FACTION.models = {
	[1] = {
		"models/cellar/characters/city3/citizens/male/c3_male_01.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_02.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_03.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_04.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_05.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_06.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_07.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_08.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_09.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_10.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_11.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_12.mdl",
		"models/cellar/characters/city3/citizens/male/c3_male_13.mdl",
	},
	[2] = {
		"models/cellar/characters/city3/citizens/female/c3_female_01.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_02.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_03.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_04.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_05.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_06.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_07.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_08.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_09.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_10.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_11.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_12.mdl",
		"models/cellar/characters/city3/citizens/female/c3_female_13.mdl",
	},
}

function FACTION:GetModels(client, gender)
	return self.models[gender]
end

function FACTION:GetRationType(character)
	return Schema:GetCitizenRationTypes(character)
end

function FACTION:OnCharacterCreated(client, character)
	character:CreateIDCard("card_cwu_head")
end

FACTION_CWU_HEAD = FACTION.index

Schema:SetFactionGroup(FACTION_CWU_HEAD, FACTION_GROUP_CWU)