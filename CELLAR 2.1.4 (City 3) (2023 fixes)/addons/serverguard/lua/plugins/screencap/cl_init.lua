--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

file.CreateDir("serverguard/screencaps");

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.CLIENT)
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT)


local function split(str, d)
	local t = {};
	local len = str:len();
	local i = 0;

	while i *d < len do
		t[i +1] = str:sub(i *d +1, (i +1) *d);

		i = i +1;
	end;

	return t;
end;

local pendingRequest = false
serverguard.netstream.Hook("sgScreencapRequest", function(data)
    pendingRequest = data
end);

hook.Add('PostRender', 'sgScreencapRequest', function()

	if pendingRequest then
		local data = pendingRequest
		local util = util;
		local id = data[1];
		local quality = data[2];
		local binaryData = render.Capture({format = "jpeg", x = 0, y = 0, w = ScrW(), h = ScrH(), quality = quality});

		if (!binaryData) then
			serverguard.netstream.Start("sgScreencapFailed", {id});
		else
			local data = split(binaryData, 61440);

			serverguard.netstream.Start("sgScreencapGetDataParts", {id, #data});

			for k, v in ipairs(data) do
				timer.Simple((k - 1) * 0.4, function()
	                net.Start "sgScreencapGetData"
	                    net.WriteUInt(id, 32)
	                    net.WriteUInt(v:len(), 32)
	                    net.WriteData(v, v:len())
	                net.SendToServer()
				end);
			end;
		end;
		pendingRequest = false
	end

end)

serverguard.netstream.Hook("sgScreencapGetDataParts", function(data)
	local uniqueID = data[1];
	local parts = data[2];

	g_ScreenCapData[uniqueID].parts = parts;
end);

net.Receive("sgScreencapGetData", function(len)
	local uniqueID = tostring(net.ReadUInt(32))
	local length = net.ReadUInt(32)
	local captureData = net.ReadData(length)

	table.insert(g_ScreenCapData[uniqueID].data, captureData);
end);