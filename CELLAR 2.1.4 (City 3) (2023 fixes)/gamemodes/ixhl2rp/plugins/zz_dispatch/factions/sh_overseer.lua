FACTION.name = "Combine Civil Authority Overseer"
FACTION.description = ""
FACTION.color = Color(50, 100, 150)
FACTION.isDefault = false
FACTION.bCanUseRations = true
FACTION.bAllowDatafile = true
FACTION.isLocallyRecognized = true
FACTION.canSeeWaypoints = true

FACTION.scoreboardClass = "scMPF"

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
	["npc_combine_s"] = D_NU,
	["CombinePrison"] = D_NU,
	["CombineElite"] = D_NU,
	["npc_manhack"] = D_LI
}

FACTION.listenChannels = {
	["cp_main"] = 1,
	["overwatch"] = 1,
}

function FACTION:OnCharacterCreated(client, character)
	character:CreateIDCard("card_cmb")
end

function FACTION:GetModels(client, gender)
	return self.models[gender]
end

function FACTION:GetDefaultName(client)
	return "CCA:OVERSEER-"..Schema:ZeroNumber(math.random(1, 999), 3), true
end

function FACTION:GetRationType(character)
	return "ration_tier_3"
end

function FACTION:OnTransfered(client)
	local character = client:GetCharacter()

	character:SetModel(self.models[1])
end

function FACTION:OnNameChanged(client, oldValue, value)

end

FACTION_MPF2 = FACTION.index

Schema:SetFactionGroup(FACTION_MPF2, FACTION_GROUP_COMBINE)
