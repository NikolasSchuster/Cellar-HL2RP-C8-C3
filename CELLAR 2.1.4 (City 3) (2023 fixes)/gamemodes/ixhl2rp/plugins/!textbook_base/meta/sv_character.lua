
local charMeta = ix.meta.character

function charMeta:SetStudyProgress(key, value)
	local studyProgresses = self:GetStudyProgresses()

	studyProgresses[key] = value

	self:SetStudyProgresses(studyProgresses)
end
