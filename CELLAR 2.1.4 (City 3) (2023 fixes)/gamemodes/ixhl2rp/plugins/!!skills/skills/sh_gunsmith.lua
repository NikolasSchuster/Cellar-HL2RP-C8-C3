SKILL.name = "Оружейник"
SKILL.description = "Навык, позволяющий создавать различное холодное и огнестрельное оружие, боеприпасы."
SKILL.category = 4

function SKILL:GetRequiredXP(skills, level)
	return math.ceil(200 * (level ^ 1.875) + 200)
end

ix.action:Register("craft_gunsmith", "gunsmith", {
	name = "Крафт",
	experience = function(action, character, skill, price)
		return price
	end
})