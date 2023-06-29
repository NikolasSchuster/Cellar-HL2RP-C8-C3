local PLUGIN = PLUGIN

local function levelTooltip(tooltip)
	local character = LocalPlayer():GetCharacter()

	if character then
		local tooltip = tooltip:AddRow("description")
		tooltip:SetText(L("levelXP", math.Round(character:GetLevelXP()), math.Round(PLUGIN:GetRequiredLevelXP(character:GetLevel()))))
		tooltip:SizeToContents()
	end
end

function PLUGIN:CreateCharacterInfo(panel)
	if IsValid(panel) then
		panel.level = panel:Add("ixListRow")
		panel.level:SetList(panel.list)
		panel.level:Dock(TOP)
		panel.level:SizeToContents()

		panel.level.text:SetHelixTooltip(levelTooltip)
		panel.level.label:SetHelixTooltip(levelTooltip)
	end
end

function PLUGIN:UpdateCharacterInfo(panel, character)
	if panel and panel.level then
		panel.level:SetLabelText(L("level"))
		panel.level:SetText(character:GetLevel())
		panel.level:SizeToContents()
	end
end