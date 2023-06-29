local PLUGIN = PLUGIN

function PLUGIN:PlayerSpawn(player)
	player.tempChannels = {}
end

function PLUGIN:CharacterLoaded(character)
	timer.Simple(0.25, function()
		ix.radio:SetPlayerChannels(character:GetPlayer())
	end)
end

-- Update channels
function PLUGIN:PlayerJoinedClass(player)
	ix.radio:SetPlayerChannels(player)
end;

-- Client asks for channel update so update channels
netstream.Hook("ixListenChannels", function(player, data)
	if player:GetCharacter() then
		ix.radio:SetPlayerChannels(player)
	end
end)

--[[
	Begin radio library Hooks
]]

-- Called when a player's channel get set
function PLUGIN:PlayerChannelSet(player, oldChannel, newChannel, channelNumber) end

-- Called when radio channels should be registered
function PLUGIN:RegisterRadioChannels() end

-- Called when a radio channel has been initialized
function PLUGIN:ClockworkRadioChannelInitialized(channel) end

-- Called when a player's channels should be adjusted
function PLUGIN:PlayerAdjustChannels(player, listenChannels, globalChannels) 
	local itemsA = player:GetCharacter():GetInventory():GetItems()
	local itemsB = player:GetCharacter():GetEquipment():GetItems()

	for k, itemTable in pairs(itemsA) do
		if itemTable.frequency then
			self:AddItemChannelToPlayer(player, itemTable)
		end
	end

	for k, itemTable in pairs(itemsB) do
		if itemTable.frequency then
			self:AddItemChannelToPlayer(player, itemTable)
		end
	end
end

-- Called to check if a radio message can be eavesdropped
function PLUGIN:NoEavesdrop(player, channelID, sayType)
	if ix.config.Get("radioNoclipEavesdrop") then
		if player:GetMoveType() == MOVETYPE_NOCLIP then
			return true
		end
	end
end

-- Called when the radio transmit info should be adjusted
function PLUGIN:AdjustRadioTransmitInfo(info) end

-- Called to check if a player can eavesdrop on someone speaking in a radio nearby
function PLUGIN:PlayerCanEavesdropRadioTransmit(player, info, transmitPos)
	if player:GetPos():DistToSqr(transmitPos) <= math.pow(info.data.range, 2) then
		return true
	end
end

-- Called when the radio transmit listeners should be adjusted
function PLUGIN:AdjustRadioTransmitListeners(info, listeners) end

-- Called when the radio transmit eavesdroppers should be adjusted
function PLUGIN:AdjustRadioTransmitEavesdroppers(info, eavesdroppers) end

--[[
	End radio library hooks
]]

function PLUGIN:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
	if chatType == "ic" or chatType == "whisper" or chatType == "yell" then
		local radio = speaker:GetEyeTraceNoCursor().Entity

		if radio and radio:GetClass() == "ix_stationary_radio" then
			if radio:IsOn() then
				local range = ix.config.Get("chatRange", 280)
				local sayType = nil
				if chatType == "whisper" then
					range = range / 3
					sayType = "whisper"
				elseif chatType == "yell" then
					range = range * 2
					sayType = "yell"
				end

				if radio:GetPos():DistToSqr(speaker:GetShootPos()) <= math.pow(range, 2) then
					local data = {
						range = range,
						sayType = sayType,
						channelID = radio:GetFrequency(),
						stationaryRadio = true
					}
					ix.radio:SayRadio(speaker, text, data, true)

					--info.bShouldSend = false
				end
			end
		end
	end
end

function PLUGIN:PlayerCanHearRadioTransmit(player, info)
	local transmitChannels = info.data.transmitTable

	for channelID, channelNumber in pairs(transmitChannels) do
		if (ix.radio:HasPlayerChannel(player, channelID, channelNumber)) then
			return true
		end
	end

	local range = math.pow(ix.config.Get("chatRange", 280), 2)
	local radios = ents.FindByClass("ix_stationary_radio")
	local channelID = info.data.channelID

	for k, radio in pairs(radios) do
		if !radio:IsOn() or radio:GetFrequency() != channelID then
			continue
		else
			if player:GetPos():DistToSqr(radio:GetPos()) < range then
				return true
			end
		end
	end
end

function PLUGIN:SaveData()
	self:SaveRadios()
end

function PLUGIN:LoadData()
	local data = self:GetData()

	if (data) then
		for _, v in ipairs(data) do
			local entity = ents.Create("ix_stationary_radio")
			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:SetModel(v[8] or "models/props_lab/citizenradio.mdl")
			entity:Spawn()
			entity:SetOn(v[4])
			entity:SetFrequency(v[5])
			entity:SetChannelTuningEnabled(v[6])
			entity:SetRadioItem(v[7])

			local physObject = entity:GetPhysicsObject()

			if (IsValid(physObject)) then
				physObject:EnableMotion(v[8] and false or true)
			end
		end
	end
end

netstream.Hook("ixRadioFrequency", function(player, id, freq)
	local itemTable = player:GetCharacter():GetInventory():GetItemByID(id)

	if itemTable then
		if string.find(freq, "^%d%d%d%.%d$") then
			local first = string.match(freq, "(%d)%d%d%.%d")
			if first != "0" then
				itemTable:SetData("frequency", freq)
				ix.radio:SetPlayerChannels(player)
			
				player:Notify("You have set this radio's frequency to "..freq..".")
			else
				player:Notify("The frequency must be between 100.0 and 999.9!")
			end
		else
			player:Notify("The radio frequency must look like xxx.x!")
		end
	end
end)