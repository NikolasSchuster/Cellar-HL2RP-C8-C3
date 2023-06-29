AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/freeman/owain_slotmachine.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetAutomaticFrameAdvance(true)
	self:SetPlaybackRate(1)

	self.cacheSeq = {}
	self.cacheSeq['idle'] = self:LookupSequence("idle")
	self.cacheSeq['leverpull'] = self:LookupSequence("leverpull")
	self:ResetSequence(self.cacheSeq['idle'])

	self.data = {}
	self.isActive = false
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

	local cid = ply:GetCharacter():GetIDCard()

	if cid then 
		local accesses = cid:GetData("access", {})

		if accesses["CASINO"] then
			return
		end
	end

	if self.data.general and self.data.general.limitUse then
		local allowed, reason = PerfectCasino.Core.ManageMultiUse(ply, self)
		if not allowed then
			PerfectCasino.Core.Msg(reason, ply)
			return
		end
	end

	self:StartRound(ply)
end

function ENT:OnSelectPlay(ply)
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

	self:StartRound(ply)
end

function ENT:OnSelectDeposit(client, amount)
	amount = tonumber(amount) or 0

	if amount <= 0 then
		return
	end

	local character = client:GetCharacter()
	local cid = character:GetIDCard()

	if !cid then 
		return
	end

	local accesses = cid:GetData("access", {})

	if !accesses["CASINO"] then
		return
	end

	if !character:HasMoney(amount) then
		return
	end

	character:TakeMoney(amount)
	self:SetCurrentJackpot(self:GetCurrentJackpot() + amount)

	PerfectCasino.Core.Msg(string.format("Вы внесли %s!", PerfectCasino.Config.FormatMoney(amount)), client)
end

function ENT:OnSelectWithdraw(client, amount)
	amount = tonumber(amount) or 0

	if amount <= 0 then
		return
	end

	local character = client:GetCharacter()
	local cid = character:GetIDCard()

	if !cid then 
		return
	end

	local accesses = cid:GetData("access", {})

	if !accesses["CASINO"] then
		return
	end

	local current = self:GetCurrentJackpot()
	local money = current - math.max(current - amount, 0)

	character:GiveMoney(money)
	self:SetCurrentJackpot(current - money)

	PerfectCasino.Core.Msg(string.format("Вы сняли %s!", PerfectCasino.Config.FormatMoney(money)), client)
end

-- Game specific code
local buffer = 0 -- Add a buffer on the timer for stopping the wheel
function ENT:StartRound(ply)
	PerfectCasino.Sound.Stop(self, "basic_slotmachine_stop3")

	if not PerfectCasino.Config.CanAfford(ply, self.data.bet.default) then
		PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.NoMoney, ply)
		return
	end

	-- Take the money
	PerfectCasino.Config.AddMoney(ply, -self.data.bet.default)
	hook.Run("pCasinoOnBasicSlotMachineBet", ply, self, self.data.bet.default)
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
		results.suspense = results[1] == results[2] -- Add hanging suspense on the last wheel

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
	end)

	-- A small delay for effect
	timer.Simple(1, function()
		if not IsValid(self) then return end
		net.Start("pCasino:BasicSlot:Spin:Start")
			net.WriteEntity(self)
		net.SendPVS(self:GetPos())
		PerfectCasino.Sound.Play(self, "other_slot_spin")

		for i=1, 3 do
			timer.Simple(buffer + (((i == 3) and results.suspense) and i+2 or i), function()
				if not IsValid(self) then return end

				self:WheelStop(i, results)

				if not (i == 3) then return end -- What to do after the final wheel has finished spinning

				self:EndRound(ply, win, results)
			end)
		end
	end)
end


function ENT:WheelStop(i, results)
	net.Start("pCasino:BasicSlot:Spin:Stop")
		net.WriteEntity(self)
		net.WriteUInt(i, 2)
		net.WriteString(results[i])
	net.Broadcast()

	-- Stop the previous stop sound
	PerfectCasino.Sound.Stop(self, "basic_slotmachine_stop"..(i-1))

	if (not (i == 3)) or ((not win) and (not results.suspense)) then
		PerfectCasino.Sound.Play(self, "basic_slotmachine_stop"..i)
	end

	if results.suspense and (i == 2) then -- Play the suspense sound over the final plop
		PerfectCasino.Sound.Play(self, "basic_slotmachine_suspense")
	end
end

function ENT:EndRound(ply, win, results)
	PerfectCasino.Sound.Stop(self, "basic_slotmachine_suspense")
	PerfectCasino.Sound.Stop(self, "other_slot_spin")

	if not win then
		if results.suspense then
			PerfectCasino.Sound.Play(self, "basic_slotmachine_fail")
			timer.Simple(1, function()
				if not IsValid(self) then return end
				PerfectCasino.Sound.Stop(self, "basic_slotmachine_fail")
			end)
		end
	
		hook.Run("pCasinoOnBasicSlotMachineLoss", ply, self, self.data.bet.default)

		self.isActive = false
		return
	end
	
	-- Tell the user that they won
	net.Start("pCasino:BasicSlot:Spin:Win")
		net.WriteEntity(self)
		net.WriteTable(win)
	net.SendPVS(self:GetPos())
	
	-- Give the user their winnings

	local baseWinnings = self.data.bet.default + (self.data.bet.default*tonumber(win.p))
	local winning = self:GetCurrentJackpot() - math.max(self:GetCurrentJackpot() - baseWinnings, 0)

	PerfectCasino.Config.AddMoney(ply, winning)

	self:SetCurrentJackpot(math.max(self:GetCurrentJackpot() - winning, 0))

	hook.Run("pCasinoOnBasicSlotMachinePayout", ply, self, winning)
	if not (baseWinnings == self.data.bet.default) then
		PerfectCasino.Core.Msg(string.format(PerfectCasino.Translation.Chat.Payout, PerfectCasino.Config.FormatMoney(winning)), ply)
	end
	
	if tobool(self.data.jackpot.toggle) and tobool(win.j) then
		PerfectCasino.Config.AddMoney(ply, self:GetCurrentJackpot())
		hook.Run("pCasinoOnBasicSlotMachineJackpot", ply, self, self:GetCurrentJackpot())
		PerfectCasino.Core.Msg(string.format(PerfectCasino.Translation.Chat.PayoutJackpot, PerfectCasino.Config.FormatMoney(self:GetCurrentJackpot())), ply)
		self:SetCurrentJackpot(0)
	end
	
	-- Play the win sound
	if tobool(self.data.jackpot.toggle) and tobool(win.j) then -- Play special jackpot sound
		PerfectCasino.Sound.Play(self, "basic_slotmachine_jackpot")
	else
		PerfectCasino.Sound.Play(self, "basic_slotmachine_win")
	end
	
	-- Wait till the client side win stuff is done before letting the machine be used again
	timer.Simple((tobool(self.data.jackpot.toggle) and tobool(win.j)) and 5 or 2, function()
		if not IsValid(self) then return end
		self.isActive = false
		if tobool(self.data.jackpot.toggle) and tobool(win.j) then
			PerfectCasino.Sound.Stop(self, "basic_slotmachine_jackpot")
		else
			PerfectCasino.Sound.Stop(self, "basic_slotmachine_win")
		end
	
		-- Wait a second before resetting the jackpot, for effect
		if tobool(self.data.jackpot.toggle) and tobool(win.j) then
			self:SetCurrentJackpot(self.data.jackpot.startValue)
		end
	end)
end