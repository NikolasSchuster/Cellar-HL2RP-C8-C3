
PLUGIN.name = "Radios"
PLUGIN.author = "Gr4Ss"
PLUGIN.description = "Adds various radios and radio channels."

ix.char.RegisterVar("radioChannels", {
	field = "radio_channels",
	fieldType = ix.type.text,
	default = {},
	isLocal = true,
	bNoDisplay = true
})

ix.config.Add("radioNoclipEavesdrop", false, "Whether or not players in observer can eavesdrop radio conversations.", nil, {
	category = "Chat"
})

--[[
	-- radio
	radioNotOn = "Your radio isn't on!",
	radioRequired = "You need a radio to do this!",
	radioAlreadyOn = "You already have a radio that is turned on!",
	radioFreqFormat = "You have specified an invalid radio frequency format!",
	radioFreqSet = "You have set your radio frequency to %s.",
]]

local typeTexts = {
	[1] = "говорит",
	[2] = "кричит",
	[3] = "шепчет"
}

function PLUGIN:InitializedChatClasses()
	local iconDefault = ix.util.GetMaterial("cellar/chat/radio_hand.png")

	ix.chat.Register("radio", {
		color = Color(75, 150, 50),
		format = "[%s] %s %s по рации \"%s\"",
		bReceiveVoices = true,
		indicator = "chatRadioing",
		OnChatAdd = function(class, speaker, text, bAnonymous, data)
			local name = hook.Run("GetCharacterName", speaker, class.uniqueID) or IsValid(speaker) and speaker:Name()

			if (table.Count(data.transmitTable) == 1) then
				local targetChannel = next(data.transmitTable)
				local channelNumber = data.transmitTable[targetChannel]

				if (!isbool(channelNumber)) then
					data.channel = ix.radio:FormatRadioChannel(targetChannel, channelNumber)
				end
			end

			local channelTable = ix.radio:FindByID(data.channelID)
			local icon = iconDefault

			if channelTable then
				icon = channelTable.icon or icon
			end

			data.useSound = true
			hook.Run("AdjustRadioTransmit", data)

			chat.AddText(data.color or class.color, icon, string.format(class.format,
				string.upper(data.channel), name, typeTexts[data.typeText] or typeTexts[1], text))

			if (data.useSound and isstring(data.sound)) then
				surface.PlaySound(data.sound)
			end
		end
	})

	-- radio eavesdrop
	ix.chat.Register("radio_eavesdrop", {
		color = Color(255, 255, 150),
		format = "%s %s по рации \"%s\"",
		OnChatAdd = function(class, speaker, text, bAnonymous, data)
			local name = hook.Run("GetCharacterName", speaker, class.uniqueID) or IsValid(speaker) and speaker:Name()

			data.useSound = false
			hook.Run("AdjustRadioEavesdrop", data)

			chat.AddText(class.color, ix.util.GetMaterial("cellar/chat/eaves_radiohand.png"), string.format(class.format,
				name, typeTexts[data.typeText] or typeTexts[1], text))

			if (data.useSound and isstring(data.sound)) then
				surface.PlaySound(data.sound)
			end
		end
	})
end
PLUGIN:InitializedChatClasses()
ix.util.Include("meta/sv_player.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_channels.lua")
ix.util.Include("sh_commands.lua")
