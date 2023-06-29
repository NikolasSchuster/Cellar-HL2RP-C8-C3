-- All the types of chips
PerfectCasino.Chips.Types = {1, 5, 10, 25, 50, 100, 250, 500, 1000, 2000, 5000, 25000, 50000, 100000, 250000, 500000, 1000000, 10000000, 100000000, 1000000000, 10000000000}
-- Builds a stack of chips to equal the number given
function PerfectCasino.Chips:GetFromNumber(num)
	local total = num
	local chips = {}

	-- Loop the chip set and break it into chips
	for i = #PerfectCasino.Chips.Types, 1, -1 do
		local chip = PerfectCasino.Chips.Types[i]
		-- We offset by 1 to account for skins starting at 0
		chips[i-1] = math.floor(total/chip)
		total = total - (chips[i-1]*chip)

		-- Don't include it if it's empty
		if chips[i-1] == 0 then
			chips[i-1] = nil
		end
	end

	return chips
end
