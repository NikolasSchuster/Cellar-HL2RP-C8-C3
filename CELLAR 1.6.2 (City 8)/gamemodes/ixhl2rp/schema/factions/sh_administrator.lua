FACTION.name = "Городской Администратор"
FACTION.description = "Человеческое представительство Альянса на нашей планете."
FACTION.color = Color(255, 200, 100, 255)
FACTION.bHumanVoices = true
FACTION.bCanUseRations = true
FACTION.bAllowDatafile = true
FACTION.models = {
	[1] = {"models/cellar/characters/gurevich.mdl"},
	[2] = {"models/group17/female_01.mdl"}
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
    character:CreateIDCard("card_ca_head")
end

function FACTION:OnCharacterCreated(client, character)

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

FACTION_ADMIN_HEAD = FACTION.index
