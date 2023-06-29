
local notSolidTextures = {
	["**studio**"] = true,
	["TOOLS/TOOLSNODRAW"] = true,
	["METAL/METALBAR001C"] = true,
	["METAL/METALGATE001A"] = true,
	["METAL/METALGATE004A"] = true,
	["METAL/METALGRATE011A"] = true,
	["METAL/METALGRATE016A"] = true,
	["METAL/METALCOMBINEGRATE001A"] = true
}

local function SendChatMessageToPlayers(speaker, chatType, text, bAnonymous, data, receivers)
	net.Start("ixChatMessage")
		net.WriteEntity(speaker)
		net.WriteString(chatType)
		net.WriteString(text)
		net.WriteBool(bAnonymous or false)
		net.WriteTable(data)
	net.Send(receivers)
end

local function ReplaceTextWithRandomWords(usedLanguage, originalText)
	local languageData = ix.chatLanguages.Get(usedLanguage)
	local wPattern = "[^~`!@#$%%%^&*()_%+%-={}%[%]|;:'\",%./<>?]+"
	local bSentenceStart = true
	local randomWords = languageData.words
	local randomText = string.Explode("%s+", originalText, true)

	-- can be done MUCH simplier but I really want to save punctuation
	for i = 1, #randomText do
		local word = randomText[i]
		local last = word:utf8sub(-1)
		local replacement = randomWords[math.random(#randomWords)]

		if (bSentenceStart and word:match(wPattern)) then
			replacement = replacement:utf8sub(1, 1):utf8upper() .. replacement:utf8sub(2)
			bSentenceStart = false
		end

		randomText[i] = word:gsub(wPattern, replacement)

		if (last == "." or last == "?" or last == "!" or last == "-" or last == "\"") then
			bSentenceStart = true
		end
	end

	randomText = table.concat(randomText, " ")

	return randomText
end

local function CanPlayerUnderstandLanguage(client, usedLanguage)
	local character = client:GetCharacter()

	return character and character:CanSpeakLanguage(usedLanguage)
end

function ix.chat.Send(speaker, chatType, text, bAnonymous, receivers, data)
	if (!chatType) then
		return
	end

	data = data or {}
	chatType = string.lower(chatType)

	if (IsValid(speaker) and hook.Run("PrePlayerMessageSend", speaker, chatType, text, bAnonymous) == false) then
		return
	end

	local class = ix.chat.classes[chatType]

	if (class and class:CanSay(speaker, text, data) != false) then
		if (class.CanHear and !receivers) then
			receivers = {}

			for _, v in ipairs(player.GetAll()) do
				if (v:GetCharacter() and class:CanHear(speaker, v, data) != false) then
					receivers[#receivers + 1] = v
				end
			end

			if (#receivers == 0) then
				return
			end
		end

		-- Format the message if needed before we run the hook.
		local rawText = text
		local maxLength = ix.config.Get("chatMax")
		-- Declare a variable for futher usage
		local usedLanguage

		if (text:utf8len() > maxLength) then
			text = text:utf8sub(0, maxLength)
		end

		if (ix.config.Get("chatAutoFormat") and hook.Run("CanAutoFormatMessage", speaker, chatType, text)) then
			text = ix.chat.Format(text)
		end

		if (speaker and speaker:GetCharacter() and ix.chatLanguages.IsChatTypeValid(chatType)) then
			local character = speaker:GetCharacter()
			usedLanguage = character:GetUsedLanguage()

			if (usedLanguage != "") then
				data.usedLanguage = usedLanguage
			else
				usedLanguage = nil
			end
		end

		text = hook.Run("PlayerMessageSend", speaker, chatType, text, bAnonymous, receivers, rawText, usedLanguage) or text

		if (ix.chatLanguages.IsChatTypeValid(chatType)) then
			local randomText

			if (class.range) then
				local maxRange = class.range
				local lossStartRange = maxRange * 0.2
				local maxMinusStartLossRange = maxRange - lossStartRange

				for k, v in ipairs(receivers) do
					if (speaker != v and v:GetMoveType() != MOVETYPE_NOCLIP) then
						local vShootPos = v:GetShootPos()
						local localText = text
						local lossFraction = 0
						local range = (speaker:GetPos() - v:GetPos()):LengthSqr()
						local traceLine = util.TraceLine({
							start = speaker:GetShootPos(),
							endpos = vShootPos,
							filter = speaker,
							mask = MASK_PLAYERSOLID_BRUSHONLY
						})

						if (traceLine.HitPos != vShootPos and !notSolidTextures[traceLine.HitTexture] and traceLine.MatType != MAT_GLASS) then
							lossFraction = 0.3
						end
						if (range > lossStartRange) then
							lossFraction = lossFraction + math.Round((range - lossStartRange) / maxMinusStartLossRange, 1)
						end

						if (lossFraction >= 1) then
							receivers[k] = nil

							continue
						end

						if (usedLanguage and !CanPlayerUnderstandLanguage(v, usedLanguage)) then
							randomText = randomText or ReplaceTextWithRandomWords(usedLanguage, localText)
							localText = randomText
						end

						if (lossFraction > 0) then
							local textTable = string.Explode("%s+", localText, true)
							local lostWordsCount = math.floor(#textTable * lossFraction)

							if (lostWordsCount > 0) then
								if (lostWordsCount > 1) then
									local textTableCopy = table.Copy(textTable)

									for i = 1, lostWordsCount do
										local _, randomKey = table.Random(textTableCopy)

										textTableCopy[randomKey] = nil
										textTable[randomKey] = "..."
									end
								else
									textTable[math.random(#textTable)] = "..."
								end

								localText = table.concat(textTable, " ")
							end

							data.lossFraction = lossFraction
						end

						SendChatMessageToPlayers(speaker, chatType, localText, bAnonymous, data, v)

						data.lossFraction = nil
					else
						SendChatMessageToPlayers(speaker, chatType, text, bAnonymous, data, v)
					end
				end
			else
				if (usedLanguage) then
					local receiversR = {}
					local indexFix = 1

					for k, v in ipairs(receivers) do
						if (speaker != v and v:GetMoveType() != MOVETYPE_NOCLIP and !CanPlayerUnderstandLanguage(v, usedLanguage)) then
							receiversR[#receiversR + 1] = v
							receivers[k] = nil
						end
					end

					for k, v in pairs(receivers) do
						receivers[indexFix] = v
						indexFix = indexFix + 1
					end

					if (#receiversR > 0) then
						randomText = ReplaceTextWithRandomWords(usedLanguage, text)

						SendChatMessageToPlayers(speaker, chatType, randomText, bAnonymous, data, receiversR)
					end
				end

				SendChatMessageToPlayers(speaker, chatType, text, bAnonymous, data, receivers)
			end
		else
			SendChatMessageToPlayers(speaker, chatType, text, bAnonymous, data, receivers)
		end

		return text
	end
end
