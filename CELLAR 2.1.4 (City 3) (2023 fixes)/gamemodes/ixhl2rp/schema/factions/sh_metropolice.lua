FACTION.name = "Combine Civil Authority"
FACTION.description = "Рекрут большой системы CCA."
FACTION.color = Color(50, 100, 150)
FACTION.isDefault = false
FACTION.bCanUseRations = true
FACTION.bAllowDatafile = true
FACTION.isLocallyRecognized = true
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

FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}
FACTION.typingBeeps = {"MPF.RadioOn", "MPF.RadioOff"}

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
	["npc_manhack"] = D_LI
}

function FACTION:OnCharacterCreated(client, character)
	character:CreateIDCard("card_mpf")
end

function FACTION:GetModels(client, gender)
	return self.models[gender]
end

function FACTION:GetDefaultName(client)
	return "CCA:c08.r." .. Schema:ZeroNumber(math.random(1, 9999), 4), true
end

function FACTION:GetRationType(character)
	return "ration_tier_3"
end

function FACTION:OnTransfered(client)
	local character = client:GetCharacter()

	character:SetName(self:GetDefaultName())
	character:SetModel(self.models[1])
end

function FACTION:OnNameChanged(client, oldValue, value)

end

FACTION_MPF = FACTION.index

Schema:SetFactionGroup(FACTION_MPF, FACTION_GROUP_COMBINE)