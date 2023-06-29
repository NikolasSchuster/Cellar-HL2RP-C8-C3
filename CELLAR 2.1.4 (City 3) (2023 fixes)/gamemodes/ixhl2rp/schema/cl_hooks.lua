
function Schema:PopulateCharacterInfo(client, character, tooltip)
	if (client:IsRestricted()) then
		local panel = tooltip:AddRowAfter("rarity", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("tiedUp"))
		panel:SizeToContents()
	elseif (client:GetNetVar("tying")) then
		local panel = tooltip:AddRowAfter("rarity", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("beingTied"))
		panel:SizeToContents()
	elseif (client:GetNetVar("untying")) then
		local panel = tooltip:AddRowAfter("rarity", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("beingUntied"))
		panel:SizeToContents()
	end
end

function Schema:ChatTextChanged(text)
	if (LocalPlayer():IsCombine()) then -- and (text:sub(1, 1):find("%w") or text:find("/%a+%s"))) then
		local chatType = ix.chat.Parse(LocalPlayer(), text, true)

		if (self:ShouldPlayTypingBeep(LocalPlayer(), chatType)) then
			netstream.Start("PlayerChatTextChanged", chatType)
		end
	end
end

function Schema:FinishChat()
	netstream.Start("PlayerFinishChat")
end

function Schema:CanPlayerJoinClass(client, class, info)
	return client:Team() == FACTION_ZOMBIE
end

function Schema:GetPlayerEntityMenu(client, options)
	local callingPlayer = LocalPlayer()

	if (!callingPlayer:IsRestricted() and client:IsRestricted() and !client:GetNetVar("untying")) then
		options["Untie"] = true
		options["Search"] = true
	elseif (!callingPlayer:IsRestricted() and !client:IsRestricted() and !client:GetNetVar("tying") and
		callingPlayer:GetCharacter():GetInventory():HasItem("zip_tie")) then
			options["Ziptie"] = true
	elseif (!callingPlayer:IsRestricted() and client:GetNetVar("crit")) then
		options["Search"] = true
	end
end

function Schema:CharacterLoaded(character)
	if (character:IsCombine()) then
		vgui.Create("ixCombineDisplay")

		timer.Create("ixRandomDisplayLines", 12, 0, function()
			if (IsValid(client) and client:IsCombine()) then
				local text = self.randomDisplayLines[math.random(1, #self.randomDisplayLines)]

				if (istable(text)) then
					text = text[2](text[1]) or ""
				end

				if (text and self.LastRandomDisplayLine != text) then
					self:AddCombineDisplayMessage(text)

					self.LastRandomDisplayLine = text
				end
			else
				self.LastRandomDisplayLine = nil

				timer.Remove("ixRandomDisplayLines")
			end
		end)
	elseif (IsValid(ix.gui.combine)) then
		ix.gui.combine:Remove()

		timer.Remove("ixRandomDisplayLines")
	end
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	return true
end

local colorModify = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.015,
	["$pp_colour_contrast"] = 1.2,
	["$pp_colour_colour"] = 0.5,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local combineOverlay = ix.util.GetMaterial("effects/combine_binocoverlay")

function Schema:RenderScreenspaceEffects()
	DrawColorModify(colorModify)
	local char = LocalPlayer():GetCharacter()

	if (char and char:HasVisor() and !char:IsOTA()) then
		render.UpdateScreenEffectTexture()

		combineOverlay:SetFloat("$alpha", 0.25)
		combineOverlay:SetInt("$ignorez", 1)

		render.SetMaterial(combineOverlay)
		render.DrawScreenQuad()
	end
end

function Schema:ShouldShowPlayerOnScoreboard(client)
	local clientFaction = LocalPlayer():Team()
	local playerFaction = client:Team()

	if (playerFaction == clientFaction) then
		return
	end
end

function Schema:CanDrawAmmoHUD(weapon) end

function Schema:IsPlayerRecognized(target)
	if !IsValid(target) then
		return
	end
	-- target:IsCombine()
	if target:IsCityAdmin() then
		return true
	end

	--if target:GetNetVar("IsConcealed", false) then
	--	return false
	--end
end

function Schema:IsRecognizedChatType(chatType)
	if (chatType == "mec" or chatType == "mel" or chatType == "med") then
		return true
	end
end

function Schema:BuildBusinessMenu(panel)
	local bHasItems = false

	for k, _ in pairs(ix.item.list) do
		if (hook.Run("CanPlayerUseBusiness", LocalPlayer(), k) != false) then
			bHasItems = true

			break
		end
	end

	return bHasItems
end

netstream.Hook("CombineDisplayMessage", function(text, color, arguments)
	if (IsValid(ix.gui.combine)) then
		ix.gui.combine:AddLine(text, color, nil, unpack(arguments))
	end
end)

netstream.Hook("PlaySound", function(sound)
	surface.PlaySound(sound)
end)

netstream.Hook("ixEmitQueuedSounds", function(sounds, delay, spacing, volume, pitch)
	ix.util.EmitQueuedSounds(LocalPlayer(), sounds, delay, spacing, volume, pitch)
end)

netstream.Hook("ixPlayLocalSound", function(path, position, level, pitch, volume)
	sound.Play(path, position, level, pitch, volume)
end)

function Schema:PopulateHelpMenu(tabs)
	tabs["voices"] = function(container)
		local classes = {}

		for k, v in pairs(Schema.voices.classes) do
			if (v.condition(LocalPlayer())) then
				classes[#classes + 1] = k
			end
		end

		if (#classes < 1) then
			local info = container:Add("DLabel")
			info:SetFont("ixSmallFont")
			info:SetText("You do not have access to any voice lines!")
			info:SetContentAlignment(5)
			info:SetTextColor(color_white)
			info:SetExpensiveShadow(1, color_black)
			info:Dock(TOP)
			info:DockMargin(0, 0, 0, 8)
			info:SizeToContents()
			info:SetTall(info:GetTall() + 16)

			info.Paint = function(_, width, height)
				surface.SetDrawColor(ColorAlpha(derma.GetColor("Error", info), 160))
				surface.DrawRect(0, 0, width, height)
			end

			return
		end

		table.sort(classes, function(a, b)
			return a < b
		end)

		for _, class in ipairs(classes) do
			local category = container:Add("Panel")
			category:Dock(TOP)
			category:DockMargin(0, 0, 0, 8)
			category:DockPadding(8, 8, 8, 8)
			category.Paint = function(_, width, height)
				surface.SetDrawColor(Color(0, 0, 0, 66))
				surface.DrawRect(0, 0, width, height)
			end

			local categoryLabel = category:Add("DLabel")
			categoryLabel:SetFont("ixMediumLightFont")
			categoryLabel:SetText(class:upper())
			categoryLabel:Dock(FILL)
			categoryLabel:SetTextColor(color_white)
			categoryLabel:SetExpensiveShadow(1, color_black)
			categoryLabel:SizeToContents()
			category:SizeToChildren(true, true)

			for command, info in SortedPairs(self.voices.stored[class]) do
				local title = container:Add("DLabel")
				title:SetFont("ixMediumLightFont")
				title:SetText(command:upper())
				title:Dock(TOP)
				title:SetTextColor(ix.config.Get("color"))
				title:SetExpensiveShadow(1, color_black)
				title:SizeToContents()

				local description = container:Add("DLabel")
				description:SetFont("ixSmallFont")
				description:SetText(info.text)
				description:Dock(TOP)
				description:SetTextColor(color_white)
				description:SetExpensiveShadow(1, color_black)
				description:SetWrap(true)
				description:SetAutoStretchVertical(true)
				description:SizeToContents()
				description:DockMargin(0, 0, 0, 8)
			end
		end
	end
end

function Schema:ShouldDisableThirdperson(client)
	if (client:IsWepRaised()) then
		return true    
	end
end

function Schema:InitPostEntity()
	RunConsoleCommand("r_eyemove", "0")
end
