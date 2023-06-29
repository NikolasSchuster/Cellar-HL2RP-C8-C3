--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

--
-- 2 tables
-- 'buddies' -> Table containing the friends.
-- 'friends' -> Table containing CPPI friend entities.
--

serverguard.AddFolder("prop-protection");

local plugin = plugin;
local autodeleteBypass = {};

local propBlacklist = {};

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);

plugin:IncludeFile("sh_hooks.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("sh_cppi.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.SHARED);

plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

gameevent.Listen("player_disconnect");

local function SAVE_BLACKLIST()
	file.Write("serverguard/prop-protection/blacklist.txt", serverguard.von.serialize(propBlacklist), "DATA");
end;

plugin:Hook("player_disconnect", "prop_protection.player_disconnect", function(data)
	local steamID = data.networkid;

	if (!plugin.config:GetValue("autodelete") or autodeleteBypass[steamID]) then
		return;
	end;

	for k, v in ipairs(ents.GetAll()) do
		if (IsValid(v) and v.serverguard and v.serverguard.owner != game.GetWorld() and !v:IsPlayer()) then
			if (v.serverguard.steamID == steamID) then
				v:Remove();
			end;
		end;
	end;
end);

plugin:Hook("Think", "prop_protection.Think", function() -- ?!
	if (!plugin.config:GetValue("autodelete")) then
		return;
	end;

	for k, v in ipairs(player.GetAll()) do
		if (IsValid(v) and v:IsPlayer() and v:GetNetworkedString("serverguard_rank", "") != "") then
			if (serverguard.player:HasPermission(v, "Bypass Prop Deletion")) then
				autodeleteBypass[v:SteamID()] = true;
			else
				if (autodeleteBypass[v:SteamID()]) then
					autodeleteBypass[v:SteamID()] = nil;
				end;
			end;
		end;
	end;
end);

local playerMeta = FindMetaTable("Player");

plugin:Hook("OnGamemodeLoaded", "prop_protection.OnGamemodeLoaded", function()
	if (playerMeta.AddCount) then
		local oldAddCount = playerMeta.AddCount;

		function playerMeta:AddCount(type, entity)
			if (IsValid(entity)) then
				entity:CPPISetOwner(self);
			end;

			oldAddCount(self, type, entity);
		end;
	end;

	if (cleanup) then
		local oldCleanupAdd = cleanup.Add;

		function cleanup.Add(player, type, entity)
			if (IsValid(player) and player:IsPlayer()) then
				entity:CPPISetOwner(player);
			end

			oldCleanupAdd(player, type, entity);
		end;
	end;

	if (undo) then
		local oldUndoAddEntity = undo.AddEntity;
		local oldUndoSetPlayer = undo.SetPlayer;
		local oldUndoFinish = undo.Finish;

		local entityList = {};
		local currentPlayer;

		function undo.AddEntity(entity)
			if (IsValid(entity)) then
				table.insert(entityList, entity);
			end;

			oldUndoAddEntity(entity);
		end;

		function undo.SetPlayer(player)
			if (IsValid(player) and player:IsPlayer()) then
				currentPlayer = player;
			end;

			oldUndoSetPlayer(player);
		end;

		function undo.Finish()
			if (IsValid(currentPlayer) and currentPlayer:IsPlayer()) then
				for k, v in ipairs(entityList) do
					if (!IsValid(v)) then
						continue;
					end;

					v:CPPISetOwner(currentPlayer);
				end;
			end;

			entityList = {};
			currentPlayer = nil;

			oldUndoFinish();
		end;
	end;
end);

plugin:Hook("serverguard.LoadPlayerData", "prop_protection.LoadPlayerData", function(player)
	player.serverguard.prop_protection = {
		friends = {},
		buddies = {},
		spam = {
			lastSpawnTime = 0,
			lastAttemptTime = 0,
			spawnAmount = 0,
			cooldownTime = 3
		}
	};
end);

plugin:Hook("InitPostEntity", "prop_protection.InitPostEntity", function()	
	timer.Simple(0.5, function()
		local entities = ents.GetAll();
		
		for k, v in pairs(entities) do
			if (IsValid(v) and !v:IsPlayer()) then
				v.serverguard = {};
			
				v:CPPISetOwner(game.GetWorld());
			end;
		end;
	end);

	local blacklistData = file.Read("serverguard/prop-protection/blacklist.txt", "DATA");

	if (blacklistData) then
		propBlacklist = serverguard.von.deserialize(blacklistData);
	end;
end);

plugin:Hook("EntityTakeDamage", "prop_protection.EntityTakeDamage", function(entity, dmginfo)
	if (plugin.config:GetValue("propdamage")) then
		if (IsValid(entity) and entity:IsPlayer() and dmginfo:GetDamageType() == DMG_CRUSH) then
			dmginfo:ScaleDamage(0.0);
		end;
	end;
end);

plugin:Hook("PlayerUse", "prop_protection.PlayerUse", function(player, entity)
	if (plugin.config:GetValue("useprotection")) then
		local owner = entity:CPPIGetOwner();
		
		-- Allow if the entity has no owner and take ownership.
		if (!IsValid(owner) and owner != game.GetWorld()) then
			entity:CPPISetOwner(player);
			
			return true;
		end
		
		if (serverguard.player:HasPermission(player, "Bypass Prop-Protection") or IsValid(owner) and (owner == player or plugin.IsFriend(owner, player))) then
			return true;
		else
			return false;
		end;
	end;
end);

plugin:Hook("PlayerSpawnProp", "prop_protection.PlayerSpawnProp", function(player, model)
	if (plugin.config:GetValue("propblacklist") and !serverguard.player:HasPermission(player, "Bypass Prop Blacklist")) then
		for k, v in pairs(propBlacklist) do
			if (string.lower(v) == string.lower(model)) then
				serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "This prop cannot be spawned because it is on the blacklist!");

				return false;
			end;
		end;
	end;

	if (plugin.config:GetValue("propspam") and !serverguard.player:HasPermission(player, "Bypass Prop Spam")) then
		local info = player.serverguard.prop_protection.spam;

		if (CurTime() >= info.lastSpawnTime + info.cooldownTime) then
			info.spawnAmount = 1;
			info.cooldownTime = 3;
		else
			info.spawnAmount = info.spawnAmount + 1;
			info.lastAttemptTime = CurTime();

			if (info.spawnAmount > 7) then
				serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "You're spawning props too fast! Please wait " .. math.ceil((info.lastSpawnTime + info.cooldownTime) - CurTime()) .. " second(s).");
 				
 				if (CurTime() < info.lastAttemptTime + 0.75) then
 					info.cooldownTime = math.Clamp(info.cooldownTime + 0.25, 1, 12);
				end;

				return false;
			end;
		end;

		info.lastSpawnTime = CurTime();
	end;
end);

serverguard.netstream.Hook("sgPropProtectionRequestInformation", function(player, data)
	local trace = player:GetEyeTrace();
	
	if (IsValid(trace.Entity) and trace.Entity.serverguard and !trace.Entity:IsPlayer()) then
		local data = trace.Entity.serverguard;
		
		serverguard.netstream.Start(player, "sgPropProtectionRequestInformation", {
			data.owner, trace.Entity, data.name, data.steamID, data.uniqueID
		});
	end;
end);

serverguard.netstream.Hook("sgPropProtectionCleanDisconnectedProps", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Prop-Protection")) then
		for k, entity in ipairs(ents.GetAll()) do
			if (IsValid(entity) and entity.serverguard and entity.serverguard.owner != game.GetWorld() and !entity:IsPlayer()) then
				if (!IsValid(entity.serverguard.owner)) then
					entity:Remove();
				end;
			end;
		end;
		
		serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " has cleaned up all disconnected players' props.");
	end;
end);

serverguard.netstream.Hook("sgPropProtectionCleanProps", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Prop-Protection")) then
		local name = "";
		local steamID = data;

		for k, entity in ipairs(ents.GetAll()) do
			if (IsValid(entity) and entity.serverguard and entity.serverguard.owner != game.GetWorld() and !entity:IsPlayer()) then
				if (entity.serverguard.steamID == steamID) then
					name = entity.serverguard.name;
					
					entity:Remove();
				end;
			end;
		end;
		
		if (name == "") then
			serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "This player has no props.");
		else
			serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, player:Name(), SERVERGUARD.NOTIFY.WHITE, " has cleaned up ", SERVERGUARD.NOTIFY.GREEN, name, SERVERGUARD.NOTIFY.WHITE, string.Ownership(name, true) .. " props.");
		end;
	end;
end);

serverguard.netstream.Hook("sgPropProtectionUploadFriends", function(player, data)
	player.serverguard.prop_protection = player.serverguard.prop_protection or {
		friends = {},
		buddies = {},
		spam = {
			lastSpawnTime = 0,
			lastAttemptTime = 0,
			spawnAmount = 0,
			cooldownTime = 3
		}
	};

	for k, v in pairs(data) do
		table.insert(player.serverguard.prop_protection.buddies, steamID);
	end;
end);

serverguard.netstream.Hook("sgPropProtectionAddFriend", function(player, data)
	local steamID = data[1];
	local bRemove = data[2];
	local buddies = player.serverguard.prop_protection.buddies;

	if (bRemove) then
		for i = 1, #buddies do
			if (buddies[i] == steamID) then
				table.remove(player.serverguard.prop_protection.buddies, i);
				
				break;
			end;
		end;
	else
		table.insert(player.serverguard.prop_protection.buddies, steamID);
	end;

	hook.Call("CPPIFriendsChanged", nil, player, player.serverguard.prop_protection.buddies);
end);

serverguard.netstream.Hook("sgPropProtectionAddBlacklist", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Prop Blacklist")) then
		if (type(data) != "string") then
			return;
		end;

		if (table.HasValue(propBlacklist, data)) then
			serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, data, SERVERGUARD.NOTIFY.WHITE, " is already on the prop blacklist!");

			return;
		end;

		table.insert(propBlacklist, data);
		SAVE_BLACKLIST();

		serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, data, SERVERGUARD.NOTIFY.WHITE, " was added to the prop blacklist.");
	end;
end);

serverguard.netstream.Hook("sgPropProtectionRemoveBlacklist", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Prop Blacklist")) then
		if (type(data) != "string") then
			return;
		end;

		for k, v in pairs(propBlacklist) do
			if (v == data) then
				table.remove(propBlacklist, k);
				SAVE_BLACKLIST();

				serverguard.Notify(player, SERVERGUARD.NOTIFY.GREEN, data, SERVERGUARD.NOTIFY.WHITE, " was removed from the prop blacklist.");
				return;
			end;
		end;

		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, data, SERVERGUARD.NOTIFY.WHITE, " is not on the prop blacklist!");
	end;
end);

serverguard.netstream.Hook("sgPropProtectionGetBlacklist", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Prop Blacklist") and player.sgBlacklistData == nil) then
		local blacklistCount = table.Count(propBlacklist);

		if (blacklistCount > 0) then
        	serverguard.netstream.StartChunked(player, "sgPropProtectionGetBlacklistChunk", propBlacklist);
		end;
	end;
end);