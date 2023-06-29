FACTION.name = "Народно-освободительная армия Китая"
FACTION.description = "Вы - рядовой боец народно-освободитьной армии Китая, сражайтесь за вашу свободу и свободу Китая."
FACTION.color = Color(101, 25, 25)
FACTION.isDefault = false
FACTION.bHumanVoices = true
FACTION.bCanUseRations = true
FACTION.models = {
	[1] = {
		"models/cellar/characters/city3/pla/male/male_pla.mdl",
	},
	[2] = {
		"models/cellar/characters/city3/pla/female/female_pla.mdl",
	},
}
FACTION.defaultLevel = 3
FACTION.startSkills = {
	["athletics"] = 4,
	["acrobatics"] = 4,
	["guns"] = 4,
	["unarmed"] = 3,
	["medicine"] = 3,
	["meleeguns"] = 3,
}

function FACTION:OnTransfered(client)
	local character = client:GetCharacter()

	character:SetModel(self.models[character:GetGender()])
end

function FACTION:GetModels(client, gender)
	return self.models[gender]
end

function FACTION:OnCharacterCreated(client, character)
	character:CreateIDCard("card_hacked")
end

FACTION_PLA = FACTION.index

Schema:SetFactionGroup(FACTION_PLA, FACTION_GROUP_PLA)