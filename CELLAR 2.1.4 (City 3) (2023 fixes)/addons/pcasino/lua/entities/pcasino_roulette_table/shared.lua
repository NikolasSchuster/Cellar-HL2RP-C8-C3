ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Roulette Table"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "LastRoundNumber")
	self:NetworkVar("Int", 1, "StartRoundIn")
	self:NetworkVar("Int", 2, "StoredMoney")
end

-- This is a lot of confusing math and took me ages to actually get right on the grid. Just accept it for what it is, I cache it, so it's not really a big deal... right? :/
-- I essentially map each bet "type" based on some math, because they're all in a grid. Best way I could think of without manually mapping every button.
function ENT:GetCurrentPad(pos)
	if not self.padCache then
		self.padCache = {}
		-- Set priority
		self.padCache[1] = {} -- The outer buttons, they don't overlap and there's not many of them, so we can do them first.
		self.padCache[2] = {} -- The 2x2 overlaps, they overlap the most so they should be done second.
		self.padCache[3] = {} -- The 1x2 or 2x1 crossovers, they also overlap so they should be done before the base numbers. We put the row bets in here too.
		self.padCache[4] = {} -- The base numbers

		local startPos = Vector(4.1, -13.3, 14)
		local sizeW, sizeH = -6.2, 4.4
		-- 1 to 36 numbers
		for i=1, 36 do
			self.padCache[4]["num_"..i] = {
				boundsA = {x = (startPos.x + (sizeW*((i-1)%3))), y = (startPos.y + (sizeH*math.floor((i-1)/3)))},
				boundsB = {x = (startPos.x + (sizeW*(((i-1)%3)+1))), y = (startPos.y + (sizeH*(math.floor((i-1)/3)+1)))}
			}

			-- Add the numbers it covers
			self.padCache[4]["num_"..i].numbers = {[i] = true}

			-- Add the payout if won
			self.padCache[4]["num_"..i].payout = 35
		end

		local startPos = Vector(-1.1, -10.2, 14)
		local sizeW, sizeH = -2, 2.21
		local row = 0
		local newI
		-- The 2x2 bets
		for i=1, 22 do
			self.padCache[2]["2x2_"..i] = {
				boundsA = {x = (startPos.x + (sizeW*((i-1)%2))) + ((sizeW*2.15)*((i-1)%2)), y = (startPos.y + (sizeH*math.floor((i-1)/2))) + (sizeH*math.floor((i-1)/2))},
				boundsB = {x = (startPos.x + (sizeW*(((i-1)%2)+1))) + ((sizeW*2.15)*((i-1)%2)), y = (startPos.y + (sizeH*(math.floor((i-1)/2)+1))) + (sizeH*math.floor((i-1)/2))}
			}

			-- Add the numbers it covers
			newI = i + row
			self.padCache[2]["2x2_"..i].numbers = {}
			self.padCache[2]["2x2_"..i].numbers[newI] = true
			self.padCache[2]["2x2_"..i].numbers[newI+1] = true
			self.padCache[2]["2x2_"..i].numbers[newI+3] = true
			self.padCache[2]["2x2_"..i].numbers[newI+4] = true
			
			-- The end of a row
			if i%2 == 0 then
				row = row + 1
			end

			-- Add the payout if won
			self.padCache[2]["2x2_"..i].payout = 8
		end

		local startPos = Vector(-1.1, -12.4, 14)
		local sizeW, sizeH = -2, 2.21
		local row = 0
		local newI
		-- The horizontal bets
		for i=1, 24 do
			self.padCache[3]["hrztl_"..i] = {
				boundsA = {x = (startPos.x + (sizeW*((i-1)%2))) + ((sizeW*2.15)*((i-1)%2)), y = (startPos.y + (sizeH*math.floor((i-1)/2))) + (sizeH*math.floor((i-1)/2))},
				boundsB = {x = (startPos.x + (sizeW*(((i-1)%2)+1))) + ((sizeW*2.15)*((i-1)%2)), y = (startPos.y + (sizeH*(math.floor((i-1)/2)+1))) + (sizeH*math.floor((i-1)/2))}
			}

			-- Add the numbers it covers
			newI = i + row
			self.padCache[3]["hrztl_"..i].numbers = {}
			self.padCache[3]["hrztl_"..i].numbers[newI] = true
			self.padCache[3]["hrztl_"..i].numbers[newI+1] = true

			-- The end of a row
			if i%2 == 0 then
				row = row + 1
			end

			-- Add the payout if won
			self.padCache[3]["hrztl_"..i].payout = 17
		end

		local startPos = Vector(2.1, -10.2, 14)
		local sizeW, sizeH = -2, 2.21
		-- The vertical bets
		for i=1, 33 do
			self.padCache[3]["vrtcl_"..i] = {
				boundsA = {x = (startPos.x + (sizeW*((i-1)%3))) + ((sizeW*2.15)*((i-1)%3)), y = (startPos.y + (sizeH*math.floor((i-1)/3))) + (sizeH*math.floor((i-1)/3))},
				boundsB = {x = (startPos.x + (sizeW*(((i-1)%3)+1))) + ((sizeW*2.15)*((i-1)%3)), y = (startPos.y + (sizeH*(math.floor((i-1)/3)+1))) + (sizeH*math.floor((i-1)/3))}
			}

			-- Add the numbers it covers
			self.padCache[3]["vrtcl_"..i].numbers = {}
			self.padCache[3]["vrtcl_"..i].numbers[i] = true
			self.padCache[3]["vrtcl_"..i].numbers[i+3] = true

			-- Add the payout if won
			self.padCache[3]["vrtcl_"..i].payout = 17
		end

		local startPos = Vector(5.3, -13.3, 14)
		local sizeW, sizeH = -2, 4.4
		local start
		-- Row bets
		for i=1, 12 do
			self.padCache[3]["row_"..i] = {
				boundsA = {x = startPos.x, y = (startPos.y + (sizeH*(i-1)))},
				boundsB = {x = (startPos.x + sizeW), y = (startPos.y + (sizeH*(i)))},
			}

			-- Add the numbers it covers
			start = (i-1)*3
			self.padCache[3]["row_"..i].numbers = {[start+1] = true, [start+2] = true, [start+3] = true}

			-- Add the payout if won
			self.padCache[3]["row_"..i].payout = 11
		end

		-- 0 is bigger, so we gotta do it manually
		self.padCache[4]["num_0"] = {
			boundsA = {x = 4.3, y = -18.6},
			boundsB = {x = -14.3, y = -13.6}
		}
		-- Add the numbers it covers
		self.padCache[4]["num_0"].numbers = {[0] = true}
		-- Add the payout if won
		self.padCache[4]["num_0"].payout = 35

		local startPos = Vector(4.1, 39.5, 14)
		local sizeW, sizeH = -6.2, 4.4
		-- Sets of 12
		for i=1, 3 do
			self.padCache[1]["2to1_"..i] = {
				boundsA = {x = (startPos.x + (sizeW*(i-1))), y = startPos.y},
				boundsB = {x = (startPos.x + (sizeW*(i))), y = (startPos.y + sizeH)}
			}

			-- Add the numbers it covers
			self.padCache[1]["2to1_"..i].numbers = {}
			for n=i, 36, 3 do
				self.padCache[1]["2to1_"..i].numbers[n] = true
			end

			-- Add the payout if won
			self.padCache[1]["2to1_"..i].payout = 2
		end

		local startPos = Vector(9.3, -13.4, 14.6)
		local sizeW, sizeH = -5, 17.7
		local start
		-- Sets of 12
		for i=1, 3 do
			self.padCache[1]["12s_"..i] = {
				boundsA = {x = startPos.x, y = (startPos.y + (sizeH*(i-1)))},
				boundsB = {x = (startPos.x + sizeW), y = (startPos.y + (sizeH*(i)))},
			}

			-- Add the numbers it covers
			self.padCache[1]["12s_"..i].numbers = {}
			start = 12*(i-1)+1
			for n=start, start+11 do
				self.padCache[1]["12s_"..i].numbers[n] = true
			end

			-- Add the payout if won
			self.padCache[1]["12s_"..i].payout = 2
		end

		local startPos = Vector(14.5, -13.4, 14.6)
		local sizeW, sizeH = -5, 8.85
		local types = {"1to18", "even", "red", "black", "odd", "19to36"}
		for k, v in ipairs(types) do
			self.padCache[1][v] = {
				boundsA = {x = startPos.x, y = (startPos.y + (sizeH*(k-1)))},
				boundsB = {x = (startPos.x + sizeW), y = (startPos.y + (sizeH*(k)))},
			}

			-- Add the numbers it covers
			self.padCache[1][v].numbers = {}
			for i=1, 36 do
				if (v == "1to18") and (i <= 18) then
					self.padCache[1][v].numbers[i] = true
				elseif (v == "19to36") and (i >= 19) then 
					self.padCache[1][v].numbers[i] = true
				elseif (v == "even") and (i%2 == 0) then 
					self.padCache[1][v].numbers[i] = true
				elseif (v == "odd") and (i%2 == 1) then 
					self.padCache[1][v].numbers[i] = true
				elseif (v == "red") and table.HasValue({1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36}, i) then 
					self.padCache[1][v].numbers[i] = true
				elseif (v == "black") and table.HasValue({2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35}, i) then 
					self.padCache[1][v].numbers[i] = true
				end
			end

			-- Add the payout if won
			self.padCache[1][v].payout = 1
		end

		-- Raise bet
		self.padCache[1]["bet_raise"] = {
			boundsA = {x = -20, y = -5.2},
			boundsB = {x = -23.7, y = -0.567747},
		}
		-- Lower bet
		self.padCache[1]["bet_lower"] = {
			boundsA = {x = -20, y = 10.5},
			boundsB = {x = -23.7, y = 15.5},
		}

		-- Find the center point of all the 3d2d inputs
		for i, _ in ipairs(self.padCache) do
			for k, v in pairs(_) do
				self.padCache[i][k].origin = {x = v.boundsA.x+((v.boundsB.x - v.boundsA.x)/2), y = v.boundsA.y+((v.boundsB.y - v.boundsA.y)/2)}
			end
		end
	end
	for i, _ in ipairs(self.padCache) do
		for k, v in pairs(_) do
			if (pos.x < v.boundsA.x) and (pos.x > v.boundsB.x) and (pos.y > v.boundsA.y) and (pos.y < v.boundsB.y) and (pos.z > 13) and (pos.z < 15) then
				return k, v
			end
		end
	end

	return false
end
function ENT:GetPadByName(padName)
	if not self.padCache then
		self:GetCurrentPad(Vector(0, 0, 0)) -- Generate the cache
	end

	for i, _ in ipairs(self.padCache) do
		for k, v in pairs(_) do
			if k == padName then
				return k, v
			end
		end
	end
end
function ENT:GetPadsFromNumber(number)
	local pads = {}

	for i, _ in ipairs(self.padCache) do
		for k, v in pairs(_) do
			if v.numbers and v.numbers[number] then
				table.insert(pads, k)
			end
		end
	end

	return pads
end

PerfectCasino.Core.RegisterEntity("pcasino_roulette_table", {
	-- Bet data
	bet = {
		betLimit = {d = 3000, t = "num"},
		default = {d = 500, t = "num"},
		max = {d = 1000, t = "num"},
		min = {d = 100, t = "num"},
		iteration = {d = 100, t = "num"}
	},
	general = {
		betPeriod = {d = 30, t = "num"} -- The default bet
	}
},
"models/freeman/owain_roulette_table.mdl")