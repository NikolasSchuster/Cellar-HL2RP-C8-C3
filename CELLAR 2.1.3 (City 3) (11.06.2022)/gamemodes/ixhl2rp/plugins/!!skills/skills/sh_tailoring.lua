SKILL.name = "Портняжное дело"
SKILL.description = "Навык, позволяющий создавать различную одежду."
SKILL.category = 4

function SKILL:GetRequiredXP(skills, level)
	return math.ceil(75 * (level ^ 1.525) + 100)
end

ix.action:Register("craft_tailoring", "tailoring", {
	name = "Крафт",
	experience = function(action, character, skill, price)
		return price
	end
})