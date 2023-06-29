ITEM.name = "Доступ Сверхчеловеческого Надзора"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0, 0, 12),
	ang = Angle(90, 0, -45),
	fov = 45,
}
ITEM.access = {
	["DATAFILE_MEDIUM"] = true,
	["cmb*"] = true,
	["BROADCAST"] = true,
}
ITEM.model = Model("models/vintagethief/cellarproject/cid_card.mdl")
ITEM.description = ""
ITEM.isEquipment = true
ITEM.slot = 9 --EQUIP_CID
ITEM.category = "categoryCard"
ITEM.rarity = 3
ITEM.KeepOnDeath = true
ITEM.KeepOnCrit = true

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

function ITEM:CanEquip(client, slot)
	return IsValid(client) and client:IsOTA() and self:GetData("equip") != true and self.slot == slot
end

function ITEM:CanUnequip(client, slot)
	return IsValid(client) and self:GetData("equip") == true
end

function ITEM:OnEquipped(client, slot)
	self:SetData("equip", true)
end

function ITEM:OnUnequipped(client, slot)
	self:SetData("equip", false)
end

function ITEM:OnInstanced(invID, x, y, item)
	local inventory = ix.item.inventories[invID]

	if (inventory and inventory.owner) then
		local character = ix.char.loaded[inventory.owner]

		if (character) then
			item:SetData("name", Schema:ZeroNumber(math.random(1, 999999), 6))
			item:SetData("cid", Schema:ZeroNumber(math.random(1, 999), 3))
			item:SetData("number", string.format("%s-%d",
				string.gsub(math.random(100000000, 999999999), "^(%d%d%d)(%d%d%d%d)(%d%d)", "%1:%2:%3"),
				Schema:ZeroNumber(math.random(1, 99), 2)
			))
		end
	end

	item:SetData("access", self.access or {})
end

ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
		item:OnUnequipped(item:GetOwner())
	end
end)

function ITEM:OnTransferred(curInv, inventory)
	if isfunction(curInv.GetOwner) then
		local owner = curInv:GetOwner()

		if IsValid(owner) and curInv.vars.isEquipment then
			self:OnUnequipped(owner)
		end
	end
end
