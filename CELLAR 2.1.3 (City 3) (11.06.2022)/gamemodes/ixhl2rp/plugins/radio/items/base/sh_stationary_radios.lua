
ITEM.name = "Stationary Radio Base"
ITEM.description = "An antique radio, do you think this'll still work?"
ITEM.model = "models/props_lab/citizenradio.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.category = "Communication"
ITEM.business = false
ITEM.tuningEnabled = false
ITEM.frequencyID = "freq_0000"

ITEM:Hook("drop", function(item)
	local radio = ents.Create("ix_stationary_radio")
	radio:SetRadioItem(item.uniqueID)
	radio:SetModel(item.model)
	radio:SetPos(item.player:GetItemDropPos(radio))
	radio:Spawn()

	radio:SetFrequency(item.frequencyID)
	radio:SetChannelTuningEnabled(item.tuningEnabled)

	item.player:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav", 75, math.random(90, 120), 1)
	return true
end)