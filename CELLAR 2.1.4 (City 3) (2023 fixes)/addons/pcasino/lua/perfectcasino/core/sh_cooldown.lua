-- A cooldown lib I stole from my community's lib
PerfectCasino.Cooldown.Timers = PerfectCasino.Cooldown.Timers or {}

function PerfectCasino.Cooldown.Check(id, time, ply)
	if not id then return true end
	if not time then return true end

	if not PerfectCasino.Cooldown.Timers[id] then
		PerfectCasino.Cooldown.Timers[id] = {}
		PerfectCasino.Cooldown.Timers[id].global = 0
	end

	if ply then
		if not PerfectCasino.Cooldown.Timers[id][ply:SteamID64()] then
			PerfectCasino.Cooldown.Timers[id][ply:SteamID64()] = 0
		end

		if PerfectCasino.Cooldown.Timers[id][ply:SteamID64()] > CurTime() then return true end

		PerfectCasino.Cooldown.Timers[id][ply:SteamID64()] = CurTime() + time

		return false
	else
		if PerfectCasino.Cooldown.Timers[id].global > CurTime() then return true end

		PerfectCasino.Cooldown.Timers[id].global = CurTime() + time

		return false
	end
end

function PerfectCasino.Cooldown.Get(id, ply)
	if not id then return 0 end
	if not time then return 0 end

	if not PerfectCasino.Cooldown.Timers[id] then return 0 end

	-- The correct returns
	if ply and PerfectCasino.Cooldown.Timers[id][ply:SteamID64()] then return PerfectCasino.Cooldown.Timers[id][ply:SteamID64()] end
	if not ply and PerfectCasino.Cooldown.Timers[id].global then return PerfectCasino.Cooldown.Timers[id].global end

	-- Failsafe
	return 0
end


function PerfectCasino.Cooldown.Reset(id, ply)
	if not id then return end

	if not PerfectCasino.Cooldown.Timers[id] then return end

	if ply then
		if not PerfectCasino.Cooldown.Timers[id][ply:SteamID64()] then return end
		PerfectCasino.Cooldown.Timers[id][ply:SteamID64()] = 0
	else
		PerfectCasino.Cooldown.Timers[id].global = 0
	end
end