util.AddNetworkString("MenuItemSpawn")
util.AddNetworkString("MenuItemGive")

net.Receive("MenuItemSpawn", function(len, player)
	if (!player:GetCharacter():HasFlags("G")) then
		return
	end

	local data = net.ReadString()
	if #data <= 0 then return end

	local uniqueID = data:lower()

	if (!ix.item.list[uniqueID]) then
		for k, v in SortedPairs(ix.item.list) do
			if (ix.util.StringMatches(v.name, uniqueID)) then
				uniqueID = k

				break
			end
		end
	end

	local vStart = player:GetShootPos()
	local vForward = player:GetAimVector()
	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + (vForward * 2048)
	trace.filter = player

	local tr = util.TraceLine(trace)
	local ang = player:EyeAngles()
	ang.yaw = ang.yaw + 180
	ang.roll = 0
	ang.pitch = 0

	local item = ix.item.Spawn(uniqueID, tr.HitPos, function(itemTable, entity)
		player:NotifyLocalized("itemCreated")
	end, ang)
end)

net.Receive("MenuItemGive", function(len, player)
	if (!player:GetCharacter():HasFlags("G")) then
		return
	end

	local data = net.ReadString()
	if #data <= 0 then return end

	local uniqueID = data:lower()

	if (!ix.item.list[uniqueID]) then
		for k, v in SortedPairs(ix.item.list) do
			if (ix.util.StringMatches(v.name, uniqueID)) then
				uniqueID = k

				break
			end
		end
	end

	local bSuccess, error = player:GetCharacter():GetInventory():Add(uniqueID, 1)

	if (bSuccess) then
		player:NotifyLocalized("itemCreated")
	else
		player:NotifyLocalized(tostring(error))
	end
end)