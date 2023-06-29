SKILL.name = "Оружие"
SKILL.description = "Навык, определяющий шанс попадания при стрельбе."
SKILL.category = 1

ix.action:Register("shootSuccess", "guns", {
	name = "Стрельба",
	experience = {
		{level = 0, xp = 15},
		{level = 3, xp = 10},
		{level = 5, xp = 5}
	}
})

ix.action:Register("shootFarSuccess", "guns", {
	name = "Стрельба на дальней дистанции",
	experience = {
		{level = 0, xp = 30},
		{level = 3, xp = 20},
		{level = 5, xp = 15}
	}
})

ix.action:Register("shootTraining", "guns", {
	name = "Стрельба (тренировка)",
	noLogging = true,
	experience = {
		{level = 0, xp = 8},
		{level = 4, xp = 4},
		{level = 8, xp = 2}
	}
})

ix.action:Register("shootMiss", "guns", {
	name = "Стрельба (промах)",
	noLogging = true,
	experience = {
		{level = 0, xp = 3},
		{level = 5, xp = 1}
	}
})