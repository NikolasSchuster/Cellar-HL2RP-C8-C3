--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Restrictions";
plugin.author = "`impulse";
plugin.version = "1.2";
plugin.description = "Provides restrictions for each player, like how many props you can spawn or if you're allowed to noclip.";
plugin.permissions = {"Manage Restrictions"};

plugin:Hook( "CanTool", "restrictions.CanTool", function( pPlayer, _, sRequestedTool )
	local sUniqueID = serverguard.player:GetRank( pPlayer )

	local tRestrictionData = serverguard.ranks:GetData( sUniqueID, "Restrictions", {} )
	local tToolList = tRestrictionData.Tools or {}

	if next( tToolList ) == nil and sUniqueID ~= "founder" then
		return false
	end

	-- Fast AF check if the tool is allowed due to this great
	-- design of the restrections table
	for sTool, bIsAllowed in pairs( tToolList ) do
		if sTool == sRequestedTool and not bIsAllowed then
			if SERVER then
				serverguard.Notify( pPlayer, SERVERGUARD.NOTIFY.RED, "You are not permitted to use this tool!" )
			end

			return false
		end
	end
end )
