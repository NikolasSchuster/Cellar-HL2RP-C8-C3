
local charMeta = ix.meta.character

function charMeta:GetSpecialBoostsDuration()
	return self:GetVar("specialBoostsDuration", {})
end

function charMeta:GetSpecialBoostDuration(boostID)
	return self:GetSpecialBoostsDuration()[boostID]
end
