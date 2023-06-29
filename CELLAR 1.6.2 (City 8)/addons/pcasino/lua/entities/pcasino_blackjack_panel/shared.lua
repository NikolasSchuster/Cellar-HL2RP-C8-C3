ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Blackjack Panel"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "User")
	self:NetworkVar("Int", 0, "Stage")
	self:NetworkVar("Int", 1, "Hand")
end

function ENT:GetCurrentPad(pos)
	if self:GetStage() == 2 then return end -- There is nothing to do on stage 2 but wait.

	if not self.padCache then
		self.padCache = {}
		self.padCache[1] = {} -- The stage for placing bets
		self.padCache[3] = {} -- The stage for choosing an action

		-- Stage 1
		-- Lower bet
		self.padCache[1]["bet_lower"] = {
			boundsA = {x = -6.7, y = -7.7},
			boundsB = {x = -11.7, y = -3.9},
		}
		-- Raise bet
		self.padCache[1]["bet_raise"] = {
			boundsA = {x = 11.7, y = -7.7},
			boundsB = {x = 6.7, y = -3.9},
		}
		-- Place bet
		self.padCache[1]["bet_place"] = {
			boundsA = {x = 11.7, y = -11.7},
			boundsB = {x = -11.7, y = -8},
		}

		-- Stage 3
		self.padCache[3]["action_double"] = {
			boundsA = {x = -0.2, y = -7.7},
			boundsB = {x = -11.7, y = -3.9},
		}
		self.padCache[3]["action_hit"] = {
			boundsA = {x = -0.2, y = -11.7},
			boundsB = {x = -11.7, y = -8},
		}
		self.padCache[3]["action_stand"] = {
			boundsA = {x = 11.7, y = -11.7},
			boundsB = {x = 0.2, y = -8},
		}
		self.padCache[3]["action_split"] = {
			boundsA = {x = 11.7, y = -7.7},
			boundsB = {x = 0.2, y = -3.9},
		}
	end

	if not self.padCache[self:GetStage()] then return false end

	for k, v in pairs(self.padCache[self:GetStage()]) do
		if (pos.x < v.boundsA.x) and (pos.x > v.boundsB.x) and (pos.y > v.boundsA.y) and (pos.y < v.boundsB.y) then
			return k, v
		end
	end

	return false
end