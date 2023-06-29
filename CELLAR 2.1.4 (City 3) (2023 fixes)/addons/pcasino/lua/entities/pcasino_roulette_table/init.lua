AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/freeman/owain_roulette_table.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetAutomaticFrameAdvance(true)
	self:SetPlaybackRate(1)

	self.cacheSeq = {}
	self.cacheSeq['idle'] = self:LookupSequence("idle")
	self.cacheSeq['wheel_spin'] = self:LookupSequence("wheel_spin")
	self:SetSequence(self.cacheSeq['idle'])

	self:SetLastRoundNumber(-1)
	self:SetStartRoundIn(-1)

	self.currentBetAmounts = {}
	self.activeBets = {}
	self.data = {}
	self.isActive = false
	self.timerStarted = false
end

function ENT:PostData()
	if not self.isActive then return end
	
	self:GetCurrentPad(Vector(0, 0, 0)) -- To force generate the cache
end

function ENT:Think() -- Used so that the animation runs at the correct FPS
	self:NextThink(CurTime())

	return true
end

function ENT:Use(ply)
	if self.isActive then return end
	if not ply:IsPlayer() then return end
	if PerfectCasino.Cooldown.Check(self:EntIndex()..":Use", 0.5, ply) then return end

	local pos = self:WorldToLocal(ply:GetEyeTrace().HitPos)
	local button = self:GetCurrentPad(pos)
	if not button then return end -- They're not looking at anything :/

	if button == "bet_lower" then
		self:ChangeBet(ply, -self.data.bet.iteration)
		return
	elseif  button == "bet_raise" then
		self:ChangeBet(ply, self.data.bet.iteration)
		return
	end

	self:PlaceBet(ply, button)
--	PerfectCasino.Core.Msg(string.format(PerfectCasino.Translation.Chat.RouletteBetPlaced, self.data.general.betPeriod - (CurTime() - (self.timerStarted or CurTime()))), ply)

	if not self.timerStarted then
		timer.Simple(self.data.general.betPeriod, function()
			if not IsValid(self) then return end
			self:StartRound()
		end)
		self.timerStarted = true
		self:SetStartRoundIn(os.time())
	end
end

local function canAccessBank(ent, client)
	local cid = client:GetCharacter():GetIDCard()

	if !cid then 
		return
	end

	local accesses = cid:GetData("access", {})

	if !accesses["CASINO"] then
		return
	end

	local pos = ent:WorldToLocal(client:GetEyeTrace().HitPos)
	local button = ent:GetCurrentPad(pos)
	
	if !button then
		return true
	end
end

function ENT:OnSelectDeposit(client, amount)
	amount = tonumber(amount) or 0

	if amount <= 0 then
		return
	end

	local character = client:GetCharacter()

	if !canAccessBank(self, client) or !character:HasMoney(amount) then
		return
	end

	character:TakeMoney(amount)
	self:SetStoredMoney(self:GetStoredMoney() + amount)

	PerfectCasino.Core.Msg(string.format("Вы внесли %s!", PerfectCasino.Config.FormatMoney(amount)), client)
end

function ENT:OnSelectWithdraw(client, amount)
	amount = tonumber(amount) or 0

	if amount <= 0 then
		return
	end

	local character = client:GetCharacter()

	if !canAccessBank(self, client) then
		return
	end

	local current = self:GetStoredMoney()
	local money = current - math.max(current - amount, 0)

	character:GiveMoney(money)
	self:SetStoredMoney(current - money)

	PerfectCasino.Core.Msg(string.format("Вы сняли %s!", PerfectCasino.Config.FormatMoney(money)), client)
end

-- As the pose par IDs don't match the numbers they land on, we need to manually map the wheel order
local wheelOrder = {23, 6, 35, 4, 19, 10, 31, 16, 27, 18, 14, 33, 12, 25, 2, 21, 8, 29, 3, 24, 5, 28, 17, 20, 7, 36, 11, 32, 30, 15, 26, 1, 22, 9, 34, 13}
wheelOrder[0] = 0 -- We map 0 manually as defining it in the table starts at 1
function ENT:StartRound()
	self.isActive = true
	self.winningNumber = math.random(0, 36)

	self:SetPoseParameter("roulette_wheel_changenumber", wheelOrder[self.winningNumber])
	self:ResetSequence(self.cacheSeq['wheel_spin'])

	self:SetLastRoundNumber(-1)
	self:SetStartRoundIn(-1)

	PerfectCasino.Sound.Play(self:GetPos() + (self:GetUp() * 15) + (self:GetForward() * 10) + (self:GetRight() * 40), "other_spin")

	timer.Simple(self:SequenceDuration(self.cacheSeq['wheel_spin']), function()
		if not IsValid(self) then return end
		self:EndRound()
	end)
end

function ENT:EndRound()
	self.isActive = false
	self.timerStarted = false

	self:PayoutBets()
	self.activeBets = {}

	self:SetLastRoundNumber(self.winningNumber)

	self:SetSequence("idle")
	
	PerfectCasino.Sound.Stop(self, "other_spin")

	net.Start("pCasino:Roulette:Bet:Clear")
		net.WriteEntity(self)
	net.Broadcast()
end

-- Bet functions
function ENT:PlaceBet(ply, pad)
	local betAmount = self.currentBetAmounts[ply:SteamID64()] or self.data.bet.default

	if not PerfectCasino.Config.CanAfford(ply, betAmount) then
		PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.NoMoney, ply)
		return
	end

	if self.data.bet.betLimit and not (tonumber(self.data.bet.betLimit) == 0) then
		if self.activeBets[ply:SteamID64()] then
			local betTotal = 0
			for k, v in pairs(self.activeBets[ply:SteamID64()]) do
				betTotal = betTotal + v
			end

			if tonumber(betTotal) >= tonumber(self.data.bet.betLimit) then
				PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.BetLimit, ply)
				return
			elseif (betTotal + betAmount) > tonumber(self.data.bet.betLimit) then
				PerfectCasino.Core.Msg(string.format(PerfectCasino.Translation.Chat.WillReachBetLimit, PerfectCasino.Config.FormatMoney(self.data.bet.betLimit - betTotal)), ply)
				return
			end
		end
	end

	PerfectCasino.Config.AddMoney(ply, -betAmount)
	self:SetStoredMoney(self:GetStoredMoney() + betAmount)
	hook.Run("pCasinoOnRouletteBet", ply, self, betAmount)

	self.activeBets[ply:SteamID64()] = self.activeBets[ply:SteamID64()] or {}
	self.activeBets[ply:SteamID64()][pad] = (self.activeBets[ply:SteamID64()][pad] or 0) + betAmount 

	PerfectCasino.Sound.Play(self, "chip"..math.random(1, 2))

	net.Start("pCasino:Roulette:Bet:Place")
		net.WriteEntity(self)
		net.WriteString(pad)
		net.WriteUInt(betAmount, 32)
	net.SendPVS(self:GetPos())
end

function ENT:ChangeBet(ply, newBet)
	self.currentBetAmounts[ply:SteamID64()] = self.currentBetAmounts[ply:SteamID64()] or self.data.bet.default

	self.currentBetAmounts[ply:SteamID64()] = math.Clamp(self.currentBetAmounts[ply:SteamID64()] + newBet, self.data.bet.min, self.data.bet.max)

	-- The bet has not changed, no need to network it
	if self.currentBetAmounts[ply:SteamID64()] == (self.currentBetAmounts[ply:SteamID64()] + newBet) then return end

	-- Network the new bet
	net.Start("pCasino:Roulette:Bet:Change")
		net.WriteEntity(self)
		net.WriteUInt(self.currentBetAmounts[ply:SteamID64()], 32)
	net.Send(ply)
end

function ENT:PayoutBets()
	if not self.winningNumber then return end

	local winningPads = self:GetPadsFromNumber(self.winningNumber)

	local padCache = {}
	for k, v in pairs(self.activeBets) do
		local ply = player.GetBySteamID64(k)
		if not ply then continue end -- Player has disconnected before bet has ended.

		-- Calculate the total winnings from this round
		local winnings = 0
		local totalBet = 0
		for n, m in pairs(v) do
			totalBet = totalBet + m
			if table.HasValue(winningPads, n) then
				local padData, _ = padCache[n], nil
				if not padData then -- would do a and b or c but GetPadByName returns 2 values :/
					_, padData = self:GetPadByName(n)
					padCache[n] = padData
				end
				
				winnings = winnings + m + (m*padData.payout)
			end
		end

		if winnings == 0 then
			PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.RouletteFail, ply)
			hook.Run("pCasinoOnRouletteLoss", ply, self, totalBet)
		else
			local winning = self:GetStoredMoney() - math.max(self:GetStoredMoney() - winnings, 0)

			PerfectCasino.Config.AddMoney(ply, winning)

			self:SetStoredMoney(math.max(self:GetStoredMoney() - winning, 0))
			hook.Run("pCasinoOnRoulettePayout", ply, self, winnings)

			if winning <= 0 then
				PerfectCasino.Core.Msg(string.format("У казино нет средств, чтобы оплатить ваш выигрыш %s!", PerfectCasino.Config.FormatMoney(winnings)), ply)
			elseif winning == winnings then
				PerfectCasino.Core.Msg(string.format(PerfectCasino.Translation.Chat.Payout, PerfectCasino.Config.FormatMoney(winnings)), ply)
			else
				PerfectCasino.Core.Msg(string.format("Вы выиграли лишь %s. Казино не смогло оплатить оставшиеся %s!", PerfectCasino.Config.FormatMoney(winnings), PerfectCasino.Config.FormatMoney(winnings - winning)), ply)
			end
		end
	end
end
