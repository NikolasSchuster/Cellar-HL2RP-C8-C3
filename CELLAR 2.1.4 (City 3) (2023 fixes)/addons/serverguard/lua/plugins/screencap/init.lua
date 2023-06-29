--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

serverguard.AddFolder("screencap");

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);

local stream = {};

serverguard.netstream.Hook("sgScreencapRequest", function(player, data)
	if (serverguard.player:HasPermission(player, "Screencap")) then
		local target = util.FindPlayer(data[1], player);
		
		if (IsValid(target)) then
			local quality = data[2];
			local id = #stream +1

			stream[id] = {
				data = {}, receiver = player, target = target
			};

			serverguard.netstream.Start(target, "sgScreencapRequest", {
				id, quality
			});
		end
	end
end);

util.AddNetworkString "sgScreencapGetData"
net.Receive("sgScreencapGetData", function(len, player)
	local id = net.ReadUInt(32)
	
	if (stream[id]) then
		local util = util;
		local length = net.ReadUInt(32)
		local dataPart = net.ReadData(length)
		
		table.insert(stream[id].data, dataPart);
		
		-- We're done!
		if (#stream[id].data >= stream[id].parts) then
			serverguard.PrintConsole("Sending screen snapshot " .. tostring(stream[id].target) .. " -> " .. tostring(stream[id].receiver) .. "\n");
			
			local compiled = table.concat(stream[id].data)
            
			-- Save it to the server.
			local fileStream = file.Open("serverguard/screencap/" .. string.gsub(stream[id].target:SteamID(), ":", "_") .. ".jpg", "wb", "DATA");
				fileStream:Write(compiled);
			fileStream:Close();
			
			-- Send the data to the admin.
			for k, str in pairs(stream[id].data) do
				timer.Simple(k * 0.4, function()
					if (stream[id]) then
						if (!IsValid(stream[id].target) or !IsValid(stream[id].receiver)) then
							stream[id] = nil;
							
							return;
						end;

                        net.Start "sgScreencapGetData"
                            net.WriteUInt(stream[id].target:UID(), 32)
                            net.WriteUInt(str:len(), 32)
                            net.WriteData(str, str:len())
                        net.Send(stream[id].receiver)
						
						if (k == #stream[id].data) then
							stream[id] = nil;
						end;
					end;
				end);
			end;
		end;
	end;
end);

serverguard.netstream.Hook("sgScreencapFailed", function(player, data)
	local id = data[1];

	if (stream[id]) then
		serverguard.Notify(stream[id].receiver, SERVERGUARD.NOTIFY.RED, "Failed to retrieve screen capture!");
	end;
end);

serverguard.netstream.Hook("sgScreencapGetDataParts", function(player, data)
	local id = data[1];

	if (stream[id]) then
		stream[id].parts = data[2];

		serverguard.netstream.Start(stream[id].receiver, "sgScreencapGetDataParts", {
			player:UID(), stream[id].parts
		});
	end;
end);