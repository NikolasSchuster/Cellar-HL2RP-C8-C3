
ITEM.base = "base_textbook"
ITEM.name = "Skills Textbooks Base"
ITEM.description = "iSkillTextbookDescription"
ITEM.model = Model("models/props_office/book06.mdl")
ITEM.category = "Skills Textbooks"
ITEM.skillID = "str"
ITEM.skillXP = 10
ITEM.volume = 1
ITEM.usesLeft = 5

function ITEM:GetStudyProgressKey()
	return self.skillID .. self.volume
end

if (CLIENT) then
	function ITEM:GetName()
		local skillInfo = ix.skills.list[self.skillID]

		if (skillInfo) then
			return L("iSkillTextbookName", skillInfo.name, self.volume)
		end

		return self.name
	end

	function ITEM:PopulateTooltip2(tooltip)
		local usesLeft = tooltip:AddRowAfter("description", "usesLeft")

		usesLeft:SetBackgroundColor(derma.GetColor("Warning", usesLeft))
		usesLeft:SetText(L("usesDesc", self:GetData("usesLeft", self.usesLeft), self.usesLeft))
		usesLeft:SizeToContents()
	end
end

-- base_textbook funcs
function ITEM:PreCanStudy(_, character)
	return character:GetStudyProgress(self:GetStudyProgressKey()) != true
end

function ITEM:CanStudy(_, character)
	local skillInfo = ix.skills.list[self.skillID]

	if (ix.skills.list[self.skillID]) then
		local previousVolume = self.volume - 1

		if (previousVolume > 0 and character:GetStudyProgress(self.skillID .. previousVolume) != true) then
			return false, "skillTextbookPreviousVolume"
		end

		return skillInfo
	end
end

function ITEM:GetStudyTimeLeft(_, character)
	return character:GetStudyProgress(self:GetStudyProgressKey())
end

function ITEM:GetMaxStudyTime()
	return ix.config.Get("skillsTextbooksMinReadTime", 3600) * self.volume
end

function ITEM:OnStudyTimeCapped(_, character, studyTime)
	character:SetStudyProgress(self:GetStudyProgressKey(), studyTime)
end

function ITEM:OnTextbookStudied(client, character, result)
	character:UpdateSkillProgress(self.skillID, self.skillXP)
	character:SetStudyProgress(self:GetStudyProgressKey(), true)

	local volumeCount = ix.config.Get("skillsTextbooksVolumeCount", 3)

	client:NotifyLocalized("studiedSkillTextbook", self.volume, volumeCount, result.name, self.skillXP)
	ix.log.Add(client, "studiedSkillTextbook", self.volume, volumeCount, result.name, self.skillXP)

	-- decrement uses and remove the item if we reach 0
	local usesLeft = self:GetData("usesLeft", self.usesLeft) - 1

	if (usesLeft > 0) then
		self:SetData("usesLeft", usesLeft)
	else
		self:Remove()
	end
end

function ITEM:OnStudyProgressSave(_, character, timeLeft)
	character:SetStudyProgress(self:GetStudyProgressKey(), timeLeft)
end
