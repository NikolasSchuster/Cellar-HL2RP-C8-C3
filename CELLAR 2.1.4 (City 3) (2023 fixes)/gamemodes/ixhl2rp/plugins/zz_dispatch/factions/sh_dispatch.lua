FACTION.name = "ИИ Надзора"
FACTION.description = ""
FACTION.color = Color(50, 100, 150)
FACTION.isDefault = false

FACTION.bCanUseRations = false
FACTION.bAllowDatafile = true
FACTION.dontNeedFood = true
FACTION.tempImmunity = true

FACTION.isGloballyRecognized = true
FACTION.isLocallyRecognized = true
FACTION.canSeeWaypoints = true

FACTION.scoreboardClass = "scMPF"

FACTION.models = {"models/dav0r/hoverball.mdl"}
FACTION.genders = {1}

FACTION.npcRelations = {
	["npc_turret_floor"] = D_LI,
	["npc_combine_camera"] = D_LI,
	["npc_turret_ceiling"] = D_LI,
	["npc_rollermine"] = D_LI,
	["npc_helicopter"] = D_LI,
	["npc_combinegunship"] = D_LI,
	["npc_strider"] = D_LI,
	["npc_metropolice"] = D_LI,
	["npc_hunter"] = D_LI,
	["npc_combine_s"] = D_LI,
	["CombinePrison"] = D_LI,
	["CombineElite"] = D_LI,
	["npc_manhack"] = D_LI
}

FACTION.listenChannels = {
	["cp_main"] = 1,
	["overwatch"] = 1,
}

function FACTION:OnCharacterCreated(client, character) end

function FACTION:GetModels(client, gender)
	return self.models
end

function FACTION:GetDefaultName(client)
	return "Overwatch AI-"..Schema:ZeroNumber(math.random(1, 999), 3), true
end

function FACTION:OnTransfered(client)
	local character = client:GetCharacter()

	character:SetName(self:GetDefaultName())
	character:SetModel(self.models[1])
end

function FACTION:OnSpawn(client)
	dispatch.SetDispatchMode(client, true)
end

FACTION_DISPATCH = FACTION.index

Schema:SetFactionGroup(FACTION_DISPATCH, FACTION_GROUP_COMBINE)