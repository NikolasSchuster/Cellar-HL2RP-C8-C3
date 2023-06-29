ITEM.base = "base_equipment"
ITEM.name = "Base Outfit MPF"
ITEM.description = ""
ITEM.model = "models/items/mpfequipment.mdl"
ITEM.slot = EQUIP_TORSO
ITEM.isOutfit = true
ITEM.width = 2
ITEM.height = 2
ITEM.ReplaceOnDeath = "Синяя рубаха с бронежилетом"
ITEM.CanBreakDown = false

ITEM.uniform = 0
ITEM.primaryVisor = Vector(0, 0, 0)
ITEM.secondaryVisor = Vector(0, 0, 0)
ITEM.specialization = nil

function ITEM:OnInstanced(invID, x, y, item)
	item:SetData("armband", 0)
end

local armbandRank = {
	[0] = "PU",
	[1] = "RL"

}

if (CLIENT) then
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

		local rank = tooltip:AddRowAfter("wear")
		rank:SetText(string.format("Ранг: %s", armbandRank[self:GetData("armband", 0)]))

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
	local armband = self:GetData("armband", 0)

	client:SetNWInt("sg_uniform", self.uniform)
	client:SetNWInt("sg_armband", armband)

	client:GetCharacter():SetData("heavy", true)

	client:SetPrimaryVisorColor(self.primaryVisor)
	client:SetSecondaryVisorColor(self.secondaryVisor)

	/*
	if client:Team() == FACTION_MPF then
		local name = client:GetName()
		local format = "(CCA%:.*%.).*(%.%d+)"
		local ranks = string.match(name, "CCA%:.*%.(.*)%.%d+") or string.match(name, "CCA%:.*%:(.*)%.%d+")
		local a = string.Explode(":", ranks)
		local spec = Schema:GetPlayerCombineSpec(client)

		ranks = string.Replace(ranks, a[1], armbandRank[armband])

		if a[2] then
			if !self.specialization then
				ranks = string.Replace(ranks, ":"..a[2], "")
			else
				ranks = string.Replace(ranks, a[2], a[2] or self.specialization)
			end
		else
			ranks = ranks..(self.specialization and (":"..self.specialization) or "")
		end

		local newName = string.gsub(name, format, "%1"..ranks.."%2")

		client:GetCharacter():SetVar("oldName", name, true)
		client:GetCharacter():SetName(newName)
	end
	*/
end

function ITEM:OnItemUnequipped(client)
	client:SetNWInt("sg_uniform", 0)
	client:SetNWInt("sg_armband", self:GetData("armband", 0))

	client:GetCharacter():SetData("heavy", false)

	client:SetPrimaryVisorColor(Vector(0, 0, 0))
	client:SetSecondaryVisorColor(Vector(0, 0, 0))
	/*
	if client:Team() == FACTION_MPF then
		client:GetCharacter():SetName(client:GetCharacter():GetVar("oldName") or client:GetName())
	end
	*/
end

function ITEM:OnGetReplacement(client, model)
	if self.genderReplacement then
		return self.genderReplacement[client:GetCharacter():GetGender()]
	end

	local gender = nil
	if string.find(model, "female") then
		gender = "female"
	elseif string.find(model, "male") then
		gender = "male"
	end

	if !gender then return "models/cellar/characters/city3/metropolice/male/cca_male_07.mdl" end

	local base = "models/cellar/characters/city3/metropolice/" .. gender .. "/"
	local elements = string.Explode("/", model)
	local mdl = string.Replace(elements[#elements], "c3", "cca")

	return base .. mdl
end