
ITEM.name = "Radio Base"
ITEM.description = "A shiny handheld radio with a frequency tuner."
ITEM.model = "models/cellar/items/handheld_radio.mdl"
ITEM.category = "Коммуникация"
ITEM.isEquipment = true
ITEM.slot = EQUIP_RADIO
ITEM.business = false
ITEM.frequency = "main"
ITEM.frequencyID = "freq_main"
--ITEM.frequencySound = "npc/overwatch/radiovoice/off2.wav"
--ITEM.frequencyColor = Color(200, 0, 0)
--ITEM.frequencyPriority = 4
--ITEM.stationaryCanAccess = true
--ITEM.factionLock = nil

-- Inventory drawing
if (CLIENT) then
	function ITEM:PaintOver(item, width, height)
		if (item:GetData("on")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(width - 14, height - 14, 8, 8)
		end
	end

	function ITEM:PopulateTooltip(tooltip)
		local panel = tooltip:AddRowAfter("rarity", "frequency")
		panel:SetBackgroundColor(derma.GetColor(self:GetData("on", false) and "Success" or "Error", tooltip))
		panel:SetText("Frequency: " .. self:GetFrequency())
		panel:SizeToContents()
	end
end

function ITEM:GetFrequency()
	return self.frequency
end

function ITEM:GetFrequencyID()
	return self.frequencyID
end

function ITEM:IsOn()
	return self:GetData("on", false) == true
end

ITEM.functions.Toggle = {
	OnCanRun = function(item)
		return IsValid(item.player) and !IsValid(item.entity) and !item.player:IsRestricted() and
			(!item.factionLock or item.factionLock[item.player:Team()]) == true
	end,

	OnRun = function(item)
		item:SetData("on", !item:GetData("on", false))
		ix.radio:SetPlayerChannels(item.player)

		return false
	end
}

function ITEM:OnTransferred(lastInventory, inventory)
	self:SetData("on", false)

	local client = lastInventory.GetOwner and lastInventory:GetOwner()

	if (IsValid(client)) then
		ix.radio:SetPlayerChannels(client)
	end
end

ITEM:Hook("drop", function(item)
	item:SetData("on", false)
	ix.radio:SetPlayerChannels(item.player)
end)
