FACTION.name = "Вортигонт"
FACTION.description = "Таинственное существо из мира Зен. Его мудрость и знания могут стать мощным оружием."
FACTION.color = Color(86, 102, 13, 255)
FACTION.models = {"models/vortigaunt_slave.mdl"}
FACTION.genders = {1}
FACTION.isDefault = false
FACTION.bCanUseRations = true
FACTION.bAllowDatafile = true
FACTION.weapons = {"ix_vortbroom"}

function FACTION:GetRationType(client)
	return "ration_biotic"
end

function FACTION:GetModels(client, gender)
	return self.models
end

function FACTION:OnSpawn(client)
	client:SetBloodColor(BLOOD_COLOR_YELLOW)
end

FACTION_VORTIGAUNT = FACTION.index
