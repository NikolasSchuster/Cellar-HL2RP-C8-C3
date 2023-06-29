local PLUGIN = PLUGIN

PLUGIN.name = "Combie Visors"
PLUGIN.author = "maxxoft"
PLUGIN.description = "Combine mask-based visors."

local CHAR = ix.meta.character
local PLAYER = FindMetaTable("Player")

function CHAR:GetVisorLevel()
	local inv = self:GetEquipment()
	if not inv then return end
	local visorLevel = inv:GetItemAtSlot(EQUIP_MASK) and inv:GetItemAtSlot(EQUIP_MASK).visorLevel or 0

	if self:IsOTA() then visorLevel = 2 end
	return visorLevel
end

function PLAYER:CanUseNightVision()
	return self:IsOTA() or (self:GetCharacter():GetVisorLevel() == 2)
end

function CHAR:HasVisor()
	return self:IsOTA() or (self:GetVisorLevel() != 0)
end
