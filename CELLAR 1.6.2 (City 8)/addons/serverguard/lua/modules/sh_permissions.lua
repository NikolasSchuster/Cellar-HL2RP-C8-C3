--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

--- ## Shared
-- Library to store and retrieve what permissions are available.
-- @module serverguard.permission

include "modules/sh_cami.lua"

serverguard.permission = serverguard.permission or {};
serverguard.permission.stored = serverguard.permission.stored or {};

--- Check whether or not a permission exists.
-- @string identifier The name of the permission.
-- @treturn boolean Whether or not the permission exists.
function serverguard.permission:Exists(identifier)
	if (type(identifier) == "string") then
		return self.stored[identifier];
	end;
end;

--- Adds a permission.
-- @string identifier The name of the permission.
function serverguard.permission:Add(identifier, priv)
	if (type(identifier) == "string") then
		if (!self.stored[identifier]) then
			self.stored[identifier] = true;
			if priv then
				CAMI.RegisterPrivilege({
	                Name = identifier,
	                MinAccess = "invalid"
	            })
	        end
		end;
	elseif (type(identifier) == "table") then
		for k, v in pairs(identifier) do
			if (type(v) == "string") then
				self:Add(v);
			end;
		end;
	end;
end;

--- Removes a permission.
-- @string identifier The name of the permission.
function serverguard.permission:Remove(identifier)
	if (type(identifier) == "string") then
		if (self.stored[identifier]) then
			self.stored[identifier] = nil;
		end;
	end;
end;

--- Gets a table of all permissions.
-- @treturn table Table of all permissions.
function serverguard.permission:GetAll()
	return self.stored;
end;

serverguard.permission:Add("Quick Menu", true);
serverguard.permission:Add("Manage Players", true);
serverguard.permission:Add("Manage Plugins", true);
serverguard.permission:Add("Admin", true);
serverguard.permission:Add("Superadmin", true);
serverguard.permission:Add("Physgun Player", true);
serverguard.permission:Add("See Help Requests", true);
serverguard.permission:Add("Unban", true);
serverguard.permission:Add("Edit Ban", true);
serverguard.permission:Add("Go Incognito", true);

hook.Add("PhysgunPickup", "serverguard.PhysgunPickup", function(pPlayer, pEntity)
	if (pEntity:IsPlayer() and serverguard.player:HasPermission(pPlayer, "Physgun Player") and serverguard.player:CanTarget(pPlayer, pEntity)) then
		pPlayer.sg_physgunPlayer = pEntity;
		pEntity.sg_playerPhysgunned = true;

		pEntity:SetLocalVelocity(Vector(0, 0, 0));
		pEntity:SetMoveType(MOVETYPE_NONE);
		pEntity:SetCollisionGroup(COLLISION_GROUP_WORLD);

		return true;
	end;
end);

hook.Add("PhysgunDrop", "serverguard.PhysgunDrop", function(pPlayer, pEntity)
	if (pEntity:IsPlayer() and pEntity.sg_playerPhysgunned) then
		pPlayer.sg_physgunPlayer = nil;

		pEntity:SetMoveType(MOVETYPE_WALK);
		pEntity:SetCollisionGroup(COLLISION_GROUP_PLAYER);
		
		pEntity.sg_playerPhysgunned = false;
	end;
end);

hook.Add("KeyPress", "serverguard.KeyPress", function(pPlayer, nKey)
	if (nKey == IN_ATTACK2) then
		local pActiveWeapon = pPlayer:GetActiveWeapon()
		
		if (pActiveWeapon ~= NULL and pActiveWeapon:GetClass() == "weapon_physgun") then
			local pEntity = pPlayer.sg_physgunPlayer;

			if (IsValid(pEntity)) then
				if (serverguard.player:HasPermission(pPlayer, "Physgun Player") and serverguard.player:CanTarget(pPlayer, pEntity)) then
					pPlayer.sg_physgunPlayer = nil;
					pEntity.sg_playerPhysgunned = false;

					pEntity:SetLocalVelocity(Vector(0, 0, 0));
					pEntity:SetMoveType(MOVETYPE_NONE);
					pEntity:SetCollisionGroup(COLLISION_GROUP_PLAYER);
				end;
			end;
		end;
	end;
end);

if (SERVER) then	
	hook.Add("CanPlayerSuicide", "serverguard.CanPlayerSuicide", function(pPlayer)
		if (pPlayer.sg_playerPhysgunned) then
			return false;
		end;
	end);
	
	hook.Add("PostGamemodeLoaded", "serverguard.permissions.PostGamemodeLoaded", function()
		hook.Remove("PhysgunDrop", "FAdmin_PickUpPlayers");
	end);
end;

local function OnPrivilegeRegistered(privilege)
	local permission = privilege.Name
	serverguard.permission:Add(permission)

	if (SERVER) then
		local defaultRank = privilege.MinAccess
		defaultRank = defaultRank:sub(1, 1):upper() .. defaultRank:sub(2)

		for rank, _ in pairs(serverguard.ranks:GetStored()) do
			-- we're setting defaults here, so only give permission if it hasn't been manually set already (i.e nil)
			if (serverguard.ranks:HasPermission(rank, permission) == nil and
				(defaultRank == "User" or serverguard.ranks:HasPermission(rank, defaultRank))) then
				serverguard.ranks:GivePermission(rank, permission)
			end
		end
	end
end

local function RegisterPrivileges()
	if (CAMI) then
		-- register privileges that may have been added before we've loaded
		for k, v in pairs(CAMI.GetPrivileges()) do
			OnPrivilegeRegistered(v)
		end
	end
end

hook.Add("CAMI.OnPrivilegeRegistered", "serverguard.CAMI.OnPrivilegeRegistered", OnPrivilegeRegistered)

hook.Add("CAMI.PlayerHasAccess", "serverguard.CAMI.PlayerHasAccess", function(client, privilege, callback)
	callback(not not serverguard.player:HasPermission(client, privilege), "serverguard")
	return true
end)

if (SERVER) then
	hook.Add("serverguard.RanksLoaded", "serverguard.RanksLoaded", RegisterPrivileges)
else
	RegisterPrivileges()
end