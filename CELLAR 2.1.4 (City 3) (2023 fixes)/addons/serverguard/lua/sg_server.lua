--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

resource.AddWorkshop("685130934");

serverguard = {
	RconEnabled = false -- Toggles ServerGuard's 'rcon' command. Only change this if you know what you're doing.
}
SERVERGUARD = {}

local folders = {}

function serverguard.AddFolder(path)
	table.insert(folders, path)
end

AddCSLuaFile("sg_client.lua")
AddCSLuaFile("sg_shared.lua")

include("sg_shared.lua")

--
--
--

function serverguard.Initialize()
	file.CreateDir("serverguard")
	
	for i = 1, #folders do
		file.CreateDir("serverguard/" .. folders[i])
	end

	local version = file.Read("serverguard/version.txt", "DATA")
	
	http.Fetch(SERVERGUARD.ENDPOINT .. "get/version",
		function(body, length, headers, responseCode)
			local returnData = util.JSONToTable(body);

			if (returnData != nil && table.Count(returnData) > 0) then
				if (!returnData["success"]) then
					return;
				end

				if (serverguard.GetCurrentVersion() != returnData["version"]) then
					serverguard.latestVersion = returnData["version"];
					serverguard.PrintConsole("Update " .. serverguard.GetLatestVersion() .. " is available for download! (Yours: " .. serverguard.GetCurrentVersion() .. ")\n\tWe recommend you update as soon as possible.\n")
					
					local recipients = {};

					for k, v in ipairs(player.GetAll()) do
						if (!v:IsAdmin()) then
							continue;
						end

						table.insert(recipients, v);
					end

					if (#recipients > 0) then
						serverguard.netstream.Start(admins, "sgUpdateNotification", serverguard.GetLatestVersion());
					end;
				end
			end
		end,

		function(error)
		end
	)

	hook.Call("serverguard.Initialize", nil)

	if (!version or version != serverguard.GetCurrentVersion()) then
		hook.Call("serverguard.PostUpdate", nil, version);
		
		file.Write("serverguard/version.txt", serverguard.version, "DATA")
	end
end;
hook.Add("Initialize", "serverguard.Initialize", serverguard.Initialize);

--
-- Load a players data.
--

hook.Add("PlayerInitialSpawn", "serverguard.PlayerInitialSpawn", function(pPlayer)
	pPlayer.serverguard = {};
	
	serverguard.ranks:SendInitialRanks(pPlayer);
	serverguard.player:Load(pPlayer);

	if (serverguard.GetCurrentVersion() != serverguard.GetLatestVersion() && pPlayer:IsAdmin()) then
		serverguard.netstream.Start(pPlayer, "sgUpdateNotification", serverguard.GetLatestVersion());
	end;
	
	hook.Call("serverguard.LoadPlayerData", nil, pPlayer, steamID, uniqueID);
end);

--
-- Needed to update in a local server
--

hook.Add("serverguard.RanksLoaded", "serverguard.RanksLoaded", function()
	serverguard.ranks:SendInitialRanks();
end);

--
-- Reset ServerGuard.
--

local SG_IN_RESET, SG_RESET_TOKEN = nil, nil;

local function RecursiveRemove(directory)
	if (!SG_IN_RESET) then
		return;
	end;

	if (string.sub(directory, -1) != "/") then
		directory = directory.."/";
	end;

	local files, folders = file.Find(directory.."*", "DATA");

	for k, v in ipairs(files) do
		file.Delete(directory..v);
	end;

	for k, v in ipairs(folders) do
		if (v != ".." and v != ".") then
			RecursiveRemove(directory..v);
		end;
	end;

	file.Delete(directory);
end;

concommand.Add("serverguard_reset", function(player, command, arguments)
	if (util.IsConsole(player) or player:IsListenServerHost()) then
		if (!SG_IN_RESET) then
			SG_RESET_TOKEN = math.random(1000, 9999);
				MsgC(Color(255, 0, 0), "CAUTION: This will reset ServerGuard and remove ALL data.\n");
				MsgC(Color(255, 255, 0), "We recommend you take a backup of the current data before confirming your reset.\n");
				MsgC(Color(255, 255, 0), "You will need to enter the following command to confirm your reset: "); MsgN("serverguard_reset "..tostring(SG_RESET_TOKEN));
				MsgC(Color(255, 255, 0), "The server will restart when the reset is complete.\n");
			SG_IN_RESET = true;
		elseif (SG_RESET_TOKEN != nil) then
			if (tonumber(arguments[1]) == SG_RESET_TOKEN) then
				RecursiveRemove("serverguard/");

				serverguard.mysql:Drop("serverguard_analytics"):Execute();
				serverguard.mysql:Drop("serverguard_bans"):Execute();
				serverguard.mysql:Drop("serverguard_ranks"):Execute();
				serverguard.mysql:Drop("serverguard_reports"):Execute(); -- backwards compatibility
				serverguard.mysql:Drop("serverguard_users"):Execute();
				serverguard.mysql:Drop("serverguard_schema"):Execute();

				hook.Call("serverguard.mysql.DropTables", nil);

				RunConsoleCommand("changelevel", game.GetMap());
			else
				MsgC(Color(255, 255, 0), "You have entered an incorrect reset code.\n");
				MsgC(Color(255, 255, 0), "The reset process has been aborted. You can restart it by entering the command: "); MsgN("serverguard_reset");

				SG_IN_RESET, SG_RESET_TOKEN = nil, nil;
			end;
		end;
	end;
end);

hook.Add("serverguard.PostUpdate", "serverguard.notification.PostUpdate", function(version)
	if (version and serverguard.GetCurrentVersion() == "1.4.0") then
		MsgC(Color(255, 255, 0), "[ServerGuard] We've noticed that you've upgraded from an old version - we HIGHLY recommend you refresh your data by using the serverguard_reset command.\n");
		MsgC(Color(255, 255, 0), "[ServerGuard] Not refreshing your data will more than likely cause errors!\n");
	end;
end);