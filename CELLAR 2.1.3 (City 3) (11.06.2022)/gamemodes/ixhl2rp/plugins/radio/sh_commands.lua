
do
	local COMMAND

	-- radio
	COMMAND = {
		description = "Send a radio message out to other characters on your current radio channel.",
		arguments = ix.type.text,
		alias = "R"
	}

	function COMMAND:OnRun(client, message)
		if (client:IsRestricted()) then
			return "@notNow"
		end

		ix.radio:SayRadio(client, message)
	end

	ix.command.Add("Radio", COMMAND)

	-- radio whisper
	COMMAND = {
		description = "Send a radio message out to other characters on your current radio channel.",
		arguments = ix.type.text,
		alias = "RW"
	}

	function COMMAND:OnRun(client, message)
		if (client:IsRestricted()) then
			return "@notNow"
		end

		ix.radio:SayRadio(client, message, {sayType = "whisper"})
	end

	ix.command.Add("RadioWhisper", COMMAND)

	-- radio yell
	COMMAND = {
		description = "Send a radio message out to other characters on your current radio channel.",
		arguments = ix.type.text,
		alias = "RY"
	}

	function COMMAND:OnRun(client, message)
		if (client:IsRestricted()) then
			return "@notNow"
		end

		ix.radio:SayRadio(client, message, {sayType = "yell"})
	end

	ix.command.Add("RadioYell", COMMAND)

	-- set channel
	COMMAND = {
		description = "Sets the radio channel you are transmitting on.",
		arguments = {
			ix.type.string,
			bit.bor(ix.type.number, ix.type.optional)
		},
		alias = "SC"
	}

	function COMMAND:OnRun(player, channelName, channelNumber)
		if (player:IsRestricted()) then
			return "@notNow"
		end

		channelNumber = channelNumber or 1
		local channelTable = ix.radio:FindByID(channelName)

		if (channelTable) then
			channelName = channelTable.name
			local channelID = channelTable.uniqueID

			-- Check if the channel is none or a global one and the player has it, then set it (as those are easy)
			if (channelTable.global and player.globalChannels[channelID]) then
				local oldChannel = player:GetNetVar("radioChannel")

				player:SetNetVar("radioChannel", channelID)

				player:NotifyLocalized("radioChannelSet", channelName)
				hook.Run("PlayerChannelSet", player, oldChannel, channelID)

			-- Check if it's an actual channel, then dig through channel number and set it
			elseif (player.listenChannels[channelID]) then
				local oldChannel = player:GetNetVar("radioChannel")

				player:SetNetVar("radioChannel", channelID)

				if (channelTable.subChannels > 1) then
					channelNumber = math.Clamp(math.floor(channelNumber), 1, channelTable.subChannels)

					player.listenChannels[channelID] = channelNumber
					netstream.Start(player, "ixSetChannel", channelID, channelNumber)

					player:NotifyLocalized("radioChannelSetSub", channelName, channelNumber)
					hook.Run("PlayerChannelSet", player, oldChannel, channelID, channelNumber)
				else
					player:NotifyLocalized("radioChannelSet", channelName)
					hook.Run("PlayerChannelSet", player, oldChannel, channelID)
				end
			else
				player:NotifyLocalized("radioNoAccess")
			end
		elseif (channelName == ix.radio.CHANNEL_NONE) then
			local oldChannel = player:GetNetVar("radioChannel")

			player:SetNetVar("radioChannel", channelName)

			player:NotifyLocalized("radioChannelSet", channelName)
			hook.Run("PlayerChannelSet", player, oldChannel, channelName)
		else
			player:NotifyLocalized("radioNoAccess")
		end
	end

	ix.command.Add("SetChannel", COMMAND)

	-- chartogglechannel
	COMMAND = {
		description = "Subcribes the player to a radio channel.",
		adminOnly = true,
		arguments = {
			ix.type.character,
			ix.type.string,
			bit.bor(ix.type.number, ix.type.optional)
		}
	}

	function COMMAND:OnRun(player, target, channelName, channelNumber)
		local targetCharacter = target
		target = targetCharacter:GetPlayer()

		channelName = channelName:lower()
		local channelTable = ix.radio:FindByID(channelName)

		if (channelTable) then
			local channelID = channelTable.uniqueID
			local channelList = targetCharacter:GetRadioChannels()

			if (channelList[channelID]) then
				channelList[channelID] = nil

				if (player != target) then
					player:Notify("You have unsubscribed "..target:GetName().." from '"..channelTable.name.."'.")
					target:Notify(player:GetName().." has unsubscribed you from '"..channelTable.name.."'.")
				else
					player:Notify("You have been unsubscribed from '"..channelTable.name.."'.")
				end
			else
				if (!channelNumber or channelTable.global) then
					channelNumber = 1
				else
					channelNumber = math.Clamp(math.floor(channelNumber), 1, channelTable.subChannels)
				end

				channelList[channelID] = channelNumber

				if (player != target) then
					player:Notify("You have subscribed "..target:GetName().." to '"..channelTable.name.."'.")
					target:Notify(player:GetName().." has subscribed you to '"..channelTable.name.."'.")
				else
					player:Notify("You have been subscribed to '"..channelTable.name.."'.")
				end
			end

			targetCharacter:SetRadioChannels(channelList)
			target:SetChannels()
		else
			player:NotifyLocalized("radioChannelInvalid", channelName)
		end
	end

	ix.command.Add("CharToggleChannel", COMMAND)

	-- chartemptogglechannel
	COMMAND = {
		description = "Temporarily subcribes the player to a radio channel.",
		adminOnly = true,
		arguments = {
			ix.type.character,
			ix.type.string,
			bit.bor(ix.type.number, ix.type.optional)
		}
	}

	function COMMAND:OnRun(player, target, channelName, channelNumber)
		local targetCharacter = target
		target = targetCharacter:GetPlayer()

		channelName = channelName:lower()
		local channelTable = ix.radio:FindByID(channelName)

		if (channelTable) then
			local channelID = channelTable.uniqueID
			local channelList = target.tempChannels

			if (channelList[channelID]) then
				channelList[channelID] = nil

				if (player != target) then
					player:Notify("You have unsubscribed "..target:GetName().." from '"..channelTable.name.."'.")
					target:Notify(player:GetName().." has unsubscribed you from '"..channelTable.name.."'.")
				else
					player:Notify("You have been unsubscribed from '"..channelTable.name.."'.")
				end
			else
				if (!channelNumber or channelTable.global) then
					channelNumber = 1
				else
					channelNumber = math.Clamp(math.floor(channelNumber), 1, channelTable.subChannels)
				end

				channelList[channelID] = channelNumber

				if (player != target) then
					player:Notify("You have temporarily subscribed "..target:GetName().." to '"..channelTable.name.."'.")
					target:Notify(player:GetName().." has temporarily subscribed you to '"..channelTable.name.."'.")
				else
					player:Notify("You have temporarily been subscribed to '"..channelTable.name.."'.")
				end
			end

			target.tempChannels = channelList
			target:SetChannels()
		else
			player:NotifyLocalized("radioChannelInvalid", channelName)
		end
	end

	ix.command.Add("CharTempToggleChannel", COMMAND)
end
