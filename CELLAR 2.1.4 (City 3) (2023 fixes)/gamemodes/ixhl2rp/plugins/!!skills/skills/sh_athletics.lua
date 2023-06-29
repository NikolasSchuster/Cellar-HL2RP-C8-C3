SKILL.name = "Атлетика"
SKILL.description = "Навык, определяющий скорость и как сильно тратится выносливость во время бега."
SKILL.category = 3

ix.action:Register("athleticsRun", "athletics", {
	name = "Бег",
	noLogging = true,
	experience = function(action, character, skill, value)
		return value
	end
})

local function CalcAthleticsSpeed(athletics)
	return 1 + (athletics * 0.1) * 0.25
end

function SKILL:OnLevelUp(client, character)
	client:SetRunSpeed(ix.config.Get("runSpeed") * CalcAthleticsSpeed(character:GetSkillModified("athletics")))
end
