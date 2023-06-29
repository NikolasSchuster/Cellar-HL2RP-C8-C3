-- Build a deck
local allCards = {}
-- hearts, diamonds, spades, clubs
for _, s in pairs({"h", "d", "s", "c"}) do
	for _, v in pairs{"a", 2, 3, 4, 5, 6, 7, 8, 9, "t", "j", "k", "q"} do -- We use 't' instead of '10' so that we can just check the 2nd value for what the card is worth
		table.insert(allCards, s..v)
	end
end

function PerfectCasino.Cards:GetRandom()
	local card = table.Random(allCards)

	--return "sq"
	return card
end

function PerfectCasino.Cards:GetValue(card, sum)
	local v = card[2]
	if not v then return false end

	if (v == "t") or (v == "j") or (v == "k") or (v == "q") then
		return 10
	elseif v == "a" then
		if sum then -- Check if we're basing it off a current evaluation
			if sum <= 10 then -- If the current sum is less than 11, we can return 11 without going bust
				return 11
			end

			return 1 -- Return 1 as a fallback
		end

		return 11
	else
		return tonumber(v)
	end
end

-- The card var must be a table of cards in the format obtained with PerfectCasino.Cards:GetRandom()
function PerfectCasino.Cards:GetHandValue(cards)
	local totalValue = 0
	local aces = 0

	for k, v in pairs(cards) do
		-- We calculate the aces after we've summmed up the total
		if v[2] == "a" then
			aces = aces + 1
			continue
		end
		totalValue = totalValue + PerfectCasino.Cards:GetValue(v)
	end

	if aces > 0 then
		for i=1, aces do
			totalValue = totalValue + PerfectCasino.Cards:GetValue("ha", totalValue) -- It doesn't matter the card we give it, as long as it's an ace
		end
	end

	return totalValue
end

local skins = {["h"] = 0, ["d"] = 1, ["c"] = 2, ["s"] = 3}
local bodygroups = {["a"] = 0, ["2"] = 1, ["3"] = 2, ["4"] = 3, ["5"] = 4, ["6"] = 5, ["7"] = 6, ["8"] = 7, ["9"] = 8, ["t"] = 9, ["j"] = 10, ["q"] = 11, ["k"] = 12}
function PerfectCasino.Cards:GetFaceData(card)
	if not card then return end

	return skins[card[1]] or 0, bodygroups[card[2]] or 0
end