
local charMeta = ix.meta.character

function charMeta:SetLanguageStudyProgress(languageID, volumeNumber, progress)
	if (ix.chatLanguages.Get(languageID)) then
		local studyProgress = self:GetStudyProgress(languageID, {})

		studyProgress[volumeNumber] = progress

		self:SetStudyProgress(languageID, studyProgress)
	end
end

function charMeta:ClearLanguageStudyProgress(languageID)
	if (ix.chatLanguages.Get(languageID)) then
		self:SetStudyProgress(languageID, nil)
	end
end
