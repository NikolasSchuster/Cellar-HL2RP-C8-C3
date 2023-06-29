--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

serverguard.AddFolder("logs")

local plugin = plugin;
local maxFileSize = 1024 * 1024 -- 1MB

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED)
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT)

local file = file

function plugin:Log(text, hideConsole)
	if (hook.Call("serverguard.logs.Log", nil, text, hideConsole)) then return; end;

	local fileNumber = 1
	local dateFormat = os.date("%m-%d-%Y")
	
	if (file.IsDir("serverguard/logs/" .. dateFormat, "DATA")) then
		local files = file.Find("serverguard/logs/" .. dateFormat .. "/*.txt", "DATA")
		
		if (#files > 0) then
			local size = file.Size("serverguard/logs/" .. dateFormat .. "/log_" .. #files .. ".txt", "DATA")
			
			if (size >= maxFileSize) then
				fileNumber = #files +1
			end
		end
	else
		file.CreateDir("serverguard/logs/" .. dateFormat, "DATA")
	end

	text = "[" .. os.date() .. "] " .. tostring(text) .. "\n"
	
	file.Append("serverguard/logs/" .. dateFormat .. "/log_" .. fileNumber .. ".txt", text)
	
	if (!hideConsole) then
		util.PrintConsoleAdmins(text)
	end
end

plugin:Hook("CheckPassword", "logs.CheckPassword", function(communityID, ip, serverPassword, enteredPassword, name)
	local anonID = GenerateAnonID64(communityID) 
	
	plugin:Log("Player <" .. anonID .. "> is attempting to connect.")
end)

plugin:Hook("PlayerInitialSpawn", "logs.PlayerInitialSpawn", function(player)
	local anonID = GenerateAnonID(player:SteamID()) 
	
	plugin:Log("Player <" .. anonID .. "> has spawned in the server")
end)

plugin:Hook("PlayerDisconnected", "logs.PlayerDisconnected", function(player)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("Player \"" .. name .. "\" <" .. steamID .. "> has left the server")
end)

plugin:Hook("PlayerSay", "logs.PlayerSay", function(player, text, m_bToAll, m_bDead)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. ": " .. text)
end)

plugin:Hook("CanDrive", "logs.CanDrive", function(player, entity)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. " attempted to drive entity \"" .. tostring(entity) .. "\"")
end)

plugin:Hook("CanTool", "logs.CanTool", function(player, trace, toolMode)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. " used tool \"" .. toolMode .. "\"")
end)

plugin:Hook("OnPhysgunReload", "logs.OnPhysgunReload", function(weapon, player)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. " un-froze (reloaded) using the physgun")
end)

plugin:Hook("PlayerSpawnedProp", "logs.PlayerSpawnedProp", function(player, model, entity)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. " spawned prop \"" .. tostring(entity) .. " (" .. model .. ")\"")
end)

plugin:Hook("PlayerSpawnedRagdoll", "logs.PlayerSpawnedRagdoll", function(player, model, entity)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. " spawned ragdoll \"" .. tostring(entity) .. " (" .. model .. ")\"")
end)

plugin:Hook("PlayerSpawnedVehicle", "logs.PlayerSpawnedVehicle", function(player, entity)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. " spawned vehicle \"" .. tostring(entity) .. "\"")
end)

plugin:Hook("PlayerSpawnedEffect", "logs.PlayerSpawnedEffect", function(player, model, entity)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. " spawned effect \"" .. tostring(entity) .. " (" .. model .. ")\"")
end)

plugin:Hook("PlayerSpawnedNPC", "logs.PlayerSpawnedNPC", function(player, entity)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. " spawned npc \"" .. tostring(entity) .. "\"")
end)

plugin:Hook("PlayerSpawnedSENT", "logs.PlayerSpawnedSENT", function(player, entity)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. " spawned SENT \"" .. tostring(entity) .. "\"")
end)

plugin:Hook("PlayerSpawnedSWEP", "logs.PlayerSpawnedSWEP", function(player, entity)
	local name = player:Nick()
	local steamID = player:GetAnonID()
	
	plugin:Log("<" .. steamID .. "> " .. name .. " spawned SWEP \"" .. tostring(entity) .. "\"")
end)

plugin:Hook("PlayerDeath", "logs.PlayerDeath", function(player, inflictor, attacker)
	if (attacker:IsPlayer()) then
		plugin:Log(attacker:Nick().." has killed "..player:Nick()..".");
	else
		plugin:Log(attacker:GetClass().." has killed "..player:Nick()..".");
	end;
end)

plugin:Hook("serverguard.RanCommand", "logs.RanCommand", function(player, commandTable, bSilent, arguments)
	if (util.IsConsole(player)) then
		plugin:Log(string.format(
			"Console ran command \"%s %s\"", commandTable.command, table.concat(arguments, " ")
		)); return;
	end;

	local steamID = player:GetAnonID()
	local playerNick = player:Nick();

	if (arguments and table.concat(arguments, " ") != "") then
		plugin:Log(string.format(
			"<%s> %s ran command \"%s %s\"", steamID, playerNick, commandTable.command, table.concat(arguments, " ")
		));
	else
		plugin:Log(string.format(
			"<%s> %s ran command \"%s\"", steamID, playerNick, commandTable.command
		));
	end;
end);

--
-- Sends a logs data to the player.
--

local function SendLogChunk(player, logFolder, logFile)
	if (player.sgLogChunks and player.sgLogChunks[logFolder] and player.sgLogChunks[logFolder][logFile]) then
		if (#player.sgLogChunks[logFolder][logFile] >= 1) then
			local chunk = player.sgLogChunks[logFolder][logFile][1];

			serverguard.netstream.Start(player, "sgSendLogChunk", {
				logFolder, logFile, chunk
			});

			table.remove(player.sgLogChunks[logFolder][logFile], 1);
		else
			serverguard.netstream.Start(player, "sgSendLogChunk", {
				logFolder, logFile, true
			});
		end;
	end;
end;

--
-- A player requests the next log chunk.
--

serverguard.netstream.Hook("sgRequestLogChunk", function(player, data)
	if (player:IsAdmin()) then
		local logFolder = data[1];
		local logFile = data[2];

		if (logFolder and logFile) then
			SendLogChunk(player, logFolder, logFile);
		end;
	end;
end);

--
-- A player requests the log data.
--

serverguard.netstream.Hook("sgRequestLogData", function(player, data)
	if (player:IsAdmin()) then
		local dateFormat = data;
		local files = file.Find("serverguard/logs/".. dateFormat.."/*.txt", "DATA");
		
		for k, v in ipairs(files) do
			local text = file.Read("serverguard/logs/".. dateFormat.."/".. v, "DATA");

			local exploded = string.Explode("\n", text);
			local index = 1;
			local buffer = {};
			local result = {};
			
			for i = 1, #exploded do
				if (string.len(table.concat(buffer)) + string.len(exploded[i]) + 2 > 1023) then
					result[#result + 1] = table.concat(buffer);
						index = index + 1;
						buffer = {};
					buffer[#buffer + 1] = exploded[i].."\n";
				else
					buffer[#buffer + 1] = exploded[i].."\n";
				end;
			end;
			
			result[#result + 1] = table.concat(buffer);

			if (!player.sgLogChunks) then
				player.sgLogChunks = {};
			end;

			if (!player.sgLogChunks[dateFormat]) then
				player.sgLogChunks[dateFormat] = {};
			end;

			player.sgLogChunks[dateFormat][k] = table.Copy(result);

			SendLogChunk(player, dateFormat, k);
		end;
	end;
end);

--
-- A player requests available log folders.
--

serverguard.netstream.Hook("sgRequestLogFolders", function(player, data)
	if (player:IsAdmin()) then
		local _, folders = file.Find("serverguard/logs/*", "DATA");

		for k, v in ipairs(folders) do
			local files = file.Find("serverguard/logs/"..v.."/*.txt", "DATA");

			serverguard.netstream.Start(player, "sgSendLogFolders", {
				v, #files
			});
		end;
	end;
end);

plugin:IncludeFile("sv_darkrp.lua", SERVERGUARD.STATE.SERVER);
plugin:IncludeFile("sv_ttt.lua", SERVERGUARD.STATE.SERVER);

function serverguard.Log(...)
	return plugin:Log(...)
end;