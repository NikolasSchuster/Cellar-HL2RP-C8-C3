local PLUGIN = PLUGIN

function PLUGIN:SetLanguage(client, language)
	local result, reason = true, "@langChanged"

	if !self:Exists(language) then
		result, reason = false, "@langInvalid"
	end

	if language == "none" then
		result, reason = true, "@langReset"
		language = nil
	else
		if !self:Has(client, language) then
			result, reason = false, "@langNotKnown"
		end
	end

	if result then
		client:SetNetVar("language", language)
	end

	return reason, language
end

do
	local CHAR = ix.meta.character

	function CHAR:GiveLanguage(languageName)
		if PLUGIN:Has(self:GetPlayer(), languageName) then
			return
		end

		local languages = self:GetData("languages", {})

		languages[#languages+1] = languageName

		self:SetData("languages", languages)
	end

	function CHAR:TakeLanguage(languageName)
		if !PLUGIN:Has(self:GetPlayer(), languageName) then
			return
		end

		local languages = self:GetData("languages", {})

		for k, v in ipairs(languages) do
			if v:lower() == languageName:lower() then
				table.remove(languages, k)
				break
			end
		end

		self:SetData("languages", languages)
	end
end