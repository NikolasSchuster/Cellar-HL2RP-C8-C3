ix.skills = ix.skills or {}
ix.skills.list = ix.skills.list or {}

function ix.skills.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		SKILL = ix.skills.list[niceName] or {}
			if (PLUGIN) then
				SKILL.plugin = PLUGIN.uniqueID
			end

			ix.util.Include(directory.."/"..v)

			SKILL.name = SKILL.name or "Unknown"
			SKILL.description = SKILL.description or "No description availalble."
			SKILL.OnDefault = function(self)
				return {0, 0} -- Base, Progress
			end
			SKILL.GetMaximum = SKILL.GetMaximum or function(self, character, skills)
				return 10
			end
			SKILL.GetRequiredXP = SKILL.GetRequiredXP or function(self, skills, level)
				return math.ceil(75 * (level^1.95) + 100)
			end
			SKILL.GetInitial = SKILL.GetInitial or function(self, attributes)
				return 0
			end

			ix.skills.list[niceName] = SKILL
		SKILL = nil
	end
end

function ix.skills.Setup(client)
	local character = client:GetCharacter()

	if character then
		for k, v in pairs(ix.skills.list) do
			if v.OnSetup then
				v:OnSetup(client, character:GetSkill(k, 0))
			end
		end
	end
end

do
	local charMeta = ix.meta.character

	if SERVER then
		util.AddNetworkString("ixSkillUpdate")

		function charMeta:UpdateSkillProgress(key, xp)
			local skill = ix.skills.list[key]

			if !skill then
				return
			end

			local skills = self:GetSkills()

			if !skills[key] then
				return
			end

			local client = self:GetPlayer()
			local value = skills[key][1]
			local required = skill:GetRequiredXP(skills, value)
			local oldXP = (skills[key][2] or 0)

			skills[key][2] = oldXP + xp

			self:SetSkills(skills)

			if IsValid(client) then
				net.Start("ixSkillUpdate")
					net.WriteUInt(self:GetID(), 32)
					net.WriteString(key)
					net.WriteTable(skills[key])
				net.Send(client)

				hook.Run("CharacterSkillProgressUpdated", client, self, key, xp > oldXP)
			end

			if skills[key][2] >= required then
				local xp = math.max(skills[key][2] - required, 0)

				self:IncreaseSkill(key, xp)
			end
		end

		function charMeta:IncreaseSkill(key, xp)
			local skill = ix.skills.list[key]

			if !skill then
				return
			end

			local skills = self:GetSkills()

			if !skills[key] then
				return
			end

			local max = skill:GetMaximum(self, skills)
			local value = skills[key][1]
			local newValue = math.Clamp(value + 1, 0, max)

			if newValue != value then
				skills[key][1] = newValue
				skills[key][2] = 0

				self:SetSkills(skills)

				local client = self:GetPlayer()

				if IsValid(client) then
					net.Start("ixSkillUpdate")
						net.WriteUInt(self:GetID(), 32)
						net.WriteString(key)
						net.WriteTable(skills[key])
					net.Send(client)

					hook.Run("CharacterSkillUpdated", client, self, key, newValue > value)
				end

				if xp then
					self:UpdateSkillProgress(key, xp)
				end
			end
		end

		function charMeta:SetSkill(key, value)
			local skill = ix.skills.list[key]
		
			if !skill then
				return
			end

			local skills = self:GetSkills()

			if !skills[key] then
				return
			end

			value = math.floor(value)
			
			local max = skill:GetMaximum(self, skills)
			local lastValue = skills[key][1]
			local newValue = math.min(value, max)

			if newValue != lastValue then
				skills[key][1] = newValue

				self:SetSkills(skills)

				local client = self:GetPlayer()

				if IsValid(client) then
					net.Start("ixSkillUpdate")
						net.WriteUInt(self:GetID(), 32)
						net.WriteString(key)
						net.WriteTable(skills[key])
					net.Send(client)

					hook.Run("CharacterSkillUpdated", client, self, key, newValue > lastValue)
				end
			end
		end

		function charMeta:AddSkillBoost(boostID, skillID, boostAmount)
			boostAmount = math.floor(boostAmount)
			
			local boosts = self:GetVar("skillboosts", {})

			boosts[skillID] = boosts[skillID] or {}
			boosts[skillID][boostID] = boostAmount

			hook.Run("CharacterSkillBoosted", self:GetPlayer(), self, skillID, boostID, boostAmount)

			return self:SetVar("skillboosts", boosts, nil, self:GetPlayer())
		end

		function charMeta:RemoveSkillBoost(boostID, skillID)
			local boosts = self:GetVar("skillboosts", {})

			boosts[skillID] = boosts[skillID] or {}
			boosts[skillID][boostID] = nil

			hook.Run("CharacterSkillBoosted", self:GetPlayer(), self, skillID, boostID, true)

			return self:SetVar("skillboosts", boosts, nil, self:GetPlayer())
		end
	else
		net.Receive("ixSkillUpdate", function()
			local id = net.ReadUInt(32)
			local character = ix.char.loaded[id]

			if character then
				local key = net.ReadString()
				local skillTable = net.ReadTable()

				skillTable[1] = skillTable[1] or 1
				skillTable[2] = skillTable[2] or 0

				character:GetSkills()[key] = skillTable
			end
		end)
	end

	function charMeta:GetSkillBoosts()
		return self:GetVar("skillboosts", {})
	end

	function charMeta:GetSkillBoost(key)
		local boosts = self:GetSkillBoosts()

		return boosts[key]
	end

	function charMeta:GetSkill(key)
		return self:GetSkills()[key][1] or 0
	end

	function charMeta:GetSkillModified(key)
		local skill = self:GetSkill(key)
		local boosts = self:GetSkillBoosts()[key]

		if boosts then
			for _, v in pairs(boosts) do
				skill = skill + v
			end
		end

		return skill
	end
end
