
ITEM.base = "base_textbook"
ITEM.name = "Language Textbooks Base"
ITEM.description = "iLanguageTextbookDescription"
ITEM.model = Model("models/props_lab/bindergreen.mdl")
ITEM.category = "Language Textbooks"
ITEM.languageID = "english"
ITEM.volume = 1

if (CLIENT) then
	function ITEM:GetName()
		local languageData = ix.chatLanguages.Get(self.languageID)

		if (languageData) then
			return L("iLanguageTextbookName", L(languageData.name), self.volume)
		end

		return L(self.name)
	end

	function ITEM:GetProgressTooltip(tooltip, _, character)
		if (character:GetStudiedLanguages(self.languageID)) then
			return L("textbookLanguageStudied"), derma.GetColor("Success", tooltip)
		end
	end
end

function ITEM:PreCanStudy(_, character)
	return character:GetLanguageStudyProgress(self.languageID, self.volume) != true and !character:GetStudiedLanguages(self.languageID)
end

function ITEM:CanStudy(client)
	local languageData = ix.chatLanguages.Get(self.languageID)

	if (languageData) then
		return languageData
	end

	client:NotifyLocalized("unknownError")
end

function ITEM:GetStudyTimeLeft(_, character)
	return character:GetLanguageStudyProgress(self.languageID, self.volume)
end

function ITEM:GetMaxStudyTime()
	return ix.config.Get("languageTextbooksMinReadTime", 3600) * self.volume
end

function ITEM:OnStudyTimeCapped(_, character, studyTime)
	character:SetLanguageStudyProgress(self.languageID, self.volume, studyTime)
end

function ITEM:OnTextbookStudied(client, character, languageData)
	local languageName = L(languageData.name, client)
	local volumeCount = ix.config.Get("languageTextbooksVolumeCount", 3)
	local studyProgresses = character:GetLanguageStudyProgress(self.languageID)

	for i = 1, volumeCount do
		if (self.volume != i and studyProgresses[i] != true) then
			character:SetLanguageStudyProgress(self.languageID, self.volume, true)

			client:NotifyLocalized("volumeStudied", self.volume, volumeCount, languageName)
			ix.log.Add(client, "studiedLanguageTextbook", self.volume, volumeCount, languageData.name)

			return
		end
	end

	character:ClearLanguageStudyProgress(self.languageID)

	character:SetStudiedLanguages(self.languageID, true)
	client:NotifyLocalized("languageStudied", languageName)
	ix.log.Add(client, "studiedLanguage", languageData.name)
end

function ITEM:OnStudyProgressSave(_, character, timeLeft)
	character:SetLanguageStudyProgress(self.languageID, self.volume, timeLeft)
end
