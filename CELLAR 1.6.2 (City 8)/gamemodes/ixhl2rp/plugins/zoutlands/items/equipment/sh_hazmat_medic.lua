ITEM.name = "Костюм химзащиты медика"
ITEM.description = "Костюм химзащиты синей окраски, предназначенный для медицинских нужд. В отличии от своего рабочего варианта, фильтрация в противогазе помогает избежать не только попадания неблагоприятных паров, но также и защитить от биологической угрозы. В подобном костюме очень душно и трудно дышать, но зато уверенность в том, что болезни не тронут вас остается очень высокой."
ITEM.model = "models/props_c17/SuitCase001a.mdl"
ITEM.slot = EQUIP_TORSO
ITEM.isOutfit = true
ITEM.width = 2
ITEM.height = 2
ITEM.CanBreakDown = false
ITEM.genderReplacement = {
	[GENDER_MALE] = "models/cellar/characters/hazmat/medic_male.mdl",
	[GENDER_FEMALE] = "models/cellar/characters/hazmat/medic_female.mdl"
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 3,
	[HITGROUP_CHEST] = 2,
	[HITGROUP_STOMACH] = 2,
	[4] = 2, -- hands
	[5] = 2, -- legs
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
