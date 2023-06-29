ITEM.name = "Защитный костюм химзащиты"
ITEM.description = "Старый военный костюм химзащиты. В комплекте идёт противогаз с возможностью подключения системы замкнутого дыхания, а также очень склизкие сапоги, которые довольно сильно сжимают вашу стопу, но при этом всем отлично защищают от попадания разного рода химикатов."
ITEM.model = "models/props_c17/SuitCase001a.mdl"
ITEM.slot = EQUIP_TORSO
ITEM.isOutfit = true
ITEM.width = 2
ITEM.height = 2
ITEM.CanBreakDown = false
ITEM.genderReplacement = {
	[GENDER_MALE] = "models/vintagethief/hazmat_armor.mdl",
	[GENDER_FEMALE] = "models/vintagethief/hazmat_armor.mdl"
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 3,
	[HITGROUP_CHEST] = 10,
	[HITGROUP_STOMACH] = 5,
	[4] = 5, -- hands
	[5] = 5, -- legs
}
ITEM.RadResist = 99.75
ITEM.rarity = 2

if CLIENT then
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
