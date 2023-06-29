ix.config.Add("needsHungerHours", 6, "How many hours it takes for a player to gain 60 hunger.", nil, {
	data = {min = 1, max = 24},
	category = "needs"
})

ix.config.Add("needsThirstHours", 4, "How many hours it takes for a player to gain 60 thirst.", nil, {
	data = {min = 1, max = 24},
	category = "needs"
})

ix.config.Add("needsTickTime", 4, "How many seconds between each time a character's needs are calculated.", nil, {
	data = {min = 1, max = 24},
	category = "needs"
})