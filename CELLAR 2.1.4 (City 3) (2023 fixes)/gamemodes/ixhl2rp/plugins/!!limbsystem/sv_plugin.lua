util.AddNetworkString("ixTakeLimbDamage")
util.AddNetworkString("ixHealLimbDamage")
util.AddNetworkString("ixResetLimbDamage")

function PLUGIN:PlayerDeath(client)
	if client.KilledByRP then
		local character = client:GetCharacter()

		if character then
			character:ResetLimbDamage()
		end
	end
end

do
	local charMeta = ix.meta.character

	function charMeta:TakeLimbDamage(limb, damage)
		local limbs = self:Limbs()

		if !limbs then
			return
		end

		damage = math.ceil(damage)
		local hitGroup = nil

		if isnumber(limb) then
			hitGroup = limb
			limb = limbs:GetByHitgroup(limb)
			
			if limb then
				limb = limb:Name()
			end
		end

		local client = self:GetPlayer()
		local limbData = self:GetLimbData()

		limbData[limb] = math.min((limbData[limb] or 0) + damage, 100)

		self:SetLimbData(limbData)

		if IsValid(client) then
			hook.Run("PlayerLimbTakeDamage", client, limb, damage, self, hitGroup)
		end
	end

	function charMeta:TakeOverallLimbDamage(damage)
		local limbs = self:Limbs()

		if !limbs then
			return
		end

		damage = math.ceil(damage)

		local client = self:GetPlayer()
		local limbData = self:GetLimbData()

		for k, v in pairs(limbs.stored) do
			local n = v:Name()
			limbData[n] = math.min((limbData[n] or 0) + damage, 100)
		end

		self:SetLimbData(limbData)
	end

	function charMeta:HealLimbs(amount)
		local limbData = self:GetLimbData()

		for k, v in pairs(limbData) do
			self:HealLimbDamage(k, amount)
		end
	end

	function charMeta:HealLimbDamage(limb, amount)
		local limbs = self:Limbs()

		if !limbs then
			return
		end

		amount = math.ceil(amount)

		if isnumber(limb) then
			limb = limbs:GetByHitgroup(limb)
			
			if limb then
				limb = limb:Name()
			end
		end

		local client = self:GetPlayer()
		local limbData = self:GetLimbData()

		if limbData[limb] then
			limbData[limb] = math.max(limbData[limb] - amount, 0)

			if limbData[limb] == 0 then
				limbData[limb] = nil
			end

			self:SetLimbData(limbData)

			if IsValid(client) then
				hook.Run("PlayerLimbDamageHealed", client, limb, amount, self)
				
				net.Start("ixHealLimbDamage")
					net.WriteUInt(self:GetID(), 32)
					net.WriteString(limb)
					net.WriteFloat(amount)
				net.Send(client)
			end
		end
	end

	function charMeta:ResetLimbDamage()
		self:SetLimbData({})
	end
end
