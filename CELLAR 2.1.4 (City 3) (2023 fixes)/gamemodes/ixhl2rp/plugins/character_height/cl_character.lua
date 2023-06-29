
local PLUGIN = PLUGIN

ix.char.RegisterVar("height", {
	default = 1,
	index = 5,
	OnDisplay = function(self, container, payload)
		local charCreationMenu = container:GetParent():GetParent():GetParent()
		local modelHooks = charCreationMenu.hooks["model"]
		local ResetSliderValue

		local slider = container:Add("DNumSlider")
		slider:Dock(TOP)
		slider:DockMargin(0, 4, 0, 0)
		slider:SetMinMax(1, 3)
		slider:SetDefaultValue(2)
		-- no other way to change color of slider and align it to knob sliding area but to override Paint function
		slider.Slider.Paint = function(this, width, height)
			local x = 7
			local y = height / 2 - 1

			surface.SetDrawColor(color_white:Unpack())
			surface.DrawRect(x, y, width - 14, 1)

			local notchesCount = this.m_iNotches
			local space = (width - 15) / notchesCount

			for i = 0, notchesCount do
				surface.DrawRect(x + i * space, y + 4, 1, 5)
			end
		end
		slider.OnValueChanged = function(this, value)
			local factionModel = charCreationMenu.factionModel:GetEntity()
			local descriptionModel = charCreationMenu.descriptionModel:GetEntity()
			local attributesModel = charCreationMenu.attributesModel:GetEntity()

			local rangeMin, rangeMax = unpack(PLUGIN.gendersHeight[payload.gender or 1])
			local maxMinDifference = rangeMax - rangeMin
			local valueFraction = value / this:GetMax()
			local heightAddition = math.Round(maxMinDifference * valueFraction, 3)
			local estimatedHeight = rangeMin + heightAddition

			factionModel:SetModelScale(estimatedHeight)
			descriptionModel:SetModelScale(estimatedHeight)
			attributesModel:SetModelScale(estimatedHeight)

			payload:Set("height", estimatedHeight)
		end
		slider.OnRemove = function()
			-- we can't rely on removing old hook using it's key due to OnRemove being called after panels re-population
			for k, v in ipairs(modelHooks) do
				if (v == ResetSliderValue) then
					table.remove(modelHooks, k)

					break
				end
			end
		end

		local sScratch = slider.Wang
		sScratch:SetCursor("arrow")
		sScratch:SetEnabled(false)
		sScratch.OnMouseReleased = function() end

		local sLabel = slider.Label
		sLabel:SetFont("ixMenuButtonFontSmall")
		sLabel:SetText(L("height"):utf8upper())
		sLabel:SizeToContents()

		local sTextEntry = slider:GetTextArea()
		sTextEntry:SetEditable(false)
		sTextEntry:SetWide(0)

		ResetSliderValue = function()
			-- just in case
			if (IsValid(slider)) then
				slider:ResetToDefaultValue()
			end
		end

		payload:Set("height", 1)
		payload:AddHook("model", ResetSliderValue)

		return slider
	end,
	OnPostSetup = function(self, panel, payload)
		local labelZPos = panel:GetZPos() - 1

		for _, v in ipairs(panel:GetParent():GetChildren()) do
			if (v:GetZPos() == labelZPos) then
				v:Remove()
				panel:SetZPos(labelZPos)

				break
			end
		end
	end
})

function PLUGIN:OnCharacterMenuCreated(panel)
	local loadCharPanel = panel.loadCharacterPanel

	loadCharPanel.delete.OnSetActive = function()
		local character = loadCharPanel.character
		local deleteModel = loadCharPanel.deleteModel

		deleteModel:SetModel(character:GetModel())
		deleteModel:GetEntity():SetModelScale(character:GetHeight())
		loadCharPanel:CreateAnimation(loadCharPanel.animationTime, {
			index = 2,
			target = {backgroundFraction = 0},
			easing = "outQuint"
		})
	end
end

function PLUGIN:InitializedPlugins()
	ix.char.vars["model"].OnDisplay = function(self, container, payload)
		local modelListCanvas = container:Add("DScrollPanel")
		modelListCanvas:Dock(TOP)
		modelListCanvas:SetTall(128)

		container.modelList = modelListCanvas:Add("DIconLayout")
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
		modelListCanvas.VBar.btnGrip.Paint = function(this, width, height)
			local parent = this:GetParent()
			local upButtonHeight = parent.btnUp:GetTall()
			local downButtonHeight = parent.btnDown:GetTall()

			DisableClipping(true)
				surface.SetDrawColor(color_white:Unpack())
				surface.DrawRect(4, -upButtonHeight, width - 8, height + upButtonHeight + downButtonHeight)
			DisableClipping(false)
		end

		container.modelList:UpdateModels(payload)

		return modelListCanvas
	end
end
