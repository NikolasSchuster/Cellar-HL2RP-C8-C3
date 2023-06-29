SKILL.name = "Акробатика"
SKILL.description = "Навык, определяющий силу прыжка."
SKILL.category = 3

ix.action:Register("jump", "acrobatics", {
	name = "Прыжок",
	noLogging = true,
	experience = {
		{level = 0, xp = 2},
		{level = 3, xp = 1},
	}
})

function SKILL:OnLevelUp(client, character)
	client:SetJumpPower(160 * (1 + math.min(math.Remap(character:GetSkillModified("acrobatics"), 0, 10, 0, 0.75), 0.75)))
end