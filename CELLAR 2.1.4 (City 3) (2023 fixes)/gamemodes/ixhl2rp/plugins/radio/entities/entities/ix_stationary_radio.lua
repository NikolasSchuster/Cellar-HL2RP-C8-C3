
local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.Author = "`impulse"
ENT.PrintName = "Stationary Radio"
ENT.Description = "A stationary radio, it has a frequency tuner on it."
ENT.Spawnable = false
ENT.AdminSpawnable = true
ENT.bNoPersist = true

if (SERVER) then
	function ENT:Initialize()
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetSolid(SOLID_VPHYSICS)

		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
			physicsObject:EnableMotion(true)
		end

		self.nextUse = 0
	end

	function ENT:SetOn(bOn)
		self:SetNetVar("on", bOn)
	end

	function ENT:SetFrequency(frequency)
		self:SetNetVar("freq", frequency)
	end

	function ENT:SetChannelTuningEnabled(bEnabled)
		self:SetNetVar("tuningEnabled", bEnabled)
	end

	-- sets the item class to use for info like name/description - should only be string
	function ENT:SetRadioItem(item)
		self:SetNetVar("item", item)
	end

	function ENT:OnSelectToggle(client)
		if (CurTime() < self.nextUse) then
			return
		end

		self:SetOn(!self:IsOn())
	end

	function ENT:OnSelectSetFrequency(client, frequency)
		local channelTable = ix.radio:FindByID(frequency)

		if (channelTable) then
			if (channelTable.stationaryCanAccess) then
				self:SetFrequency(channelTable.uniqueID)

				client:Notify("You have set this stationary radio's channel to "..channelTable.name..".")
			else
				client:Notify("This stationary radio cannot tune in on that channel!")
			end
		elseif (self:GetChannelTuningEnabled() and string.find(frequency, "^%d%d%d%.%d$")) then
			local first = string.match(frequency, "(%d)%d%d%.%d")

			if (first != "0") then
				local freqID = "freq_" .. string.gsub(frequency, "%p", "")

				channelTable = ix.radio:FindByID(freqID)

				if (!channelTable) then
					PLUGIN:CreateItemChannel("freq " .. frequency, freqID, nil, true)
				end

				netstream.Start(nil, "ixCreateItemRadioChannel", "freq " .. frequency, freqID)
				self:SetFrequency(freqID)

				client:Notify("You have set this stationary radio's frequency to " .. frequency .. ".")
			else
				client:Notify("The frequency must be between 100.0 and 999.9!")
			end
		else
			client:Notify("The radio frequency must look like xxx.x!")
		end
	end
else
	local glowMaterial = Material("sprites/light_glow02_add")

	ENT.PopulateEntityInfo = true

	function ENT:GetEntityMenu()
		local options = {
			["Toggle"] = true,
		}

		if (self:GetChannelTuningEnabled()) then
			options["Set Frequency"] = function()
				-- we'll manually network it because we want to send custom data over
				Derma_StringRequest("Set Frequency", "Please enter the frequency of this radio.", "", function(text)
					ix.menu.NetworkChoice(self, "Set Frequency", text)
				end)

				return false
			end
		end

		return options
	end

	function ENT:OnPopulateEntityInfo(tooltip)
		local item = ix.item.list[self:GetRadioItem()]

		if (!item) then
			return
		end

		ix.hud.PopulateItemTooltip(tooltip, item)

		local color = derma.GetColor(self:IsOn() and "Success" or "Error", tooltip)
		tooltip:SetArrowColor(color)

		local name = tooltip:GetRow("name")
		name:SetBackgroundColor(color)

		local channelTable = ix.radio:FindByID(self:GetFrequency())
		local freq = tooltip:AddRowAfter("name")
		freq:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		freq:SetText("Frequency: " .. (channelTable and channelTable.name or "none"))
		freq:SizeToContents()
	end

	function ENT:Draw()
		self:DrawModel()

		local color = self:GetColor()
		local glowColor = Color(0, 255, 0, color.a)
		local position = self:GetPos()
		local forward = self:GetForward() * 9
		local right = self:GetRight() * 5
		local up = self:GetUp() * 8

		if (!self:IsOn()) then
			glowColor = Color(255, 0, 0, color.a)
		end

		if (self:GetModel() == "models/props_office/office_phone.mdl") then
			forward = self:GetForward() * -1
			right = self:GetRight() * 0
			up = self:GetUp() * 1
		end

		render.SetMaterial(glowMaterial)
		render.DrawSprite(position + forward + right + up, 8, 8, glowColor)
	end
end

function ENT:IsOn()
	return self:GetNetVar("on", false)
end

function ENT:GetFrequency(frequency)
	return self:GetNetVar("freq")
end

function ENT:GetChannelTuningEnabled()
	return self:GetNetVar("tuningEnabled")
end

function ENT:GetRadioItem()
	return self:GetNetVar("item")
end