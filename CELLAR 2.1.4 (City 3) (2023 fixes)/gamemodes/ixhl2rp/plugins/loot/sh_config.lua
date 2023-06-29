ix.config.Add("garbage_respawn_tick", 400, "The time of garbage respawn in seconds.", nil, {
	data = {min = 0, max = 3600},
	category = "garbage"
})

ix.config.Add("garbage_clean_time", 5, "The time of cleaning process.", nil, {
	data = {min = 0, max = 60},
	category = "garbage"
})
