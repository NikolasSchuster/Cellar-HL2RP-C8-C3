--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

local function CANNOT_USE(player, owner)
	return (!serverguard.player:HasPermission(player, "Bypass Prop-Protection") and owner != CPPI.CPPI_DEFER)
	and (IsValid(owner) and (owner != player or !plugin.IsFriend(owner, player)));
end;

function plugin.CanDrive(player, entity)
	if (!IsValid(player)) then
		ErrorNoHalt("Invalid player used for 'CanDrive'.\n"..debug.traceback().."\n");
		return;
	end;

	local bBypassPropProtection = serverguard.player:HasPermission(player, "Bypass Prop-Protection");

	if ((entity:CPPIGetOwner() == game.GetWorld() or entity:CPPIGetOwner() == CPPI.CPPI_DEFER) and !bBypassPropProtection) then
		return false;
	end;
	
	if (IsValid(entity)) then
		if (entity:IsPlayer() and !bBypassPropProtection) then
			return false;
		end;
		
		local owner = entity:CPPIGetOwner();
		
		if (CANNOT_USE(player, owner)) then
			return false;
		end;
	end;
end;

plugin:Hook("CanDrive", "prop_protection.CanDrive", plugin.CanDrive);

function plugin.CanProperty(player, property, entity)
	if (!IsValid(player)) then
		ErrorNoHalt("Invalid player used for 'CanProperty'.\n"..debug.traceback().."\n");
		return;
	end;

	local bBypassPropProtection = serverguard.player:HasPermission(player, "Bypass Prop-Protection");

	if ((entity:CPPIGetOwner() == game.GetWorld() or entity:CPPIGetOwner() == CPPI.CPPI_DEFER) and !bBypassPropProtection) then 
		return false;
	end;
	
	if (IsValid(entity)) then
		if (property == "bonemanipulate" and entity:IsPlayer() and !bBypassPropProtection) then
			return false;
		end;
		
		local owner = entity:CPPIGetOwner();
		
		if (CANNOT_USE(player, owner)) then
			return false;
		end;
	end;
end;

plugin:Hook("CanProperty", "prop_protection.CanProperty", plugin.CanProperty);

function plugin.CanTool(player, trace, toolMode)
	if (!IsValid(player)) then
		ErrorNoHalt("Invalid player used for 'CanTool'.\n"..debug.traceback().."\n");
		return;
	end;

	local bBypassPropProtection = serverguard.player:HasPermission(player, "Bypass Prop-Protection");
	local entity = trace.Entity;

	if ((entity:CPPIGetOwner() == game.GetWorld() or entity:CPPIGetOwner() == CPPI.CPPI_DEFER) and !bBypassPropProtection and entity != game.GetWorld()) then
		return false;
	end;
	
	if (IsValid(entity)) then
		if (entity:IsPlayer() and !bBypassPropProtection) then
			return false;
		end;
		
		local owner = entity:CPPIGetOwner();
		
		if (CANNOT_USE(player, owner)) then
			return false;
		end;
	end;
end;

plugin:Hook("CanTool", "prop_protection.CanTool", plugin.CanTool);

function plugin.PhysgunPickup(player, entity)
	if (!IsValid(player)) then
		ErrorNoHalt("Invalid player used for 'PhysgunPickup'.\n"..debug.traceback().."\n");
		return false;
	end;
	
	if (serverguard.player:HasPermission(player, "Bypass Prop-Protection") and !entity:IsPlayer()) then
		return true
	end
	
	if ((entity:CPPIGetOwner() == game.GetWorld() or entity:CPPIGetOwner() == CPPI.CPPI_DEFER)) then
		return false
	end
	
	if (!entity:IsPlayer() and !IsValid(entity:CPPIGetOwner()) and (entity:CPPIGetOwner() != game.GetWorld() and entity:CPPIGetOwner() != CPPI.CPPI_DEFER)) then
		if (SERVER) then
			entity:CPPISetOwner(player)
		end
		
		return true
	end
	
	if (!entity:IsPlayer() and (!IsValid(entity:CPPIGetOwner()) or IsValid(entity:CPPIGetOwner()) and (entity:CPPIGetOwner() == player or plugin.IsFriend(entity:CPPIGetOwner(), player)))) then
		return true
	end

	return false
end;

plugin:Hook("PhysgunPickup", "prop_protection.PhysgunPickup", plugin.PhysgunPickup);

function plugin.OnPhysgunReload(weapon, player)
	if (!IsValid(player)) then
		ErrorNoHalt("Invalid player used for 'OnPhysgunReload'.\n"..debug.traceback().."\n");
		return;
	end;
	
	local trace = player:GetEyeTrace();

	if (IsValid(trace.Entity)) then
		local owner = trace.Entity:CPPIGetOwner();
		
		if (CANNOT_USE(player, owner)) then
			return false;
		end;
	end;
end;

plugin:Hook("OnPhysgunReload", "prop_protection.OnPhysgunReload", plugin.OnPhysgunReload);

function plugin.GravGunPickupAllowed(player, entity)
	if (!IsValid(player)) then
		ErrorNoHalt("Invalid player used for 'GravGunPickupAllowed'.\n"..debug.traceback().."\n");
		return;
	end;
	
	local owner = entity:CPPIGetOwner();

	if (CANNOT_USE(player, owner)) then
		return false;
	end;
end;

plugin:Hook("GravGunPickupAllowed", "prop_protection.GravGunPickupAllowed", plugin.GravGunPickupAllowed)

function plugin.PlayerSpawnedProp(player, model, entity)
	entity.serverguard = {};
	
	entity:CPPISetOwner(player);
end;

plugin:Hook("PlayerSpawnedProp", "prop_protection.PlayerSpawnedProp", plugin.PlayerSpawnedProp);

function plugin.PlayerSpawnedRagdoll(player, model, entity)
	entity.serverguard = {};
	
	entity:CPPISetOwner(player);
end;

plugin:Hook("PlayerSpawnedRagdoll", "prop_protection.PlayerSpawnedRagdoll", plugin.PlayerSpawnedRagdoll);

function plugin.PlayerSpawnedVehicle(player, entity)
	entity.serverguard = {};
	
	entity:CPPISetOwner(player);
end;

plugin:Hook("PlayerSpawnedVehicle", "prop_protection.PlayerSpawnedVehicle", plugin.PlayerSpawnedVehicle);

function plugin.PlayerSpawnedEffect(player, model, entity)
	entity.serverguard = {};
	
	entity:CPPISetOwner(player);
end;

plugin:Hook("PlayerSpawnedEffect", "prop_protection.PlayerSpawnedEffect", plugin.PlayerSpawnedEffect);

function plugin.PlayerSpawnedNPC(player, entity)
	entity.serverguard = {};
	
	entity:CPPISetOwner(player);
end;

plugin:Hook("PlayerSpawnedNPC", "prop_protection.PlayerSpawnedNPC", plugin.PlayerSpawnedNPC);

function plugin.PlayerSpawnedSENT(player, entity)
	entity.serverguard = {};
	
	entity:CPPISetOwner(player);
end;

plugin:Hook("PlayerSpawnedSENT", "prop_protection.PlayerSpawnedSENT", plugin.PlayerSpawnedSENT);

function plugin.PlayerSpawnedSWEP(player, entity)
	entity.serverguard = {};
	
	entity:CPPISetOwner(player);
end;

plugin:Hook("PlayerSpawnedSWEP", "prop_protection.PlayerSpawnedSWEP", plugin.PlayerSpawnedSWEP);