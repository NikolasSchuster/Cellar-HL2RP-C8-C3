
util.AddNetworkString("ixUpdateBagLimitNotification")

local function CanInteractWithStorage(item, inventory)
	return (!inventory or inventory.GetReceivers) and (item.base == "base_bags" or item.isBag)
end

local function ChangeStorageCount(item, client, change, inventory)
	if (client and CanInteractWithStorage(item, inventory)) then
		if (item.isSmall) then
			client.ixSmallStorageCount = (client.ixSmallStorageCount or 0) + change
		else
			client.ixStorageCount = (client.ixStorageCount or 0) + change
		end
	end
end

local function CheckStorageLimit(client, item)
	if (CanInteractWithStorage(item)) then
		if ((item.isSmall and client.ixStorageCount > 0) or !item.isSmall and client.ixSmallStorageCount > 0) then
			return true
		end

		if (item.isSmall and client.ixSmallStorageCount > ix.config.Get("inventoryMaxSmallStorages", 2) - 1) then
			return true, true
		elseif (!item.isSmall and client.ixStorageCount > ix.config.Get("inventoryMaxStorages", 1) - 1) then
			return true, false
		end
	end
end

local function ChangeLastNotification(client, bIsSmall)
	local variant = (bIsSmall == nil and 0) or (bIsSmall == false and 1) or (bIsSmall == true and 2)

	net.Start("ixUpdateBagLimitNotification")
		net.WriteUInt(variant, 2)
	net.Send(client)
end

function PLUGIN:PlayerLoadedCharacter(client, character)
	local inventory = character:GetInventory()
	client.ixStorageCount = 0
	client.ixSmallStorageCount = 0

	local invs = {}
	for _, v in pairs(inventory.slots) do
		for _, v2 in pairs(v) do
			if (istable(v2) and v2.data) then
				local isBag = (((v2.base == "base_bags") or v2.isBag) and v2.data.id)

				if (!table.HasValue(invs, isBag)) then
					if (isBag and isBag != inventory:GetID()) then
						if (v2.isSmall) then
							client.ixSmallStorageCount = (client.ixSmallStorageCount or 0) + 1
						else
							client.ixStorageCount = (client.ixStorageCount or 0) + 1
						end

						invs[#invs + 1] = isBag
					end
				end
			end
		end
	end
end

function PLUGIN:CanTransferItem(item, _, targetInv)
	local invOwner = targetInv.GetOwner and targetInv:GetOwner()

	if (invOwner) then
		local bCanNotTake, bIsSmall = CheckStorageLimit(invOwner, item)

		if (bCanNotTake) then
			ChangeLastNotification(invOwner, bIsSmall)

			return false
		end
  	end
end

function PLUGIN:CanPlayerTradeWithVendor(client, _, uniqueID, isSellingToVendor)
	if (!isSellingToVendor) then
		local itemTable = ix.item.list[uniqueID]
		local bCanNotTake, bIsSmall = CheckStorageLimit(client, itemTable)

		if (bCanNotTake) then
			ChangeLastNotification(client, bIsSmall)

			return false
		end
	end
end

function PLUGIN:CharacterVendorTraded(client, _, uniqueID, isSellingToVendor)
	if (isSellingToVendor) then
		local itemTable = ix.item.list[uniqueID]

		ChangeStorageCount(itemTable, client, -1)
	end
end

function PLUGIN:InventoryItemAdded(oldInv, targetInv, item)
	ChangeStorageCount(item, targetInv:GetOwner(), 1, targetInv)
end

function PLUGIN:InventoryItemRemoved(inventory, item)
	ChangeStorageCount(item, inventory:GetOwner(), -1, targetInv)
end
