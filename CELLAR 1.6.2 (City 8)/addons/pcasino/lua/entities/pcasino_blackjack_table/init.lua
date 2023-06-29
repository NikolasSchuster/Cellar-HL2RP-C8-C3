AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
 
local preset = {
	{p = 0.95, a = 35},
	{p = 0, a = 16},
	{p = 0, a = -16},
	{p = 0.95, a = -35},
}
function ENT:Initialize()
	self:SetModel("models/freeman/owain_blackjack_table.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetPos(self:GetPos() + (self:GetUp() * 20))

	self:DropToFloor()

	self.panels = {}
	for i=1, 4 do
		local panel = ents.Create("pcasino_blackjack_panel")
		self.panels[i] = panel
		panel.order = i
		panel:SetParent(self)

		panel:SetPos(self:GetPos() + (self:GetUp() * 30) + ((self:GetForward() * 16) + ((self:GetForward() * -10) * preset[i].p)) + ((self:GetRight() * -20) * (i - 2.5)))

		local ang = self:GetAngles()

		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 90)	
		ang:RotateAroundAxis(ang:Right(), preset[i].a)

		panel:SetAngles(ang)

		panel:Spawn()
		panel.table = self
	end

	self:SetStartRoundIn(-1)

	self.currentBetAmounts = {}
	self.activeBets = {}
	self.data = {}
	self.isActive = false
	self.timerStarted = false

end

function ENT:PostData()
end

function ENT:Use(ply)
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

	return true
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

function ENT:StartRound()
	self.isActive = true
	self:SetStartRoundIn(-1)
	self.curHands = {}

	-- Build the players hands 
	for k, v in pairs(self.panels) do
		if v:GetStage() == 1 then
			v:SetStage(0) -- No one is playing at this station
		else
			-- Player left after placing the bet
			local ply = v:GetUser()
			if not IsValid(ply) then
				v:SetStage(0)
				continue
			end

			self.curHands[k] = {}
			self.curHands[k][1] = { -- As users can have more than 1 hand, we only assume they have 1 for now
				finished = false,
				cards = {PerfectCasino.Cards:GetRandom(), PerfectCasino.Cards:GetRandom()},
				ply = ply,
				bet = self.activeBets[ply:SteamID64()]
			}
		end
	end

	-- Build the dealer's hand
	self.dealerHand = {PerfectCasino.Cards:GetRandom()} -- He only needs 1 card for now as he receives the rest at the end of the game.

	-- Network everyone's cards to the clients. Maybe do it 1 by one or some shit like that?
	net.Start("pCasino:Blackjack:StartingCards")
		net.WriteEntity(self)
		net.WriteTable(self.curHands)
		net.WriteTable(self.dealerHand)
	net.SendPVS(self:GetPos())

	-- Card placing sound
	PerfectCasino.Sound.Play(self, "card"..math.random(1, 4))

	-- Get the first person's turn
	self:EndTurn() -- If we run EndTurn on nothing, it will initiate the next turn.
end

function ENT:EndRound()
	-- Get the dealer to a value of 17 or more
	while PerfectCasino.Cards:GetHandValue(self.dealerHand) < 17 do
		table.insert(self.dealerHand, PerfectCasino.Cards:GetRandom())
	end

	-- Network the dealer's cards
	net.Start("pCasino:Blackjack:DealerCards")
		net.WriteEntity(self)
		net.WriteTable(self.dealerHand)
	net.SendPVS(self:GetPos())

	-- The sounds for placing of cards
	for i=1, (#self.dealerHand - 1) do
		timer.Simple(i - 1, function()
			PerfectCasino.Sound.Play(self, "card"..math.random(1, 4))
		end)
	end


	-- A small buffer so you have time to process what happened
	timer.Simple(3 + (#self.dealerHand - 2), function()
		-- Payout the winners
		self:PayoutBets()

		-- Reset everything
		self.isActive = false
		self.activeBets = {}
		self.timerStarted = false
		for k, v in pairs(self.panels) do
			v:SetStage(1) -- Set the pad back to the betting stage
			v:SetUser(NULL)
		end
	
		-- Reset everything
		net.Start("pCasino:Blackjack:Clear")
			net.WriteEntity(self)
		net.Broadcast()
	end)
end

function ENT:FindNextTurn()
	for i=4, 1, -1 do
		if not self.curHands[i] then continue end -- This pad has no user playing
		for k, v in ipairs(self.curHands[i]) do -- Loop all this user's hands and see if they have a hand waiting
			if v.finished then continue end -- This hand has already been played

			return i, k -- This is the next valid hand
		end
	end

	return false
end

function ENT:PromptTurn(pad, hand)
	local padEnt = self.panels[pad]
	padEnt:SetStage(3)
	padEnt:SetHand(hand)

	timer.Create("pCasino:Blackjack:Timeout:"..self:EntIndex(), tonumber(self.data.turn.timeout), 1, function()
		if not IsValid(self) then return end

		self:EndTurn(pad, hand)
	end)
end


function ENT:EndTurn(pad, hand)
	if pad and hand then
		self.curHands[pad][hand].finished = true
		self.panels[pad]:SetStage(2)
	end
	
	timer.Remove("pCasino:Blackjack:Timeout:"..self:EntIndex())
	local curTurnPad, curTurnHand = self:FindNextTurn()
	if not curTurnPad then
		self:EndRound()
		return
	end

	self:PromptTurn(curTurnPad, curTurnHand)
end

function ENT:TurnAction(pad, action)
	local curTurnPad, curTurnHand = self:FindNextTurn()
	local handData = self.curHands[curTurnPad][curTurnHand]

	if not (pad.order == curTurnPad) then return end -- Not this pads turn

	if action == "doubledown" then
		if #handData.cards > 2 then return end -- This is not their first move, a double down is illegal

		-- Check if they can even afford to double down
		if not PerfectCasino.Config.CanAfford(handData.ply, handData.bet) then
			PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.NoMoney, handData.ply)
			return
		end
	
		-- Take the money
		PerfectCasino.Config.AddMoney(handData.ply, -handData.bet)
		self:SetStoredMoney(self:GetStoredMoney() + handData.bet)

		hook.Run("pCasinoOnBlackjackBet", handData.ply, self, handData.bet)
		-- Add the chips
		net.Start("pCasino:Blackjack:Bet:Place")
			net.WriteEntity(self)
			net.WriteUInt(curTurnPad, 3)
			net.WriteUInt(handData.bet, 32)
		net.SendPVS(self:GetPos())


		-- Double the bet
		handData.bet = handData.bet*2

		-- Give them another card
		local newCard = PerfectCasino.Cards:GetRandom()
		table.insert(handData.cards, newCard)

		-- Network the new card, newCard
		net.Start("pCasino:Blackjack:NewCard")
			net.WriteEntity(self)
			net.WriteUInt(curTurnPad, 3)
			net.WriteUInt(curTurnHand, 3)
			net.WriteString(newCard)
		net.SendPVS(self:GetPos())

		-- Card placing sound
		PerfectCasino.Sound.Play(self, "card"..math.random(1, 4))

		-- End this hands turn
		self:EndTurn(curTurnPad, curTurnHand)
	elseif action == "split" then
		if #handData.cards > 2 then return end -- This is not their first move, a double down is illegal
		if not handData.cards[2] then return end
		if not (PerfectCasino.Cards:GetValue(handData.cards[1]) == PerfectCasino.Cards:GetValue(handData.cards[2])) then return end -- Check if the cards are the same value

		-- Check if they can even afford to split
		if not PerfectCasino.Config.CanAfford(handData.ply, handData.bet) then
			PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.NoMoney, handData.ply)
			return
		end
	
		-- Take the money
		PerfectCasino.Config.AddMoney(handData.ply, -handData.bet)
		self:SetStoredMoney(self:GetStoredMoney() + handData.bet)

		hook.Run("pCasinoOnBlackjackBet", handData.ply, self, handData.bet)

		-- Add the chips
		net.Start("pCasino:Blackjack:Bet:Place")
			net.WriteEntity(self)
			net.WriteUInt(curTurnPad, 3)
			net.WriteUInt(handData.bet, 32)
		net.SendPVS(self:GetPos())

		-- Create the 2nd hand
		table.insert(self.curHands[curTurnPad], { -- Add a new hand
			finished = false,
			cards = {handData.cards[2]},
			ply = handData.ply,
			bet = handData.bet
		})

		-- Remove the 2nd card from the current hand
		handData.cards[2] = nil

		-- Network the entire new pad
		net.Start("pCasino:Blackjack:Split")
			net.WriteEntity(self)
			net.WriteUInt(curTurnPad, 3)
			net.WriteTable(self.curHands[curTurnPad])
		net.SendPVS(self:GetPos())

		-- Card placing sound
		PerfectCasino.Sound.Play(self, "card"..math.random(1, 4))
	elseif action == "hit" then
		-- Give them another card
		local newCard = PerfectCasino.Cards:GetRandom()
		table.insert(handData.cards, newCard)

		-- Network the new card, newCard
		net.Start("pCasino:Blackjack:NewCard")
			net.WriteEntity(self)
			net.WriteUInt(curTurnPad, 3)
			net.WriteUInt(curTurnHand, 3)
			net.WriteString(newCard)
		net.SendPVS(self:GetPos())

		-- Card placing sound
		PerfectCasino.Sound.Play(self, "card"..math.random(1, 4))

		-- End this hands turn
		if PerfectCasino.Cards:GetHandValue(handData.cards) >= 21 then
			self:EndTurn(curTurnPad, curTurnHand)
		end
	elseif  action == "stand" then
		self:EndTurn(curTurnPad, curTurnHand)
	end
end

-- Bet functions
function ENT:PlaceBet(ply, pad)
	local betAmount = self.currentBetAmounts[ply:SteamID64()] or self.data.bet.default

	if not PerfectCasino.Config.CanAfford(ply, betAmount) then
		PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.NoMoney, ply)
		return false
	end

	PerfectCasino.Config.AddMoney(ply, -betAmount)
	self:SetStoredMoney(self:GetStoredMoney() + betAmount)

	hook.Run("pCasinoOnBlackjackBet", ply, self, betAmount)

	self.activeBets[ply:SteamID64()] = betAmount 

	PerfectCasino.Sound.Play(self, "chip"..math.random(1, 2))

	pad:SetStage(2)
	pad:SetUser(ply)

	net.Start("pCasino:Blackjack:Bet:Place")
		net.WriteEntity(self)
		net.WriteUInt(pad.order, 3)
		net.WriteUInt(betAmount, 32)
	net.SendPVS(self:GetPos())

	PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.BetPlaced, ply)

	-- Start the timer 
	if not self.timerStarted then
		timer.Create("pCasino:BlackJack:Countdown:"..self:EntIndex(), self.data.general.betPeriod, 1, function()
			if not IsValid(self) then return end
			self:StartRound()
		end)
		self.timerStarted = true
		self:SetStartRoundIn(os.time())
	else
		-- See how many pads are ready
		local padsReady = 0
		for k, v in pairs(self.panels) do
			if v:GetStage() == 2 then
				padsReady = padsReady + 1 
			end
		end

		-- All pads are full, start the game early
		if padsReady == 4 then
			timer.Remove("pCasino:BlackJack:Countdown:"..self:EntIndex())
			self:StartRound()
		end
	end
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
	local dealerValue = PerfectCasino.Cards:GetHandValue(self.dealerHand)

	for k, v in pairs(self.curHands) do
		for n, m in ipairs(v) do
			if not IsValid(m.ply) then continue end

			local handValue = PerfectCasino.Cards:GetHandValue(m.cards)
			local stored = self:GetStoredMoney()

			if handValue > 21 then -- Player bust
				PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.HandBust, m.ply)
				hook.Run("pCasinoOnBlackjackLoss", m.ply, self, m.bet)
			elseif dealerValue > 21 then -- Dealer busts
				local winnings = math.floor(m.bet * self.data.payout.win)
				local winning = stored - math.max(stored - winnings, 0)

				PerfectCasino.Config.AddMoney(m.ply, winning)
				self:SetStoredMoney(math.max(stored - winning, 0))

				if winning <= 0 then
					PerfectCasino.Core.Msg(string.format("У казино нет средств, чтобы оплатить вам %s!", PerfectCasino.Config.FormatMoney(winnings)), m.ply)
				elseif winning == winnings then
					PerfectCasino.Core.Msg(string.format(PerfectCasino.Translation.Chat.DealerHandBust, PerfectCasino.Config.FormatMoney(winnings)), m.ply)
				else
					PerfectCasino.Core.Msg(string.format("Вы выиграли лишь %s. Казино не смогло оплатить оставшиеся %s!", PerfectCasino.Config.FormatMoney(winnings), PerfectCasino.Config.FormatMoney(winnings - winning)), m.ply)
				end

				hook.Run("pCasinoOnBlackjackPayout", m.ply, self, m.bet*self.data.payout.win)
			elseif handValue == dealerValue then -- Player and house drew
				local winnings = m.bet
				local winning = stored - math.max(stored - winnings, 0)

				PerfectCasino.Config.AddMoney(m.ply, winning)
				self:SetStoredMoney(math.max(stored - winning, 0))

				PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.HandDraw, m.ply)

				if winning <= 0 then
					PerfectCasino.Core.Msg(string.format("У казино нет средств, чтобы оплатить вам %s!", PerfectCasino.Config.FormatMoney(winnings)), m.ply)
				elseif winning != winnings then
					PerfectCasino.Core.Msg(string.format("Вы выиграли лишь %s. Казино не смогло оплатить оставшиеся %s!", PerfectCasino.Config.FormatMoney(winnings), PerfectCasino.Config.FormatMoney(winnings - winning)), m.ply)
				end

				hook.Run("pCasinoOnBlackjackPayout", m.ply, self, m.bet)
			elseif handValue < dealerValue then -- The house beats you
				PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.HandLose, m.ply)
				hook.Run("pCasinoOnBlackjackLoss", m.ply, self, m.bet)
			elseif handValue > dealerValue then -- You beat the house!
				local payout = (handValue == 21) and self.data.payout.blackjack or self.data.payout.win
				payout = math.floor(m.bet * payout)
				local winnings = payout
				local winning = stored - math.max(stored - winnings, 0)

				PerfectCasino.Config.AddMoney(m.ply, winning)
				self:SetStoredMoney(math.max(stored - winning, 0))

				if winning <= 0 then
					PerfectCasino.Core.Msg(string.format("У казино нет средств, чтобы оплатить вам %s!", PerfectCasino.Config.FormatMoney(winnings)), m.ply)
				elseif winning == winnings then
					PerfectCasino.Core.Msg(string.format(PerfectCasino.Translation.Chat.HandWin, PerfectCasino.Config.FormatMoney(payout)), m.ply)
				else
					PerfectCasino.Core.Msg(string.format("Вы выиграли лишь %s. Казино не смогло оплатить оставшиеся %s!", PerfectCasino.Config.FormatMoney(winnings), PerfectCasino.Config.FormatMoney(winnings - winning)), m.ply)
				end

				hook.Run("pCasinoOnBlackjackPayout", m.ply, self, payout)
			end
		end
	end
end
