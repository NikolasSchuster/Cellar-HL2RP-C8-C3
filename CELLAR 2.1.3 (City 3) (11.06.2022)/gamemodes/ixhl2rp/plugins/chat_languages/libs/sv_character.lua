
util.AddNetworkString("ixCharacterStudiedLanguagesChanged")
util.AddNetworkString("ixCharacterChangeUsedLanguage")

ix.char.RegisterVar("studiedLanguages", {
	field = "studied_languages",
	fieldType = ix.type.text,
	default = {},
	OnSet = function(self, key, value)
		if (ix.chatLanguages.Get(key) and (!value or isbool(value))) then
			local studiedLanguages = self:GetStudiedLanguages()
			local client = self:GetPlayer()

			studiedLanguages[key] = value

			net.Start("ixCharacterStudiedLanguagesChanged")
				net.WriteUInt(self:GetID(), 32)
				net.WriteString(key)
				net.WriteType(value)
			net.Send(receiver or client)

			self.vars.studiedLanguages = studiedLanguages

			if (!value and self:GetUsedLanguage() == key) then
				self:SetUsedLanguage("")
			end
		else
			return false
		end
	end,
	OnValidate = function(_, value)
		if (value != nil) then
			if (isstring(value)) then
				local languageData = ix.chatLanguages.Get(value)

				if (!languageData or languageData.bNotLearnable) then
					return false, "unknownError"
				end

				return {[value] = true}
			else
				return false, "unknownError"
			end
		end
	end,
	OnGet = function(self, key, default)
		local studiedLanguages = self.vars.studiedLanguages or {}

		if (key) then
			if (!studiedLanguages) then
				return default
			end

			local value = studiedLanguages[key]

			return value == nil and default or value
		else
			return default or studiedLanguages
		end
	end
})

ix.char.RegisterVar("languagesStudyProgress", {
	field = "languages_study_progress",
	fieldType = ix.type.text,
	default = {},
	isLocal = true,
	bNoDisplay = true
})

ix.char.RegisterVar("usedLanguage", {
	field = "used_language",
	fieldType = ix.type.string,
	default = "",
	bNoDisplay = true,
	OnSet = function(self, value)
		local oldValue = self.vars.usedLanguage

		if (value == "" or (ix.chatLanguages.Get(value) and self:CanSpeakLanguage(value)) and value != oldValue) then
			self.vars.usedLanguage = value

			net.Start("ixCharacterChangeUsedLanguage")
				net.WriteUInt(self:GetID(), 32)
				net.WriteString(value)
			net.Send(self.player)

			hook.Run("CharacterVarChanged", self, key, oldValue, value)
		else
			return false
		end

		return false
	end
})

net.Receive("ixCharacterChangeUsedLanguage", function(_, client)
	local curTime = CurTime()

	if ((client.ixNextUsedLanguageChange or 0) <= curTime) then
		local character = client:GetCharacter()

		if (character) then
			character:SetUsedLanguage(net.ReadString())
		end

		client.ixNextUsedLanguageChange = curTime + 0.2
	end
end)
