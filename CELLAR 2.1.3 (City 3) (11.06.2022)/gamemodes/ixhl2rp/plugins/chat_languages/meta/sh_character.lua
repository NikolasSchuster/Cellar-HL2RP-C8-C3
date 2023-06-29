
local charMeta = ix.meta.character

function charMeta:CanSpeakLanguage(languageID)
	return self:GetStudiedLanguages(languageID) == true
end

function charMeta:GetLanguageStudyProgress(languageID, volumeNumber)
	if (ix.chatLanguages.Get(languageID)) then
		local studyProgress = self:GetStudyProgress(languageID)

		if (studyProgress and volumeNumber) then
			return studyProgress[volumeNumber]
		end

		return studyProgress
	end
end
