SKILL.name = "Холодное оружие"
SKILL.description = "Навык, определяющий шанс успешной атаки и парирования холодным оружием."
SKILL.category = 1

ix.action:Register("meleeSuccess", "meleeguns", {
	name = "Ближний бой",
	experience = {
		{level = 0, xp = 16},
		{level = 2, xp = 9},
		{level = 5, xp = 3}
	}
})

ix.action:Register("meleeParry", "meleeguns", {
	name = "Ближний бой (парирование)",
	noLogging = true,
	experience = {
		{level = 0, xp = 8},
		{level = 5, xp = 4}
	}
})

ix.action:Register("meleeMiss", "meleeguns", {
	name = "Ближний бой (промах)",
	noLogging = true,
	experience = {
		{level = 0, xp = 4},
		{level = 5, xp = 2}
	}
})