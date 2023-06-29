
util.AddNetworkString("ixFoodConservation")

function PLUGIN:OnItemTransferred(item, oldInv, newInv)
	local osTime = os.time()
	local expirationDate = item:GetData("expirationDate")

	if (isnumber(expirationDate) and expirationDate > osTime) then
		local containerEntity
		local dateToSet
		local timeLeftToSet

		if (newInv.vars and newInv.vars.isContainer) then
			containerEntity = newInv.storageInfo.entity
			dateToSet = expirationDate + 2629744 -- month
			timeLeftToSet = expirationDate - osTime
		elseif (oldInv.vars and oldInv.vars.isContainer) then
			local expirationTimeLeft = item:GetData("expirationTimeLeft")

			containerEntity = oldInv.storageInfo.entity
			dateToSet = expirationTimeLeft and osTime + expirationTimeLeft or expirationDate
		else
			return
		end

		if (ix.container.stored[containerEntity:GetModel()].bRefrigerator) then
			local playerHumans = player.GetHumans()

			item:SetData("expirationDate", dateToSet, playerHumans)
			item:SetData("expirationTimeLeft", timeLeftToSet, playerHumans)
		end
	end
end
