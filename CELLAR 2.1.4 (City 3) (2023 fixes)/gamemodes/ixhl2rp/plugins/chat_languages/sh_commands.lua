
ix.command.Add("CharGiveLanguage", {
	description = "@cmdCharGiveLanguage",
	superAdminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.string
	},
	OnRun = function(self, client, target, languageName)
		local targetClient = target:GetPlayer()
		local languageID, translatedName

		for k, v in pairs(ix.chatLanguages.GetAll()) do
			translatedName = L(v.name, client)

			if (ix.util.StringMatches(translatedName, languageName)) then
				local timerID = "ixStudyingLanguage" .. targetClient:SteamID()
				languageID = k
				languageName = v.name

				if (timer.Exists(timerID)) then
					targetClient:SetAction()
				end

				target:ResetLanguageLeftStudyTime(k)

				break
			end
		end

		if (languageID) then
			local targetName = target:GetName()

			if (!target:CanSpeakLanguage(languageID)) then
				target:SetStudiedLanguages(languageID, true)
				client:NotifyLocalized("cLanguageGivenFrom", translatedName, targetName)

				if (client != targetClient) then
					targetClient:NotifyLocalized("cLanguageGivenTo", client:Name(), L(languageName, targetClient))
				end

				ix.log.Add(client, "languageGiven", targetName, languageName)
			else
				client:NotifyLocalized("cLanguageAlreadyGiven", targetName, translatedName)
			end
		else
			client:NotifyLocalized("cNotValidLanguageName")
		end
	end
})

ix.command.Add("CharTakeLanguage", {
	description = "@cmdCharTakeLanguage",
	superAdminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.string
	},
	OnRun = function(self, client, target, languageName)
		local languageID, translatedName

		for k, v in pairs(target:GetStudiedLanguages()) do
			local languageData = ix.chatLanguages.Get(k)

			if (languageData) then
				translatedName = L(languageData.name, client)

				if (ix.util.StringMatches(translatedName, languageName)) then
					languageID = k
					languageName = languageData.name

					break
				end
			end
		end

		if (languageID) then
			local targetName = target:GetName()
			local targetClient = target:GetPlayer()

			target:SetStudiedLanguages(languageID, nil)
			client:NotifyLocalized("cLanguageTakenBy", translatedName, targetName)

			if (client != targetClient) then
				targetClient:NotifyLocalized("cLanguageTakenFrom", client:Name(), L(languageName, targetClient))
			end

			ix.log.Add(client, "languageTaken", targetName, languageName)
		else
			client:NotifyLocalized("cNotValidOrTakenAlreadyLanguageName")
		end
	end
})
