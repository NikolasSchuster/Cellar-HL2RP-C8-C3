local PLUGIN = PLUGIN

util.AddNetworkString("ixSkillRoll")
util.AddNetworkString("ixStatRoll")

net.Receive("ixLevelUp", function(len, ply)
	local character = ply:GetCharacter()

	if !character:GetData("levelup") then
		return
	end

	local specials = net.ReadTable()
	local lvl = character:GetLevel()
	local pointsmax = 6 + (5 + (5 * math.min(lvl, 5)) + (1 * math.max(lvl - 5, 0)))

	if istable(value) then
		local count = 0

		for _, v in pairs(value) do
			count = count + v + -1
		end

		if count < pointsmax then
			return
		end
	end

	character:SetData("levelup", false)
	character:SetSpecials(specials)
end)

do
	local charMeta = ix.meta.character

	function charMeta:SkillRoll(skillID)
		local client = self:GetPlayer()
		local skillValue = self:GetSkillModified(skillID)
		local success = false
		local value = math.random(0, 10)

		if value == 1 then
			success = true
		elseif value == 10 then
			success = false
		elseif value <= skillValue then
			success = true
		end

		ix.chat.Send(client, "skillroll", tostring(value), nil, nil, {
			check = skillValue,
			skill = skillID,
			success = success,
		})

		ix.log.Add(client, "skillroll", skillID, success, value, skillValue)
	end

	function charMeta:StatRoll(attributeID)
		local client = self:GetPlayer()
		local statValue = self:GetSpecial(attributeID, 0)
		local success = false
		local value = math.random(1, 10)

		if value == 1 then
			success = true
		elseif value == 10 then
			success = false
		elseif value <= statValue then
			success = true
		end

		ix.chat.Send(client, "statroll", tostring(value), nil, nil, {
			check = statValue,
			stat = attributeID,
			success = success,
		})

		ix.log.Add(client, "statroll", attributeID, success, value, statValue)
	end
end

net.Receive("ixSkillRoll", function(len, ply)
	local skillID = net.ReadString()
	local character = ply:GetCharacter()

	if !ply.isSkillRoll then
		return
	end

	if !character then 
		return
	end

	if !ix.skills.list[skillID] then
		return ply:NotifyLocalized("skillNotFound")
	end

	character:SkillRoll(skillID)

	ply.isSkillRoll = false
end)

net.Receive("ixStatRoll", function(len, ply)
	local statID = net.ReadString()
	local character = ply:GetCharacter()

	if !ply.isStatRoll then
		return
	end

	if !character then 
		return
	end

	if !ix.specials.list[statID] then
		return ply:NotifyLocalized("attributeNotFound")
	end

	character:StatRoll(statID)

	ply.isStatRoll = false
end)

ix.log.AddType("skillroll", function(client, ...)
	local arg = {...}
	return string.format("%s (%s %s) has rolled %s out of 100 (%s).", client:Name(), arg[1], arg[4], arg[3], arg[2] and "SUCCESS" or "FAIL")
end)

ix.log.AddType("statroll", function(client, ...)
	local arg = {...}
	return string.format("%s (%s %s) has rolled %s out of 10 (%s).", client:Name(), arg[1], arg[4], arg[3], arg[2] and "SUCCESS" or "FAIL")
end)


-- Athletics Skill Related code
local function CalcAthleticsSpeed(athletics)
	return 1 + (athletics * 0.1) * 0.25
end

local function CalcAthleticsFatigue(athletics)
	return (athletics * 0.1) * 0.5
end

local walkSpeed
local function CalcAthleticsTrain(client)
	local character = client:GetCharacter()

	if (!character or client:GetMoveType() == MOVETYPE_NOCLIP or IsValid(client.ixRagdoll)) then
		return
	end

	walkSpeed = ix.config.Get("walkSpeed")
	local xp = 0

	if (client:KeyDown(IN_SPEED) and client:GetVelocity():LengthSqr() >= (walkSpeed * walkSpeed)) then
		xp = 1
	elseif client:GetVelocity():LengthSqr() >= (walkSpeed * walkSpeed) then
		xp = 0.25
	end

	if xp > 0 then
		character:DoAction("athleticsRun", xp)
	end
end

function PLUGIN:PostPlayerLoadout(client)
	ix.specials.Setup(client)

	local character = client:GetCharacter()

	if character then
		client:SetRunSpeed(ix.config.Get("runSpeed") * CalcAthleticsSpeed(character:GetSkillModified("athletics")))
		client:SetJumpPower(160 * (1 + math.min(math.Remap(character:GetSkillModified("acrobatics"), 0, 10, 0, 0.75), 0.75)))

		local uniqueID = "ixAthletics" .. client:SteamID()
		timer.Create(uniqueID, 1, 0, function()
			if (!IsValid(client)) then
				timer.Remove(uniqueID)
				return
			end

			CalcAthleticsTrain(client)
		end)
	end
end
