-- Handle leaving the chair

-- Check if they are leaving a chair
hook.Add("KeyPress", "pCasino:ChairLeave", function(ply, key)
	if not (key == IN_USE) then return end

	local chair = ply:GetVehicle()
	if not IsValid(chair) then return end
	if not chair.pCasinoChair then return end

	timer.Create("pCasino:ChairLeave:"..ply:SteamID64(), 1, 1, function()
		if not IsValid(ply) then return end
		ply:ExitVehicle()
	end)
end)
-- Kill the timer if they release the key early
hook.Add("KeyRelease", "pCasino:ChairLeave", function(ply, key)
	if not (key == IN_USE) then return end

	if not timer.Exists("pCasino:ChairLeave:"..ply:SteamID64()) then return end
	timer.Remove("pCasino:ChairLeave:"..ply:SteamID64())
end)
-- Block them from leaving normally
hook.Add("CanExitVehicle", "pCasino:ChairLeave", function(vehicle, ply)
	if not vehicle.pCasinoChair then return end

	return false
end)
-- Apparently you can't use E while in a seat, so we need to spoof it.
hook.Add("KeyPress", "pCasino:SpoofUse", function(ply, key)
	if not (key == IN_USE) then return end

	-- Chair
	local chair = ply:GetVehicle()
	if not IsValid(chair) then return end
	if not chair.pCasinoChair then return end

	local entity = ply:GetEyeTrace().Entity
	if not IsValid(entity) then return end
	if not string.match(entity:GetClass(), "pcasino") then return end -- Only allowed to use pCasino ents with this workaround
	if entity.pCasinoChair or (entity:GetClass() == "pcasino_chair") then return end -- Prevent chair hopping
	if entity:GetPos():DistToSqr(ply:GetPos()) > 25000 then return end

	entity:Use(ply, ply, 1, 0)
end)


-- Free spins
function PerfectCasino.Core.GiveFreeSpin(ply)
	-- Make sure they have an entry in the spins table
	PerfectCasino.Spins[ply:SteamID64()] = PerfectCasino.Spins[ply:SteamID64()] or 0
	-- Give them a free spin
	PerfectCasino.Spins[ply:SteamID64()] = PerfectCasino.Spins[ply:SteamID64()] + 1

	net.Start("pCasino:FreeSpin")
		net.WriteUInt(PerfectCasino.Spins[ply:SteamID64()], 6)
	net.Send(ply)
end
function PerfectCasino.Core.TakeFreeSpin(ply)
	-- Make sure they have an entry in the spins table
	PerfectCasino.Spins[ply:SteamID64()] = PerfectCasino.Spins[ply:SteamID64()] or 0
	-- Give them a free spin
	PerfectCasino.Spins[ply:SteamID64()] = PerfectCasino.Spins[ply:SteamID64()] - 1

	net.Start("pCasino:FreeSpin")
		net.WriteUInt(PerfectCasino.Spins[ply:SteamID64()], 6)
	net.Send(ply)
end

-- Manage multi-use of machines
function PerfectCasino.Core.ManageMultiUse(ply, ent)
	-- This is their first time using a limited machine.
	if not PerfectCasino.MachineLimits[ply:SteamID64()] then
		PerfectCasino.MachineLimits[ply:SteamID64()] = {
			lastUsed = os.time(),
			ent = ent
		}

		return true
	end

	-- Check if the machine is being used by someone else
	local inUse = false
	for k, v in pairs(PerfectCasino.MachineLimits) do
		-- Check if the ents match
		-- Check who is using it
		-- Check when they last used it
		if (v.ent == ent) and (not (k == ply:SteamID64())) and (v.lastUsed + 30 > os.time()) then
			inUse = true
			break
		end
	end

	if inUse then
		return false, PerfectCasino.Translation.Chat.LimitMachineUsedByOther
	end

	local plyData = PerfectCasino.MachineLimits[ply:SteamID64()]

	-- They are just trying to use the same machine as before.
	if ent == plyData.ent then
		return true
	end

	-- They are trying to use a different machine too soon.
	if plyData.lastUsed + 30 > os.time() then
		return false, PerfectCasino.Translation.Chat.LimitMachineUse
	end

	-- They are approved to use a new machine.
	PerfectCasino.MachineLimits[ply:SteamID64()] = {
		lastUsed = os.time(),
		ent = ent
	}

	return true
end

-- Block pocketing any pCasino item
hook.Add("canPocket", "pCasino:PocketBlock", function(ply, ent)
	if not IsValid(ent) then return end
	if not string.match(ent:GetClass(), "pcasino") then return end

	return false -- Block it
end)

-- Converter for Casino Kit
concommand.Add("pcasino_migration_casinokit", function(ply, cmd, args)
	if IsValid(ply) then return end -- This command must be run by console
	if (not args) or (not args[1]) or (not (args[1] == "yes")) then print("You are about to refund all Casino Kit credits back into DarkRP money. This will wipe the Casino Kit chip data, so it is suggested that you make a backup of sv.db (Or atleast the ckit_chips table) before running this command incase something goes wrong. If you are sure, please rerun this command with the argument 'yes'.") return end 
	if not sql.TableExists("ckit_chips") then print("No Casino Kit data found") return end

	local data = sql.Query("SELECT * FROM ckit_chips;")
	if not data then print("No Casino Kit data found, after scraping the database") return end
	
	print("Starting Casino Kit migration")
	local totalAmount = 0
	for k, v in pairs(data) do
		local ply = player.GetBySteamID64(v.sid64)
		local amount = v.amount * 10
		-- For total at the end
		totalAmount = totalAmount + amount

		if IsValid(ply) then -- The player is online
			print(v.sid64, "is online, using appropriate method to prevent override")
			ply:addMoney(v.amount * 10)
		else
			print(v.sid64, "is offline, updating money")
			DarkRP.storeOfflineMoney(v.sid64, v.amount * 10)
		end
	end

	print("Deleting ckit_chips")
	sql.Query("DROP TABLE ckit_chips;")

	print("All Casino Kit credits have been refunded. "..#data.." people were refunded at a total of $"..totalAmount)
end)