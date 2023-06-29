local PLUGIN = PLUGIN

do
	local charMeta = ix.meta.character

	function charMeta:LevelUp(deltaXP)
		local nextLevel = self:GetLevel() + 1

		self:SetLevelXP(0)

		if nextLevel <= PLUGIN.maxLevel then
			self:SetLevel(nextLevel)
			self:SetData("levelup", true)
			ix.chat.Send(nil, "level", "", nil, {self:GetPlayer()}, {
				t = 1,
			})
		end

		if deltaXP then
			self:AddLevelXP(deltaXP)
		end
	end

	function charMeta:LevelDown(deltaXP)
		local nextLevel = self:GetLevel() - 1

		self:SetLevelXP(0)
		
		if nextLevel > 0 then
			self:SetLevel(nextLevel)
			
			ix.chat.Send(nil, "level", "", nil, {self:GetPlayer()}, {
				t = 3,
			})
		end

		if deltaXP then
			self:AddLevelXP(deltaXP)
		end
	end

	function charMeta:AddLevelXP(xp, reasonType)
		xp = xp or 1

		local max = PLUGIN:GetRequiredLevelXP(self:GetLevel())
		local cur = (self:GetLevelXP() + xp)
		
		if cur >= max then
			local delta = (cur - max)
			self:LevelUp(delta)

			return
		elseif cur < 0 then
			max = PLUGIN:GetRequiredLevelXP(self:GetLevel() - 1)
			local delta = (max - cur)
			self:LevelDown(delta)

			return
		end

		self:SetLevelXP(cur)
	end

	local rollTable = {
		[1] = {1, 80},
		[2] = {1, 80},
		[3] = {1, 100},
		[4] = {7, 100},
		[5] = {14, 100},
		[6] = {21, 100},
		[7] = {28, 100},
		[8] = {35, 100},
		[9] = {42, 100},
		[10] = {49, 100},
	}
	
	function charMeta:GetRolls()
		return rollTable[self:GetLevel() or 1] or rollTable[3]
	end
end