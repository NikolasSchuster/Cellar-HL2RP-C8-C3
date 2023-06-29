local PLUGIN = PLUGIN

PLUGIN.tempMin = -45
PLUGIN.tempMax = 8
PLUGIN.dmgMin = 1
PLUGIN.dmgMax = 4
PLUGIN.offMin = 0.09
PLUGIN.offMax = 21.01
PLUGIN.globalTemp = 8


function PLUGIN:TakeThermalLimbDamage(character, damage, resist, hitgroup, bShock)
	if character:GetPlayer().inWarmth then
		damage = damage / 5
	end

	if resist >= damage then
		damage = 0
	else
		damage = damage - (resist * 0.9)
	end

	if damage > 0 then

		character:TakeLimbDamage(hitgroup, damage)
		if bShock then
			-- is it fucked up to do this 5 times every 4-8 seconds???
			character:AddShockDamage(damage * 2)
			character:GetPlayer():SetColdlevel(0)
		end


		return true
	end
	return false
end

function PLUGIN:CalculateThermalLimbDamage(temperature, client, equipment, damage, offset)
	if (client.ixObsData) then return end
	local character = client:GetCharacter()
	local outfit = equipment["torso"] and equipment["torso"].isOutfit or false
	local dangerous = temperature < 8
	local resist = 0
	local damageTaken = false
	local isVort = client:Team() == FACTION_VORTIGAUNT
	if (not dangerous) then return end

	if isVort then resist = 3 end

	-- calculate damage through outfit:
	if outfit or isVort then
		if not isVort then
			resist = equipment["torso"].thermalIsolation or 0
		end

		if resist >= damage then
			damage = 0
		else
			damage = damage - resist * 0.8
		end

		if damage > 0 then
			character:TakeOverallLimbDamage(damage)
			character:AddShockDamage(damage * 2 * 4)
			damageTaken = true
		end
	else
		-- head damage:
		resist = equipment["head"] and equipment["head"].thermalIsolation or 0
		damageTaken = self:TakeThermalLimbDamage(character, damage, resist, HITGROUP_HEAD, true)

		-- chest damage:
		resist = equipment["torso"] and equipment["torso"].thermalIsolation or 0
		damageTaken = self:TakeThermalLimbDamage(character, damage, resist, HITGROUP_CHEST, true)
		damageTaken = self:TakeThermalLimbDamage(character, damage, resist, HITGROUP_STOMACH, true)

		-- arms damage:
		resist = equipment["hands"] and equipment["hands"].thermalIsolation or 0
		damageTaken = self:TakeThermalLimbDamage(character, damage, resist, HITGROUP_LEFTARM, true)
		damageTaken = self:TakeThermalLimbDamage(character, damage, resist, HITGROUP_RIGHTARM, true)

		-- legs damage:
		resist = equipment["hands"] and equipment["hands"].thermalIsolation or 0
		damageTaken = self:TakeThermalLimbDamage(character, damage, resist, HITGROUP_LEFTLEG, true)
		damageTaken = self:TakeThermalLimbDamage(character, damage, resist, HITGROUP_RIGHTLEG, true)
	end
	if resist and (resist > 0) then
		offset = offset * (1 - (resist * 0.1))
	end

	-- TODO: overall body temperature effects that affect gameplay
	-- character:SetTemperature(math.Clamp(character:GetTemperature() - offset, 24, 37.2))
end

function PLUGIN:GetTempDamage(temperature)
	local allDmg = self.dmgMin + self.dmgMax
	local allOff = self.offMin + self.offMax
	local damage = math.abs(temperature - self.tempMax) * allDmg / (math.abs(self.tempMin) + self.tempMax)
	local offset = math.abs(temperature - self.tempMax) * allOff / (math.abs(self.tempMin) + self.tempMax)
	return damage, offset
end

function PLUGIN:CalculateThermalDamage(temperature, client)
	if temperature >= 0 and temperature <= 29 then return end
	if (client.ixObsData) then return end

	local character = client:GetCharacter()
	local inventory = character:GetEquipment()
	local equipment = {
		["head"] = inventory:GetItemAtSlot(EQUIP_HEAD),
		["torso"] = inventory:GetItemAtSlot(EQUIP_TORSO),
		["hands"] = inventory:GetItemAtSlot(EQUIP_HANDS),
		["legs"] = inventory:GetItemAtSlot(EQUIP_LEGS)
	}

	-- todo:
	-- we should probably do isolation calculation once on equip
	-- to get rid of doing GetItemAtSlot every tick
	-- and write it somewhere in character (SetData? NetVar?)

	local damage, offset = self:GetTempDamage(temperature)

	self:CalculateThermalLimbDamage(temperature, client, equipment, damage, offset)
end

function PLUGIN:TempTick(client)
	local area = ix.area.stored[client.ixArea]
	local temperature

	if area and client.ixInArea then
		temperature = area.properties.temperature
	else
		temperature = self.globalTemp
	end

	self:CalculateThermalDamage(temperature, client)
end
