
ix.item = ix.item or {}

function ix.item.RawFlip(item, bReturnSwappedValues)
	if (isnumber(item)) then
		item = ix.item.instances[item]
	end

	local fWidth, fHeight = item.height, item.width

	if (bReturnSwappedValues) then
		return fWidth, fHeight
	end

	item.width = fWidth
	item.height = fHeight
end

function ix.item.FixFlip(item)
	if (isnumber(item)) then
		item = ix.item.instances[item]
	end

	local stockItem = ix.item.list[item.uniqueID]

	if (
		item.data["flip"] and (item.width == stockItem.width or item.height == stockItem.height) or
		!item.data["flip"] and (item.width != stockItem.width or item.height != stockItem.height)
	) then
		ix.item.RawFlip(item)
	end
end
