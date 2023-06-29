ITEM.name = "Equipment"
ITEM.description = "A Equipment Base."
ITEM.category = "Outfit"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.isEquipment = true
ITEM.slot = 0
ITEM.pacData = {}
ITEM.BreakDown = "mat_cloth"
ITEM.CanBreakDown = true
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 0,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0, -- hands
	[5] = 0, -- legs
}

--[[
-- This will change a player's skin after changing the model. Keep in mind it starts at 0.
ITEM.newSkin = 1
-- This will change a certain part of the model.
ITEM.replacements = {"group01", "group02"}
-- This will change the player's model completely.
ITEM.replacements = "models/manhack.mdl"
-- This will have multiple replacements.
ITEM.replacements = {
	{"male", "female"},
	{"group01", "group02"}
}

-- This will apply body groups.
ITEM.bodyGroups = {
	["blade"] = 1,
	["bladeblur"] = 1
}
]]--


-- Inventory drawing
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
		local uses = tooltip:AddRowAfter("rarity")
		uses:SetText(L("wearSlot", L("slot" .. self.slot)))

		for i, v in ipairs(self.Stats) do
			if v == 0 then continue end

			local s = tooltip:AddRow("stat" .. i)
			s:SetTextColor(greenClr)
			s:SetText(string.format("+%i %s", v, stats[i]))
			s:SizeToContents()
		end

		if (self.thermalIsolation) then
			local t = tooltip:AddRow("tempstat")
				t:SetTextColor(greenClr)
				t:SetText("Уровень термоизоляции: " .. self.thermalIsolation or 0)
				t:SizeToContents()
		end
	end
end

function ITEM:RemoveOutfit(client)
	client = client or self.player

	local character = client:GetCharacter()

	self:SetData("equip", false)

/*
	if (character:GetData("oldModel" .. self.slot)) then
		character:SetModel(character:GetData("oldModel" .. self.slot))
		character:SetData("oldModel" .. self.slot, nil)
	end

	if (self.newSkin) then
		if (character:GetData("oldSkin" .. self.slot)) then
			client:SetSkin(character:GetData("oldSkin" .. self.slot))
			character:SetData("oldSkin" .. self.slot, nil)
		else
			client:SetSkin(0)
		end
	end

	for k, _ in pairs(self.bodyGroups or {}) do
		local index = k
		if isstring(k) then
			index = client:FindBodygroupByName(k)
		end
		
		if (index > -1) then
			client:SetBodygroup(index, 0)

			local groups = character:GetData("groups", {})

			if (groups[index]) then
				groups[index] = nil
				character:SetData("groups", groups)
			end
		end
	end

	-- restore the original bodygroups
	local oldGroups = character:GetData("oldGroups" .. self.slot)
	if (oldGroups) then
		for k, v in pairs(oldGroups) do
			client:SetBodygroup(k, v)
		end

		character:SetData("groups", table.Copy(oldGroups))
		character:SetData("oldGroups" .. self.slot, nil)
	end*/

	if character.outfit then
		character.outfit:RemoveItem(self)

		local a, b = character.outfit:GetResult()
		character.outfit:UpdateModel(character:GetPlayer(), a, b)
	end

	if (self.attribBoosts) then
		for k, _ in pairs(self.attribBoosts) do
			character:RemoveBoost(self.uniqueID, k)
		end
	end

	for k, _ in pairs(self:GetData("outfitAttachments", {})) do
		self:RemoveAttachment(k, client)
	end

	self:OnItemUnequipped(client)
end

-- makes another outfit depend on this outfit in terms of requiring this item to be equipped in order to equip the attachment
-- also unequips the attachment if this item is dropped
function ITEM:AddAttachment(id)
	local attachments = self:GetData("outfitAttachments", {})
	attachments[id] = true

	self:SetData("outfitAttachments", attachments)
end

function ITEM:RemoveAttachment(id, client)
	local item = ix.item.instances[id]
	local attachments = self:GetData("outfitAttachments", {})

	if (item and attachments[id]) then
		item:OnDetached(client)
	end

	attachments[id] = nil
	self:SetData("outfitAttachments", attachments)
end

ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
		item:OnUnequipped(item:GetOwner())
	end
end)

ITEM.functions.Breakdown = {
	name = "Разорвать",
	--icon = "icon16/briefcase.png",
	OnRun = function(item)
		item.isBreaking = true

		local amount = istable(item.BreakDownAmount) and math.random(item.BreakDownAmount[1], item.BreakDownAmount[2]) or math.random(2, 4)

		for i = 1, amount do
			if !item.player:GetCharacter():GetInventory():Add(item.BreakDown) then
				ix.item.Spawn(item.BreakDown, item.player)
			end
		end

		item.player:EmitSound("physics/cardboard/cardboard_box_break"..math.random(1, 3)..".wav")
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item.CanBreakDown and item:GetData("equip") != true and !item.isBreaking
	end
}

function ITEM:CanEquip(client, slot)
	if (slot == EQUIP_HEAD) and (client:GetCharacter():HasWearedGasmask()) then
		return false
	end

	return IsValid(client) and self:GetData("equip") != true and self.slot == slot
end

function ITEM:CanUnequip(client, slot)
	return IsValid(client) and self:GetData("equip") == true
end

function ITEM:OnEquipped(client, slot)
	local char = client:GetCharacter()

	self:SetData("equip", true)
/*
	if (isfunction(self.OnGetReplacement)) then
		char:SetData("oldModel" .. self.slot, char:GetData("oldModel" .. self.slot, client:GetModel()))
		char:SetModel(self:OnGetReplacement())
	elseif (self.replacement or self.replacements) then
		char:SetData("oldModel" .. self.slot, char:GetData("oldModel" .. self.slot, client:GetModel()))

		if (istable(self.replacements)) then
			if (#self.replacements == 2 and isstring(self.replacements[1])) then
				char:SetModel(client:GetModel():gsub(self.replacements[1], self.replacements[2]))
			else
				for _, v in ipairs(self.replacements) do
					char:SetModel(client:GetModel():gsub(v[1], v[2]))
				end
			end
		else
			char:SetModel(self.replacement or self.replacements)
		end
	elseif (self.genderReplacement) then
		char:SetData("oldModel" .. self.slot, char:GetData("oldModel" .. self.slot, client:GetModel()))

		char:SetModel(self.genderReplacement[char:GetGender()] or self.genderReplacement[GENDER_MALE])
	end

	if (self.newSkin) then
		char:SetData("oldSkin" .. self.slot, client:GetSkin())
		client:SetSkin(self.newSkin)
	end

	local groups = {}
	local groupps = char:GetData("groups", {})

	for i = 0, (client:GetNumBodyGroups() - 1) do
		groups[i] = groupps[i] or 0
	end

	if (!table.IsEmpty(groups)) then
		char:SetData("oldGroups" .. self.slot, table.Copy(groups))

		--client:ResetBodygroups()
	end

	if (self.bodyGroups) then
		groups = {}

		for k, value in pairs(self.bodyGroups) do
			local index = k
			if isstring(k) then
				index = client:FindBodygroupByName(k)
			end

			if (index > -1) then
				groups[index] = value
			end
		end

		local newGroups = char:GetData("groups", {})

		for index, value in pairs(groups) do
			newGroups[index] = value
			client:SetBodygroup(index, value)
		end

		if (!table.IsEmpty(newGroups)) then
			char:SetData("groups", newGroups)
		end
	end
*/
	
	local model = false

	if isfunction(self.OnGetReplacement) then
		model = self:OnGetReplacement(client, client:GetModel())
	elseif (self.replacement or self.replacements) then
		if (istable(self.replacements)) then
			if (#self.replacements == 2 and isstring(self.replacements[1])) then
				model = client:GetModel():gsub(self.replacements[1], self.replacements[2])
			else
				for _, v in ipairs(self.replacements) do
					model = client:GetModel():gsub(v[1], v[2])
				end
			end
		else
			model = self.replacement or self.replacements
		end
	elseif (self.genderReplacement) then
		model = self.genderReplacement[char:GetGender()] or self.genderReplacement[GENDER_MALE]
	end

	if char.outfit then
		char.outfit:AddItem(self, model, self.bodyGroups)

		local a, b = char.outfit:GetResult()
		client.ChangeModel = false
		char.outfit:UpdateModel(char:GetPlayer(), a, b)
	end

	if (self.attribBoosts) then
		for k, v in pairs(self.attribBoosts) do
			char:AddBoost(self.uniqueID, k, v)
		end
	end

	client.ArmorItems = client.ArmorItems or {}
	client.ArmorItems[self] = true

	self:OnItemEquipped(client)
end

function ITEM:OnUnequipped(client, slot)
	self:RemoveOutfit(self:GetOwner() or client)

	client.ArmorItems = client.ArmorItems or {}
	client.ArmorItems[self] = nil
end

function ITEM:OnRemoved()
	if (self.invID != 0 and self:GetData("equip")) then
		self.player = self:GetOwner()
			self:RemoveOutfit(self.player)
		self.player = nil
	end
end

function ITEM:OnTransferred(curInv, inventory)
	if isfunction(curInv.GetOwner) then
		local owner = curInv:GetOwner()

		if IsValid(owner) and curInv.vars.isEquipment then
			self:OnUnequipped(owner)
		end
	end
end

function ITEM:OnItemEquipped() end
function ITEM:OnItemUnequipped() end