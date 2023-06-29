ITEM.base = "base_equipment"
ITEM.name = "Base Outfit OTA"
ITEM.description = ""
ITEM.model = "models/props_c17/SuitCase001a.mdl"
ITEM.slot = EQUIP_TORSO
ITEM.isOutfit = true
ITEM.width = 2
ITEM.height = 2
ITEM.CanBreakDown = false
ITEM.ReplaceOnDeath = "Рубаха с бронежилетом ОТА"

ITEM.primaryVisor = Vector(0, 0, 0)
ITEM.secondaryVisor = Vector(0, 0, 0)

if CLIENT then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end

	local stats = {
		[HITGROUP_GENERIC] = "к защите",
		[HITGROUP_HEAD] = "к защите головы",
		[HITGROUP_CHEST] = "к защите торса",
		[HITGROUP_STOMACH] = "к защите паха",
		[4] = "к защите рук", -- hands
		[5] = "к защите ног", -- legs
	}
	local greenClr = Color(50, 200, 50)

	function ITEM:PopulateTooltip(tooltip)
		local uses = tooltip:AddRowAfter("rarity", "wear")
		uses:SetText(L("wearSlot", L("slot"..self.slot)))

		if self.RadResist then
			local s = tooltip:AddRow("radresist")
			s:SetTextColor(greenClr)
		    s:SetText(string.format("+%i%% к сопротивлению радиации", self.RadResist))
			s:SizeToContents()
		end

		for i, v in ipairs(self.Stats) do
			if v == 0 then continue end

			local s = tooltip:AddRow("stat"..i)
			s:SetTextColor(greenClr)
		    s:SetText(string.format("+%i %s", v, stats[i]))
			s:SizeToContents()
		end
	end
end

function ITEM:OnItemEquipped(client)
	client:SetPrimaryVisorColor(self.primaryVisor)
	client:SetSecondaryVisorColor(self.secondaryVisor)
end

function ITEM:OnItemUnequipped(client) 
	client:SetPrimaryVisorColor(Vector(0, 0, 0))
	client:SetSecondaryVisorColor(Vector(0, 0, 0))
end