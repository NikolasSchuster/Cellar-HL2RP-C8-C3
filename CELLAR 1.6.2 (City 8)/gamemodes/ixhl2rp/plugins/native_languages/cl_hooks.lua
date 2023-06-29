
local PLUGIN = PLUGIN

CHAT_RECOGNIZED = CHAT_RECOGNIZED or {}
CHAT_RECOGNIZED["language"] = true
CHAT_RECOGNIZED["language_unknown"] = true

local sayTypes = {
	ic = "stIC",
	w = "stW",
	y = "stY"
}

function PLUGIN:MessageReceived(speaker, info)
	if (speaker:GetNetVar("language") and sayTypes[info.chatType]) then
		local language = speaker:GetNetVar("language")
		local character = LocalPlayer():GetCharacter()
		local factionTable = ix.faction.Get(character:GetFaction())
		local bKnowsLanguage = false

		if (factionTable.bKnowAllLanguages or self:Has(LocalPlayer(), language)) then
			bKnowsLanguage = true
		end

		-- Capitalize first letter of the language.
		local languageName = string.upper(string.sub(language, 1, 1)) .. string.sub(language, 2)
		local class = ix.chat.classes[info.chatType]
		local sayType = L(sayTypes[info.chatType])

		info.data.language = languageName
		info.data.color = class.color
		info.data.sayType = sayType

		if (bKnowsLanguage) then
			-- Capitalize first letter of the text.
			local text = string.upper(string.sub(info.text, 1, 1)) .. string.sub(info.text, 2)

			-- Remove space at end
			text = string.TrimRight(text)

			-- Add punctuation.
			local endText = string.sub(text, -1)

			if (endText ~= "." and endText ~= "!" and endText ~= "?") then
				text = text .. "."
			end

			info.text = text
			info.chatType = "language"
		else
			info.text = ""
			info.chatType = "language_unknown"
		end
	end
end

function PLUGIN:GetChatPrefixInfo(text)
	local language = LocalPlayer():GetNetVar("language")

	if (language and language != "English") then
		return language
	end
end
