
net.Receive("ixFoodConservation", function()
	local item = ix.item.instances[net.ReadUInt(32)]
	local dateToSet = net.ReadUInt(32)
	local timeLeftToSet = net.ReadUInt(32)

	if (item) then
		item.data = item.data or {}
		item.data["expirationDate"] = dateToSet
		item.data["expirationTimeLeft"] = timeLeftToSet != 0 and timeLeftToSet or nil
	end
end)
