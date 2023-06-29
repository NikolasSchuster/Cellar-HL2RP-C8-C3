AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/freeman/owain_slotmachine_wheel.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetAutomaticFrameAdvance(true)
	self:SetPlaybackRate(1)

	self.cacheSeq = {}
	self.cacheSeq['idle'] = self:LookupSequence("idle")
	self.cacheSeq['leverpull'] = self:LookupSequence("handle_pull")
	self.cacheSeq['wheel_needle_spin'] = self:LookupSequence("wheel_needle_spin")
	self:ResetSequence(self.cacheSeq['idle'])

	self.wheels = {}
	for i=0, self:GetNumPoseParameters()-2 do
		self.wheels[i+1] = self:GetPoseParameterName(i)
	end

	self.data = {}
	self.isActive = false
	self.isWaitingWheelSpin = false

end

function ENT:PostData()
	self:GenerateResult() -- Generate the pool in advance, micro optimization :D
	self:SetCurrentJackpot(self.data.jackpot.startValue)
end

function ENT:GenerateResult()
	if not self.pool then
		self.pool = {}
		for k, v in pairs(self.data.chance) do
			for i=1, v do
				table.insert(self.pool, k)
			end
		end
	end

	return table.Random(self.pool)
end
function ENT:CheckForCombo(res1, res2, res3)
	local winData
	for k, v in pairs(self.data.combo) do
		if not (res1 == v.c[1]) and not (v.c[1] == "anything") then continue end -- Match the 1st wheel
		if not (res2 == v.c[2]) and not (v.c[2] == "anything") then continue end -- Match the 2nd wheel
		if not (res3 == v.c[3]) and not (v.c[3] == "anything") then continue end -- Match the last wheel

		if winData then -- Make sure we give the best result
			if tobool(self.data.jackpot.toggle) and winData.j and not v.j then continue end -- If the current win is a jack and the new win isn't, choose the current win
			if tonumber(winData.p) > tonumber(v.p) then continue end -- If the current win pays better, keep it
		end

		winData = v -- Set the new win
	end

	return winData or false
end

function ENT:Think() -- Used so that the animation runs at the correct FPS
	if not self.isActive then return end
	
	self:NextThink(CurTime())
	return true
end

function ENT:Use(ply)
	if self.isActive then return end
	if not ply:IsPlayer() then return end
	if PerfectCasino.Cooldown.Check(self:EntIndex()..":Use", 1, ply) then return end

	if self.data.general and self.data.general.limitUse then
		local allowed, reason = PerfectCasino.Core.ManageMultiUse(ply, self)
		if not allowed then
			PerfectCasino.Core.Msg(reason, ply)
			return
		end
	end
	
	if self.isWaitingWheelSpin then
		self:StartSpin(self.isWaitingWheelSpin)
	else
		self:StartRound(ply)
	end
end


local resultCache = {}
resultCache["gold"] = 0
resultCache["vault"] = 1
resultCache["coin"] = 2
resultCache["bar"] = 3
resultCache["bag"] = 4
resultCache["emerald"] = 5
resultCache["chest"] = 6
resultCache["coins"] = 7

local snap = 360/table.Count(resultCache)
-- Game specific code
function ENT:StartRound(ply)
	PerfectCasino.Sound.Stop(self, "wheel_slotmachine_stop3")

	if not PerfectCasino.Config.CanAfford(ply, self.data.bet.default) then
		PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.NoMoney, ply)
		return
	end

	-- Take the money
	PerfectCasino.Config.AddMoney(ply, -self.data.bet.default)
	hook.Run("pCasinoOnWheelSlotMachineBet", ply, self, self.data.bet.default)
	-- Add to the jackpot
	if tobool(self.data.jackpot.toggle) then
		self:SetCurrentJackpot(self:GetCurrentJackpot() + (self.data.bet.default * self.data.jackpot.betAdd))
	end

	-- Make it so the machine can't be used while the wheels are spinning 
	self.isActive = true

	-- Figure out the reward
	local results = {}
	for i = 1, 3 do
		results[i] = self:GenerateResult()
	end

	results.suspense = results[1] == results[2]  -- Add hanging suspense on the last wheel

	local win = self:CheckForCombo(results[1], results[2], results[3])

	-- Run the pull animation
	self:ResetSequence(self.cacheSeq['leverpull'])
	timer.Simple(0.5, function()
		if not IsValid(self) then return end
		PerfectCasino.Sound.Play(self, "other_lever")
	end)
	-- Reset it after it's done
	timer.Simple(self:SequenceDuration(self.cacheSeq['leverpull']), function()
		if not IsValid(self) then return end
		self:ResetSequence(self.cacheSeq['idle'])
		PerfectCasino.Sound.Stop(self, "other_lever")

		for k, v in pairs(self.wheels) do
			-- Set the wheels end point
			local angleResult = (resultCache[results[k]] * snap)
			self:SetPoseParameter(v, angleResult)
		end
	end)

	-- A small delay for effect
	timer.Simple(1, function()
		if not IsValid(self) then return end
		net.Start("pCasino:WheelSlot:Spin:Start")
			net.WriteEntity(self)
		net.SendPVS(self:GetPos())
		PerfectCasino.Sound.Play(self, "other_slot_spin")

		for i=1, 3 do
			timer.Simple(i, function()
				if not IsValid(self) then return end

				self:WheelStop(i, results)

				if not (i == 3) then return end -- What to do after the final wheel has finished spinning

				self:EndRound(ply, win, results)
			end)
		end
	end)
end

function ENT:WheelStop(i, results)
	net.Start("pCasino:WheelSlot:Spin:Stop")
		net.WriteEntity(self)
		net.WriteUInt(i, 2)
		net.WriteString(results[i])
	net.Broadcast()

	-- Stop the previous stop sound
	PerfectCasino.Sound.Stop(self, "wheel_slotmachine_stop"..(i-1))

	PerfectCasino.Sound.Play(self, "wheel_slotmachine_stop"..i)
end


function ENT:EndRound(ply, win, results)
	PerfectCasino.Sound.Stop(self, "other_slot_spin")

	if not win then
		if results.suspense then
			PerfectCasino.Sound.Play(self, "basic_slotmachine_fail")
			timer.Simple(1, function()
				if not IsValid(self) then return end
				PerfectCasino.Sound.Stop(self, "basic_slotmachine_fail")
			end)
		end
	
		hook.Run("pCasinoOnWheelSlotMachineLoss", ply, self, self.data.bet.default)
		self.isActive = false
		return
	end
	
	-- Tell the user that they won
	net.Start("pCasino:WheelSlot:Spin:Win")
		net.WriteEntity(self)
		net.WriteTable(win)
	net.SendPVS(self:GetPos())
	
	-- They've won, but it's not the wheel
	if not tobool(win.j) then
		-- Give the user their winnings
		local baseWinnings = self.data.bet.default + (self.data.bet.default*tonumber(win.p))
		PerfectCasino.Config.AddMoney(ply, baseWinnings)
		hook.Run("pCasinoOnWheelSlotMachinePayout", ply, self, baseWinnings)
		if not (baseWinnings == self.data.bet.default) then
			PerfectCasino.Core.Msg(string.format(PerfectCasino.Translation.Chat.Payout, PerfectCasino.Config.FormatMoney(self.data.bet.default + (self.data.bet.default*tonumber(win.p)))), ply)
		end
		-- Play the win sound
		PerfectCasino.Sound.Play(self, "basic_slotmachine_win")
		-- Wait a moment before resetting
		timer.Simple(2, function()
			if not IsValid(self) then return end
			-- Rest the ability to use it
			self.isActive = false
			-- Stop the sound
			PerfectCasino.Sound.Stop(self, "basic_slotmachine_win")
		end)
	else
		PerfectCasino.Sound.Play(self, "wheel_slotmachine_jackpot_voice")
		-- Prep for a wheel spin
		self.isWaitingWheelSpin = ply
		self.isActive = false
	end
end

function ENT:StartSpin(ply)
	self.isActive = true
	-- Play the wheel spinning music
    timer.Simple(1.1, function()
        PerfectCasino.Sound.Play(self, "wheel_slotmachine_jackpot")
    end)
	local result = math.random(12)
	local winData = self.data.wheel[result]
	self:ResetSequence(self.cacheSeq['wheel_needle_spin'])

	net.Start("pCasino:WheelSlot:Spin:Spin")
		net.WriteEntity(self)
	net.SendPVS(self:GetPos())

	timer.Simple(2, function()
		if not IsValid(self) then return end
		self:SetPoseParameter("mysterywheel_pointer_rotate", result-1)
	end)
	-- Spin the wheel
	timer.Simple(self:SequenceDuration(self.cacheSeq['wheel_needle_spin']), function()
		if not IsValid(self) then return end

		local customMsg = PerfectCasino.Config.RewardsFunctions[winData.f](ply, self, winData.i)
		PerfectCasino.Core.Msg(customMsg or string.format(PerfectCasino.Translation.Chat.SlotWheelSpin, winData.n), ply)

		-- Reset the ability to use the wheel
		self.isWaitingWheelSpin = false
		self.isActive = false
	end)
end
