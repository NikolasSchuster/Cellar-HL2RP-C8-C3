
local lossGoalColor = Color(105, 105, 105)
local initialIcon = Material("flags20/flag_gb.png")

CHAT_FLAG_ICON = CHAT_FLAG_ICON
MESSAGE_LOSS_FRACTION = MESSAGE_LOSS_FRACTION

function PLUGIN:ChatboxCreated()
	if (!IsValid(self.panel)) then
		self.panel = vgui.Create("ixLanguageChatButton")
	end
end

function PLUGIN:ChatboxPositionChanged(x, y, width, height)
	self.panel:CorrectPosition(x, y, width, height)
end

function PLUGIN:LoadFonts(font)
	surface.CreateFont("ixMenuLanguageFont", {
		font = "Nagonia",
		size = ScreenScale(10),
		extended = true,
		weight = 200
	})
end

function PLUGIN:CharacterLoaded(character)
	self.panel:ChangeFlagIcon(character)
end

function PLUGIN:MessageReceived(client, info)
	local messageData = info.data
	local usedLanguage = messageData.usedLanguage
	local langaugeData = ix.chatLanguages.Get(usedLanguage)

	if (langaugeData) then
		CHAT_FLAG_ICON = langaugeData.messageIcon
	elseif (ix.chatLanguages.IsChatTypeValid(info.chatType)) then
		CHAT_FLAG_ICON = initialIcon
	end

	if (messageData.lossFraction) then
		MESSAGE_LOSS_FRACTION = messageData.lossFraction
	end
end

function chat.AddText(...)
	local packedVarag = {...}

	if (CHAT_FLAG_ICON) then
		table.insert(packedVarag, 1, CHAT_FLAG_ICON)

		CHAT_FLAG_ICON = nil
	end

	if (MESSAGE_LOSS_FRACTION) then
		for k, v in ipairs(packedVarag) do
			if (istable(v) and v.r and v.g and v.b) then
				local differences = {
					["r"] = v.r - lossGoalColor.r,
					["g"] = v.g - lossGoalColor.g,
					["b"] = v.b - lossGoalColor.b
				}
				v = Color(
					v.r - differences.r * MESSAGE_LOSS_FRACTION,
					v.g - differences.g * MESSAGE_LOSS_FRACTION,
					v.b - differences.b * MESSAGE_LOSS_FRACTION
				)

				packedVarag[k] = v
			end
		end

		MESSAGE_LOSS_FRACTION = nil
	end

	if (IsValid(ix.gui.chat)) then
		ix.gui.chat:AddMessage(unpack(packedVarag))
	end

	-- log chat message to console
	local text = {}

	for _, v in ipairs(packedVarag) do
		if (istable(v) or isstring(v)) then
			text[#text + 1] = v
		elseif (isentity(v) and v:IsPlayer()) then
			text[#text + 1] = team.GetColor(v:Team())
			text[#text + 1] = v:Name()
		elseif (type(v) != "IMaterial") then
			text[#text + 1] = tostring(v)
		end
	end

	text[#text + 1] = "\n"
	MsgC(unpack(text))
end

net.Receive("ixCharacterChangeUsedLanguage", function()
	local id = net.ReadUInt(32)
	local character = ix.char.loaded[id]

	if (character) then
		character.vars.usedLanguage = net.ReadString()

		ix.gui.languageChatButton:ChangeFlagIcon(character, character.vars.usedLanguage)
	end
end)
