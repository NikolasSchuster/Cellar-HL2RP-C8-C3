
ix.config.Add("languageTextbooksVolumeCount", 3, "The maximum number of language textbooks that will be generated and needed to be read in order to study a language.", nil, {
	data = {min = 1, max = 4},
	category = "languages"
})

ix.config.Add("languageTextbooksMinReadTime", 3600, "The time it takes to study first volume of a language textbook in seconds.", nil, {
	data = {min = 1800, max = 7200},
	category = "languages"
})

if (SERVER) then
	ix.log.AddType("languageGiven", function(client, targetName, languageName)
		return Format("%s gave to %s %s language.", client:Name(), targetName, languageName)
	end, FLAG_NORMAL)

	ix.log.AddType("languageTaken", function(client, targetName, languageName)
		return Format("%s took from %s %s language.", client:Name(), targetName, languageName)
	end, FLAG_NORMAL)

	ix.log.AddType("studiedLanguageTextbook", function(client, volumeNumber, volumeCount, languageName)
		return Format("%s have completed %s of %s %s language volumes.", client:Name(), volumeNumber, volumeCount, languageName)
	end, FLAG_NORMAL)

	ix.log.AddType("studiedLanguage", function(client, languageName)
		return Format("%s have studied %s language.", client:Name(), languageName)
	end, FLAG_NORMAL)
end
