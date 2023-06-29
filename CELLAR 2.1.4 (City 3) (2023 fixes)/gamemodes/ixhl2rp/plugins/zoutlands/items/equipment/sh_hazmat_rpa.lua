ITEM.name = "Защитная униформа ФПА"
ITEM.description = "Комбинезон из жесткой резины темно-зелёного цвета, торс и грудь до ног защищает свинцовый фартук. Из обуви берцы. Униформа создана для экстремальных условий, функции которой включает диэлектрический эффект и огнеупорность. В таком костюме эффект от радиации в разы ниже обычной гражданской. Комплект включает ГП-9 с лицевой частью МАГ-3Л."
ITEM.model = "models/props_c17/SuitCase001a.mdl"
ITEM.slot = EQUIP_TORSO
ITEM.isOutfit = true
ITEM.width = 2
ITEM.height = 2
ITEM.CanBreakDown = false
ITEM.genderReplacement = {
	[GENDER_MALE] = "models/vintagethief/hazmat_worker.mdl",
	[GENDER_FEMALE] = "models/vintagethief/hazmat_worker.mdl"
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 2,
	[HITGROUP_CHEST] = 5,
	[HITGROUP_STOMACH] = 5,
	[4] = 3, -- hands
	[5] = 3, -- legs
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
