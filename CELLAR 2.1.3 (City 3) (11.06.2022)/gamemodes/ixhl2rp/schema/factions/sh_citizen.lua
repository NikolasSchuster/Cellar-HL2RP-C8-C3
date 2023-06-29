FACTION.name = "Гражданин"
FACTION.description = "A regular human citizen enslaved by the Universal Union."
FACTION.color = Color(150, 125, 100, 255)
FACTION.isDefault = true
FACTION.bHumanVoices = true
FACTION.bCanUseRations = true
FACTION.bAllowDatafile = true
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
FACTION.npcRelations = {
	["npc_strider"] = D_HT,
	["npc_metropolice"] = D_NU
}

function FACTION:GetModels(client, gender)
	return self.models[gender]
end

function FACTION:GetRationType(character)
	return Schema:GetCitizenRationTypes(character)
end

function FACTION:OnCharacterCreated(client, character)
	character:CreateIDCard("card")
end

function FACTION:GenerateName(gender)
	local isMale = gender == 1
	local firstname = GetHumanFirstNames(isMale)[isMale and math.random(1, HUMAN_NAMES_MALE) or math.random(1, HUMAN_NAMES_FEMALE)]
	local lastname = GetHumanLastNames()[math.random(1, HUMAN_LASTNAMES)]

	return firstname:sub(1, 1):upper() .. firstname:sub(2):lower() .. " " .. lastname:sub(1, 1):upper() .. lastname:sub(2):lower()
end

FACTION_CITIZEN = FACTION.index
