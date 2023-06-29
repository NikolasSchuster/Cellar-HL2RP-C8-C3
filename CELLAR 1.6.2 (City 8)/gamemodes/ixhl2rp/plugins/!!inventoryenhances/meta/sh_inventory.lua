MAX_EQUIPMENT_SLOTS = 16

EQUIP_HEAD = 1
EQUIP_EYE = 2
EQUIP_EARS = 3
EQUIP_MASK = 4
EQUIP_TORSO = 5
EQUIP_HANDS = 6
EQUIP_LEGS = 7
EQUIP_BACK = 8
EQUIP_CID = 9
EQUIP_RADIO = 10
EQUIP_LHAND = 11
EQUIP_RHAND = 12
EQUIP_RESERVED1 = 13
EQUIP_RESERVED2 = 14
EQUIP_RESERVED3 = 15
EQUIP_RESERVED4 = 16

local META = ix.meta.inventory

function META:GetItemAtSlot(slot)
	if self.vars.isEquipment then
		return (self.slots[1] or {})[slot]
	end
end

function META:CanItemFit(x, y, w, h, item2)
	if self.vars.isEquipment then
		local item = (self.slots[x] or {})[y]
		local can = (!item and true or (item.id == item2.id))

		if (hook.Run("CanTransferEquipment", item2, self, self, y) == false) then
			return false
		end

		return can
	end

	local canFit = true

	for x2 = 0, w - 1 do
		for y2 = 0, h - 1 do
			local item = (self.slots[x + x2] or {})[y + y2]

			if ((x + x2) > self.w or item) then
				if (item2) then
					if (item and item.id == item2.id) then
						continue
					end
				end

				canFit = false
				break
			end
		end

		if (!canFit) then
			break
		end
	end

	return canFit
end

if SERVER then
	function META:Add(uniqueID, quantity, data, x, y, noReplication)
		x = self.vars.isEquipment and 1 or x
		quantity = quantity or 1

		if (quantity < 1) then
			return false, "noOwner"
		end

		if (!isnumber(uniqueID) and quantity > 1) then
			for _ = 1, quantity do
				local bSuccess, error = self:Add(uniqueID, 1, data)

				if (!bSuccess) then
					return false, error
				end
			end

			return true
		end

		local client = self.GetOwner and self:GetOwner() or nil
		local item = isnumber(uniqueID) and ix.item.instances[uniqueID] or ix.item.list[uniqueID]
		local targetInv = self
		local bagInv

		if (!item) then
			return false, "invalidItem"
		end

		if (isnumber(uniqueID)) then
			local oldInvID = item.invID

			if (!x and !y) then
				x, y, bagInv = self:FindEmptySlot(item.width, item.height)
			end

			if (bagInv) then
				targetInv = bagInv
			end

			-- we need to check for owner since the item instance already exists
			if (!item.bAllowMultiCharacterInteraction and IsValid(client) and client:GetCharacter() and
				item:GetPlayerID() == client:SteamID64() and item:GetCharacterID() != client:GetCharacter():GetID()) then
				return false, "itemOwned"
			end

			if (hook.Run("CanTransferItem", item, ix.item.inventories[0], targetInv) == false) then
				return false, "notAllowed"
			end

			if (x and y) then
				if targetInv.vars.isEquipment then
					targetInv.slots[1] = targetInv.slots[1] or {}
					targetInv.slots[1][y] = item
				else
					targetInv.slots[x] = targetInv.slots[x] or {}
					targetInv.slots[x][y] = true
				end

				item.gridX = x
				item.gridY = y
				item.invID = targetInv:GetID()

				if !targetInv.vars.isEquipment then
					for x2 = 0, item.width - 1 do
						local index = x + x2

						for y2 = 0, item.height - 1 do
							targetInv.slots[index] = targetInv.slots[index] or {}
							targetInv.slots[index][y + y2] = item
						end
					end
				end

				if (!noReplication) then
					targetInv:SendSlot(x, y, item)
				end

				if (!self.noSave) then
					local query = mysql:Update("ix_items")
						query:Update("inventory_id", targetInv:GetID())
						query:Update("x", x)
						query:Update("y", y)
						query:Where("item_id", item.id)
					query:Execute()
				end

				hook.Run("InventoryItemAdded", ix.item.inventories[oldInvID], targetInv, item)

				return x, y, targetInv:GetID()
			else
				return false, "noFit"
			end
		else
			if (!x and !y) then
				x, y, bagInv = self:FindEmptySlot(item.width, item.height)
			end

			if (bagInv) then
				targetInv = bagInv
			end

			if (hook.Run("CanTransferItem", item, ix.item.inventories[0], targetInv) == false) then
				return false, "notAllowed"
			end

			if (x and y) then
				if !targetInv.vars.isEquipment then
					for x2 = 0, item.width - 1 do
						local index = x + x2

						for y2 = 0, item.height - 1 do
							targetInv.slots[index] = targetInv.slots[index] or {}
							targetInv.slots[index][y + y2] = true
						end
					end
				else
					targetInv.slots[1] = targetInv.slots[1] or {}
					targetInv.slots[1][y] = true
				end

				local characterID
				local playerID

				if (self.owner) then
					local character = ix.char.loaded[self.owner]

					if (character) then
						characterID = character.id
						playerID = character.steamID
					end
				end

				ix.item.Instance(targetInv:GetID(), uniqueID, data, x, y, function(newItem)
					newItem.gridX = x
					newItem.gridY = y

					if !targetInv.vars.isEquipment then
						for x2 = 0, newItem.width - 1 do
							local index = x + x2

							for y2 = 0, newItem.height - 1 do
								targetInv.slots[index] = targetInv.slots[index] or {}
								targetInv.slots[index][y + y2] = newItem
							end
						end
					else
						targetInv.slots[1] = targetInv.slots[1] or {}
						targetInv.slots[1][y] = newItem
					end

					if (!noReplication) then
						targetInv:SendSlot(x, y, newItem)
					end

					hook.Run("InventoryItemAdded", nil, targetInv, newItem)
				end, characterID, playerID)

				return x, y, targetInv:GetID()
			else
				return false, "noFit"
			end
		end
	end
end

local ITEM = ix.meta.item

function ITEM:Transfer(invID, x, y, client, noReplication, isLogical)
	invID = invID or 0

	if (self.invID == invID) then
		return false, "same inv"
	end

	local inventory = ix.item.inventories[invID]
	local curInv = ix.item.inventories[self.invID or 0]

	if (curInv and !IsValid(client)) then
		client = curInv.GetOwner and curInv:GetOwner() or nil
	end

	-- check if this item doesn't belong to another one of this player's characters
	local itemPlayerID = self:GetPlayerID()
	local itemCharacterID = self:GetCharacterID()

	if (!self.bAllowMultiCharacterInteraction and IsValid(client) and client:GetCharacter()) then
		local playerID = client:SteamID64()
		local characterID = client:GetCharacter():GetID()

		if (itemPlayerID and itemCharacterID) then
			if (itemPlayerID == playerID and itemCharacterID != characterID) then
				return false, "itemOwned"
			end
		else
			self.characterID = characterID
			self.playerID = playerID

			local query = mysql:Update("ix_items")
				query:Update("character_id", characterID)
				query:Update("player_id", playerID)
				query:Where("item_id", self:GetID())
			query:Execute()
		end
	end

	if (hook.Run("CanTransferItem", self, curInv, inventory) == false) then
		return false, "notAllowed"
	end

	if invID and invID > 0 and inventory and inventory.vars.isEquipment then
		local a, b = hook.Run("CanTransferEquipment", self, curInv, inventory, y)
		
		if (a == false) then
			return false, b
		end
	end

	local authorized = false

	if (inventory and inventory.OnAuthorizeTransfer and inventory:OnAuthorizeTransfer(client, curInv, self)) then
		authorized = true
	end

	if (!authorized and self.CanTransfer and self:CanTransfer(curInv, inventory) == false) then
		return false, "notAllowed"
	end

	if (curInv) then
		if (invID and invID > 0 and inventory) then
			local targetInv = inventory
			local bagInv

			if (!x and !y) then
				x, y, bagInv = inventory:FindEmptySlot(self.width, self.height)
			end

			if (bagInv) then
				targetInv = bagInv
			end

			if (!x or !y) then
				return false, "noFit"
			end

			local prevID = self.invID
			local status, result = targetInv:Add(self.id, nil, nil, x, y, noReplication)

			if (status) then
				if (self.invID > 0 and prevID != 0) then
					-- we are transferring this item from one inventory to another
					curInv:Remove(self.id, false, true, true)
					self.invID = invID

					if (self.OnTransferred) then
						self:OnTransferred(curInv, inventory)
					end

					hook.Run("OnItemTransferred", self, curInv, inventory)
					return true
				elseif (self.invID > 0 and prevID == 0) then
					-- we are transferring this item from the world to an inventory
					ix.item.inventories[0][self.id] = nil

					if (self.OnTransferred) then
						self:OnTransferred(curInv, inventory)
					end

					hook.Run("OnItemTransferred", self, curInv, inventory)
					return true
				end
			else
				return false, result
			end
		elseif (IsValid(client)) then
			-- we are transferring this item from an inventory to the world
			self.invID = 0
			curInv:Remove(self.id, false, true)

			local query = mysql:Update("ix_items")
				query:Update("inventory_id", 0)
				query:Where("item_id", self.id)
			query:Execute()

			inventory = ix.item.inventories[0]
			inventory[self:GetID()] = self

			if (self.OnTransferred) then
				self:OnTransferred(curInv, inventory)
			end

			hook.Run("OnItemTransferred", self, curInv, inventory)

			if (!isLogical) then
				return self:Spawn(client)
			end

			return true
		else
			return false, "noOwner"
		end
	else
		return false, "invalidInventory"
	end
end