
local charMeta = ix.meta.character

function charMeta:AttachDurationToSpecialBoost(boostID, duration)
	local specialBoostsDuration = self:GetSpecialBoostsDuration(boostID)

	specialBoostsDuration[boostID] = duration

	self:SetVar("specialBoostsDuration", specialBoostsDuration)
end

function charMeta:AddSpecialBoostWithDuration(boostID, attribID, boostAmount, duration)
	local bSuccess = self:AddSpecialBoost(boostID, attribID, boostAmount)

	if (bSuccess) then
		self:AttachDurationToSpecialBoost(boostID, duration)
	end
end

-- override: Septic wants positive boost to not exceed the number of 3
function charMeta:AddSpecialBoost(boostID, attribID, boostAmount)
	local boosts = self:GetVar("specialboosts", {})
	local attribBoosts = 0

	boosts[attribID] = boosts[attribID] or {}

	for _, v in pairs(boosts[attribID]) do
		attribBoosts = attribBoosts + v
	end

	if ((attribBoosts + boostAmount) > 3) then
		return false
	end

	boosts[attribID][boostID] = boostAmount

	hook.Run("CharacterSpecialBoosted", self:GetPlayer(), self, attribID, boostID, boostAmount)
	self:SetVar("specialboosts", boosts)

	return true
end
