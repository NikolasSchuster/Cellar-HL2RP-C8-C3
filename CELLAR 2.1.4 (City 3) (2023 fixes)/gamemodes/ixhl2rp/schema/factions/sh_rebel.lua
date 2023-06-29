FACTION.name = "Сопротивление"
FACTION.description = "Вы - рядовой боец сопротивления, сражайтесь за вашу свободу и постарайтесь выжить."
FACTION.color = Color(199, 53, 0, 255)
FACTION.isDefault = false
FACTION.bHumanVoices = true
FACTION.bCanUseRations = true
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

function FACTION:OnCharacterCreated(client, character)
	
end

FACTION_REBEL = FACTION.index

Schema:SetFactionGroup(FACTION_REBEL, FACTION_GROUP_REBEL)
