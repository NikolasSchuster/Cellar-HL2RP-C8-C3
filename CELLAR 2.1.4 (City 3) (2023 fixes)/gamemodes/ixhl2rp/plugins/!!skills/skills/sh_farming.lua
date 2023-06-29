SKILL.name = "Фермерство"
SKILL.description = "Навык, определяющий мастерство в уходе за растениями."
SKILL.category = 4

function SKILL:GetRequiredXP(skills, level)
	return math.ceil(75 * (level ^ 1.525) + 100)
end

ix.action:Register("farmingWater", "farming", {
	name = "Поливание",
	experience = 28
})

ix.action:Register("farmingPlant", "farming", {
	name = "Посадка",
	experience = 35
})

ix.action:Register("farmingHarvest", "farming", {
	name = "Сбор",
	experience = 20
})