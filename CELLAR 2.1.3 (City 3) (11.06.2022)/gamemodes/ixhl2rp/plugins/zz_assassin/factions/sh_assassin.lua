FACTION.name = "Ассассин Патруля"
FACTION.isDefault = false
FACTION.color = Color(151, 42, 97)
FACTION.scoreboardClass = "scOTA"
FACTION.models = {
	[1] = {"models/schwarzkruppzo/assassin.mdl"}
}

FACTION.genders = {2}

FACTION.isGloballyRecognized = true
FACTION.dontNeedFood = true
FACTION.defaultLevel = 6
FACTION.startSkills = {
	["athletics"] = 10,
	["acrobatics"] = 10,
	["guns"] = 10,
	["unarmed"] = 5,
	["medicine"] = 5,
	["meleeguns"] = 10,
	["impulse"] = 10,
}
FACTION.listenChannels = {
	["cp_main"] = 1,
	["overwatch"] = 1,
}

function FACTION:GetModels(client, gender)
	return self.models[1]
end

function FACTION:GetDefaultName(client)
	return "OW:ASSASSIN-" .. math.random(1, 99), true
end

function FACTION:OnCharacterCreated(client, character)
	character:CreateIDCard("ota_access")
	character:SetSpecial("in", 10)
	character:SetSpecial("en", 10)
	character:SetSpecial("pe", 10)
end

function FACTION:CharacterLoaded(character)
end

function FACTION:OnTransfered(client)
	local character = client:GetCharacter()

	character:SetName(self:GetDefaultName())
	character:SetModel(self.models[1])
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

FACTION_ASS = FACTION.index

Schema:SetFactionGroup(FACTION_ASS, FACTION_GROUP_OTA)