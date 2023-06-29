SKILL.name = "Ремесло"
SKILL.description = "Навык, позволяющий перерабатывать различные материалы."
SKILL.category = 4

function SKILL:GetRequiredXP(skills, level)
	return math.ceil(250 * (level ^ 1.3) + 75)
end

ix.action:Register("craft_crafting", "crafting", {
	name = "Крафт",
	experience = function(action, character, skill, price)
		return price
	end
})