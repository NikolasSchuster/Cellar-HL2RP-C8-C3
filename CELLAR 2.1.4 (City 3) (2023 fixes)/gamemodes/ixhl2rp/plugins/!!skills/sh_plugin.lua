local PLUGIN = PLUGIN

PLUGIN.name = "Skills and Attributes"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

ix.util.Include("sh_config.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

if (SERVER) then
	//function PLUGIN:GetPlayerPunchDamage(client, damage, context)
	//	if (client:GetCharacter()) then
			-- Add to the total fist damage.
	//		context.damage = context.damage + (client:GetCharacter():GetAttribute("st", 0) * ix.config.Get("strengthMultiplier"))
	//	end
	//end

	//function PLUGIN:PlayerThrowPunch(client, trace)
		//if (client:GetCharacter() and IsValid(trace.Entity) and trace.Entity:IsPlayer()) then
		//	client:GetCharacter():UpdateAttrib("st", 0.001)
		//end
	//end
end

-- Configuration for the plugin
ix.config.Add("strengthMultiplier", 0.3, "The strength multiplier scale", nil, {
	data = {min = 0, max = 1.0, decimals = 1},
	category = "Strength"
})


local function CalculateWidestName(tbl)
	local highest = 0
	do
		local highs = {}
		for k, v in pairs(tbl) do
			surface.SetFont("ixAttributesFont")
			local w1 = surface.GetTextSize(L(v.name))
			highs[#highs+1] = w1

			highest = math.max(unpack(highs))
		end
	end

	return highest
end

do
	local skillsUI
	ix.char.RegisterVar("specials", {
		field = "specials",
		fieldType = ix.type.text,
		default = {},
		index = 6,
		category = "skills",
		isLocal = true,
		OnDisplay = function(self, container, payload)
			local faction = ix.faction.indices[payload.faction]
			local pointsmax = hook.Run("GetDefaultSpecialPoints", LocalPlayer(), payload)

			if (pointsmax < 1) then
				return
			end

			local stats = container:Add("ixStatsPanel")
			stats:Dock(TOP)

			local y
			local total = 0

			payload.specials = {}

			-- total spendable attribute points
			local totalBar = stats:Add("ixAttributeBar")
			totalBar:SetMax(pointsmax)
			totalBar:SetValue(pointsmax)
			totalBar:Dock(TOP)
			totalBar:DockMargin(2, 2, 2, 2)
			totalBar:SetText(L("attribPointsLeft"))
			totalBar:SetReadOnly(true)
			totalBar:SetColor(Color(20, 120, 20, 255))

			y = totalBar:GetTall() + 4

			stats.attributes = stats:Add("ixStatsPanelCategory")
			stats.attributes:SetText(L("attributes"):upper())
			stats.attributes:Dock(LEFT)

			stats.skills = stats:Add("ixStatsPanelCategory")
			stats.skills:SetText(L("skills"):upper())
			stats.skills:Dock(FILL)
			stats.skills:DockMargin(20, 0, 0, 0)

			local w1 = CalculateWidestName(ix.specials.list)
			local w2 = CalculateWidestName(ix.skills.list)

			stats.attributes.offset = w1 * 1.75
			stats.attributes:SetWide(w1 * 2.75)

			for k, v in SortedPairsByMemberValue(ix.specials.list, "weight") do
				payload.specials[k] = 1

				local bar = stats.attributes:Add("ixStatBar")
				bar:Dock(TOP)

				if (!bFirst) then
					bar:DockMargin(4, 1, 0, 0)
				else
					bar:DockMargin(4, 0, 0, 0)
					bFirst = false
				end

				bar:SetValue(payload.specials[k])

				local maximum = v.maxValue or 10
				bar:SetMax(maximum)
				if (v.noStartBonus) then
					bar:SetReadOnly()
				end
				bar:SetText(L(v.name), Format("%i/%i", payload.specials[k], maximum))
				bar:SetDesc(L(v.description))
				bar.OnChanged = function(this, difference)
					if ((payload.specials[k] + difference) <= 0) then
						return false
					end

					if ((total + difference) > pointsmax) then
						return false
					end

					total = total + difference
					payload.specials[k] = payload.specials[k] + difference

					this:SetText(L(v.name), Format("%i/%i", payload.specials[k], maximum))
					totalBar:SetValue(totalBar.value - difference)
				end
			end

			stats.attributes:SizeToContents()

			stats.skills.offset = w2 * 1.5
			stats.skills:SetWide(w2 * 2)

			local bFirst = true

			for i = 1, 6 do
				stats.skills.categories = stats.skills.categories or {}
				stats.skills.categories[i] = stats.skills:Add("ixStatsPanel")
				stats.skills.categories[i].offset = stats.skills.offset
				stats.skills.categories[i]:Dock(TOP)
				stats.skills.categories[i]:DockMargin(0, 0, 0, 8)
			end

			local categories = {}
			for k, v in pairs(ix.skills.list) do
				categories[v.category] = categories[v.category] or {}
				categories[v.category][k] = L(v.name)
			end

			stats.skills.bars = {}

			for k, v in pairs(categories) do
				for z, x in SortedPairs(v) do
					v = ix.skills.list[z]
					local bar = stats.skills.categories[k]:Add("ixStatBar")
					bar:Dock(TOP)

					if (!bFirst) then
						bar:DockMargin(4, 1, 4, 0)
					else
						bar:DockMargin(4, 0, 4, 0)
						bFirst = false
					end

					local value = v:GetInitial(payload.specials, payload) or 0
					if faction.startSkills and faction.startSkills[z] then
						value = faction.startSkills[z]
					end

					bar:SetValue(value)

					local maximum = v:GetMaximum(nil, nil, 0)
					bar:SetMax(maximum)
					bar:SetReadOnly()
					bar:SetText(L(v.name), Format("%i / %i", value, maximum))
					bar:SetDesc(L(v.description))

					stats.skills.bars[z] = bar
				end
			end

			local y = 0
			for i = 1, 6 do
				stats.skills.categories[i]:SizeToContents()

				local _, top, _, bottom = stats.skills.categories[i]:GetDockMargin()
				y = y + stats.skills.categories[i]:GetTall() + top + bottom
			end

			if (stats.attributes:GetTall() < (y + 4)) then
				stats.attributes:SetTall(0)
			end

			stats.skills:SetTall(stats.skills:GetTall() + y + 4)

			stats:SizeToContents()
			return stats
		end,
		OnValidate = function(self, value, data, client)
			if (value != nil) then
				if (istable(value)) then
					local count = 0

					for _, v in pairs(value) do
						count = count + v + -1
					end

					local defaulSpecialPoints = hook.Run("GetDefaultSpecialPoints", client, data)

					if (count < defaulSpecialPoints) then
						return false, "Вы должны потратить все очки SPECIAL!"
					end

					if (count > defaulSpecialPoints) then
						return false, "unknownError"
					end
				else
					return false, "unknownError"
				end
			end
		end,
		ShouldDisplay = function(self, container, payload)
			return !table.IsEmpty(ix.specials.list)
		end
	})

	ix.char.RegisterVar("skills", {
		field = "skills",
		fieldType = ix.type.text,
		default = {},
		category = "skills",
		isLocal = true,
		OnDisplay = function(self, container, payload)
		end,
		OnValidate = function(self, value, data, client)
			if data.specials then
				local faction = ix.faction.indices[data.faction]

				data.skills = {}

				for k, v in pairs(ix.skills.list) do
					data.skills[k] = faction.startSkills and {faction.startSkills[k] or 0, 0} or v:OnDefault()
				end
			end
		end,
	})
end

function PLUGIN:GetDefaultSpecialPoints(client, payload)
	local pointsMax = 10
	local faction = ix.faction.indices[payload.faction]

	if faction.defaultLevel then
		pointsMax = 5 + (5 * math.min(faction.defaultLevel, 5)) + (1 * math.max(faction.defaultLevel - 5, 0))
	end

	return pointsMax
end

function PLUGIN:CharacterSkillUpdated(client, character, skillID, isIncreased)
	local skill = (ix.skills.list[skillID] or {})

	ix.chat.Send(nil, "level", "", nil, {client}, {
		t = isIncreased and 2 or 4,
		skill = skillID,
		value = math.floor(character:GetSkill(skillID))
	})

	if skill.OnLevelUp then
		skill:OnLevelUp(client, character)
	end
end

local successColor = Color(77, 176, 77)
ix.chat.Register("skillroll", {
	format = "** [%s %s] %s (%s).",
	color = Color(176, 77, 77),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(data.success and successColor or self.color, string.format(self.format,
			L((ix.skills.list[data.skill] or {}).name), math.Round(data.check), L("rollOutput", speaker:GetName(), text, 10), data.success and L"skillSuccess" or L"skillFail"
		))
	end
})

ix.chat.Register("statroll", {
	format = "** [%s %s] %s (%s).",
	color = Color(176, 77, 77),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(data.success and successColor or self.color, string.format(self.format,
			L((ix.specials.list[data.stat] or {}).name), math.Round(data.check), L("rollOutput", speaker:GetName(), text, 10), data.success and L"skillSuccess" or L"skillFail"
		))
	end
})


if SERVER then
	util.AddNetworkString("ixLevelPatch")
	util.AddNetworkString("ixLevelUp")

	local TIME_PATCH = 1617188178
	local TIME_PATCH2 = 1617191206

	function PLUGIN:CharacterLoaded(character)
		if !character:GetPlayer():IsBot() then
			if tonumber(character:GetCreateTime()) <= TIME_PATCH then
				if character:GetData("patch14") then
					return
				end

				net.Start("ixLevelPatch")
				net.Send(character:GetPlayer())
			end

			if tonumber(character:GetCreateTime()) <= TIME_PATCH2 then
				character:SetBleeding(false)
			end
		end
	end

	function PLUGIN:CharacterRestored(character)
		local skills = character:GetSkills({})
		local updateNewSkills = false

		for k, v in pairs(ix.skills.list) do
			if skills[k] then continue end

			skills[k] = v:OnDefault()
			updateNewSkills = true
		end

		if updateNewSkills then
			character:SetSkills(skills)
		end
	end

	local function CalcAthleticsSpeed(athletics)
		return 1 + (athletics * 0.1) * 0.25
	end
	net.Receive("ixLevelPatch", function(len, ply)
		local character = ply:GetCharacter()

		if tonumber(character:GetCreateTime()) > TIME_PATCH then
			return
		end

		if character:GetData("patch14") then
			return
		end

		local specials = net.ReadTable()
		local lvl = character:GetLevel()
		local pointsmax = 5 + (5 * math.min(lvl, 5)) + (1 * math.max(lvl - 5, 0))

		if istable(value) then
			local count = 0

			for _, v in pairs(value) do
				count = count + v + -1
			end

			if count < pointsmax then
				print("Error")
				return
			end
		end

		character:SetData("patch14", true)
		character:SetSpecials(specials)

		local skills = character:GetSkills()

		for k, v in pairs(skills) do
			skills[k][1] = math.Clamp(math.floor(10 * ((skills[k][1] or 0) / 100)), 0, 10)
		end

		character:SetSkills(skills)
		character:SetBleeding(false)
		ply:SetRunSpeed(ix.config.Get("runSpeed") * CalcAthleticsSpeed(character:GetSkillModified("athletics")))
		ply:SetJumpPower(160 * (1 + math.min(math.Remap(character:GetSkillModified("acrobatics"), 0, 10, 0, 0.75), 0.75)))
	end)
else
	local function CalculateWidestName(tbl)
		local highest = 0
		do
			local highs = {}
			for k, v in pairs(tbl) do
				surface.SetFont("ixAttributesFont")
				local w1 = surface.GetTextSize(L(v.name))
				highs[#highs+1] = w1

				highest = math.max(unpack(highs))
			end
		end

		return highest
	end

	local function OpenSpecials(container, specials, pointsmax, default)
		local stats = container:Add("ixStatsPanel")
		stats:Dock(TOP)
		local y
		local total = 0
		local totalBar = stats:Add("ixAttributeBar")
		totalBar:SetMax(pointsmax)
		totalBar:SetValue(pointsmax)
		totalBar:Dock(TOP)
		totalBar:DockMargin(2, 2, 2, 2)
		totalBar:SetText(L("attribPointsLeft"))
		totalBar:SetReadOnly(true)
		totalBar:SetColor(Color(20, 120, 20, 255))

		y = totalBar:GetTall() + 4

		stats.attributes = stats:Add("ixStatsPanelCategory")
		stats.attributes:SetText(L("attributes"):upper())
		stats.attributes:Dock(FILL)

		local w1 = CalculateWidestName(ix.specials.list)

		stats.attributes.offset = w1 * 1.75
		stats.attributes:SetWide(w1 * 2.75)

		local charSpecials = LocalPlayer():GetCharacter():GetSpecials()

		for k, v in SortedPairsByMemberValue(ix.specials.list, "weight") do
			specials[k] = default and 1 or charSpecials[k]

			local bar = stats.attributes:Add("ixStatBar")
			bar:Dock(TOP)

			if !bFirst then
				bar:DockMargin(4, 1, 0, 0)
			else
				bar:DockMargin(4, 0, 0, 0)
				bFirst = false
			end

			bar:SetValue(specials[k])

			local maximum = v.maxValue or 10
			bar:SetMax(maximum)
			bar:SetText(L(v.name), Format("%i/%i", specials[k], maximum))
			bar:SetDesc(L(v.description))
			bar.OnChanged = function(this, difference)
				if ((specials[k] + difference) <= 0) then
					return false
				end

				for z, x in pairs(specials) do
					if (specials[z] - (specials[k] + difference)) < -3 then
						return false
					end
				end

				if ((total + difference) > pointsmax) then
					return false
				end

				total = total + difference

				specials[k] = specials[k] + difference

				this:SetText(L(v.name), Format("%i/%i", specials[k], maximum))
				totalBar:SetValue(totalBar.value - difference)
			end
		end

		stats.attributes:SizeToContents()

		stats:SizeToContents()
	end

	local color_green = Color(0, 255, 0)
	local function OpenBackward()
		if IsValid(ix.gui.patchfix1) then
			ix.gui.patchfix1:Remove()
		end

		local w, h = ScrW(), ScrH()
		w = math.max(w * 0.6, h * 0.7)
		h = h * 0.5

		local frame = vgui.Create("DFrame")
		frame:SetTitle(L"skillPatchTitle")
		frame:SetDraggable(false)
		frame:SetSize(w, h)
		frame:MakePopup()
		frame:Center()
		frame:ShowCloseButton(false)
		frame.OnClose = function(self)
			ix.gui.patchfix1 = nil
		end

		local specials = {}

		local label = frame:Add("DLabel")
		label:SetFont("ixMenuButtonHugeFont")
		label:SetTextColor(ix.config.Get("color"))
		label:SetText("Перераспределение очков")
		label:SizeToContents()
		label:Dock(TOP)
		label:DockMargin(10, 0, 0, 0)

		local label = frame:Add("DLabel")
		label:SetFont("ixSmallTitleFont")
		label:SetTextColor(color_white)
		label:SetAutoStretchVertical(true)
		label:SetWrap(true)
		label:SetText("В связи с обновлением характеристик и навыков, Вам необходимо заного перераспределить очки характеристик персонажа.")
		label:SizeToContents()
		label:Dock(TOP)
		label:DockMargin(0, 0, 0, 0)

		local container = frame:Add("DScrollPanel")
		container:Dock(FILL)

		local accept = frame:Add("DButton")
		accept:SetFont("ixMenuButtonLabelFont")
		accept:SetText(L"skillPatchApply")
		accept:SetTextColor(color_green)
		accept:SetTall(48)
		accept:Dock(BOTTOM)
		accept.DoClick = function(self)
			net.Start("ixLevelPatch")
				net.WriteTable(specials or {})
			net.SendToServer()

			frame:Close()
		end

		local lvl = LocalPlayer():GetCharacter():GetLevel()
		local pointsmax = 5 + (5 * math.min(lvl, 5)) + (1 * math.max(lvl - 5, 0))

		OpenSpecials(container, specials, pointsmax, true)

		ix.gui.patchfix1 = frame
	end

	local function OpenLevelUp()
		if IsValid(ix.gui.levelup) then
			ix.gui.levelup:Remove()
		end

		local lvl = LocalPlayer():GetCharacter():GetLevel()
		local pointsmax = 6 + (5 + (5 * math.min(lvl, 5)) + (1 * math.max(lvl - 5, 0)))

		for k, v in pairs(ix.specials.list) do
			pointsmax = pointsmax - LocalPlayer():GetCharacter():GetSpecials()[k]
		end

		local w, h = ScrW(), ScrH()
		w = math.max(w * 0.6, h * 0.7)
		h = h * 0.5

		local frame = vgui.Create("DFrame")
		frame:SetTitle(L"skillPatchTitle")
		frame:SetDraggable(false)
		frame:SetSize(w, h)
		frame:MakePopup()
		frame:Center()
		frame:ShowCloseButton(false)
		frame.OnClose = function(self)
			ix.gui.levelup = nil
		end

		local specials = {}

		local label = frame:Add("DLabel")
		label:SetFont("ixMenuButtonHugeFont")
		label:SetTextColor(ix.config.Get("color"))
		label:SetText("Повышение уровня")
		label:SizeToContents()
		label:Dock(TOP)
		label:DockMargin(10, 0, 0, 0)

		local label = frame:Add("DLabel")
		label:SetFont("ixSmallTitleFont")
		label:SetTextColor(color_white)
		label:SetAutoStretchVertical(true)
		label:SetWrap(true)
		label:SetText("Ваш уровень был повышен! Распределите "..pointsmax.." очков характеристик.")
		label:SizeToContents()
		label:Dock(TOP)
		label:DockMargin(0, 0, 0, 0)

		local container = frame:Add("DScrollPanel")
		container:Dock(FILL)

		local accept = frame:Add("DButton")
		accept:SetFont("ixMenuButtonLabelFont")
		accept:SetText(L"skillPatchApply")
		accept:SetTextColor(color_green)
		accept:SetTall(48)
		accept:Dock(BOTTOM)
		accept.DoClick = function(self)
			net.Start("ixLevelUp")
				net.WriteTable(specials or {})
			net.SendToServer()

			frame:Close()
		end

		OpenSpecials(container, specials, pointsmax)

		ix.gui.levelup = frame
	end

	net.Receive("ixLevelUp", OpenLevelUp)
	net.Receive("ixLevelPatch", OpenBackward)
end

ix.specials.LoadFromDir(PLUGIN.folder.."/specials")
ix.skills.LoadFromDir(PLUGIN.folder.."/skills")

function PLUGIN:DoPluginIncludes(path)
	ix.specials.LoadFromDir(path.."/specials")
	ix.skills.LoadFromDir(path.."/skills")
end

function PLUGIN:CharacterMaxStamina(character)
	if !character then return 100 end
	local base = 30 + (12 * character:GetSpecial("en"))
	local mod = 1
	local thirst = character:GetThirst()

	if thirst < 75 and thirst >= 25 then
		mod = 0.75
	elseif thirst < 25 then
		mod = 0.2
	end

	return base * mod
end

-- Athletics Skill Related code
local function CalcAthleticsSpeed(athletics)
	return 1 + (athletics * 0.1) * 0.25
end

local function CalcAthleticsFatigue(athletics)
	return (athletics * 0.1) * 0.5
end

function PLUGIN:AdjustStaminaRegeneration(client, offset)
	local character = client:GetCharacter()
	local food, water = character:GetHunger(), character:GetThirst()

	local factor = math.min(math.Remap(((food + water) / 2), 0, 50, 0.25, 1), 0.25, 1)
	local isCrouch = client:Crouching() or client:IsProne()

	return (isCrouch and ix.config.Get("staminaCrouchRegeneration", 2) or ix.config.Get("staminaRegeneration", 1.75)) * factor
end

function PLUGIN:AdjustStaminaOffsetRunning(client, offset)
	local character = client:GetCharacter()

	return offset + CalcAthleticsFatigue(character:GetSkillModified("athletics"))
end
