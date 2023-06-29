include("shared.lua")


local preset = {
	{p = 0.7, a = -30, o = 0.9},
	{p = 0.1, a = -16, o = 1.8},
	{p = 0, a = 16, o = 3},
	{p = 0.3, a = 35, o = 4.1},
}
function ENT:Initialize()
	-- Rebuild the panels table client side, without needing to do any extra networking.
	self.panels = {}
	for k, v in ipairs(self:GetChildren()) do
		if v:GetClass() == "pcasino_blackjack_panel" then
			table.insert(self.panels, v)
		end
	end
	-- Flip the table
	self.panels = table.Reverse(self.panels)
	for k, v in pairs(self.panels) do
		v.order = k
	end

	self.currentBid = 0
	self.active = false
	self.currentBets = {}
	self.currentCards = {}
	self.curHands = {}

	self.hasInitialized = true
end

function ENT:PostData()
	if not self.hasInitialized then
		self:Initialize()
	end
	
	self.currentBid = self.data.bet.default
end
function ENT:OnRemove()
	self:ClearBets()
end

local surface_setdrawcolor = surface.SetDrawColor
local surface_drawrect = surface.DrawRect
local draw_simpletext = draw.SimpleText
local black = Color(0, 0, 0, 200)
local white = Color(255, 255, 255, 100)
function ENT:DrawTranslucent()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 25000 then return end

	-- We can piggyback off the distance check to only request the entities data when it's needed :D
	if (not self.data) and (not PerfectCasino.Cooldown.Check(self:EntIndex(), 5)) then
		PerfectCasino.Core.RequestConfigData(self)
		return
	end

	if not self.data then return end

	if not (self:GetStartRoundIn() == -1) then
		local pos = self:GetPos()
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)
		cam.Start3D2D(pos + (ang:Up()*-22) + (ang:Right()*-19.7) + (ang:Forward()*-4.5), ang, 0.05)
			
			-- Previous bet step
			surface_setdrawcolor(black)
			surface_drawrect(5, 5, 190, 65)
			-- Border
			surface_setdrawcolor(white)
			surface_drawrect(0, 0, 200, 5)
			surface_drawrect(0, 5, 5, 65)
			surface_drawrect(195, 5, 5, 65)
			surface_drawrect(0, 70, 200, 5)

			local text = string.format(PerfectCasino.Translation.UI.Start, self.data.general.betPeriod - (os.time() - self:GetStartRoundIn())) 
			draw_simpletext(text, "pCasino.Entity.Bid", 100, 37, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		cam.End3D2D()
	end

	if not self.currentCards or not self.currentCards[0] then return end

	for k, v in pairs(self.currentCards) do
		for i, h in pairs(v) do
			local masterCard = h[1]

			local ang = masterCard:GetAngles()
			ang:RotateAroundAxis(ang:Right(), -90)
			ang:RotateAroundAxis(ang:Up(), 90)

			local pos = masterCard:GetPos() + (ang:Forward()*-2.4) + (ang:Right()*1.2)
			
			cam.Start3D2D(pos, ang, 0.04)
				-- Main Box
				surface_setdrawcolor(black)
				surface_drawrect(-20, -20, 40, 40)
				-- Border
				surface_setdrawcolor(white)
				surface_drawrect(-20, -20, 2, 38)-- Left border
				surface_drawrect(-18, -20, 38, 2)-- Top border
				surface_drawrect(18, -18, 2, 38) -- Right border
				surface_drawrect(-20, 18, 38, 2)

				draw_simpletext(PerfectCasino.Cards:GetHandValue(self.curHands[k][i]), "pCasino.Header.Static", -1, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end 
	end
end

-- Chip code
function ENT:AddBet(pad, amount)
	self.currentBets[pad] = self.currentBets[pad] or {}

	local chips = PerfectCasino.Chips:GetFromNumber(amount)

	local ang = self:GetAngles()
	for k=#PerfectCasino.Chips.Types, 0, -1 do -- Run it in reverse, putting the highest chips at the bottom
		if not chips[k] then continue end
		for i=1, chips[k] do
			local plaque = k >= 11 -- There are 11 normal skins, so anything over 10 (11-1, due to skins starting at 0) we use the big plaque models

			local chip = ClientsideModel(plaque and "models/freeman/owain_casino_plaque.mdl" or "models/freeman/owain_casino_chip.mdl")
			table.insert(self.currentBets[pad], chip)
			chip:SetParent(self)
			chip:SetSkin(plaque and k-11 or k)
			chip:SetPos(self:GetPos() + ((self:GetUp()*15.8) + (self:GetUp() * (#self.currentBets[pad]*0.3))) + ((self:GetForward()*8) + ((self:GetForward()*-10) * preset[pad].p)) + ((self:GetRight() * -13) * (pad - 2.5)))
			chip:SetAngles(ang)
		end
	end
end
function ENT:ClearBets()
	for _, pad in pairs(self.currentBets) do
		for k, v in pairs(pad) do
			if not IsValid(v) then continue end
			v:Remove()
		end
	end

	self.currentBets = {}
end

-- Card code
function ENT:AddCard(pad, hand, face)
	self.currentCards[pad] = self.currentCards[pad] or {}
	self.currentCards[pad][hand] = self.currentCards[pad][hand] or {}

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 90)
	--ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), preset[pad] and preset[pad].a or 0)

	
	local card = ClientsideModel("models/freeman/owain_playingcards.mdl")
	table.insert(self.currentCards[pad][hand], card)
	card:SetParent(self)

	if face then 
		local skin, bodygroup = PerfectCasino.Cards:GetFaceData(face)
		card:SetBodygroup(1, bodygroup)
		card:SetSkin(skin)
		card:SetAngles(ang)
	else
		ang:RotateAroundAxis(ang:Right(), 180)
		ang:RotateAroundAxis(ang:Forward(), 180)
		card:SetAngles(ang)
	end
		

	if pad == 0 then -- Dealers hand
		card:SetPos(self:GetPos() + (self:GetUp()*15.8) + (self:GetForward()*-7) + (self:GetRight()*10) + ((self:GetRight()*-3) * #self.currentCards[pad][hand]))
	else -- Players hand
		-- If there is no existing card, set the basis for the positions of them
		if #self.currentCards[pad][hand] == 1 then
			-- Then positioning for the cards is rather complex to understand on 1 line, so I've decided to comment it out to save myself the pain
			card:SetPos(self:GetPos() -- The table's position
				+ (self:GetUp()*15.8) -- Take it to the hight of the table playing area
				+ (self:GetForward()*2) -- Bring it closer to the edge of the mat
				+ ((self:GetForward()*-9) * (preset[pad].p + ((#self.currentCards[pad][hand]-1)*0.1))) -- Shift the cards up or down the X axist to align with the pads better
				+ ((self:GetRight()*-10) * ((preset[pad].o - 2.7))) -- Move the cards across the Y axis so they are next to their pads
			)
	
		-- Move the cards to the right based on what hand it is. This is done after the first move as we need it's new position to calculate the movement
			card:SetPos(card:GetPos() -- It's current position
				+ ((-card:GetRight()*4) * (hand-1))
			)
		else -- Otherwise we can juse the existing card to position the rest of them
			local baseCard = self.currentCards[pad][hand][#self.currentCards[pad][hand] - 1]
	
			card:SetPos(baseCard:GetPos() -- The base card's position
				+ (self:GetUp()*(#self.currentCards[pad][hand]*0.02))  -- Make each card in that hand higher than the last, so they don't overlap and give glitchy artifacts
				+ (-baseCard:GetRight() * 0.6) -- Shift the card slightly to the right
				+ (baseCard:GetUp() * 0.5) -- Move the card slightly up
			)
		end
	end
end

function ENT:ClearCards()
	for _, pad in pairs(self.currentCards) do
		for k, h in ipairs(pad) do
			for _, c in ipairs(h) do
				if not IsValid(c) then continue end
				c:Remove()
			end
		end
	end

	self.currentCards = {}
end

function ENT:OnRemove()
	self:ClearBets()
	self:ClearCards()
end

ENT.PopulateEntityInfo = true

function ENT:GetEntityMenu()
	local cid = LocalPlayer():GetCharacter():GetIDCard()

	if !cid then 
		return
	end

	local accesses = cid:GetData("access", {})

	if !accesses["CASINO"] then
		return
	end

	local pos = self:WorldToLocal(LocalPlayer():GetEyeTrace().HitPos)

	local options = {
		["Внести токены"] = function()
			Derma_StringRequest("Внести токены", "Введите желаемую сумму", "0", function(text)
				local amount = tonumber(text) or 0

				if amount > 0 then
					ix.menu.NetworkChoice(self, "Deposit", amount)
				end
			end)

			return false
		end,
		["Снять токены"] = function()
			Derma_StringRequest("Снять токены", "Введите желаемую сумму", tostring(self:GetStoredMoney()), function(text)
				local amount = tonumber(text) or 0

				if amount > 0 then
					ix.menu.NetworkChoice(self, "Withdraw", amount)
				end
			end)

			return false
		end,
	}

	return options
end

net.Receive("pCasino:Blackjack:Bet:Change", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.data then return end

	local newBet = net.ReadUInt(32)
	entity.currentBid = newBet
end)

net.Receive("pCasino:Blackjack:Bet:Place", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.data then return end
	if entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > 100000 then return end

	local pad = net.ReadUInt(3)
	local betAmount = net.ReadUInt(32)

	entity:AddBet(pad, betAmount)
end)
net.Receive("pCasino:Blackjack:Clear", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end

	entity:ClearBets()
	entity:ClearCards()

	entity.curHands = {}
end)

net.Receive("pCasino:Blackjack:StartingCards", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.data then return end
	if entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > 100000 then return end

	local hands = net.ReadTable()
	local dealersHand = net.ReadTable()

	for i, p in pairs(hands) do
		entity.curHands[i] = {} -- Build the pad

		for ih, h in ipairs(p) do
			entity.curHands[i][ih] = {} -- Build the hand

			for _, c in ipairs(h.cards) do
				table.insert(entity.curHands[i][ih], c) -- Add the card to the hand

				entity:AddCard(i, ih, c) -- Add a visual card to the table
			end
		end
	end

	entity.curHands[0] = {}
	entity.curHands[0][1] = {}
	for k, c in pairs(dealersHand) do
		entity:AddCard(0, 1, c)
		table.insert(entity.curHands[0][1], c)
	end
	entity:AddCard(0, 1) -- The dealer's blind card
end)
net.Receive("pCasino:Blackjack:NewCard", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.data then return end
	if entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > 100000 then return end

	local pad = net.ReadUInt(3)
	local hand = net.ReadUInt(3)
	local card = net.ReadString()

	if (not entity.curHands) or (not entity.curHands[pad]) or (not entity.curHands[pad][hand]) then return end

	table.insert(entity.curHands[pad][hand], card) -- Add the card to the hand
	entity:AddCard(pad, hand, card) -- Add a visual card to the table
end)
net.Receive("pCasino:Blackjack:Split", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.data then return end
	if entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > 100000 then return end

	local pad = net.ReadUInt(3)
	local hands = net.ReadTable()

	-- Clear the existing cards to rebuild them
	for k, v in pairs(entity.currentCards[pad]) do
		for n, m in pairs(v) do
			m:Remove()
		end
	end

	-- Reset then sub tables
	entity.curHands[pad] = {}

	entity.currentCards[pad] = {}

	for i, h in ipairs(hands) do
		entity.curHands[pad][i] = {}
		for _, c in ipairs(h.cards) do
			table.insert(entity.curHands[pad][i], c) -- Add the card to the hand

			entity:AddCard(pad, i, c)
		end
	end
end)
net.Receive("pCasino:Blackjack:DealerCards", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.data then return end
	if entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > 100000 then return end

	local dealersCards = net.ReadTable()

	-- Remove the blind card
	if (not entity.currentCards) or (not entity.currentCards[0]) or (not entity.currentCards[0][1]) or (not entity.currentCards[0][1][2]) then return end

	entity.currentCards[0][1][2]:Remove()
	entity.currentCards[0][1][2] = nil
	for i, c in ipairs(dealersCards) do
		if i == 1 then continue end -- We already have the first card placed
		timer.Simple(i-2, function()
			entity:AddCard(0, 1, c)
			table.insert(entity.curHands[0][1], c) -- Add the card to the hand
		end)
	end
end)