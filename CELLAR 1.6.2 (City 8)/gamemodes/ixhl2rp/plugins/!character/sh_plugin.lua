local PLUGIN = PLUGIN

PLUGIN.name = "Enhanced Character Creation"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = ""

ix.util.Include("sh_gender.lua")
//ix.util.Include("sh_humannames.lua")

do
	ix.char.RegisterVar("description", {
		field = "description",
		fieldType = ix.type.text,
		default = "",
		index = 2,
		OnValidate = function(self, value, payload)
			value = string.Trim((tostring(value):gsub("\r\n", ""):gsub("\n", "")))
			local minLength = ix.config.Get("minDescriptionLength", 16)

			if (value:utf8len() < minLength) then
				return false, "descMinLen", minLength
			elseif (!value:find("%s+") or !value:find("%S")) then
				return false, "invalid", "description"
			end

			return value
		end,
		OnPostSetup = function(self, panel, payload)
			panel:SetMultiline(true)
			panel:SetFont("ixMenuButtonFont")
			panel:SetTall(panel:GetTall() * 2 + 6) -- add another line
			panel.AllowInput = function(_, character)
				if (character == "\n" or character == "\r") then
					return true
				end
			end
		end,
		alias = "Desc"
	})

	ix.char.RegisterVar("gender", {
		field = "gender",
		fieldType = ix.type.number,
		default = 0,
		index = 3,
		OnValidate = function(self, value, payload, client) 
			if value <= 0 or value > 2 then
				return false
			end
			
			return value
		end,
		OnDisplay = function(self, container, payload)
			local setting = container:Add("DComboBox")
			setting:Dock(TOP)
			setting:SetTall(48)
			setting:SetFont("ixMenuButtonFont")
			setting:SetTextColor(color_white)
			setting:SetSortItems(false)
			setting.OnSelect = function(panel)
				payload:Set("gender", select(2, setting:GetSelected()))
			end
			setting.Paint = function(panel, width, height)
				derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
			end

			local faction = ix.faction.indices[payload.faction]
			local genders = faction.genders or {GENDER_MALE, GENDER_FEMALE}

			for k, v in ipairs(genders) do
				if !PLUGIN.Genders[v] then continue end

				setting:AddChoice(L(PLUGIN.Genders[v]), v)
			end

			payload:Set("gender", 1)
			setting:ChooseOptionID(1)

			return setting
		end,
		ShouldDisplay = function(self, container, payload)
			local faction = ix.faction.indices[payload.faction]
			return faction.genders and (#faction.genders > 1) or true
		end
	})

	ix.char.RegisterVar("model", {
		field = "model",
		fieldType = ix.type.string,
		default = "models/error.mdl",
		index = 4,
		OnSet = function(character, value)
			local client = character:GetPlayer()

			if (IsValid(client) and client:GetCharacter() == character) then
				client:SetModel(value)
			end

			character.vars.model = value
		end,
		OnGet = function(character, default)
			return character.vars.model or default
		end,
		OnDisplay = function(self, container, payload)
			container.modelList = container:Add("DIconLayout")
			container.modelList:Dock(FILL)
			container.modelList:SetTall(512)
			container.modelList:SetSpaceX(1)
			container.modelList:SetSpaceY(1)
			container.modelList.Paint = function(panel, width, height)
				derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
			end
			container.modelList.UpdateModels = function(this, payload)
				this:Clear()

				local faction = ix.faction.indices[payload.faction]

				if (faction) then
					local models = faction:GetModels(LocalPlayer(), payload.gender)

					payload:Set("model", math.random(1, #models))

					for k, v in SortedPairs(models) do
						local icon = this:Add("SpawnIcon")
						icon:SetSize(64, 128)
						icon:InvalidateLayout(true)
						icon.DoClick = function(this)
							payload:Set("model", k)
						end
						icon.PaintOver = function(this, w, h)
							if (payload.model == k) then
								local color = ix.config.Get("color", color_white)

								surface.SetDrawColor(color.r, color.g, color.b, 200)

								for i = 1, 3 do
									local i2 = i * 2
									surface.DrawOutlinedRect(i, i, w - i2, h - i2)
								end
							end
						end

						if (isstring(v)) then
							icon:SetModel(v)
						else
							icon:SetModel(v[1], v[2] or 0, v[3])
						end
					end
				end
			end

			container.modelList:UpdateModels(payload)

			return container.modelList
		end,
		OnValidate = function(self, value, payload, client)
			local faction = ix.faction.indices[payload.faction]

			if (faction) then
				local models = faction:GetModels(client, payload.gender)

				if (!payload.model or !models[payload.model]) then
					return false, "needModel"
				end
			else
				return false, "needModel"
			end
		end,
		OnAdjust = function(self, client, data, value, newData)
			local faction = ix.faction.indices[data.faction]

			if (faction) then
				local model = faction:GetModels(client, data.gender)[value]

				if (isstring(model)) then
					newData.model = model
				elseif (istable(model)) then
					newData.model = model[1]

					-- save skin/bodygroups to character data
					local bodygroups = {}

					for i = 1, 9 do
						bodygroups[i - 1] = tonumber(model[3][i]) or 0
					end

					newData.data = newData.data or {}
					newData.data.skin = model[2] or 0
					newData.data.groups = bodygroups
				end
			end
		end,
		ShouldDisplay = function(self, container, payload)
			local faction = ix.faction.indices[payload.faction]
			return #faction:GetModels(LocalPlayer(), payload.gender or 1) > 1
		end
	})

	ix.char.RegisterVar("attributes", {
		field = "attributes",
		fieldType = ix.type.text,
		default = {},
		index = 6,
		category = "attributes",
		isLocal = true,
		OnDisplay = function(self, container, payload)
			local maximum = hook.Run("GetDefaultAttributePoints", LocalPlayer(), payload) or ix.config.Get("maxAttributes", 30)

			if (maximum < 1) then
				return
			end

			local attributes = container:Add("DPanel")
			attributes:Dock(TOP)

			local y
			local total = 0

			payload.attributes = {}

			-- total spendable attribute points
			local totalBar = attributes:Add("ixAttributeBar")
			totalBar:SetMax(maximum)
			totalBar:SetValue(maximum)
			totalBar:Dock(TOP)
			totalBar:DockMargin(2, 2, 2, 2)
			totalBar:SetText(L("attribPointsLeft"))
			totalBar:SetReadOnly(true)
			totalBar:SetColor(Color(20, 120, 20, 255))

			y = totalBar:GetTall() + 4

			for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
				payload.attributes[k] = 0

				local bar = attributes:Add("ixAttributeBar")
				bar:SetMax(maximum)
				bar:Dock(TOP)
				bar:DockMargin(2, 2, 2, 2)
				bar:SetText(L(v.name))
				bar.OnChanged = function(this, difference)
					if ((total + difference) > maximum) then
						return false
					end

					total = total + difference
					payload.attributes[k] = payload.attributes[k] + difference

					totalBar:SetValue(totalBar.value - difference)
				end

				if (v.noStartBonus) then
					bar:SetReadOnly()
				end

				y = y + bar:GetTall() + 4
			end

			attributes:SetTall(y)
			return attributes
		end,
		OnValidate = function(self, value, data, client)
			if (value != nil) then
				if (istable(value)) then
					local count = 0

					for _, v in pairs(value) do
						count = count + v
					end

					if (count > (hook.Run("GetDefaultAttributePoints", client, count) or ix.config.Get("maxAttributes", 30))) then
						return false, "unknownError"
					end
				else
					return false, "unknownError"
				end
			end
		end,
		ShouldDisplay = function(self, container, payload)
			return false //!table.IsEmpty(ix.attributes.list)
		end
	})
end

if CLIENT then
	function PLUGIN:CanCreateCharacterInfo(suppress)
		suppress.attributes = true
	end

	function PLUGIN:CreateCharacterInfo(charinfo)
		if IsValid(charinfo) then
			charinfo.gender = charinfo:Add("ixListRow")
			charinfo.gender:SetList(charinfo.list)
			charinfo.gender:Dock(TOP)
		end
	end

	function PLUGIN:UpdateCharacterInfo(charinfo, character)
		if charinfo and charinfo.gender then
			charinfo.gender:SetLabelText(L("gender"))
			charinfo.gender:SetText(L(self.Genders[character:GetGender()] or "unknown"))
			charinfo.gender:SizeToContents()
		end
	end
end
