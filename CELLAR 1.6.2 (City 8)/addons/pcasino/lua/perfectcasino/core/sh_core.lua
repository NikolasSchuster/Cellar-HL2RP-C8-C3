-- The letters bodygroup and width
PerfectCasino.Core.Letter = {
	["a"] = {b = 0, w = 5},
	["b"] = {b = 1, w = 4},
	["c"] = {b = 2, w = 4.2},
	["d"] = {b = 3, w = 4.5},
	["e"] = {b = 4, w = 3.7},
	["f"] = {b = 5, w = 3.6},
	["g"] = {b = 6, w = 5},
	["h"] = {b = 7, w = 5},
	["i"] = {b = 8, w = 2},
	["j"] = {b = 9, w = 3.2},
	["k"] = {b = 10, w = 4.7},
	["l"] = {b = 11, w = 3.7},
	["m"] = {b = 12, w = 6},
	["n"] = {b = 13, w = 5},
	["o"] = {b = 14, w = 5},
	["p"] = {b = 15, w = 4},
	["q"] = {b = 16, w = 5},
	["r"] = {b = 17, w = 4.7},
	["s"] = {b = 18, w = 4},
	["t"] = {b = 19, w = 4.5},
	["u"] = {b = 20, w = 4.5},
	["v"] = {b = 21, w = 5.2},
	["w"] = {b = 22, w = 7.3},
	["x"] = {b = 23, w = 5},
	["y"] = {b = 24, w = 4.7},
	["z"] = {b = 25, w = 4.6},
	["0"] = {b = 26, w = 4.2},
	["1"] = {b = 27, w = 3},
	["2"] = {b = 28, w = 4},
	["3"] = {b = 29, w = 3.8},
	["4"] = {b = 30, w = 4.4},
	["5"] = {b = 31, w = 3.8},
	["6"] = {b = 32, w = 4.1},
	["7"] = {b = 33, w = 4.1},
	["8"] = {b = 34, w = 4.2},
	["9"] = {b = 35, w = 4.1},
	["-"] = {b = 36, w = 2.7},
	["!"] = {b = 37, w = 2},
	["."] = {b = 38, w = 2.3}
}

-- Who has "admin" perms
function PerfectCasino.Core.Access(user)
	if not IsValid(user) then return false end
	return PerfectCasino.Config.AccessGroups[user:GetUserGroup()] or PerfectCasino.Config.AccessGroups[user:SteamID64()] or PerfectCasino.Config.AccessGroups[user:SteamID()]
end

-- Chat messages
function PerfectCasino.Core.Msg(msg, ply)
	if SERVER then
		net.Start("pCasino:Msg")
			net.WriteString(msg)
		if not ply then
			net.Broadcast()
		else
			net.Send(ply)
		end
	else
		chat.AddText(Color(100, 185, 100), ix.util.GetMaterial("cellar/chat/roll.png"), msg)
	end
end


if SERVER then return end

net.Receive("pCasino:Msg", function()
	PerfectCasino.Core.Msg(net.ReadString())
end)

