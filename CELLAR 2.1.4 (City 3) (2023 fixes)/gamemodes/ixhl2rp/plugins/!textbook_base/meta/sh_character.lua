
local charMeta = ix.meta.character

function charMeta:GetStudyProgress(key, default)
	local studyProgresses = self:GetStudyProgresses()

	return studyProgresses[key] or default
end
