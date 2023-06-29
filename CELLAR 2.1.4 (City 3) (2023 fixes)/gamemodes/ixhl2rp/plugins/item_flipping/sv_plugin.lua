
util.AddNetworkString("ixInventoryFlipItem")

do
	local ITEM = ix.meta.item

	local function CanRemainOnSamePos(inventory, x, y, w, h)
		local bCanRemain = true

		for x2 = 0, w - 1 do
			for y2 = 0, h - 1 do
				local item = (inventory.slots[x + x2] or {})[y + y2]

				if ((x + x2) > inventory.w or (y + y2) > inventory.h or item) then
					bCanRemain = false

					break
				end
			end

			if (!bCanRemain) then
				break
			end
		end

		return bCanRemain
	end

	function ITEM:Flip(bNoReplication, bNoSave)
		local failureMessage

		if (self.width != self.height) then
			local inventory = ix.item.inventories[self.invID]

			if (self.invID > 0 and inventory) then
				failureMessage = "unknownError"
				local bSlotsBroken = false

				for x2 = self.gridX, self.gridX + (self.width - 1) do
					if (inventory.slots[x2]) then
						for y2 = self.gridY, self.gridY + (self.height - 1) do
							local slotItem = inventory.slots[x2][y2]

							if (slotItem and self.id == slotItem.id) then
								inventory.slots[x2][y2] = nil
							else
								bSlotsBroken = true
							end
						end
					end
				end

				if (!bSlotsBroken) then
					failureMessage = "noFit"
					local fWidth, fHeight = ix.item.RawFlip(self, true)
					local x, y = self.gridX, self.gridY
					local bCanItemFit = CanRemainOnSamePos(inventory, x, y, fWidth, fHeight)

					if (!bCanItemFit) then
						x, y = inventory:FindEmptySlot(fWidth, fHeight, true)
					end

					if (x and y) then
						local oldX, oldY = self.gridX, self.gridY

						inventory.slots[x] = inventory.slots[x] or {}
						inventory.slots[x][y] = true

						self.width = fWidth
						self.height = fHeight
						self.gridX = x
						self.gridY = y

						for x2 = 0, self.width - 1 do
							local index = x + x2

							for y2 = 0, self.height - 1 do
								inventory.slots[index] = inventory.slots[index] or {}
								inventory.slots[index][y + y2] = self
							end
						end

						self:SetData("flip", !self.data["flip"], nil, bNoSave)

						if (!bNoReplication) then
							local receivers = inventory:GetReceivers()

							if (!table.IsEmpty(receivers)) then
								net.Start("ixInventoryFlipItem")
									net.WriteUInt(inventory:GetID(), 32)
									net.WriteUInt(oldX, 6)
									net.WriteUInt(oldY, 6)
									net.WriteUInt(x, 6)
									net.WriteUInt(y, 6)
									net.WriteString(self.uniqueID)
									net.WriteUInt(self.id, 32)
									net.WriteUInt(inventory.owner or 0, 32)
								net.Send(receivers)
							end
						end

						if (!bNoSave) then
							local query = mysql:Update("ix_items")
								query:Update("x", x)
								query:Update("y", y)
								query:WhereNotEqual("x", x)
								query:WhereNotEqual("y", y)
								query:Where("item_id", self.id)
							query:Execute()
						end

						return true
					end
				end

				for x2 = self.gridX, self.gridX + (self.width - 1) do
					inventory.slots[x2] = inventory.slots[x2] or {}

					for y2 = self.gridY, self.gridY + (self.height - 1) do
						local slotItem = inventory.slots[x2][y2]

						if (!slotItem) then
							inventory.slots[x2][y2] = self
						end
					end
				end
			end
		end

		return false, failureMessage
	end
end

net.Receive("ixInventoryFlipItem", function(_, client)
	local realTime = RealTime()

	if ((client.ixNextItemFlip or 0) <= realTime) then
		local character = client:GetCharacter()

		if (character) then
			local itemID = net.ReadUInt(32)
			local invID = net.ReadUInt(32)
			local inventory = ix.item.inventories[invID]

			if (inventory and inventory:OnCheckAccess(client)) then
				local item = ix.item.instances[itemID]

				if (item and invID == item.invID) then
					local result, message = item:Flip()

					if (!result and message) then
						client:NotifyLocalized(message)
					end
				end
			end
		end

		client.ixNextItemFlip = realTime + 0.5
	end
end)

-- OVERRIDE --

-- swaping items instances width and height if they are flipped and thus making sure they're attached to correct inventory slots
ix.inventory = ix.inventory or {}

function ix.inventory.Restore(invID, width, height, callback)
	local inventories = {}

	if (!istable(invID)) then
		if (!isnumber(invID) or invID < 0) then
			error("Attempt to restore inventory with an invalid ID!")
		end

		inventories[invID] = {width, height}
		ix.inventory.Create(width, height, invID)
	else
		for k, v in pairs(invID) do
			inventories[k] = {v[1], v[2]}
			ix.inventory.Create(v[1], v[2], k)
		end
	end

	local query = mysql:Select("ix_items")
		query:Select("item_id")
		query:Select("inventory_id")
		query:Select("unique_id")
		query:Select("data")
		query:Select("character_id")
		query:Select("player_id")
		query:Select("x")
		query:Select("y")
		query:WhereIn("inventory_id", table.GetKeys(inventories))
		query:Callback(function(result)
			if (istable(result) and #result > 0) then
				local invSlots = {}

				for _, item in ipairs(result) do
					local itemInvID = tonumber(item.inventory_id)
					local invInfo = inventories[itemInvID]

					if (!itemInvID or !invInfo) then
						-- don't restore items with an invalid inventory id or type
						continue
					end

					local inventory = ix.item.inventories[itemInvID]
					local x, y = tonumber(item.x), tonumber(item.y)
					local itemID = tonumber(item.item_id)
					local data = util.JSONToTable(item.data or "[]")
					local characterID, playerID = tonumber(item.character_id), tostring(item.player_id)

					if (x and y and itemID) then
						if (x <= inventory.w and x > 0 and y <= inventory.h and y > 0) then
							local item2 = ix.item.New(item.unique_id, itemID)

							if (item2) then
								invSlots[itemInvID] = invSlots[itemInvID] or {}
								local slots = invSlots[itemInvID]

								item2.data = {}

								if (data) then
									item2.data = data

									if (item2.data["flip"]) then
										ix.item.RawFlip(item2)
									end
								end

								item2.gridX = x
								item2.gridY = y
								item2.invID = itemInvID
								item2.characterID = characterID
								item2.playerID = (playerID == "" or playerID == "NULL") and nil or playerID

								for x2 = 0, item2.width - 1 do
									for y2 = 0, item2.height - 1 do
										slots[x + x2] = slots[x + x2] or {}
										slots[x + x2][y + y2] = item2
									end
								end

								if (item2.OnRestored) then
									item2:OnRestored(item2, itemInvID)
								end
							end
						end
					end
				end

				for k, v in pairs(invSlots) do
					ix.item.inventories[k].slots = v
				end
			end

			if (callback) then
				for k, _ in pairs(inventories) do
					callback(ix.item.inventories[k])
				end
			end
		end)
	query:Execute()
end
