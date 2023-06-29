surface.CreateFont("WaypointFont", {
	font = "Blender Pro Bold",
	antialias = true,
	size = 12,
	extended = true
})

surface.CreateFont("WaypointFontSign", {
	font = "Blender Pro Bold",
	antialias = true,
	size = 16,
	extended = true
})

local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local function getLetter(index)
	local letter = ((index -1) % 26) + 1
	local sub = math.floor(letter / 26)

	return letters[letter] .. (sub != 0 and sub or "")
end

local function distToMeters(num)
	return num * 0.0254
end

local icons = {
	gun = {
		mat = Material("cellar/ui/dispatch/ico/gun"),
		color = Color(255, 50, 70)
	},
	death = {
		mat = Material("cellar/ui/dispatch/ico/death"),
		color = Color(200, 64, 64)
	},
	attack = {
		mat = Material("cellar/ui/dispatch/ico/attack"),
		color =  Color(255, 50, 70)
	},
	factory = {
		mat = Material("cellar/ui/dispatch/ico/factory"),
		color =  Color(31, 171, 125),
		text_color = color_white
	},
	hazard = {
		mat = Material("cellar/ui/dispatch/ico/hazard"),
		color =  Color(175, 200, 125),
		text_color = color_white
	},
	protect = {
		mat = Material("cellar/ui/dispatch/ico/protect"),
		color =  Color(0, 225, 255)
	},
	regroup = {
		mat = Material("cellar/ui/dispatch/ico/regroup"),
		color =  Color(0, 225, 255)
	},
	poi = {
		mat = Material("cellar/ui/dispatch/ico/poi"),
		color =  Color(255, 200, 64)
	},
	warn = {
		mat = Material("cellar/ui/dispatch/ico/warn"),
		color = Color(255, 50, 70)
	},
}

local size = 96
local half = 48
local scale = 1

size = math.floor(size * scale)
half = math.floor(half * scale)

local waypoints = dispatch.waypoints or {}
dispatch.waypoints = waypoints or {}

local halfPos = Vector()

function dispatch.DrawWaypoints()
	local clientPos = LocalPlayer():EyePos()
	local scrW, scrH = ScrW(), ScrH()
	halfPos = Vector(scrW / 2, scrH / 2, 0)

	for k, waypoint in pairs(waypoints) do
		if waypoint.time < CurTime() then
			waypoints[k] = nil
			continue
		end

		local info = icons[waypoint.type] or icons.poi
		local screenPos = waypoint.pos:ToScreen()
		local textColor = info.text_color or info.color

		screenPos.x = math.floor(math.Clamp(screenPos.x, half, scrW - half))
		screenPos.y = math.floor(math.Clamp(screenPos.y, half, scrH - half))

		surface.SetDrawColor(info.color)
		surface.SetMaterial(info.mat)
		surface.DrawTexturedRect(screenPos.x - half, screenPos.y - half, size, size)

		if Vector(screenPos.x, screenPos.y, 0):Distance(halfPos) <= half then
			draw.SimpleText(waypoint.text, "WaypointFont", screenPos.x, screenPos.y + half * 0.65 + 5, textColor, TEXT_ALIGN_CENTER)
		end

		draw.SimpleText(getLetter(k), "WaypointFontSign", screenPos.x, math.floor(screenPos.y - (half * 0.65)), textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(math.floor(distToMeters(clientPos:Distance(waypoint.pos))) .. "m", "WaypointFont", screenPos.x, screenPos.y + half * 0.65, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

net.Receive("dispatch.waypoint", function()
	local data = net.ReadTable()

	waypoints[data.index] = data
end)

net.Receive("dispatch.waypoint.fx", function()
	local type, entry = net.ReadString(), net.ReadUInt(4)

	local isLocal = LocalPlayer():IsCombine() and !LocalPlayer():ShouldDrawLocalPlayer()

	if isLocal then
		LocalPlayer():EmitSound(dispatch.snd_waypoints[type][entry], 60, 100, 1, CHAN_VOICE)
	else
		for k, v in ipairs(player.GetAll()) do
			if !v:IsCombine() or v:GetNoDraw() or !v:Alive() then continue end

			v:EmitSound(dispatch.snd_waypoints[type][entry], 60, 100, 1, CHAN_VOICE)
		end
	end
end)