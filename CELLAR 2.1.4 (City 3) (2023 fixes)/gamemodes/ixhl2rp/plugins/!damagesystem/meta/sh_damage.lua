do
	local ENTITY = FindMetaTable("Entity")
	ENTITY.OTakeDamageInfo = ENTITY.OTakeDamageInfo or ENTITY.TakeDamageInfo

	function ENTITY:TakeDamageInfo(damageInfo, bloodDmgInfo)
		self:OTakeDamageInfo(damageInfo)

		if bloodDmgInfo then
			hook.Run("TakeAdvancedDamage", self, bloodDmgInfo)
		end
	end
end

do
	local DMG = {}
	DMG.__index = DMG

	function DMG:SetShock(int)
		self.shockDmg = int
	end

	function DMG:GetShock()
		return self.shockDmg or 0
	end

	function DMG:SetBlood(int)
		self.bloodDmg = int
	end

	function DMG:GetBlood()
		return self.bloodDmg or 0
	end

	function DMG:SetBleedChance(int)
		self.bleedChance = int
	end

	function DMG:GetBleedChance()
		return self.bleedChance or 0
	end

	function DMG:SetBleedDmg(int)
		self.bleedDmg = int
	end

	function DMG:GetBleedDmg()
		return self.bleedDmg or 0
	end

	function BloodDmgInfo()
		return setmetatable({}, DMG)
	end
end