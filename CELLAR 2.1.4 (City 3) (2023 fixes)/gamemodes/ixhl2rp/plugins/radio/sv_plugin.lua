util.AddNetworkString("PlayVRadio")

function ix.radio:HasPlayerChannel(player, channelID, channelNumber)
	local channel = self:FindByID(channelID)

	if channel then
		if channel.global then
			return player.globalChannels[channel.uniqueID]
		else
			if !channelNumber or isbool(channelNumber) or channelNumber == "all" then
				return player.listenChannels[channel.uniqueID]
			elseif isnumber(channelNumber) then
				return player.listenChannels[channel.uniqueID] == channelNumber;
			elseif istable(channelNumber) then
				return (player.listenChannels[channel.uniqueID] >= channelNumber[1]
					and player.listenChannels[channel.uniqueID] <= channelNumber[2])
			end
		end
	end
end

function ix.radio:SetPlayerChannels(player)
	player.listenChannels = {}
	player.globalChannels = {}

	if !player.tempChannels then
		player.tempChannels = {}
	end

	local success

	-- Add faction channels
	local character = player:GetCharacter()
	local faction = ix.faction.indices[character:GetFaction()]

	if faction and faction.listenChannels then
		for channelID, channelNumber in pairs(faction.listenChannels) do
			success = self:AddChannelToPlayer(player, channelID, channelNumber)
			if !success then
				ErrorNoHalt("[Radio] Attempted to add unexisting faction channel "..channelID.." to player ("..character:GetFaction()..").")
			end
		end
	end

	-- Add class channels
	local class = ix.class.list[character:GetClass()]
	if class and class.listenChannels then
		for channelID, channelNumber in pairs(class.listenChannels) do
			success = self:AddChannelToPlayer(player, channelID, channelNumber)
			if !success then
				ErrorNoHalt("[Radio] Attempted to add unexisting class channel "..channelID.." to player ("..character:GetClass()..").")
			end
		end
	end

	-- Add personal channels
	local listenChannels = character:GetRadioChannels()
	for channelID, channelNumber in pairs(listenChannels) do
		success = self:AddChannelToPlayer(player, channelID, channelNumber)
		if !success then
			ErrorNoHalt("[Radio] Attempted to add unexisting listen channel "..channelID.." to player (listenChannels).")
		end
	end

	-- Add temporary channels
	for channelID, channelNumber in pairs(player.tempChannels) do
		success = self:AddChannelToPlayer(player, channelID, channelNumber)
		if !success then
			ErrorNoHalt("[Radio] Attempted to add unexisting temporary channel "..channelID.." to player (tempChannels).")
		end
	end

	hook.Run("PlayerAdjustChannels", player, player.listenChannels, player.globalChannels)
							
	netstream.Start(player, "ixListenChannels", player.listenChannels, player.globalChannels)

	if (table.Count(player.listenChannels) > 0) then
		local currentChannel = player:GetNetVar("radioChannel")
		if currentChannel == "" or currentChannel == "none" or !self:HasPlayerChannel(player, currentChannel) then
			self:ResetTransmitChannel(player)
		end
	else
		player:SetNetVar("radioChannel", self.CHANNEL_NONE)
	end
end

function ix.radio:ResetTransmitChannel(player)
	local channel = nil
	for chnlID, v in pairs(player.listenChannels) do
		local chnl = self:FindByID(chnlID)
		if chnl and (!channel or channel.defaultPriority < chnl.defaultPriority) then
			channel = chnl
		end
	end

	if !channel then
		for chnlID, v in pairs(player.globalChannels) do
			local chnl = self:FindByID(chnl)
			if (chnl and (!channel) or channel.defaultPriority < chnl.defaultPriority) then
				channel = chnl
			end
		end
	end

	if channel then
		player:SetNetVar("radioChannel", channel.uniqueID)
	else
		player:SetNetVar("radioChannel", self.CHANNEL_NONE)
	end
end

function ix.radio:AddChannelToPlayer(player, channelID, channelNumber)
	local channel = self:FindByID(channelID)
	if channel then		
		if !channel.global then
			if !channelNumber then
				channelNumber = 1
			end

			player.listenChannels[channel.uniqueID] = math.Clamp(math.floor(channelNumber), 1, channel.subChannels)
		else
			player.globalChannels[channel.uniqueID] = 1
		end
		return true
	else
		return false
	end
end

function ix.radio:RemoveChannelFromPlayer(player, channelID)
	local channel = self:FindByID(channelID)
	if channel then
		local ret = nil
		if !channel.global then
			ret = table.remove(player.listenChannels, channel.uniqueID)
		else
			ret = table.remove(player.globalChannels, channel.uniqueID)
		end

		if ret then
			if channel.uniqueID == player:GetNetVar("radioChannel") then
				self:ResetTransmitChannel(player)
			end

			return true
		else
			return false
		end
	end
end

function ix.radio:RegisterSayType(sayType, range, typetext)
	if range and isnumber(range) and typetext and isstring(typeText) then
		self.sayTypes[sayType] = {range, typetext}
	end
end

function ix.radio:SendVoiceline(info, listeners)

	local speaker = info.player
	local character = speaker:GetCharacter()
	local class = Schema.voices.GetClass(speaker, "radio")
	local faction = ix.faction.indices[character:GetFaction()]
	local beeps = faction.typingBeeps or {}


	if !isstring(info.text) then return end

	if !(class[1] and info.text) then return end

	local voiceinfo = Schema.voices.Get(class[1], info.text)

	if !istable(voiceinfo) then return end

	local snd = istable(voiceinfo.sound) and voiceinfo.sound[character:GetGender() or 1] or voiceinfo.sound

	for k, listener in pairs(listeners) do
		net.Start("PlayVRadio")
			net.WriteEntity(speaker)
			net.WriteString(snd)
			net.WriteString(beeps[2] or " ")
		net.Send(listener)
	end
end

function ix.radio:SayRadio(client, text, data, bNoErrors)
	if text == "" then
		if !bNoErrors then	
			client:NotifyLocalized("radioNoText")
		end

		return false
	end

	if !data or !istable(data) then
		data = {}
	end

	-- Get the channelTable
	local channelTable = nil
	if !data.channelID then
		channelTable = self:FindByID(client:GetNetVar("radioChannel"))

		if !channelTable then
			if !bNoErrors then
				client:NotifyLocalized("radioNoChannel")
			end

			return false
		end
	else
		channelTable = self:FindByID(data.channelID)

		if !channelTable then
			if !bNoErrors then
				client:NotifyLocalized("radioChannelInvalid")
			end

			return false
		end
	end

	-- Add channel info
	data.channelID = channelTable.uniqueID
	data.channel = channelTable.name -- Display name for in chat

	-- Add message color if none is set already
	if !data.color then
		data.color = channelTable.color
	end

	if channelTable.sound then
		data.sound = channelTable.sound
	else
		data.sound = "npc/overwatch/radiovoice/on3.wav"
	end

	-- Set the channel and channel number
	data.transmitTable = {}
	data.global = false
	-- Check if it's a global channel
	if channelTable.global then
		data.global = true
		data.transmitTable = channelTable.targetChannels
	-- Check if a channelNumber has to be set
	else
		if channelTable.subChannels > 1 then
			data.transmitTable[channelTable.uniqueID] = client.listenChannels[channelTable.uniqueID]
		else
			data.transmitTable[channelTable.uniqueID] = true
		end
	end

	-- Set the sayType and message range
	data.range = ix.config.Get("chatRange", 280)
	data.typeText = 1
	if self.sayTypes[data.sayType] then
		data.range = self.sayTypes[data.sayType][1]
		data.typeText = self.sayTypes[data.sayType][2]
	elseif data.sayType == "yell" then
		data.range = data.range * 1.5
		data.typeText = 2
	elseif data.sayType == "whisper" then
		data.range = data.range * 0.25
		data.typeText = 3
	end

	-- Should we not allow eavesdropping?
	data.bNoEavesdrop = data.bNoEavesdrop or hook.Run("NoEavesdrop", client, channelTable, data)

	local info = {
		player = client,
		text = text,
		data = data,
		bShouldSend = true
	};

	hook.Run("AdjustRadioTransmitInfo", info)

	if info.bShouldSend then
		local players = player.GetAll()
		local transmitPos = info.player:GetPos()
		local listeners = {}
		local eavesdroppers = {}

		for k, ply in pairs(players) do
			if !ply:GetCharacter() or !ply:Alive() or !ply.listenChannels then
				continue
			end

			local canHear = hook.Run("PlayerCanHearRadioTransmit", ply, info)
			if canHear or ply == info.player then
				listeners[#listeners + 1] = ply
			elseif !info.data.bNoEavesdrop then
				local canEavesdrop = hook.Run("PlayerCanEavesdropRadioTransmit", ply, info, transmitPos)
				if canEavesdrop then
					eavesdroppers[#eavesdroppers + 1] = ply
				end
			end
		end

		hook.Run("AdjustRadioTransmitListeners", info, listeners)

		if #listeners > 0 then
			ix.chat.Send(info.player, "radio", info.text, false, listeners, info.data)
			ix.radio:SendVoiceline(info, lsisteners)
		end

		hook.Run("AdjustRadioTransmitEavesdroppers", info, eavesdroppers)

		ix.chat.Send(info.player, "radio_eavesdrop", info.text, false, eavesdroppers, info.data)
	end
end

function PLUGIN:CreateItemChannel(frequency, frequencyID, priority, stationaryCanAccess)
	local CHANNEL = ix.radio:New()
	CHANNEL.name = frequency
	CHANNEL.uniqueID = frequencyID
	CHANNEL.subChannels = 1
	CHANNEL.global = false
	CHANNEL.defaultPriority = priority or 5
	CHANNEL.stationaryCanAccess = stationaryCanAccess
	CHANNEL:Register()
end

function PLUGIN:FreqToFreqID(frequency)
	local freqID = "radioitem_"..string.lower(frequency)
	freqID = string.gsub(freqID, "%s", "_")
	freqID = string.gsub(freqID, "%p", "")

	return freqID
end

function PLUGIN:AddItemChannelToPlayer(player, itemTable)
	if !itemTable:IsOn() then
		return
	end

	if itemTable.factionLock then
		if !itemTable.factionLock[player:Team()] then
			return
		end
	end

	local frequency = itemTable:GetFrequency()
	local frequencyID = itemTable:GetFrequencyID()

	if !frequencyID then
		frequencyID = self:FreqToFreqID(frequency)
	end

	if !ix.radio:IsActualChannel(frequencyID) then
		self:CreateItemChannel(frequency, frequencyID, itemTable.frequencyPriority, itemTable.stationaryCanAccess)
	end

	netstream.Start(player, "ixCreateItemRadioChannel", frequency, frequencyID)

	ix.radio:AddChannelToPlayer(player, frequencyID)

	return frequencyID
end

function PLUGIN:SaveRadios()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_stationary_radio")) do
		local physicsObject = v:GetPhysicsObject()
		local moveable
		
		if IsValid(physicsObject) then
			moveable = physicsObject:IsMoveable()
		end

		data[#data + 1] = {
			v:GetPos(),
			v:GetAngles(),
			v:IsOn(),
			v:GetFrequency(),
			v:GetChannelTuningEnabled(),
			v:GetRadioItem(),
			moveable,
			v:GetModel()
		}
	end

	self:SetData(data)
end