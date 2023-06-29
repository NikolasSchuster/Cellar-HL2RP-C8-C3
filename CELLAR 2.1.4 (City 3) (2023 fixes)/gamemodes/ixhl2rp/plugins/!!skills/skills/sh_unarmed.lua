SKILL.name = "Рукопашный бой"
SKILL.description = "Навык, определяющий шанс успешной атаки и парирования в рукопашном бою."
SKILL.category = 1

ix.action:Register("unarmedSuccess", "unarmed", {
	name = "Рукопашный бой",
	experience = {
		{level = 0, xp = 16},
		{level = 2, xp = 9},
		{level = 5, xp = 2}
	}
})

ix.action:Register("unarmedParry", "unarmed", {
	name = "Рукопашный бой (парирование)",
	noLogging = true,
	experience = {
		{level = 0, xp = 6},
		{level = 5, xp = 2}
	}
})

ix.action:Register("unarmedFail", "unarmed", {
	name = "Рукопашный бой (промах)",
	noLogging = true,
	experience = {
		{level = 0, xp = 2},
		{level = 5, xp = 1}
	}
})
