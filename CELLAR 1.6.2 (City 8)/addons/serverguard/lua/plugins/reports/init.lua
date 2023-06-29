--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
plugin.reports = plugin.reports or {};

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("cl_settings.lua", SERVERGUARD.STATE.CLIENT);

plugin:Hook("serverguard.mysql.CreateTables", "serverguard.reports.CreateTables", function()
	local REPORTS_TABLE_QUERY = serverguard.mysql:Create("serverguard_reports");
		REPORTS_TABLE_QUERY:Create("id", "INTEGER NOT NULL AUTO_INCREMENT");
		REPORTS_TABLE_QUERY:Create("name", "VARCHAR(255) NOT NULL");
		REPORTS_TABLE_QUERY:Create("steamID", "VARCHAR(255) DEFAULT \"Unknown\" NOT NULL");
		REPORTS_TABLE_QUERY:Create("text", "TEXT NOT NULL");
		REPORTS_TABLE_QUERY:Create("time", "INT(11) NOT NULL");
		REPORTS_TABLE_QUERY:PrimaryKey("id");
	REPORTS_TABLE_QUERY:Execute();
end);

hook.Add("serverguard.mysql.UpgradeSchemas", "serverguard.reports.UpgradeSchemas", function(callback)
	serverguard.mysql:UpgradeSchema("serverguard_reports", {
		{
			"ALTER TABLE `serverguard_reports` ADD `member` VARCHAR(255) NOT NULL DEFAULT '0';",
			"ALTER TABLE `serverguard_reports` ADD `sSteamID` VARCHAR(255) NOT NULL DEFAULT '0';",
			"ALTER TABLE `serverguard_reports` ADD `answered` INT(11) NOT NULL DEFAULT '0';",
		}
	}, callback);
end);

hook.Add("serverguard.PostUpdate", "serverguard.reports.PostUpdate", function(version) -- we want this to run regardless of whether or not the plugin is enabled
	if (version and util.ToNumber(string.gsub(version, "%.", "")) < 150) then
		plugin.queueUpdate = true;
	end;
end);

hook.Add("serverguard.mysql.OnConnected", "serverguard.reports.OnConnectedUpdate", function()
	if (!plugin.queueUpdate) then
		return;
	end;

	--[[	
	local ALTER_QUERY = serverguard.mysql.Push("ALTER", "serverguard_reports");
		ALTER_QUERY:AddSyntax("ADD");
		ALTER_QUERY:AddValue("steamID VARCHAR(255) DEFAULT \"Unknown\" NOT NULL");
	serverguard.mysql.Pop();
	--]]
end);

plugin:Hook("serverguard.mysql.OnConnected", "serverguard.reports.OnConnected", function()	
	local queryObj = serverguard.mysql:Select("serverguard_reports");
		queryObj:Callback(function(result, status, lastID)
			if (type(result) == "table" and #result > 0) then
				for k, v in pairs(result) do
					table.insert(plugin.reports, {
						id = v.id, name = v.name, steamID = v.steamID, text = v.text, time = v.time, member = v.member or nil, answered = v.answered or nil, staffSteamID = v.sSteamID or nil
					});
				end;
			end;
		end);
	queryObj:Execute();
end);

plugin:Hook("PlayerSay", "reports.PlayerSay", function(player, text, bTeam)
	if (text[1] == "@") then
		text = text:sub(2);

		if (#text != 0) then
			serverguard.netstream.GetStored()["sgSendReport"][1](player, text);
			serverguard.Notify(player, SGPF("report_received", player:Name(), text));
		end;
		
		return ""
	end
end);

local function SendReportChunk(player)
	if (#player.sgReportChunks >= 1) then
		local chunk = player.sgReportChunks[1];

		serverguard.netstream.Start(player, "sgSendReportChunk", {
			id = chunk.id, name = chunk.name, steamID = chunk.steamID, text = chunk.text, time = tonumber(chunk.time), member = chunk.member or nil, answered = tonumber(chunk.answered) or nil, staffSteamID = chunk.staffSteamID or nil
		});

		table.remove(player.sgReportChunks, 1);
	end;
end;

serverguard.netstream.Hook("sgRequestReports", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Reports")) then
		if (!player.sgReportChunks) then
			player.sgReportChunks = {};
		end;

		player.sgReportChunks = table.Copy(plugin.reports);

		SendReportChunk(player);
	end;
end);

serverguard.netstream.Hook("sgRequestReportChunk", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Reports")) then
		SendReportChunk(player);
	end;
end);



serverguard.netstream.Hook("sgToolsReport", function(Player, data)
	if (serverguard.player:HasPermission(Player, "Manage Reports")) then
		local report;

		// Validate the report //
		for k,v in pairs(plugin.reports) do
			if (v.id == data.id) then
				report = v
			end
		end

		if (report) then
			local foundPlayer;

			// Look for the player
			// I find this faster than using the util
			for k,v in ipairs(player.GetSortedPlayers()) do
				if v:SteamID() == report.steamID then
					foundPlayer = v
					break 
				end
			end

			local action = data.action

			// We found the player whom the reports belong to //
			if (foundPlayer) then

				// Message action - Sends the reporter a message //
				if (action == "m") then
					return
				end

				// So we're not sending a message. Which means a straight command comes from the client to run.
				// Valid Commands: goto, bring
				// Let the command handle the permissions of the caller(client)
				serverguard.command.Run(Player, action, false, foundPlayer:SteamID())

			end

		end

	end
end)

serverguard.netstream.Hook("sgAnswerReport", function(pPlayer, data)
	if (serverguard.player:HasPermission(pPlayer, "Manage Reports")) then
		local id = data;

		local report;

		for k,v in pairs(plugin.reports) do
			if (v.id == id) then
				report = v
			end
		end

		if (report) then
			if (report.member) then return end 

			report.member = pPlayer:Nick()
			report.answered = os.time()
			report.staffSteamID = pPlayer:SteamID()

			local queryObj = serverguard.mysql:Select("serverguard_reports");
			queryObj:Where("id", report.id)
			queryObj:Callback(function(result, status, lastID)
				local updateObj = serverguard.mysql:Update("serverguard_reports");
					updateObj:Update("member", report.member)
					updateObj:Update("sSteamID", report.staffSteamID)
					updateObj:Update("answered", report.answered)
					updateObj:Where("id", report.id)
				updateObj:Execute();
			end)
			queryObj:Execute();

			local alerts = plugin.config:GetValue("alert")

			if (alerts) then
				for k,v in pairs(player.GetAll()) do
					if v:SteamID() == report.steamID then
						serverguard.Notify(v, SERVERGUARD.NOTIFY.GREEN, pPlayer:Nick().. " has claimed your report.")
					end
				end
			end
		end

	end
end)

serverguard.netstream.Hook("sgRemoveReport", function(player, data)
	if (serverguard.player:HasPermission(player, "Manage Reports")) then
		local id = data;
		
		for k, v in pairs(plugin.reports) do
			if (v.id == id) then
				table.remove(plugin.reports, k);
			end;
		end;

		local deleteObj = serverguard.mysql:Delete("serverguard_reports");
			deleteObj:Where("id", id);
		deleteObj:Execute();
	end;
end);

serverguard.netstream.Hook("sgRequestRemoveAllReports", function(player, data)
	if (serverguard.player:HasPermission(player, "Delete All Reports")) then
		plugin.reports = {};

		serverguard.mysql:Delete("serverguard_reports"):Execute();

		serverguard.netstream.Start(player, "sgRemoveAllReports", true);
	end;
end);

serverguard.netstream.Hook("sgSendReport", function(pPlayer, data)
	local rawText = data;
	local text = string.gsub(rawText, "\n", " ");
	local playerName = pPlayer:Nick();
	local playerSteamID = pPlayer:SteamID();
	local reportTime = os.time();

	if (string.len(text) > 256) then
		text = string.sub(text, 1, 253) .. "...";
	end

	for k, v in ipairs(player.GetAll()) do
		if (serverguard.player:HasPermission(v, "Manage Reports") and v != pPlayer) then
			serverguard.Notify(v, SGPF("report_received", pPlayer:Name(), text));
		end;
	end;

	local insertCallback = function(result)
		local queryObj = serverguard.mysql:Select("serverguard_reports");
			queryObj:Where("name", playerName);
			queryObj:Where("steamID", playerSteamID);
			queryObj:Where("time", reportTime);
			queryObj:Callback(function(result, status, lastID)
				if (type(result) == "table" and #result > 0) then
					table.insert(plugin.reports, {
						id = result[1].id, name = result[1].name, steamID = result[1].steamID, text = result[1].text, time = result[1].time
					});
				end;
			end);
		queryObj:Execute();
	end;

	local insertObj = serverguard.mysql:Insert("serverguard_reports");
		insertObj:Insert("name", playerName);
		insertObj:Insert("steamID", playerSteamID);
		insertObj:Insert("text", rawText);
		insertObj:Insert("time", reportTime);
		insertObj:Callback(insertCallback);
	insertObj:Execute();
end);