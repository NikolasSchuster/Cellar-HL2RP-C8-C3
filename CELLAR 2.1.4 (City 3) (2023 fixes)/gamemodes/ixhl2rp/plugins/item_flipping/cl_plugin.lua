
net.Receive("ixInventoryFlipItem", function()
	local invID = net.ReadUInt(32)
	local oldX, oldY = net.ReadUInt(6), net.ReadUInt(6)
	local x, y = net.ReadUInt(6), net.ReadUInt(6)
	local uniqueID = net.ReadString()
	local id = net.ReadUInt(32)
	local owner = net.ReadUInt(32)

	local character = owner != 0 and ix.char.loaded[owner] or LocalPlayer():GetCharacter()

	if (character) then
		local inventory = ix.item.inventories[invID]

		if (inventory) then
			local item = ix.item.New(uniqueID, id)

			if (inventory.slots[oldX]) then
				inventory.slots[oldX][oldY] = nil
			end

			ix.item.RawFlip(item)

			inventory.slots[x] = inventory.slots[x] or {}
			inventory.slots[x][y] = item

			invID = invID == LocalPlayer():GetCharacter():GetInventory():GetID() and 1 or invID

			local panel = ix.gui["inv" .. invID]

			if (IsValid(panel)) then
				local icon = panel:AddIcon(
					item:GetModel() or "models/props_junk/popcan01a.mdl", x, y, item.width, item.height, item:GetSkin()
				)

				if (IsValid(icon)) then
					icon:SetHelixTooltip(function(tooltip)
						ix.hud.PopulateItemTooltip(tooltip, item)
					end)

					icon.itemID = item.id
					panel.panels[item.id] = icon
				end
			end

			surface.PlaySound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav")
		end
	end
end)

-- OVERRIDE --

-- swapping items instances width and height if they should or should not be flipped on every inventory sync, e.g. character load
net.Receive("ixInventorySync", function()
	local slots = net.ReadTable()
	local id = net.ReadUInt(32)
	local w, h = net.ReadUInt(6), net.ReadUInt(6)
	local owner = net.ReadType()
	local vars = net.ReadTable()

	if (!LocalPlayer():GetCharacter()) then
		return
	end

	local character = owner and ix.char.loaded[owner]
	local inventory = ix.inventory.Create(w, h, id)
	inventory.slots = {}
	inventory.vars = vars

	local x, y

	for _, v in ipairs(slots) do
		x, y = v[1], v[2]

		inventory.slots[x] = inventory.slots[x] or {}

		local item = ix.item.New(v[3], v[4])

		item.data = {}
		if (v[5]) then
			item.data = v[5]

			ix.item.FixFlip(item)
		end

		item.invID = item.invID or id
		inventory.slots[x][y] = item
	end

	if (character) then
		inventory:SetOwner(character:GetID())
		character.vars.inv = character.vars.inv or {}

		for k, v in ipairs(character:GetInventory(true)) do
			if (v:GetID() == id) then
				character:GetInventory(true)[k] = inventory

				return
			end
		end

		table.insert(character.vars.inv, inventory)
	end
end)
