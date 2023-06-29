util.AddNetworkString("ixInventoryDragCombine")
util.AddNetworkString("ixInventoryCombineAction")
util.AddNetworkString("ixInventorySplitAction")

function ix.item.PerformInventoryCombineAction(client, action, item, targetItem, invID, data)
	local character = client:GetCharacter()

	if (!character) then
		return
	end

	local inventory = ix.item.inventories[invID or 0]

	if (!inventory:OnCheckAccess(client) or !inventory:GetItemByID(item)) then
		return
	end

	item = ix.item.instances[item]
	targetItem = ix.item.instances[targetItem]

	if (!item or !targetItem) then
		return
	end

	local targetInventory = ix.item.inventories[targetItem.invID or 0]

	if (!targetInventory:OnCheckAccess(client) or !targetInventory:GetItemByID(targetItem.id)) then
		return
	end

	if (hook.Run("CanPlayerCombineItem", client, item, targetItem) == false) then
		return
	end

	item.player = client
	targetItem.player = client

	if !action then
		if (item.Combine) then
			item:Combine(targetItem)
		end

		item.player = nil
		targetItem.player = nil

		return
	else
		local callback = (item.combine or {})[action]

		if (callback) then
			if (callback.OnCanRun and callback.OnCanRun(item, targetItem, data) == false) then
				item.player = nil
				targetItem.player = nil

				return
			end

			--hook.Run("PlayerInteractItem", client, action, item)

			local result

			--if (item.hooks[action]) then
			--	result = item.hooks[action](item, data)
			--end

			result = callback.OnRun(item, targetItem, data)

			--if (item.postHooks[action]) then
				-- Posthooks shouldn't override the result from OnRun
				--item.postHooks[action](item, result, data)
			--end

			if (result != false) then
				item:Remove()
			end

			item.player = nil
			targetItem.player = nil

			return result != false
		end
	end
end

net.Receive("ixInventoryDragCombine", function(length, client)
	ix.item.PerformInventoryCombineAction(client, nil, net.ReadUInt(32), net.ReadUInt(32), net.ReadUInt(32))
end)

net.Receive("ixInventoryCombineAction", function(length, client)
	ix.item.PerformInventoryCombineAction(client, net.ReadString(), net.ReadUInt(32), net.ReadUInt(32), net.ReadUInt(32), net.ReadTable())
end)

function ix.item.PerformSplit(self, invID, x, y, client)
	invID = invID or 0

	if (self.invID == invID) then
		return false, "same inv"
	end

	local inventory = ix.item.inventories[invID]
	local curInv = ix.item.inventories[self.invID or 0]

	if (curInv and !IsValid(client)) then
		client = curInv.GetOwner and curInv:GetOwner() or nil
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
			local status, result --=  create split item

			if (status) then
				if (self.invID > 0 and prevID != 0) then
					if (self.OnSplit) then
						self:OnSplit(curInv, inventory)
					end

					hook.Run("OnItemSplit", self, curInv, inventory)
					return true
				end
			else
				return false, result
			end
		elseif (IsValid(client)) then
			if (self.OnSplit) then
				self:OnSplit(curInv, inventory)
			end

			hook.Run("OnItemSplit", self, curInv, inventory)

			-- create split entity

			return true
		else
			return false, "noOwner"
		end
	else
		return false, "invalidInventory"
	end
end

net.Receive("ixInventorySplitAction", function(length, client)
	local oldX, oldY, x, y = net.ReadUInt(6), net.ReadUInt(6), net.ReadUInt(6), net.ReadUInt(6)
	local invID, newInvID = net.ReadUInt(32), net.ReadUInt(32)

	local character = client:GetCharacter()

	if (character) then
		local inventory = ix.item.inventories[invID]

		if (!inventory or inventory == nil) then
			inventory:Sync(client)
		end

		if ((!inventory.owner or (inventory.owner and inventory.owner == character:GetID())) or
			inventory:OnCheckAccess(client)) then
			local item = inventory:GetItemAt(oldX, oldY)

			if (item) then
				if (newInvID and invID != newInvID) then
					local inventory2 = ix.item.inventories[newInvID]

					if (inventory2) then
						local bStatus, error --= Split to another inv 
						--item:Transfer(newInvID, x, y, client)

						if (!bStatus) then
							client:NotifyLocalized(error or "unknownError")
						end
					end

					return
				end

				if (inventory:CanItemFit(x, y, item.width, item.height, item)) then
					-- split to this inv
				end
			end
		end
	end
end)

local function NetworkInventoryMove(receiver, invID, itemID, oldX, oldY, x, y)
	net.Start("ixInventoryMove")
		net.WriteUInt(invID, 32)
		net.WriteUInt(itemID, 32)
		net.WriteUInt(oldX, 6)
		net.WriteUInt(oldY, 6)
		net.WriteUInt(x, 6)
		net.WriteUInt(y, 6)
	net.Send(receiver)
end

net.Receive("ixInventoryMove", function(length, client)
	local oldX, oldY, x, y = net.ReadUInt(6), net.ReadUInt(6), net.ReadUInt(6), net.ReadUInt(6)
	local invID, newInvID = net.ReadUInt(32), net.ReadUInt(32)

	local character = client:GetCharacter()


	if (character) then
		local inventory = ix.item.inventories[invID]

		if (!inventory or inventory == nil) then
			inventory:Sync(client)
		end

		if ((!inventory.owner or (inventory.owner and inventory.owner == character:GetID())) or
			inventory:OnCheckAccess(client)) then
			local item = inventory:GetItemAt(oldX, oldY)

			if (item) then
				if (newInvID and invID != newInvID) then
					local inventory2 = ix.item.inventories[newInvID]

					if (inventory2) then
						local bStatus, error = item:Transfer(newInvID, x, y, client)

						if (!bStatus) then
							NetworkInventoryMove(
								client, item.invID, item:GetID(), item.gridX, item.gridY, item.gridX, item.gridY
							)

							client:NotifyLocalized(error or "unknownError")
						end
					end

					return
				end

				if (inventory:CanItemFit(x, y, item.width, item.height, item)) then
					item.gridX = x
					item.gridY = y

					if inventory.vars.isEquipment then
						inventory.slots[1][oldY] = nil
						inventory.slots[1][y] = item
					else
						for x2 = 0, item.width - 1 do
							for y2 = 0, item.height - 1 do
								local previousX = inventory.slots[oldX + x2]

								if (previousX) then
									previousX[oldY + y2] = nil
								end
							end
						end

						for x2 = 0, item.width - 1 do
							for y2 = 0, item.height - 1 do
								inventory.slots[x + x2] = inventory.slots[x + x2] or {}
								inventory.slots[x + x2][y + y2] = item
							end
						end
					end

					local receivers = inventory:GetReceivers()

					if (istable(receivers)) then
						local filtered = {}

						for _, v in ipairs(receivers) do
							if (v != client) then
								filtered[#filtered + 1] = v
							end
						end

						if (#filtered > 0) then
							NetworkInventoryMove(
								filtered, invID, item:GetID(), oldX, oldY, x, y
							)
						end
					end

					if (!inventory.noSave) then
						local query = mysql:Update("ix_items")
							query:Update("x", x)
							query:Update("y", y)
							query:Where("item_id", item.id)
						query:Execute()
					end
				else
					NetworkInventoryMove(
						client, item.invID, item:GetID(), item.gridX, item.gridY, item.gridX, item.gridY
					)
				end
			end
		else
			local item = inventory:GetItemAt(oldX, oldY)

			if (item) then
				NetworkInventoryMove(
					client, item.invID, item.invID, item:GetID(), item.gridX, item.gridY, item.gridX, item.gridY
				)
			end
		end
	end
end)

local LAYER = {}
LAYER.__index = LAYER

LAYER.item = false
LAYER.model = false
LAYER.bodygroups = {}

function LAYER:__tostring()
	return "LAYER"
end

local OUTFIT = {}
OUTFIT.__index = OUTFIT

function OUTFIT:__tostring()
	return "OUTFIT"
end

function OUTFIT:Init(client)
	self.items = {}
	self.layers = {}
	self.client = client

	local base = setmetatable({}, LAYER)
	base.item = false
	base.model = client:GetCharacter():GetModel()
	base.bodygroups = {}

	for i = 0, (client:GetNumBodyGroups() - 1) do
		base.bodygroups[i] = 0
	end
/*
	local customBodygroups = client:GetCharacter():GetData("groups", {})

	for k, v in pairs(customBodygroups) do
		base.bodygroups[k] = v
	end
*/
	self.layers[1] = base
end

function OUTFIT:AddItem(item, mdl, bodygroups)
	local layer = setmetatable({}, LAYER)
	layer.item = item
	layer.model = mdl or false
	layer.bodygroups = table.Copy(bodygroups)

	table.insert(self.layers, layer)
end

function OUTFIT:RemoveItem(item)
	for k, v in ipairs(self.layers) do
		if k == 1 then continue end

		if v.item == item then
			table.remove(self.layers, k)
			break
		end
	end
end

function OUTFIT:GetResult()
	local max = 0
	for k, v in ipairs(self.layers) do
		if #v.bodygroups > max then
			max = #v.bodygroups
		end
	end
	local bodygroups = table.Copy(self.layers[1].bodygroups)
	while #bodygroups < max do
		table.insert(bodygroups, 0)
	end
	local model = self.client:GetCharacter():GetModel()

	for k, v in ipairs(self.layers) do
		if k == 1 then continue end

		for z, x in pairs(bodygroups) do
			bodygroups[z] = v.bodygroups[z] or x
		end

		model = v.model or model
	end

	return model, bodygroups
end

function OUTFIT:UpdateModel(client, model, bodygroups)
	if model and client:GetModel() != model then
		client:SetModel(model)
	end

	for k, v in pairs(bodygroups) do
		client:SetBodygroup(k, v)
	end
end

function PLUGIN:CharacterLoaded(character)
	local client = character:GetPlayer()
	local index = character:GetEquipID()

	if (index != 0) then
		local inventory = ix.item.inventories[index]

		if (inventory) then
			inventory.vars.isEquipment = true
			inventory:Sync(client)
			inventory:AddReceiver(client)
		else
			local owner = character:GetID()

			ix.inventory.Restore(index, 1, MAX_EQUIPMENT_SLOTS, function(inv)
				inv.vars.isEquipment = true
				inv:Sync(client)
				inv:AddReceiver(client)
			end)
		end
	else
		ix.inventory.New(character:GetID(), "equipment", function(inv)
			inv.vars.isEquipment = true
			inv:Sync(client)
			inv:AddReceiver(client)
			inv:SetOwner(character:GetID(), true)
			character:SetEquipID(inv:GetID())
		end)
	end

	if character.outfit then
		character.outfit = nil
	end

	character.outfit = setmetatable({}, OUTFIT)
	character.outfit:Init(client)

	local equipment = character:GetEquipment()

	if equipment then
		local items = equipment:GetItems()
		local torso = equipment:GetItemAtSlot(EQUIP_TORSO)
		local mask = equipment:GetItemAtSlot(EQUIP_MASK)

		if torso and torso.OnEquipped then
			timer.Simple(2, function() torso:OnEquipped(client, torso.slot) end)
		end

		if mask and mask.OnEquipped then
			timer.Simple(2.1, function() mask:OnEquipped(client, mask.slot) end)
		end

		for _, v in pairs(items) do
			if v.OnEquipped then
				v:OnEquipped(client, v.slot)
			end
		end
	end
end

function PLUGIN:OnPlayerRespawn(client)
	local character = client:GetCharacter()

	if character then
		hook.Run("CharacterLoaded", character)
	end
end

function PLUGIN:PlayerModelChanged(client, model, oldmodel)
	if !client.ChangeModel then client.ChangeModel = true return end

	local character = client:GetCharacter()

	if character then
		if character.outfit then
			character.outfit = nil
		end

		character.outfit = setmetatable({}, OUTFIT)
		character.outfit:Init(client)
	end
end

local function SaveBGCache(client, oldcharacter)
	if oldcharacter then
		local bgs = {}

		for i = 0, (client:GetNumBodyGroups() - 1) do
			bgs[i] = client:GetBodygroup(i)
		end

		oldcharacter:SetData("bgcache", bgs)
	end
end

function PLUGIN:PrePlayerLoadedCharacter(client, character, oldcharacter)
	SaveBGCache(client, oldcharacter)
end

function PLUGIN:PlayerDisconnected(client)
	SaveBGCache(client, client:GetCharacter())
end