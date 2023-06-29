do
	local PLAYER = FindMetaTable("Player")

	-- to do: fix ugly chat send
	function PLAYER:RadNotify(stage)
		if stage > (self.lastRadNotify or 0) and (self.lastRadNotify or 0) != stage then
			if stage == 5 then
				ix.chat.Send(self, "it", L("radStage5", self), false, {self})
			elseif stage == 4 then
				ix.chat.Send(self, "it", L("radStage4", self), false, {self})
			elseif stage == 3 then
				ix.chat.Send(self, "it", L("radStage3", self), false, {self})
			elseif stage == 2 then
				ix.chat.Send(self, "it", L("radStage2", self), false, {self})
			elseif stage == 1 then
				ix.chat.Send(self, "it", L("radStage1", self), false, {self})
			end

			self.lastRadNotify = stage
		end
	end

	function PLAYER:RadDamage()
		local character = self:GetCharacter()
		local radLevel = character:GetRadLevel()

		if radLevel > 999 then
			local dmg = math.Clamp(math.Remap(radLevel, 999, 1500, 1, 2), 1, 2)
			local d = DamageInfo()
			
			d:SetDamage(dmg)
			d:SetAttacker(self)
			d:SetInflictor(self)
			d:SetDamageType(DMG_RADIATION) 

			self:TakeDamageInfo(d)
		elseif radLevel > 799 then
			-- fall
		end
	end
end