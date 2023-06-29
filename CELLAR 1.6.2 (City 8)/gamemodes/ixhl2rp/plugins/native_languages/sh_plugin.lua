local PLUGIN = PLUGIN

PLUGIN.name = "Native Languages"
PLUGIN.author = "alexgrist"
PLUGIN.description = "Adds functionality for characters speaking different languages."

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")

function PLUGIN:Add(name)
	self.stored = self.stored or {}
	self.stored[#self.stored + 1] = name
end

function PLUGIN:Exists(identifier)
	local result = false

	for _, v in ipairs(self.stored) do
		if (string.lower(v) == string.lower(identifier)
		or string.len(identifier) >= 3 and ix.util.StringMatches(v, identifier)) then
			result = v

			break
		end
	end

	return result
end

function PLUGIN:Has(client, identifier)
	local bStatus = false

	if (self:Exists(identifier)) then
		local languages = client:GetCharacter():GetData("languages", {})

		for _, v in ipairs(languages) do
			if (string.lower(v) == string.lower(identifier)) then
				bStatus = true

				break
			end
		end
	end

	return bStatus
end

do
	local CLASS = {}
	
	function CLASS:OnChatAdd(speaker, text, bAnonymous, data)
		local name = hook.Run("GetCharacterName", speaker, self.uniqueID)
			or IsValid(speaker) and speaker:Name()

		chat.AddText(data.color or self.color, L("langSay", name, data.sayType, data.language, text))
	end

	ix.chat.Register("language", CLASS)

	CLASS = {}

	function CLASS:OnChatAdd(speaker, text, bAnonymous, data)
		local name = hook.Run("GetCharacterName", speaker, self.uniqueID)
			or IsValid(speaker) and speaker:Name()

		chat.AddText(data.color or self.color, L("langSayUnk", name, data.sayType, data.language))
	end

	ix.chat.Register("language_unknown", CLASS)
end

do
	local COMMAND = {}
	COMMAND.description = "@cmdSetLanguage"
	COMMAND.arguments = {
		bit.bor(ix.type.string, ix.type.optional)
	}
	COMMAND.alias = "L"

	function COMMAND:OnRun(client, language)
		if (!isstring(language)) then
			language = "none"
		end

		return PLUGIN:SetLanguage(client, language)
	end

	ix.command.Add("SetLanguage", COMMAND)

	COMMAND = {}
	COMMAND.description = "@cmdCharGiveLanguage"
	COMMAND.arguments = {ix.type.character, ix.type.string}
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, target, language)
		local languageName = PLUGIN:Exists(language)

		if (languageName) then
			target:GiveLanguage(languageName)

			ix.util.NotifyLocalized("langGiven", nil, client:Name(), target:GetName(), languageName)
		else
			return "@langInvalid"
		end
	end

	ix.command.Add("CharGiveLanguage", COMMAND)

	COMMAND = {}
	COMMAND.description = "@cmdCharTakeLanguage"
	COMMAND.arguments = {ix.type.character, ix.type.string}
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, target, language)
		local languageName = PLUGIN:Exists(language)

		if (languageName) then
			target:TakeLanguage(languageName)

			ix.util.NotifyLocalized("langTaken", nil, client:Name(), languageName, target:GetName())
		else
			return "@langInvalid"
		end
	end

	ix.command.Add("CharTakeLanguage", COMMAND)
end

do
	local languages = {
		"Vortigese"
	}

	for _, v in ipairs(languages) do
		PLUGIN:Add(v)
	end
end
