util.AddNetworkString("dispatch.waypoint")
util.AddNetworkString("dispatch.waypoint.fx")

dispatch.waypoints = dispatch.waypoint or {}

function dispatch.GetWaypointReceivers()
	local recvs = {}

	for _, client in ipairs(player.GetAll()) do
		local char = client:GetCharacter()
		if !char then continue end

		if ix.faction.Get(char:GetFaction()).canSeeWaypoints then
			table.insert(recvs, client)
		end
	end

	return recvs
end

local function getFreeWaypoint()
	for i = 1, #dispatch.waypoints do
		if dispatch.waypoints[i] == nil then
			return i
		end
	end

	return #dispatch.waypoints + 1
end

local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local function getLetter(index)
	local letter = ((index -1) % 26) + 1
	local sub = math.floor(letter / 26)

	return letters[letter] .. (sub != 0 and sub or "")
end

function dispatch.AddWaypoint(pos, text, icon, time, addedBy)
	local index = getFreeWaypoint()

	local data = {}
	data.index = index
	data.pos = pos
	data.text = text
	data.type = icon
	data.addedBy = addedBy
	data.time = CurTime() + (time or 60)

	dispatch.waypoints[index] = data

	net.Start("dispatch.waypoint")
		net.WriteTable(data)
	net.Send(dispatch.GetWaypointReceivers())

	timer.Create("Waypoint" .. index, time or 60, 0, function()
		dispatch.waypoints[index] = nil
	end)

	if (dispatch.chatter_cooldown or 0) < CurTime() then
		local rnd = math.random(1, #dispatch.snd_waypoints[icon])

		net.Start("dispatch.waypoint.fx")
			net.WriteString(icon)
			net.WriteUInt(rnd, 4)
		net.Broadcast()

		dispatch.chatter_cooldown = CurTime() + (SoundDuration(dispatch.snd_waypoints[icon][rnd]) or 0) + 1
	end

	return getLetter(index)
end

function dispatch.SyncWaypoints(receiver)
	for k, v in pairs(dispatch.waypoints) do
		net.Start("dispatch.waypoint")
			net.WriteTable(v)
		net.Send(receiver)
	end
end

net.Receive("dispatch.waypoint", function(len, client)
	if !dispatch.InDispatchMode(client) then return end

	local type, position = net.ReadString(), net.ReadVector()

	dispatch.AddWaypoint(position, "", type)
end)