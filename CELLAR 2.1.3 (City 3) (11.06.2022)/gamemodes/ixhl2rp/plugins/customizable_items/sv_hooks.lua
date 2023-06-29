local PLUGIN = PLUGIN

net.Receive("ixCreateCustomItem", function(len, client)
	local base = net.ReadString()
	local properties = net.ReadTable()

	if !CAMI.PlayerHasAccess(client, "Helix - Create Custom Items", nil) then return end

	PLUGIN:CreateCustomItem(base, properties, client, nil)
end)