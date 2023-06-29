ix.action = ix.action or {}
ix.action.list = ix.action.list or {}

function ix.action:Register(uniqueID, skill, data)
	if !uniqueID or !isstring(uniqueID) then
		return
	end

	data.uniqueID = uniqueID
	data.name = data.name or "Unknown"
	data.skill = skill

	if data.experience and istable(data.experience) and data.experience[1] then
		table.SortByMember(data.experience, "level", true)
		data.experience[#data.experience + 1] = {level = math.huge, xp = 0}
	end

	ix.action.list[uniqueID] = data
end

function ix.action:Get(id)
	return ix.action.list[id]
end

do
	local CHAR = ix.meta.character

	function CHAR:CanDoAction(actionID, ...)
		local action = ix.action:Get(actionID)

		if !action then
			return
		end

		if !action.CanDo then
			return true
		end

		if !isfunction(action.CanDo) then
			return self:GetSkill(action.skill) >= action.CanDo
		else
			return action:CanDo(self, self:GetSkill(action.skill), ...)
		end
	end

	if SERVER then

		function CHAR:XPStarvationMod(experience)
			local hunger = self:GetHunger()
			local mod = 1

			if hunger < 75 and hunger >= 50 then
				mod = 0.75
			elseif hunger < 50 and hunger >= 25 then
				mod = 0.5
			elseif hunger < 25 and hunger > 2 then
				mod = 0.25
			elseif hunger < 3 then
				mod = 0
			end

			return experience * mod
		end

		function CHAR:DoAction(actionID, ...)
			local action = ix.action:Get(actionID)
			local result = self:GetActionResult(action, ...)

			if result and result > 0 then
				local int = self:GetSpecial("in")
				local intFactor = 0.15 + math.Clamp(math.Remap(int, 1, 5, 0, 0.85), 0, 0.85) + math.Clamp(math.Remap(int, 5, 10, 0, 0.5), 0, 0.5)

				result = result * intFactor

				result = self:XPStarvationMod(result)

				self:UpdateSkillProgress(action.skill, result)

				if !action.noLogging then
					ix.log.Add(self:GetPlayer(), "skillAction", action.name, result, action.skill)
				end
			elseif action.alwaysLog then
				ix.log.Add(self:GetPlayer(), "skillActionNoExp", action.name)
			end
		end
	end

	local function GetXP(DoResult, skillLevel)
		for k, v in ipairs(DoResult) do
			if v.level > skillLevel then
				break
			elseif v.level <= skillLevel and skillLevel < DoResult[k + 1].level then
				return v.xp
			end
		end

		return 0
	end

	function CHAR:GetActionResult(action, ...)
		if !action.experience then
			return 0
		end

		local skill = self:GetSkill(action.skill)

		if isnumber(action.experience) then
			return action.experience
		elseif !isfunction(action.experience) then
			return GetXP(action.experience, skill)
		else
			return action:experience(self, skill, ...)
		end
	end
end

if SERVER then
	ix.log.AddType("skillAction", function(client, name, result, skill)
		return string.format("%s совершил '%s' действие, получив %d опыта в навыке %s.", client:GetName(), name, result, skill)
	end)

	ix.log.AddType("skillActionNoExp", function(client, name)
		return string.format("%s совершил '%s' действие.", client:GetName(), name)
	end)
end