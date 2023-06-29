
local PLUGIN = PLUGIN

function PLUGIN:IsRecognizedChatType(chatType)
	if (chatType == "radio" or chatType == "radio_eavesdrop") then
		return true
	end
end

function PLUGIN:PostChatboxDraw(width, height, alpha)
	local client = LocalPlayer()

	if (!client:Alive() or (IsValid(ix.gui.area) and #ix.gui.area:GetEntries() > 0)) then
		return
	end

	local listeningOn = {}

	-- List all listening channels
	if (self.listenChannels and !table.IsEmpty(self.listenChannels)) then
		for channel, channelNumber in pairs(self.listenChannels) do
			local channelTable = ix.radio:FindByID(channel)
			if (channelTable) then
				-- Check if a channel number has to be added
				if (channelTable.subChannels > 1) then
					listeningOn[#listeningOn + 1] = channelTable.name.." (#"..channelNumber..")"
				else
					listeningOn[#listeningOn + 1] = channelTable.name
				end
			end
		end

		table.sort(listeningOn)
		-- Remove the last ', '
		listeningOn = table.concat(listeningOn, ", ")
	else
		listeningOn = ix.radio.CHANNEL_NONE
	end

	-- Set transmittingOn channel
	local transmittingOn = client:GetNetVar("radioChannel") or ix.radio.CHANNEL_NONE
	local channelTable = ix.radio:FindByID(transmittingOn)

	-- If channel is not global, not none and has more than one subchannel, add in a channel number
	if (channelTable) then
		if (channelTable.global) then
			if (table.Count(channelTable.targetChannels) == 1) then
				local targetChannel = next(channelTable.targetChannels)
				transmittingOn = ix.radio:FormatRadioChannel(targetChannel, channelTable.targetChannels[targetChannel])
			end
		elseif (channelTable.subChannels > 1) then
			if (self.listenChannels and self.listenChannels[transmittingOn]) then
				transmittingOn = channelTable.name.." (#"..self.listenChannels[transmittingOn]..")"
			end
		else
			transmittingOn = channelTable.name
		end
	end

	-- Draw text
	if (listeningOn != "none" or transmittingOn != "none") then
		local fontHeight = draw.GetFontHeight("BudgetLabel")
		local color = ColorAlpha(color_white, alpha)

		DisableClipping(true)
			draw.SimpleText("Radio channels: "..listeningOn, "BudgetLabel", 0, -fontHeight * 2, color)
			draw.SimpleText("Transmitting on: "..transmittingOn, "BudgetLabel", 0, -fontHeight, color)
		DisableClipping(false)
	end
end

-- Receive channel list
netstream.Hook("ixListenChannels", function(listenChannels, globalChannels)
	PLUGIN.listenChannels = listenChannels or {}
end)

netstream.Hook("ixSetChannel", function(channelID, channelNumber)
	if (ix.radio:IsActualChannel(channelID)) then
		PLUGIN.listenChannels[channelID] = channelNumber
	end
end)

netstream.Hook("ixRadioFrequency", function(itemID, default)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", default, function(text)
		netstream.Start("ixRadioFrequency", itemID, text)
	end)
end)

netstream.Hook("ixCreateItemRadioChannel", function(frequency, frequencyID)
	if (!ix.radio:IsActualChannel(frequencyID)) then
		local CHANNEL = ix.radio:New()
		CHANNEL.name = frequency
		CHANNEL.uniqueID = frequencyID
		CHANNEL.subChannels = 1
		CHANNEL.global = false
		CHANNEL.defaultPriority = 5
		CHANNEL:Register()
	end
end)

-- Gets the listen chanels in case the plugin is reloaded
netstream.Start("ixListenChannels", true)
