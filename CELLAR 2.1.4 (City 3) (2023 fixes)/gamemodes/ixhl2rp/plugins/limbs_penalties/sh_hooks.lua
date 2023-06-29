
-- reduce stamina restoration if chest is hurt
function PLUGIN:AdjustStaminaOffset(client, offset)
	if (offset > 0) then
		local cDamageFraction = self:GetLimbsDamage(client, true, "chest")[1]

		if (isnumber(cDamageFraction)) then
			return offset * (1 - cDamageFraction)
		end
	end
end

function PLUGIN:StartCommand(client, cUserCmd)
	local lLimbsDamage = self:GetLimbsDamage(client, false, "leftLeg", "rightLeg")

	if (lLimbsDamage[1] == 100 and lLimbsDamage[2] == 100) then
		cUserCmd:ClearMovement()
	end
end

-- forbid player from exiting prone mode if one of two legs is hurt to 0
PLUGIN["prone.CanExit"] = function(self, client)
	local lLimbsDamage = self:GetLimbsDamage(client, false, "leftLeg", "rightLeg")

	if (lLimbsDamage[1] == 100 or lLimbsDamage[2] == 100) then
		return false
	end
end
