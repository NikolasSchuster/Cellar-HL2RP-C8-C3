util.AddNetworkString("ixCreateCustomItem")

function PLUGIN:CreateCustomItem(base, properties, pos, ang)
	local item = ix.item.list[base]

	if !isstring(base) or !istable(properties) then
		return
	end

	if !item or !item.hasProperties then
		return
	end

	ix.item.Spawn(base, pos, nil, ang, properties)
end
