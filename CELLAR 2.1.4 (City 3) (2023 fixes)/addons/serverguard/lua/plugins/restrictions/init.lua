--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);
	
local function ReachedLimit(player, limitType, message)
	local uniqueID = serverguard.player:GetRank(player);

	if (uniqueID == "founder") then
		return false, true;
	end;

	local restrictions = serverguard.ranks:GetData(uniqueID, "Restrictions");
	local iLimit = nil;
	local amount = tonumber(
		player:GetCount(string.lower(limitType))
	);

	if (restrictions and restrictions[limitType]) then
		iLimit = tonumber(restrictions[limitType]) or 0;
	end;

	if (iLimit == -1) then
		return false, true;
	end;

	if (iLimit and amount >= iLimit) then
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, message);
		return true;
	end;

	if (amount >= cvars.Number("sbox_max" .. string.lower(limitType))) then
		return false, false;
	end

	return false;
end;

plugin:Hook("PlayerSpawnEffect", "restrictions.PlayerSpawnEffect", function(player, model)
	local reachedLimit, bForce = ReachedLimit(player, "Effects", "You have reached your limit of effects.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnNPC", "restrictions.PlayerSpawnNPC", function(player, class, weapon)
	local reachedLimit, bForce = ReachedLimit(player, "NPCs", "You have reached your limit of NPCs.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnProp", "restrictions.PlayerSpawnProp", function(player, model)
	local reachedLimit, bForce = ReachedLimit(player, "Props", "You have reached your limit of props.")

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnRagdoll", "restrictions.PlayerSpawnRagdoll", function(player, model)
	local reachedLimit, bForce = ReachedLimit(player, "Ragdolls", "You have reached your limit of ragdolls.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnSENT", "restrictions.PlayerSpawnSENT", function(player, class)
	local reachedLimit, bForce = ReachedLimit(player, "Sents", "You have reached your limit of sents.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnSWEP", "restrictions.PlayerSpawnSWEP", function(player, class, swepData)
	local reachedLimit, bForce = ReachedLimit(player, "Sents", "You have reached your limit of sents.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PlayerSpawnVehicle", "restrictions.PlayerSpawnVehicle", function(player, model, class, data)
	local reachedLimit, bForce = ReachedLimit(player, "Vehicles", "You have reached your limit of vehicles.");

	if (reachedLimit) then
		return false;
	end;

	if (!reachedLimit and bForce) then
		return true;
	end;
end);

plugin:Hook("PostGamemodeLoaded", "restrictions.PostGamemodeLoaded", function()
	local meta = FindMetaTable("Player");
	meta.oldCheckLimit = meta.oldCheckLimit or meta.CheckLimit;
	function meta:CheckLimit(str)
		local reachedLimit, bForce = ReachedLimit(self, str:sub(1,1):upper()..str:sub(2), "You have reached your limit of "..str..".");

		if (reachedLimit) then
			return false;
		end;

		if (!reachedLimit and bForce) then
			return true;
		end;

		return self:oldCheckLimit(str);
	end;
end);