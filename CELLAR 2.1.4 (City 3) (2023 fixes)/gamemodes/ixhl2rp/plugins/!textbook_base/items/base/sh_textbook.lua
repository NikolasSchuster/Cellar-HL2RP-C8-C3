
ITEM.name = "Textbook Base"
ITEM.description = "A Textbook Base."
ITEM.model = Model("models/props_lab/bindergreen.mdl")
ITEM.category = "Textbooks"
ITEM.studyTime = 60

--[[in order to make item on this base work, you have to initilize funcs bellow]]--
-- [CL; OPT] GetProgressTooltip(tooltip, client, character) !OPTIONAL!
-- [CL; OPT] PopulateTooltip2(baseTooltip, client, character) !OPTIONAL!
-- [SH] PreCanStudy(client, character)
-- [SV] CanStudy(client, character)
-- [SH] GetStudyTimeLeft(client, character)
-- [SV] GetMaxStudyTime()
-- [SV] OnStudyTimeCapped(client, character)
-- [SV] OnTextbookStudied(client, character, result)
-- [SV] OnStudyProgressSave(client, character, timeLeft)

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local client = LocalPlayer()
		local character = client:GetCharacter()
		local studyProgress = self:GetStudyTimeLeft(LocalPlayer(), client:GetCharacter())

		local progressT = tooltip:AddRowAfter("name", "progress")
		local color, text

		if (self.PopulateTooltip2) then
			self:PopulateTooltip2(tooltip, client, character)
		end

		if (self.GetProgressTooltip) then
			text, color = self:GetProgressTooltip(progressT, client, character)
		end

		if (!color and !text) then
			if (!studyProgress) then
				text = L("textbookNoStudy")
				color = derma.GetColor("Error", progressT)
			elseif (isnumber(studyProgress)) then
				local percentage = string.format("%.2f", math.Round((1 - studyProgress / self.studyTime) * 100, 2)) .. "%"

				text = L("textbookStudyInProgress", percentage)
				color = derma.GetColor("Info", progressT)
			elseif (studyProgress == true) then
				text = L("textbookStudySuccess")
				color = derma.GetColor("Success", progressT)
			end
		end

		progressT:SetBackgroundColor(color)
		progressT:SetText(text)
		progressT:SizeToContents()
	end
end

ITEM.functions.Study = {
	icon = "icon16/book_open.png",
	OnRun = function(item)
		local client = item.player

		if (client:GetVelocity():LengthSqr() > 0) then
			client:NotifyLocalized("noStudyOnMove")

			return false
		end

		local character = client:GetCharacter()
		local result, message = item:CanStudy(client, character)

		if (result) then
			local steamID = client:SteamID()
			local timerID = "ixStudying" .. steamID
			local actionTimerID = "ixAct" .. steamID
			local savedPosition = client:GetPos()

			local studyTime = item:GetStudyTimeLeft(client, character) or item.studyTime
			local maxStudyTime = item:GetMaxStudyTime()

			if (studyTime > maxStudyTime) then
				studyTime = maxStudyTime

				item:OnStudyTimeCapped(client, character, studyTime)
			end

			client:SetAction("@studying", studyTime, function()
				item:OnTextbookStudied(client, character, result)
			end, nil, nil, function()
				timer.Remove(timerID)
			end)

			timer.Create(timerID, 0.1, math.floor(studyTime / 0.1), function()
				if (IsValid(client)) then
					local bNotInInventory = client != item:GetOwner()

					if (bNotInInventory or savedPosition != client:GetPos()) then
						client:SetAction()

						if (!bNotInInventory) then client:NotifyLocalized("noStudyOnMove") end

						-- just in case
						timer.Remove(timerID)
					elseif (timer.RepsLeft(timerID) > 0) then
						if (timer.Exists(actionTimerID)) then
							item:OnStudyProgressSave(client, character, timer.TimeLeft(actionTimerID))
						else
							timer.Remove(timerID)
						end
					end
				else
					timer.Remove(actionTimerID)
					timer.Remove(timerID)
				end
			end)
		else
			client:NotifyLocalized(message or "unknownError")
		end

		return false
	end,
	OnCanRun = function(item)
		if (IsValid(item.entity) or !IsValid(item.player)) then
			return false
		end

		return item:PreCanStudy(item.player, item.player:GetCharacter())
	end
}
