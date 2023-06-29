
util.AddNetworkString("ixLimbsPenaltiesProne")

-- forbid player from picking up player ragdolls if one of two legs is hurt to 0 (to prevent bugs with hands_hold_restrictions plugin)
function PLUGIN:CanPlayerHoldObject(client, entity)
	if (entity.ixPlayer) then
		local lLimbsDamage = self:GetLimbsDamage(client, false, "leftLeg", "rightLeg")

		if (lLimbsDamage[1] == 100 or lLimbsDamage[2] == 100) then
			return false
		end
	end
end

-- [slow down player if legs are hurt]
-- if this function being replicated even in skills plugin why we wouldn't do the same?
local function CalcAthleticsSpeed(athletics)
	return 1 + (athletics * 0.1) * 0.25
end

local function RecalculateSpeedPenalty(client, limb, character)
	local clientTeam = client:Team()

	if (clientTeam == FACTION_BIRD or clientTeam == FACTION_ZOMBIE or clientTeam == FACTION_SYNTH) then
		return
	end

	local secondLeg

	if (limb == "leftLeg") then
		secondLeg = "rightLeg"
	elseif (limb == "rightLeg") then
		secondLeg = "leftLeg"
	else
		return
	end

	local firstLegDamage = character:GetLimbDamage(limb, true)
	local secondLegDamage = character:GetLimbDamage(secondLeg, true)
	local slowDownFormula = 1

	if (firstLegDamage > 0 or secondLegDamage > 0) then
		slowDownFormula = slowDownFormula - ((firstLegDamage * 0.5) + (secondLegDamage * 0.5))
	end

	local walkSpeed = ix.config.Get("walkSpeed") * slowDownFormula
	local runSpeed = ix.config.Get("runSpeed") * CalcAthleticsSpeed(character:GetSkillModified("athletics")) * slowDownFormula

	if (!client:IsProne() and (firstLegDamage == 1 or secondLegDamage == 1)) then
		prone.Enter(client)

		net.Start("ixLimbsPenaltiesProne")
		net.Send(client)
	end

	if (walkSpeed != 0 and walkSpeed != client:GetWalkSpeed()) then
		client:SetWalkSpeed(walkSpeed)
	end
	if (runSpeed != 0 and runSpeed != client:GetRunSpeed()) then
		client:SetRunSpeed(runSpeed)
	end
end

function PLUGIN:PlayerLimbTakeDamage(client, limb, _, character)
	RecalculateSpeedPenalty(client, limb, character)
end

function PLUGIN:PlayerLimbDamageHealed(client, limb, _, character)
	RecalculateSpeedPenalty(client, limb, character)
end

function PLUGIN:PostPlayerLoadout(client)
	-- run speed is being set in the same hook so we need to wait a little bit
	timer.Simple(.1, function()
		local character = client and client:GetCharacter()

		if (character) then
			RecalculateSpeedPenalty(client, "leftLeg", character)
		end
	end)
end

-- prevent athletics skill from breaking speed penalty
function PLUGIN:CharacterSkillUpdated(client, character, key)
	if (key == "athletics") then
		timer.Simple(.1, function()
			if (client and character) then
				RecalculateSpeedPenalty(client, "leftLeg", character)
			end
		end)
	end
end
