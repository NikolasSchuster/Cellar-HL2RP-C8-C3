
ix.radio = {}
ix.radio.channels = ix.radio.channels or {}
ix.radio.CHANNEL_NONE = "none"
ix.radio.sayTypes = ix.radio.sayTypes or {}

--[[
	Begin defining the radio channel class base for other radio channel's to inherit from.
--]]

--[[ Set the __index meta function of the class. --]]
local CLASS_TABLE = {}
CLASS_TABLE.__index = CLASS_TABLE

CLASS_TABLE.name = "Radio Channel Base" -- Display name
CLASS_TABLE.uniqueID = "radio_channel_base" -- Internal name
CLASS_TABLE.subChannels = 1 -- Amount of sub-channels (only needed if global != true)
CLASS_TABLE.global = false -- Does it transmit over all subchannels of a channel?
CLASS_TABLE.targetChannels = {} -- Target channel if (global == true)
CLASS_TABLE.defaultPriority = 0 -- When a player's channels are reset, the one with the highest priority will be his default

-- Called when the channel is converted to a string.
function CLASS_TABLE:__tostring()
	return "CHANNEL["..self.name.."]"
end

-- A function to override a channel's base data.
function CLASS_TABLE:Override(varName, value)
	self[varName] = value
end

-- A function to add target Channels
function CLASS_TABLE:AddTargetChannel(channel, range)
	if (channel) then
		if (!range) then
			self.targetChannels[channel] = "all"
		elseif (isnumber(range)) then
			self.targetChannels[channel] = {1, math.min(math.Round(range), 1)}
		elseif (istable(range)) then
			self.targetChannels[channel] = {math.min(math.Round(range[1]), 1), math.min(math.Round(range[1]), 1)}
		end
	end
end

-- A function to register a new channel.
function CLASS_TABLE:Register()
	return ix.radio:Register(self)
end

--[[
	End defining the base channel class.
	Begin defining the channel utility functions.
--]]

-- A function to get all channels.
function ix.radio:GetAll()
	return self.channels
end

-- A function to get a new channel.
function ix.radio:New()
	local object = setmetatable({}, CLASS_TABLE)
		object.__index = CLASS_TABLE
	return object
end

-- A function to register a new channel.
function ix.radio:Register(channel)
	channel.uniqueID = string.lower(string.gsub(channel.uniqueID or string.gsub(channel.name, "%s", "_"), "['%.]", ""))

	if (!channel.color) then
		channel.color = Color(42, 179, 0, 255)
	end

	channel.subChannels = math.max(math.Round(channel.subChannels), 1)

	self.channels[channel.uniqueID] = channel

	if (self.Initialized) then
		self:InitializeChannel(channel)
	end
end

-- A function to get a channel by its name.
function ix.radio:FindByID(channelID)
	if (channelID and channelID != 0 and type(channelID) != "boolean"
		and channelID != self.CHANNEL_NONE and channelID != "") then
		local lowerName = string.lower(channelID)
		local channel = self.channels[lowerName]

		if (channel) then
			return channel
		else
			for _, chnl in pairs(self.channels) do
				local channelName = string.lower(chnl.name)

				if (string.find(channelName, lowerName)
				and (!channel or string.len(channelName) < string.len(channel.name))) then
					channel = chnl
				end
			end

			return channel
		end
	end
end

-- Returns if a channel exists
-- If bNotNone is true, it will exclude CHANNEL_NONE
function ix.radio:IsValidChannel(channelID, bNotNone)
	return self.channels[channelID] or (channelID == self.CHANNEL_NONE and !bNotNone)
end

-- Returns if a channel is an actual channel (it exists and is not a global one)
function ix.radio:IsActualChannel(channelID)
	local channel = self:FindByID(channelID)
	if (channel and !channel.global) then
		return true
	else
		return false
	end
end

-- Returns if a channel has subchannels, and how many
function ix.radio:HasSubChannels(channelID)
	local channel = self:FindByID(channelID)
	if (channel and channel.subChannels and channel.subChannels > 1) then
		return true, channel.subChannels
	else
		return false, 1
	end
end

-- Returns if a channel is a global channel (it exists and is global)
function ix.radio:IsGlobalChannel(channelID)
	local channel = self:FindByID(channelID)
	if (channel and channel.global) then
		return true
	else
		return false
	end
end

-- Called when channels should be initialized
function ix.radio:Initialize()
	hook.Run("RegisterRadioChannels")

	self.Initialized = true
	local channels = self:GetAll()

	for _, channel in pairs(channels) do
		self:InitializeChannel(channel)
	end
end

function ix.radio:InitializeChannel(channel)
	-- Setup chann
	if (channel.OnSetup) then
		channel:OnSetup()
	end
	-- Ensure a valid range if the channel is global
	if (channel.global) then
		local targetChannels = channel.targetChannels
		for targetChannel, range in pairs(targetChannels) do
			local chnl = self:FindByID(targetChannel)
			-- Check if the channel exists
			if (!chnl or chnl.global) then targetChannels[targetChannel] = nil end
			-- Ensure the range is valid
			if (range != "all") then
				range[1] = math.max(range[1], 1)
				range[2] = math.min(range[2], chnl.subChannels)
			end
		end

		channel.targetChannels = targetChannels
	end

	hook.Run("RadioChannelInitialized", channel)
end

if (CLIENT) then
	function ix.radio:FormatRadioChannel(channel, channelNumber)
		if (isstring(channelNumber)) then
			return self:FindByID(channel).name.." ("..channelNumber..")"
		elseif (isnumber(channelNumber)) then
			return self:FindByID(channel).name.." (#"..channelNumber..")"
		elseif (istable(channelNumber)) then
			return self:FindByID(channel).name.." (#"..channelNumber[1].."-"..channelNumber[2]..")"
		end
	end
end
