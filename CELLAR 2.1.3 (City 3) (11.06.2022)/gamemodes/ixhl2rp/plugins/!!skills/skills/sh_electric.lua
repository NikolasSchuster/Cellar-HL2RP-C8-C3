SKILL.name = "Электроника"
SKILL.description = "Навык, позволяющий разбирать и создавать различную электронику."
SKILL.category = 4

function SKILL:GetRequiredXP(skills, level)
	return math.ceil(75 * (level ^ 1.55) + 100)
end

ix.action:Register("craft_electric", "electric", {
	name = "Крафт",
	experience = function(action, character, skill, price)
		return price
	end
})