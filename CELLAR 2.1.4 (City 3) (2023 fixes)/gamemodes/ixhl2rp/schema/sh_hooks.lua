function Schema:InitializedChatClasses()
	ix.chat.Register("ic", {
		format = "%s says \"%s\"",
		indicator = "chatTalking",
		GetColor = function(self, speaker, text)
			-- If you are looking at the speaker, make it greener to easier identify who is talking.
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				return ix.config.Get("chatListenColor")
			end

			-- Otherwise, use the normal chat color.
			return ix.config.Get("chatColor")
		end,
		CanHear = ix.config.Get("chatRange", 280),
		OnChatAdd = function(self, speaker, text, anonymous, info)
			local color = self.color
			local name = anonymous and
				L"someone" or hook.Run("GetCharacterName", speaker, "ic") or
				(IsValid(speaker) and speaker:Name() or "Console")

			if (self.GetColor) then
				color = self:GetColor(speaker, text, info)
			end

			local translated = L2("icFormat", name, text)

			chat.AddText(color, ix.util.GetMaterial("cellar/chat/ic.png"), translated or string.format(self.format, name, text))
		end
	})

	ix.chat.Register("w", {
		format = "%s whispers \"%s\"",
		color = Color(150, 170, 200, 255),
		CanHear = ix.config.Get("chatRange", 280) * 0.25,
		prefix = {"/W", "/Whisper", "/ш", "/шепот"},
		description = "@cmdW",
		indicator = "chatWhispering",
		OnChatAdd = function(self, speaker, text, anonymous, info)
			local name = anonymous and
				L"someone" or hook.Run("GetCharacterName", speaker, "w") or
				(IsValid(speaker) and speaker:Name() or "Console")

			chat.AddText(self.color, ix.util.GetMaterial("cellar/chat/whisper.png"), L2("wFormat", name, text))
		end
	})

	ix.chat.Register("y", {
		format = "%s yells \"%s\"",
		color = Color(230, 100, 75, 255),
		CanHear = ix.config.Get("chatRange", 280) * 2,
		prefix = {"/Y", "/Yell", "/к", "/крик"},
		description = "@cmdY",
		indicator = "chatYelling",
		OnChatAdd = function(self, speaker, text, anonymous, info)
			local name = anonymous and
				L"someone" or hook.Run("GetCharacterName", speaker, "y") or
				(IsValid(speaker) and speaker:Name() or "Console")

			chat.AddText(self.color, ix.util.GetMaterial("cellar/chat/yell.png"), L2("yFormat", name, text))
		end
	})

	-- dispatch broadcast
	ix.chat.Register("dispatch", {
		color = Color(200, 75, 75),
		format = "Диспетчер транслирует \"%s\"",
		CanSay = function(class, speaker, text)
			if (!speaker:IsDispatch()) then
				speaker:NotifyLocalized("notAllowed")

				return false
			end
		end,
		OnChatAdd = function(class, speaker, text)
			chat.AddText(class.color, ix.util.GetMaterial("cellar/chat/dispatch.png"), string.format(class.format, text))
		end
	})

	ix.chat.Register("dispatch_radio", {
		color = Color(200, 0, 0),
		format = "Dispatch radios on command: \"%s\"",
		bReceiveVoices = true,
		CanSay = function(class, speaker, text)
			if (!speaker:IsDispatch()) then
				speaker:NotifyLocalized("notAllowed")

				return false
			end
		end,
		CanHear = function(class, speaker, listener)
			return listener:IsCombine()
		end,
		OnChatAdd = function(class, speaker, text)
			chat.AddText(class.color, string.format(class.format, text))

			surface.PlaySound("npc/overwatch/radiovoice/on3.wav")
		end
	})

	ix.chat.Register("dispatch_chat", {
		color = Color(255, 200, 50),
		prefix = {"/D"},
		factionAccessTable = {
			--[FACTION_SRVADMIN] = true,
			--[FACTION_OVERWATCH] = true,
			[FACTION_OTA] = true
		},
		bReceiveVoices = true,
		CanSay = function(class, speaker, text)
			return class.factionAccessTable[speaker:Team()] == true
		end,
		CanHear = function(class, speaker, listener)
			return class.factionAccessTable[listener:Team()] == true
		end,
		OnChatAdd = function(class, speaker, text)
			chat.AddText(class.color, "@dispatch ", speaker, color_white, ": "..text)
		end
	})

	-- admin broadcast
	ix.chat.Register("broadcast", {
		color = Color(150, 125, 175),
		format = "%s транслирует \"%s\"",
		CanSay = function(class, speaker, text)
			local cid = speaker:GetCharacter():GetIDCard()

			if !cid then 
				return false
			end

			local accesses = cid:GetData("access", {})

			if !accesses["BROADCAST"] then
				speaker:NotifyLocalized("notAllowed")

				return false
			end
		end,
		OnChatAdd = function(class, speaker, text)
			chat.AddText(class.color, ix.util.GetMaterial("cellar/chat/broadcast.png"), string.format(class.format, IsValid(speaker) and speaker:Name() or "Broadcast", text))
		end
	})

	local meColor = Color(150, 180, 120, 255)
	-- long-range action
	ix.chat.Register("mel", {
		format = "**** %s %s",
		color = meColor,
		CanHear = ix.config.Get("chatRange", 280) * 6,
		prefix = {"/MeL", "/ActionLong"},
		description = "@cmdMeL",
		deadCanChat = true,
		indicator = "chatPerforming"
	})

	ix.chat.Register("me", {
		format = "*** %s %s",
		color = meColor,
		CanHear = ix.config.Get("chatRange", 280) * 2,
		prefix = {"/Me", "/Action"},
		description = "@cmdMe",
		deadCanChat = true,
		indicator = "chatPerforming"
	})

	-- close action
	ix.chat.Register("mec", {
		format = "** %s %s",
		color = meColor,
		prefix = {"/MeC", "/ActionClose"},
		description = "@cmdMeC",
		CanHear = ix.config.Get("chatRange", 280) * 0.33,
		deadCanChat = true,
		indicator = "chatPerforming"
	})

	-- direct action
	ix.chat.Register("med", {
		format = "* %s %s",
		color = meColor,
		prefix = {"/MeD", "/ActionDirect"},
		description = "@cmdMeD",
		indicator = "chatPerforming",
		CanHear = function(class, speaker, listener)
			local entity = speaker:GetEyeTraceNoCursor().Entity

			if (speaker == listener and (!IsValid(entity) or !entity:IsPlayer())) then
				speaker:NotifyLocalized("lookAtPlayer")
				return false
			end

			return speaker == listener or listener == entity
		end
	})

	local itColor = Color(90, 170, 190, 255)
	-- long-range area action
	ix.chat.Register("itl", {
		prefix = "/ItL",
		description = "@cmdItL",
		deadCanChat = true,
		CanHear = ix.config.Get("chatRange", 280) * 6,
		indicator = "chatPerforming",
		OnChatAdd = function(class, speaker, text)
			chat.AddText(itColor, "**** " .. text)
		end
	})

	-- close area action
	ix.chat.Register("it", {
		prefix = {"/It"},
		description = "@cmdIt",
		indicator = "chatPerforming",
		deadCanChat = true,
		CanHear = ix.config.Get("chatRange", 280) * 2,
		OnChatAdd = function(self, speaker, text)
			chat.AddText(itColor, "*** "..text)
		end,
	})

	ix.chat.Register("itc", {
		prefix = "/ItC",
		description = "@cmdItC",
		deadCanChat = true,
		CanHear = ix.config.Get("chatRange", 280) * 0.33,
		indicator = "chatPerforming",
		OnChatAdd = function(class, speaker, text)
			chat.AddText(itColor, "** " .. text)
		end
	})

	-- direct area action
	ix.chat.Register("itd", {
		prefix = "/ItD",
		description = "@cmdItD",
		indicator = "chatPerforming",
		CanHear = function(class, speaker, listener)
			local entity = speaker:GetEyeTraceNoCursor().Entity

			if (speaker == listener and (!IsValid(entity) or !entity:IsPlayer())) then
				speaker:NotifyLocalized("lookAtPlayer")
				return false
			end

			return speaker == listener or listener == entity
		end,
		OnChatAdd = function(class, speaker, text)
			chat.AddText(itColor, "* " .. text)
		end
	})

	ix.chat.Register("roll", {
		format = "%s.",
		color = Color(100, 185, 100),
		CanHear = ix.config.Get("chatRange", 280),
		deadCanChat = true,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			chat.AddText(self.color, ix.util.GetMaterial("cellar/chat/roll.png"), string.format(self.format,
				L("rollOutput", speaker:GetName(), text, data.max or 100)
			))
		end
	})

	ix.chat.Register("chess", {
		CanHear = ix.config.Get("chatRange", 280),
		OnChatAdd = function(self, speaker, text)
			chat.AddText(ix.util.GetMaterial("cellar/chat/roll.png"), Color(100, 185, 100), text)
		end,
	})

	ix.chat.Register("localevent", {
		CanHear = (ix.config.Get("chatRange", 280) * 2),
		OnChatAdd = function(self, speaker, text)
			chat.AddText(Color(255, 150, 0), text)
		end,
	})

	ix.chat.Register("ooc", {
		CanSay = function(self, speaker, text)
			if (!ix.config.Get("allowGlobalOOC")) then
				speaker:NotifyLocalized("Global OOC is disabled on this server.")
				return false
			else
				local delay = ix.config.Get("oocDelay", 10)

				-- Only need to check the time if they have spoken in OOC chat before.
				if (delay > 0 and speaker.ixLastOOC) then
					local lastOOC = CurTime() - speaker.ixLastOOC

					-- Use this method of checking time in case the oocDelay config changes.
					if (lastOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
						speaker:NotifyLocalized("oocDelay", delay - math.ceil(lastOOC))

						return false
					end
				end

				-- Save the last time they spoke in OOC.
				speaker.ixLastOOC = CurTime()
			end
		end,
		OnChatAdd = function(self, speaker, text)
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end

			local icon = serverguard.ranks:GetRank(serverguard.player:GetRank(speaker)).texture or "icon16/user.png"

			icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

			chat.AddText(icon, Color(255, 50, 50), "[OOC] ", speaker, color_white, ": "..text)
		end,
		prefix = {"//", "/OOC"},
		description = "@cmdOOC",
		noSpaceAfter = true
	})
end
Schema:InitializedChatClasses()
do
	local chatTypes = {
		["ic"] = true,
		["w"] = true,
		["y"] = true,
		["radio"] = true,
		["request"] = true,
		["dispatch"] = true,
		["dispatch_radio"] = true
	}

	function Schema:ShouldPlayTypingBeep(client, chatType)
		return client:IsCombine() and chatTypes[chatType] and client:GetMoveType() != MOVETYPE_NOCLIP
	end
end

function Schema:CanPlayerUseBusiness(client, uniqueID)
	return false
end

function Schema:CanDrive()
	return false
end

function Schema:GetMaxPlayerCharacter(client)
	local maximum = ix.config.Get("maxCharacters", 5)

	for _, v in SortedPairs(ix.faction.teams) do
		if (client:HasWhitelist(v.index)) then
			maximum = maximum + 1
		end
	end

	return maximum
end

function Schema:OnPlayerHitGround(client)
	local velocity = client:GetVelocity()

	client:SetVelocity(Vector(-(velocity.x / 2), -(velocity.y / 2), 0))
end

function Schema:SetupMove(client, moveData, userCmd)
	if (userCmd:KeyDown(IN_BACK)) then
		moveData:SetForwardSpeed(-client:GetWalkSpeed())
		moveData:SetSideSpeed(math.Clamp(moveData:GetSideSpeed(), -client:GetWalkSpeed(), client:GetWalkSpeed()))
	end
end

function Schema:InitializedPlugins()
	for _, v in pairs(weapons.GetList()) do
		local base = v.Base

		if (base == "arccw_base" or base == "arccw_base_melee" or base == "arccw_base_nade") then
			v.HoldtypeHolstered = v.HoldtypeActive
		end
	end
end

function Schema:InitializedChatClasses()
	ix.chatLanguages.AddChatType("radio")
	ix.chatLanguages.AddChatType("radio_eavesdrop")
	ix.chatLanguages.AddChatType("request")
	ix.chatLanguages.AddChatType("request_eavesdrop")
	ix.chatLanguages.AddChatType("request_loopback")
	ix.chatLanguages.AddChatType("dispatch")
	ix.chatLanguages.AddChatType("dispatch_radio")
	ix.chatLanguages.AddChatType("dispatch_chat")
	ix.chatLanguages.AddChatType("broadcast")
end

function Schema:PhysgunPickup(client, entity)
	if (entity:GetNWBool("IsPermaEntity")) then
		return false
	end
end
