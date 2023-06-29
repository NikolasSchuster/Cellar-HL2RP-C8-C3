
ix.config.Add("skillsTextbooksVolumeCount", 3, "The maximum number of skills textbooks that will be generated.", nil, {
	data = {min = 1, max = 3},
	category = "skillsTextbooks"
})
ix.config.Add("skillsTextbooksMinReadTime", 3600, "The time it takes to study first volume of a skill textbook in seconds.", nil, {
	data = {min = 1800, max = 7200},
	category = "skillsTextbooks"
})
ix.config.Add("skillsTextbooksMinXP", 500, "Minimum XP character will gain after completing skill textbook.", nil, {
	data = {min = 500, max = 1000},
	category = "skillsTextbooks"
})

if (SERVER) then
	ix.log.AddType("studiedSkillTextbook", function(client, volumeNumber, volumeCount, skillName, skillXP)
		return Format("%s have completed %s of %s %s skill volumes and gainex %s XP points.", client:Name(), volumeNumber, volumeCount, skillName, skillXP)
	end, FLAG_NORMAL)
end
