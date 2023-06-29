--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.CLIENT)
plugin:IncludeFile("sh_cppi.lua", SERVERGUARD.STATE.CLIENT)
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("sh_hooks.lua", SERVERGUARD.STATE.CLIENT)
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT)

hook.Add("serverguard.LoadPlayerData", "prop_protection.LoadPlayerData", function(player)
	g_serverGuard.prop_protection = g_serverGuard.prop_protection or {friends = {}, buddies = {}}
end)

serverguard.config.New("prop_protection", function(data)
	g_serverGuard.prop_protection = g_serverGuard.prop_protection or {friends = {}, buddies = data or {}}
	g_serverGuard.prop_protection.buddies = data or {}
	
	timer.Simple(1, function()
		serverguard.netstream.Start("sgPropProtectionUploadFriends", data);
	end)
end)

local lastPropCheck = CurTime()

plugin:Hook("Think", "prop_protection.Think", function()
	if (lastPropCheck < CurTime()) then
		local trace = LocalPlayer():GetEyeTrace()
		
		if (IsValid(trace.Entity)) then
			if (trace.Entity.serverguard) then
				if (!trace.Entity.serverguard.updated) then
					serverguard.netstream.Start("sgPropProtectionRequestInformation", true);
				end
			else
				serverguard.netstream.Start("sgPropProtectionRequestInformation", true);
			end
		end
		
		lastPropCheck = CurTime() +0.2
	end
end)

plugin:Hook("HUDPaint", "prop_protection.HUDPaint", function()
	if (!hook.Call("serverguard.HideOwner")) then
		local trace = LocalPlayer():GetEyeTrace()
		
		if (IsValid(trace.Entity) and !trace.Entity:IsPlayer()) then
			if (trace.Entity.serverguard) then
				local name = "Owner: " .. trace.Entity.serverguard.name
				
				if (!IsValid(trace.Entity.serverguard.owner) and trace.Entity.serverguard.owner != game.GetWorld()) then
					name = "Owner: " .. trace.Entity.serverguard.name .. " (Disconnected)"
				end
				
				local width, height = util.GetTextSize("serverGuard_ownerFont", name)
				
				draw.RoundedBox(6, ScrW() -(width +12), ScrH() /2 -13, width +16, height +2, Color(0, 0, 0, 180))
				draw.SimpleText(name, "serverGuard_ownerFont", ScrW() -5, ScrH() /2 -(height /2) +4, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			else
				local width, height = util.GetTextSize("serverGuard_ownerFont", "Owner: Unknown")
				
				draw.RoundedBox(6, ScrW() -(width +12), ScrH() /2 -13, width +16, height +2, Color(0, 0, 0, 180))
				draw.SimpleText("Owner: Unknown", "serverGuard_ownerFont", ScrW() -5, ScrH() /2 -(height /2) +4, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		end
	end
end)

serverguard.netstream.Hook("sgPropProtectionRequestInformation", function(data)
	local owner = data[1];
	local entity = data[2];
	
	local name = data[3];
	local steamID = data[4];
	local uniqueID = data[5];
	
	if (owner == game.GetWorld()) then
		name = "World"
		steamID = "World"
		uniqueID = "World"
	end
	
	entity.serverguard = {name = name, owner = owner, updated = true, uniqueID = uniqueID}
end);

serverguard.netstream.Hook("sgPropProtectionClearEntityData", function(data)
	local entity = data;

	if (IsValid(entity) and entity.serverguard) then
		entity.serverguard.updated = false;
	end;
end);