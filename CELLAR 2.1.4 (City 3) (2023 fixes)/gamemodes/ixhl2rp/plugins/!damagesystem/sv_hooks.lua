
local PLUGIN = PLUGIN

do
	local ENTITY = FindMetaTable("Entity")
	local PLAYER = FindMetaTable("Player")
	oldDispatchAttack = oldDispatchAttack or ENTITY.DispatchTraceAttack

	function ENTITY:DispatchTraceAttack(dmgInfo, traceResult, dir)
		local attacker = dmgInfo:GetAttacker()

		if IsValid(attacker) then
			if hook.Run("EntityTraceAttack", attacker, self, traceResult, dmgInfo) == false then
				oldDispatchAttack(self, dmgInfo, traceResult, dir)
				return
			end
		end

		oldDispatchAttack(self, dmgInfo, traceResult, dir)
	end

	function PLAYER:DropActiveWeaponItem()
		local weapon = IsValid(self:GetActiveWeapon()) and self:GetActiveWeapon().ixItem or nil

		if weapon then
			weapon:Unequip(self, false)
			weapon:Transfer(nil, nil, nil, self)
		end
	end

	function PLAYER:SetCriticalState(state)
		local character = self:GetCharacter()

		if !character then
			return
		end

		if state then
			if self:InOutlands() then
				self.KilledByRP = false
				self:Kill()

				hook.Run("DoPlayerDeath", self)

				return
			end
			
			self:SetHealth(1)
			self:SetNetVar("crit", true)

			if self:IsCombine() then
				local letter = dispatch.AddWaypoint(self:GetShootPos(), "ПОТЕРЯ БИО-СИГНАЛА", "death", 30)
				Schema:AddCombineDisplayMessage(string.format("Метка %s: потерян био-сигнал с наземной единицей!", letter), color_red)
			end

			character:SetData("crit", true)
			character:SetData("critTime", os.time() + 600)

			if !IsValid(self.ixRagdoll) then
				self:SetRagdolled(true)
				self.ixRagdoll.ixGrace = nil
				self:SetLocalVar("knocked", true)
			end
		else
			self:SetNetVar("crit", nil)

			character:SetData("crit", nil)
			character:SetData("critTime", nil)
		end
	end

	function PLAYER:InCriticalState()
		return self:GetNetVar("crit")
	end
end

function PLUGIN:ResetDamageData(client, character, force)
	if force or client.KilledByRP then
		character:SetDmgData({
			isBleeding = false,
			isPain = false,
			bleedBone = 0,
			bleedDmg = 0
		})

		character:SetBlood(5000)
		character:SetShock(0)

		client:SetHealth(client:GetMaxHealth())
		client:SetNetVar("isBleeding", false)
		client:SetNetVar("bleedingBone", 0)
		
		character:ResetLimbDamage()

		client.KilledByRP = nil
	end

	client.ixUnconsciousOut = nil
	client:SetNetVar("doll", nil)
	client:SetLocalVar("knocked", false)

/*
	net.Start("ixCritData")
		net.WriteEntity(client)
		net.WriteBool(false)
	net.Broadcast()
*/
	net.Start("ixBleedingEffect")
		net.WriteEntity(client)
	net.Broadcast()
end

function PLUGIN:PlayerInitialSpawn(client)
	client:SetBloodColor(-1)
end

function PLUGIN:OnPlayerRespawn(client)
	local character = client:GetCharacter()

	if character then
		client:SetCriticalState(false)

		self:ResetDamageData(client, character, true)
	end
end

function PLUGIN:PlayerDisconnected(client)
	local character = client:GetCharacter()

	if character then
		if client:InCriticalState() then
			client.KilledByRP = true
			client:Kill()
					
			character:Ban()
			character:Save()
		end
	end
end

function PLUGIN:OnCharacterCreated(client, character)
	client.KilledByRP = nil

	self:ResetDamageData(client, character, true)
end

function PLUGIN:PostPlayerLoadout(client)
	local character = client:GetCharacter()

	if !client.KilledByRP then
		local dmgData = character:GetDmgData()

		if dmgData.bleedDmg > 0 then
			dmgData.bleedDmg = 1
		end

		character:SetDmgData(dmgData)
		character:SetBlood(math.max(character:GetBlood(), 3500))
		character:SetShock(math.min(character:GetShock(), character:GetBlood()))

		local limbs = character:Limbs()

		if limbs then
			local limbData = character:GetLimbData()

			for k, v in pairs(limbs.stored) do
				local n = v:Name()
				limbData[n] = math.min((limbData[n] or 0), 90)
			end

			character:SetLimbData(limbData)
		end
		
		client:SetHealth(self:GetMinimalHealth(character))
	else
		if character and character:GetBlood() < 0 then
			self:ResetDamageData(client, character, true)
		end
	end

	if client.KilledNotify then
		ix.chat.Send(nil, "dmgMsg", "", false, {client}, {t = 2})
	end
/*
	net.Start("ixCritData")
		net.WriteEntity(client)
		net.WriteBool(false)
	net.Broadcast()
*/
	client.KilledByRP = nil
end

local function TransferItem(item, invID, x, y)
	item.Dropped = true

	if item.OnUnequipped then
		item:OnUnequipped(item:GetOwner())
	end

	if item.Unequip then
		item:Unequip(item:GetOwner())
	end

	item:Transfer(invID, x, y)
end

function PLUGIN:DoPlayerDeath(client)
	local character = client:GetCharacter()

	if character then
		if !IsValid(client.ixRagdoll) then
			for k, v in pairs(client:GetWeapons()) do
				local weapon = v.ixItem
				if !weapon then continue end

				weapon:Unequip(client, false)
				weapon:Transfer(nil, nil, nil, self)
			end
		end

		local charInventory = character:GetInventory()
		local equipment = character:GetEquipment()
		local stack = {}
		local items = {}
		local weapons = {}

		for _, item in pairs(charInventory:GetItems()) do
			if item.uniqueID:find("card") then continue end
			if item.base == "base_weaponstest" and item:GetData("equip") then 
				weapons[#weapons + 1] = item
				continue 
			end

			if !item.KeepOnDeath or (client.KilledByRP and !item.KeepOnCrit) then
				stack[#stack + 1] = item
			end
		end

		for _, item in pairs(equipment:GetItems()) do
			if item.uniqueID:find("card") then continue end

			if !item.KeepOnDeath or (client.KilledByRP and !item.KeepOnCrit) then
				stack[#stack + 1] = item
			end
		end
		
		if !client.KilledByRP and !client:InOutlands() then
			local max = math.floor((#stack * 0.3))

			for i = 1, max do
				local r = math.random(#stack)

				items[#items + 1] = stack[r]

				table.remove(stack, r)
			end

			for k, item in ipairs(weapons) do
				items[#items + 1] = item
			end
		end

		local money = client.KilledByRP and character:GetMoney() or math.ceil(character:GetMoney() * 0.3)

		if ((client.KilledByRP or client:InOutlands()) and #stack or #items) > 0 or money > 0 then
			local container = ents.Create("ix_drop")
			container:SetPos(client:GetPos() + client:GetAngles():Forward() * 5)
			container:Spawn()

			local uniqueID = "ixDecay" .. container:EntIndex()

			container:CallOnRemove("ixDecayRemove", function(container)
				ix.storage.Close(container:GetInventory())

				if timer.Exists(uniqueID) then
					timer.Remove(uniqueID)
				end
			end)

			timer.Create(uniqueID, 1800, 1, function()
				if IsValid(container) then
					container:Remove()
				else
					timer.Remove(uniqueID)
				end
			end)

			local inventory = ix.inventory.Create(ix.config.Get("inventoryWidth") * 2, ix.config.Get("inventoryHeight") * 2, os.time())
			inventory.vars.isBag = false
			inventory.vars.isDrop = true
			inventory.vars.entity = container
			inventory.noSave = true

			function inventory.OnAuthorizeTransfer(_, _, _, item)
				if item.Dropped then
					return true
				end
			end

			container:SetInventory(inventory)

			container:SetMoney(money)
			character:SetMoney(character:GetMoney() - money)

			for k, v in ipairs(((client.KilledByRP or client:InOutlands()) and stack or items)) do
				if v.ReplaceOnDeath then
					inventory:Add(v.ReplaceOnDeath)
				else
					TransferItem(v, inventory:GetID(), v.gridX, v.gridY)
				end
			end
		end

		character:SetBlood(-1)

		if client.KilledByRP then
			character:SetDmgData({
				isBleeding = 0,
				isPain = false,
				bleedBone = 0,
				bleedDmg = 0
			})
			character:SetShock(0)
			
			client:SetNetVar("isBleeding", false)
			client:SetNetVar("bleedingBone", 0)
		else
			local dmgData = character:GetDmgData()

			if dmgData.bleedDmg > 0 then
				dmgData.bleedDmg = 1
			end

			character:SetDmgData(dmgData)
			character:SetBlood(math.max(character:GetBlood(), 3500))
			character:SetShock(math.min(character:GetShock(), character:GetBlood()))
		end

		client.KilledNotify = !client.KilledByRP

		client:SetNetVar("doll", nil)
		client:SetLocalVar("knocked", false)
		client.ixUnconsciousOut = nil

		if IsValid(client.ixCritUsedBy) then
			client.ixCritUsedBy.ixCritUsing = nil
		end

		client.ixCritUsedBy = nil
/*
		net.Start("ixCritData")
			net.WriteEntity(client)
			net.WriteBool(false)
		net.Broadcast()
*/
		net.Start("ixBleedingEffect")
			net.WriteEntity(client)
		net.Broadcast()
	end
end

function PLUGIN:PostPlayerDeath(client)
	
end

function PLUGIN:PlayerLoadedCharacter(client, character, oldCharacter)
	client.KilledByRP = nil
	client:SetNetVar("doll", nil)
	client:SetLocalVar("knocked", false)
	client.ixUnconsciousOut = nil
	client:SetNetVar("crit", nil)

	if character:GetData("crit") then
		client:SetHealth(1)
		client:SetNetVar("crit", true)

		client:SetRagdolled(true)
		client.ixRagdoll.ixGrace = nil
		client:SetLocalVar("knocked", true)
	end

/*
	net.Start("ixCritData")
		net.WriteEntity(client)
		net.WriteBool(false)
	net.Broadcast()
*/
	character:SetupUnconscious()
	character:SetupBleeding()
	character:SetupFeelPain()
	character:HandleBrokenBones()
end

function PLUGIN:ScaleDamageByHitGroup(client, lastHitGroup, dmgInfo)
	local weapon = dmgInfo:GetInflictor()

	if weapon.IsHL2Grenade then
		dmgInfo:ScaleDamage(2.5)
	end

	local a = 1
	if lastHitGroup == HITGROUP_HEAD then
		a = 2
		dmgInfo:ScaleDamage(2)
	end

	return a
end

function PLUGIN:GetArmorDamageReduction(player, lastHitGroup, dmg)
	if IsValid(player) and player:Team() != FACTION_VORTIGAUNT then
		local Armor = 0

		if player.ArmorItems then
			for item, v in pairs(player.ArmorItems or {}) do
				Armor = Armor + (item.Stats[lastHitGroup] or 0)
			end
		end

		Armor = Armor * 5

		return math.min(1 + Armor / dmg, 4)
	end

	return 1
end

function PLUGIN:GetAttackDistance(entity, targetPos)
	local a = math.max(entity:GetShootPos():DistToSqr(targetPos) / 803000, 0)

	if a > 1.6 then
		return PLUGIN.RANGE_FAR
	elseif a > 0.8 then
		return PLUGIN.RANGE_LONG
	elseif a > 0.3 then
		return PLUGIN.RANGE_MEDIUM
	end

	return PLUGIN.RANGE_CLOSE
end

local hitboneLang = {
	[0] = "@attHg0",
	[1] = "@attHg1",
	[2] = "@attHg2",
	[3] = "@attHg3",
	[4] = "@attHg4",
	[5] = "@attHg5",
	[6] = "@attHg6",
	[7] = "@attHg7"
}

local AgilityDistanceMod = {
	[1] = -75,
	[2] = -5,
	[3] = 5,
	[4] = 10
}

local function GetRagdollHitGroup(entity, position)
	local closest = {nil, HITGROUP_GENERIC}

	for k, v in pairs(ix.limb.bones) do
		local bone = entity:LookupBone(k)

		if bone then
			local bonePosition = entity:GetBonePosition(bone)

			if position then
				local distance = bonePosition:Distance(position)

				if !closest[1] or distance < closest[1] then
					closest[1] = distance
					closest[2] = v
				end
			end
		end
	end

	return closest[2]
end

function PLUGIN:GetWeaponSkill(character, weapon)
	return weapon.ImpulseSkill and character:GetSkillModified("impulse") or character:GetSkillModified("guns")
end

do
	local function SkillRoll(value, skill)
		if value == 0 then
			return true
		elseif value == 10 then
			return false
		elseif value <= skill then
			return true
		end
	end

	local function StatRoll(stat)
		local value = math.random(1, 10)

		if value == 1 then
			return true
		elseif value == 10 then
			return false
		elseif value <= stat then
			return true
		end
	end

	-- limbs_penalties task addition
	local function ScaleHitChanceByHandsDamage(hitChance, character)
		local leftHandDamage, rightHandDamage = character:GetLimbDamage("leftHand", true), character:GetLimbDamage("rightHand", true)

		if (leftHandDamage > 0 or rightHandDamage > 0) then
			hitChance = hitChance * (1 - ((leftHandDamage * 0.5) + (rightHandDamage * 0.5)))
		end

		return hitChance
	end

	function PLUGIN:DoRangeAttack(entity, character, weapon, trace, dmgInfo, highNum, penetration)
		if highNum then
			local data = {}
				data.start = entity:GetShootPos()
				data.endpos = entity:GetShootPos() + entity:GetAimVector() * 803000
				data.filter = {entity}

			trace = util.TraceLine(data)
		end

		local isRagdoll = IsValid(trace.Entity.ixPlayer) and trace.Entity.ixPlayer or nil
		local target = isRagdoll and isRagdoll or trace.Entity
		local isHittingPlayer = IsValid(target) and target:IsPlayer()
		local hitGroup = trace.HitGroup
		local commandNumber = entity:GetCurrentCommand():CommandNumber()
		local Hit = false

		entity.LastBulletHit = entity.LastBulletHit or 0

		if penetration and entity.LastBulletHit == commandNumber then
			return
		end

		if !penetration and entity.LastBulletCheckCmd == commandNumber then
			return entity.LastBulletCheckHit
		end

		entity.LastBulletCheckCmd = commandNumber
		
		if isHittingPlayer then
			if target:InCriticalState() then
				return false
			end
			
			if isRagdoll then
				hitGroup = GetRagdollHitGroup(trace.Entity, trace.HitPos)
			end

			local targetCharacter = target:GetCharacter()
			local DistanceType = self:GetAttackDistance(entity, trace.HitPos)

			local weaponMod = 0

			if weapon.ixItem then
				weaponMod = (weapon.ixItem.DistanceSkillMod[DistanceType] or 0) * 10
			else
				weaponMod = (weapon.Stat_DistanceSkillMod[DistanceType] or 0) * 10
			end

			local gunBuff = 0

			if entity.ArmorItems then
				for item, v in pairs(entity.ArmorItems or {}) do
					gunBuff = gunBuff + (item.WeaponSkillBuff or 0)
				end
			end

			local weaponSkill = ((self:GetWeaponSkill(character, weapon) + gunBuff) * 10)
			local luckMod = character:GetSpecial("lk")
			local perceptionMod = (character:GetSpecial("pe") + 5) / 10
			local hitChance = (weaponMod + (weaponSkill * perceptionMod) + luckMod)

			hitChance = ScaleHitChanceByHandsDamage(hitChance, character)

			local SkillTest = isRagdoll and true or math.random(1, 100) < (10 + hitChance)
			local AgilityTest = false
			local PenetrationTest = false

			if SkillTest then
				local targetLuckMod, targetAgilityMod = targetCharacter:GetSpecial("lk"), (targetCharacter:GetSpecial("ag") * 5)
				local AttackRolls, DefendRolls = character:GetRolls(), targetCharacter:GetRolls()

				if !isRagdoll then
					local isStanding = target:GetVelocity():LengthSqr() <= 100
					local targetSpeedMod = isStanding and 0 or 1 + math.Clamp(math.Remap(target:GetVelocity():LengthSqr(), 2500, 55225, 0, 1), 0, 1)
					local evasionChance = ((hitChance + AttackRolls[1]) - ((DefendRolls[1] + targetAgilityMod + targetLuckMod) * targetSpeedMod))

					AgilityTest = math.random(1, 100) < (math.Clamp(evasionChance, 51, 89) + (targetCharacter:GetData("neo") or 0))
				else
					AgilityTest = true
				end

				if AgilityTest then
					local Attack = 1
					local Armor = 1

					if IsValid(weapon) then 
						if weapon.ixItem then
							Attack = weapon.ixItem.Attack or Attack
						else
							Attack = weapon.Stat_Attack or Attack
						end
					end

					if target.ArmorItems then
						for item, v in pairs(target.ArmorItems or {}) do
							Armor = Armor + (item.Stats[hitGroup] or 0)
						end
					end

					local penetrationChance = 100 * (Attack / Armor)

					PenetrationTest = math.random(0, 100) <= penetrationChance

					if PenetrationTest then
						entity.LastBulletHit = commandNumber
						Hit = true
					end
				end
			end

			if weapon.ImpulseSkill then
				character:DoAction(Hit and (DistanceType > 2 and "shootFarSuccess2" or "shootSuccess2") or "shootMiss2")
			else
				character:DoAction(Hit and (DistanceType > 2 and "shootFarSuccess" or "shootSuccess") or "shootMiss")
			end

			--entity:Emote("it", SkillTest and "attackMe" or "attackFailMe", weapon.ixItem and weapon.ixItem:GetName() or weapon:GetClass(), hitboneLang[hitGroup] or hitboneLang[0], targetCharacter:GetName(), !AgilityTest and "@attAgSuccess" or (PenetrationTest and "@attSuccess1" or "@attArmorFail"))
			entity.LastBulletCheckHit = Hit

			return Hit
		end

		entity.LastBulletCheckHit = true
		return true
	end

	function PLUGIN:DoMeleeAttack(entity, character, weapon, targetEntity, trace, dmgInfo)
		local isRagdoll = IsValid(targetEntity.ixPlayer) and targetEntity.ixPlayer or nil
		local target = isRagdoll and isRagdoll or targetEntity
		local isHittingPlayer = IsValid(target) and target:IsPlayer()
		local hitGroup = trace.HitGroup
		local Hit = false

		if isHittingPlayer then
			if target:InCriticalState() then
				return false
			end

			local targetWeapon = target:GetActiveWeapon()
			local isFists = IsValid(targetWeapon) and targetWeapon.IsFists or true

			if isRagdoll then
				hitGroup = GetRagdollHitGroup(trace.Entity, trace.HitPos)
			end

			local isStanding = true
			local isBackstab = false

			if !isRagdoll then
				isStanding = target:GetVelocity():LengthSqr() <= 100

				local vecAimTarget, vecAimAttacker = target:GetAimVector(), entity:GetAimVector()
				vecAimTarget.z = 0
				vecAimAttacker.z = 0

				if vecAimTarget:DotProduct(vecAimAttacker) > 0.25 then
					isBackstab = true
				end
			end

			local targetCharacter = target:GetCharacter()
			local AttackRolls, DefendRolls = character:GetRolls(), targetCharacter:GetRolls()

			if (targetCharacter:GetData("neo") or 0) != 0 then
				isBackstab = false
			end
			
			local targetMaxStamina = targetCharacter:GetMaxStamina()
			local targetCurrentStamina = target:GetLocalVar("stm", 0)
			local targetLuckMod, targetAgilityMod = targetCharacter:GetSpecial("lk"), (targetCharacter:GetSpecial("ag") * 2)
			local targetSpeedMod = isStanding and 0 or 1 + math.Clamp(math.Remap(target:GetVelocity():LengthSqr(), 2500, 55225, 0, 0.75), 0, 0.75)
			local evasionChance = ((DefendRolls[1] + targetAgilityMod + targetLuckMod) * (0.5 + 0.5 * targetCurrentStamina / targetMaxStamina)) * targetSpeedMod

			local maxStamina = character:GetMaxStamina()
			local currentStamina = entity:GetLocalVar("stm", 0)
			local weaponSkill = (character:GetSkillModified("meleeguns") * 10)
			local luckMod = character:GetSpecial("lk")
			local agilityMod = (character:GetSpecial("ag") * 2)
			local hitChance = ((isStanding and 25 or 0) + (isBackstab and 100 or 0) + weaponSkill + agilityMod + luckMod) * (0.75 + 0.5 * currentStamina / maxStamina)

			hitChance = ScaleHitChanceByHandsDamage(hitChance, character)

			local skilltest = isRagdoll and true or math.random(1, 100) < (hitChance - evasionChance)
		
			local ParryTest = false
			local PenetrationTest = true
			local hasArmor = false

			if skilltest then
				if isBackstab or isRagdoll then
					ParryTest = true
				elseif !ParryTest then
					local weaponSkill = isFists and (targetCharacter:GetSkillModified("unarmed") * 10) or (targetCharacter:GetSkillModified("meleeguns") * 10)
					local parryChance = math.Clamp(weaponSkill + evasionChance, 10, 50) 

					ParryTest = math.random(1, 100) > (parryChance - (targetCharacter:GetData("neo") or 0))
				end

				if ParryTest then
					local Attack = 1
					local Armor = 1

					if IsValid(weapon) and weapon.ixItem then
						Attack = weapon.ixItem.Attack or 1
					end

					Attack = Attack + (character:GetSpecial("st") * 2)

					if hitGroup != HITGROUP_HEAD and target.ArmorItems then
						for item, v in pairs(target.ArmorItems or {}) do
							Armor = Armor + (item.Stats[hitGroup] or 0)
						end
					end

					if Armor > 1 then
						hasArmor = true
					end

					local penetrationChance = 100 * (Attack / Armor)

					PenetrationTest = math.random(0, 100) <= penetrationChance

					if PenetrationTest then
						if weapon.IsStun then
							if weapon:IsActivated() then
								target.ixStuns = (target.ixStuns or 0) + 1

								timer.Simple(10, function()
									target.ixStuns = math.max(target.ixStuns - 1, 0)
								end)
							end

							target:ViewPunch(Angle(-20, math.random(-15, 15), math.random(-10, 10)))

							if weapon:IsActivated() and target.ixStuns > 3 then
								target:SetRagdolled(true, 60)
								target.ixStuns = 0
							end
						end

						Hit = true
					end
				else
					targetCharacter:DoAction(isFists and "unarmedParry" or "meleeParry")
				end
			end
			
			character:DoAction(Hit and "meleeSuccess" or "meleeMiss")

			--local armorText = hasArmor and "@attSuccess1" or ""
			--entity:Emote("it", skilltest and "meleeMe" or "meleeFailMe", weapon.ixItem and weapon.ixItem:GetName() or weapon:GetClass(), hitboneLang[hitGroup] or hitboneLang[0], targetCharacter:GetName(), !ParryTest and "@meleeParry" or (PenetrationTest and armorText or "@attArmorFail"))
			
			return Hit
		end

		return true
	end

	function PLUGIN:DoFistsAttack(entity, character, weapon, targetEntity, trace, dmgInfo)
		local isRagdoll = IsValid(targetEntity.ixPlayer) and targetEntity.ixPlayer or nil
		local target = isRagdoll and isRagdoll or targetEntity
		local isHittingPlayer = IsValid(target) and target:IsPlayer()
		local hitGroup = trace.HitGroup
		local Hit = false

		if isHittingPlayer then
			if target:InCriticalState() then
				return false
			end

			local targetWeapon = target:GetActiveWeapon()
			local isFists = IsValid(targetWeapon) and targetWeapon.IsFists or true

			if isRagdoll then
				hitGroup = GetRagdollHitGroup(trace.Entity, trace.HitPos)
			end

			local isStanding = true
			local isBackstab = false

			if !isRagdoll then
				isStanding = target:GetVelocity():LengthSqr() <= 100

				local vecAimTarget, vecAimAttacker = target:GetAimVector(), entity:GetAimVector()
				vecAimTarget.z = 0
				vecAimAttacker.z = 0

				if vecAimTarget:DotProduct(vecAimAttacker) > 0.25 then
					isBackstab = true
				end
			end

			local targetCharacter = target:GetCharacter()
			local AttackRolls, DefendRolls = character:GetRolls(), targetCharacter:GetRolls()

			if (targetCharacter:GetData("neo") or 0) != 0 then
				isBackstab = false
			end

			local targetMaxStamina = targetCharacter:GetMaxStamina()
			local targetCurrentStamina = target:GetLocalVar("stm", 0)
			local targetLuckMod, targetAgilityMod = targetCharacter:GetSpecial("lk"), (targetCharacter:GetSpecial("ag") * 2)
			local targetSpeedMod = isStanding and 0 or 1 + math.Clamp(math.Remap(target:GetVelocity():LengthSqr(), 2500, 55225, 0, 0.75), 0, 0.75)
			local evasionChance = ((DefendRolls[1] + targetAgilityMod + targetLuckMod) * (0.5 + 0.5 * targetCurrentStamina / targetMaxStamina)) * targetSpeedMod

			local maxStamina = character:GetMaxStamina()
			local currentStamina = entity:GetLocalVar("stm", 0)
			local weaponSkill = (character:GetSkillModified("unarmed") * 10)
			local luckMod = character:GetSpecial("lk")
			local agilityMod = (character:GetSpecial("ag") * 2)
			local hitChance = ((isStanding and 25 or 0) + (isBackstab and 100 or 0) + weaponSkill + agilityMod + luckMod) * (0.75 + 0.5 * currentStamina / maxStamina)

			hitChance = ScaleHitChanceByHandsDamage(hitChance, character)

			local skilltest = isRagdoll and true or math.random(1, 100) < (hitChance - evasionChance)
		
			local ParryTest = false
			local PenetrationTest = true
			local hasArmor = false

			if skilltest then
				if isBackstab or isRagdoll then
					ParryTest = true
				elseif !ParryTest then
					local weaponSkill = isFists and (targetCharacter:GetSkillModified("unarmed") * 10) or (targetCharacter:GetSkillModified("meleeguns") * 10)
					local parryChance = math.Clamp(weaponSkill + evasionChance, 10, 50) 

					ParryTest = math.random(1, 100) > (parryChance - (targetCharacter:GetData("neo") or 0))
				end

				if ParryTest then
					local Attack = 1 + character:GetSpecial("st")
					local Armor = 1

					if hitGroup != HITGROUP_HEAD and target.ArmorItems then
						for item, v in pairs(target.ArmorItems or {}) do
							Armor = Armor + (item.Stats[hitGroup] or 0)
						end
					end

					if Armor > 1 then
						Attack = math.min(Attack, Armor)
						hasArmor = true
					end

					local penetrationChance = 100 * (Attack / Armor)

					PenetrationTest = math.random(0, 100) <= penetrationChance

					if PenetrationTest then
						Hit = true
					end
				else
					targetCharacter:DoAction(isFists and "unarmedParry" or "meleeParry")
				end
			end

			character:DoAction(Hit and "unarmedSuccess" or "unarmedFail")

			--local armorText = hasArmor and "@attSuccess1" or ""
			--entity:Emote("it", skilltest and "fistsMe" or "fistsFailMe", hitboneLang[hitGroup] or hitboneLang[0], targetCharacter:GetName(), !ParryTest and "@meleeParry" or (PenetrationTest and armorText or "@attArmorFail"))

			return Hit
		end

		return true
	end
end

function PLUGIN:EntityFireBullets(entity, bulletInfo)

end

function PLUGIN:ArcCWBulletCallback(weapon, attacker, trace, dmgInfo, highNum)
	if !self:DoRangeAttack(attacker, attacker:GetCharacter(), weapon, trace, dmgInfo, highNum) then
		dmgInfo:SetDamage(0)

		return false
	end
end

function PLUGIN:ArcCWPenetrationCallback(weapon, attacker, trace, dmgInfo)
	if !self:DoRangeAttack(attacker, attacker:GetCharacter(), weapon, trace, dmgInfo, nil, true) then
		dmgInfo:SetDamage(0)

		return false
	end
end

function PLUGIN:EntityTraceAttack(attacker, target, trace, dmgInfo)
	local weapon = dmgInfo:GetInflictor()
	if IsValid(weapon) then
		if attacker:GetCharacter():GetData("zombie", false) then
			weapon.IsFists = false
			weapon.BloodDamage = 2000
			if target.GetCharacter then
				ix.plugin.list["apocalypse"]:InfectCharacter(target:GetCharacter())
			end
		end
		if weapon.IsFists then
			if !self:DoFistsAttack(attacker, attacker:GetCharacter(), dmgInfo:GetInflictor(), target, trace, dmgInfo) then
				dmgInfo:SetDamage(0)

				return false
			end
		elseif !self:DoMeleeAttack(attacker, attacker:GetCharacter(), dmgInfo:GetInflictor(), target, trace, dmgInfo) then
			dmgInfo:SetDamage(0)

			return false
		end
	end
end

function PLUGIN:GetMinimalHealth(character)
	local head = character:GetLimbDamage("head")
	local chest = character:GetLimbDamage("chest")
	local stomach = character:GetLimbDamage("stomach")
	local lleg = character:GetLimbDamage("leftLeg")
	local rleg = character:GetLimbDamage("rightLeg")
	local lhand = character:GetLimbDamage("leftHand")
	local rhand = character:GetLimbDamage("rightHand")

	return 100 - (head + ((chest + stomach)/2) + ((lleg + rleg)/2) + ((lhand + rhand)/2))/4
end

function PLUGIN:GetBloodDamageInfo(inflictor)
	if inflictor:IsPlayer() and IsValid(inflictor:GetActiveWeapon()) then 
		inflictor = inflictor:GetActiveWeapon()
	end

	local bloodDmgInfo = BloodDmgInfo()

	if inflictor.IsFists then
		bloodDmgInfo:SetShock(150)
		bloodDmgInfo:SetBlood(0)
		bloodDmgInfo:SetBleedChance(0)

		return bloodDmgInfo
	elseif isfunction(inflictor.GetBloodDamageInfo) then
		local shock, blood, bleed = inflictor:GetBloodDamageInfo()

		bloodDmgInfo:SetShock(shock or 0)
		bloodDmgInfo:SetBlood(blood or 0)
		bloodDmgInfo:SetBleedChance(bleed or 0)

		return bloodDmgInfo
	elseif inflictor.IsVortibeam then
		bloodDmgInfo:SetShock(9500)
		bloodDmgInfo:SetBlood(1000)
		bloodDmgInfo:SetBleedChance(0)

		return bloodDmgInfo
	end

	bloodDmgInfo:SetShock(inflictor.ShockDamage or 0)
	bloodDmgInfo:SetBlood(inflictor.BloodDamage or 0)
	bloodDmgInfo:SetBleedChance(inflictor.BleedChance or 0)

	return bloodDmgInfo
end

function PLUGIN:OnCharacterFallover(client, ragdoll, state)
	if !state then
		client:SetCriticalState(false)
		/*
		net.Start("ixCritData")
			net.WriteEntity(self)
			net.WriteBool(false)
		net.Broadcast()
		*/
	end
end

local painSounds = {
	Sound("vo/npc/male01/pain01.wav"),
	Sound("vo/npc/male01/pain02.wav"),
	Sound("vo/npc/male01/pain03.wav"),
	Sound("vo/npc/male01/pain04.wav"),
	Sound("vo/npc/male01/pain05.wav"),
	Sound("vo/npc/male01/pain06.wav")
}

local painSoundsVort = {
	Sound("vo/npc/vortigaunt/vortigese03.wav"),
	Sound("vo/npc/vortigaunt/vortigese02.wav"),
	Sound("vo/npc/vortigaunt/vortigese08.wav"),
	Sound("vo/npc/vortigaunt/vortigese04.wav")
}
  
function PLUGIN:PlayerAdvancedHurt(client, attacker, damage, blood, shock, limb)
	if (client.ixNextPain or 0) < CurTime() then
		local painSound = hook.Run("GetPlayerPainSound", client) or painSounds[math.random(1, #painSounds)]

		if (client:IsFemale() and !painSound:find("female")) then
			painSound = painSound:gsub("male", "female")
		end
		
		if (client:GetCharacter():GetFaction() == FACTION_VORTIGAUNT) then
			painSound = painSoundsVort[math.random(1, #painSoundsVort)]
		end

		client:EmitSound(painSound)
		client.ixNextPain = CurTime() + 0.33
	end

	ix.log.AddRaw(string.format("%s has taken damage from %s (dmg: %s; blood: %s; shock: %s; limb: %s).", client:Name(), attacker:GetName() != "" and attacker:GetName() or attacker:GetClass(), damage, blood, shock, limb))
end

do
	local function StatRoll(stat)
		local value = math.random(1, 10)

		if value == 1 then
			return true
		elseif value == 10 then
			return false
		elseif value <= stat then
			return true
		end
	end

	function PLUGIN:PlayerLimbTakeDamage(client, limb, damage, character, hitgroup)
		if character:GetData("armored") or istable(client.ixObsData) then
			return
		end

		if hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG then
			if !client:IsOTA() then
				local damage = 1.2 * character:GetLimbDamage(limb, true)

				if damage > 0 and !IsValid(client.ixRagdoll) and !client:IsUnconscious() then
					if math.random(1, 100) < damage then
						client:DropActiveWeaponItem()

						local time = 5 + (damage * 0.25)
						client:SetRagdolled(true, time, time)
					end
				end
			end
		elseif hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTARM then
			local damage = 50 * character:GetLimbDamage(limb, true)

			if damage > 0 and weapon then
				if math.random(1, 100) < damage then
					if !StatRoll(math.max(targetCharacter:GetSpecial("ag") - 5, 1)) then
						client:DropActiveWeaponItem()
					end
				end
			end
		end
	end
end

local names = {
	[HITGROUP_HEAD] = "HEAD",
	[HITGROUP_CHEST] = "CHEST",
	[HITGROUP_STOMACH] = "STOMACH",
	[HITGROUP_LEFTARM] = "ARM",
	[HITGROUP_RIGHTARM] = "ARM",
	[HITGROUP_LEFTLEG] = "LEG",
	[HITGROUP_RIGHTLEG] = "LEG",
	[HITGROUP_GENERIC] = "ALL",
}

function PLUGIN:CalculateCreatureDamage(client, lastHitGroup, dmgInfo, multiplier)
	if istable(client.ixObsData) then dmgInfo:SetDamage(0) return end

	local baseDamage = dmgInfo:GetDamage()

	if baseDamage <= 0 then
		return
	end

	local character = client:GetCharacter()
	local damageType = dmgInfo:GetDamageType()
	local info = client.infoTable

	if istable(info.immunities) then
		for k, v in ipairs(info.immunities) do
			if damageType == v then
				dmgInfo:SetDamage(0)
				return
			end
		end
	end

	if dmgInfo:IsFallDamage() and info.noFallDamage then
		dmgInfo:SetDamage(0)
		return
	end

	local inflictor = dmgInfo:GetInflictor()
	local attacker = dmgInfo:GetAttacker()

	if inflictor.IsVortibeam then
		baseDamage = 75
	end

	dmgInfo:SetDamage(0)

	if attacker:IsPlayer() then
		local isHead = lastHitGroup == HITGROUP_HEAD
		local isChest = lastHitGroup == HITGROUP_CHEST or lastHitGroup == HITGROUP_STOMACH or lastHitGroup == HITGROUP_GENERIC
		local isMinor = (!isHead and !isChest)
		local attackerChar = attacker.GetCharacter and attacker:GetCharacter()
		local strengthMul = 1

		if attackerChar then
			if damageType == DMG_CLUB then
				strengthMul = math.Clamp(math.Remap(attackerChar:GetSpecial("st"), 1, 10, 0.25, 3), 0.25, 3)
			end

			if inflictor.IsFists and damageType == DMG_CLUB then
				baseDamage = (attackerChar:GetSkillModified("unarmed") + 1) * 0.75
			end
		end

		baseDamage = baseDamage * strengthMul

		if isMinor then
			baseDamage = baseDamage * 0.1
		elseif isHead then
			baseDamage = baseDamage * 1.5
		end
	end

	local newHP = math.max(client:Health() - baseDamage, 0)
	client:SetHealth(newHP)

	if newHP <= 0 then
		dmgInfo:SetDamage(1)
	end

	self:PlayerAdvancedHurt(client, dmgInfo:GetAttacker(), baseDamage, 0, 0, names[lastHitGroup] or "GENERIC")
end

local random_limbs = {
	HITGROUP_RIGHTARM,
	HITGROUP_LEFTARM,
	HITGROUP_RIGHTLEG,
	HITGROUP_LEFTLEG,
	HITGROUP_STOMACH,
	HITGROUP_CHEST,
	HITGROUP_HEAD
}
function PLUGIN:CalculatePlayerDamage(client, lastHitGroup, dmgInfo, multiplier)
	if istable(client.ixObsData) then dmgInfo:SetDamage(0) return end

	local baseDamage = dmgInfo:GetBaseDamage()

	if baseDamage <= 0 then
		return
	end

	local character = client:GetCharacter()
	local bDamageIsValid = dmgInfo:IsBulletDamage() or dmgInfo:IsDamageType(DMG_CLUB) or dmgInfo:IsDamageType(DMG_SLASH)
	local bloodDmgInfo = BloodDmgInfo()
	local inflictor = dmgInfo:GetInflictor()
	local attacker = dmgInfo:GetAttacker()
	local damageType = dmgInfo:GetDamageType()
	local attackerWeapon = attacker:IsPlayer() and attacker:GetActiveWeapon() or attacker

	lastHitGroup = lastHitGroup == 0 and HITGROUP_CHEST or lastHitGroup

	local armored = false

	if client.ArmorItems then
		for item, v in pairs(client.ArmorItems or {}) do
			if item.IsArmored then
				armored = true

				break
			end
		end
	end

	multiplier = inflictor.IsVortibeam and 1 or multiplier

	if attacker:IsNextBot() then
		baseDamage = 5

		local limb = random_limbs[math.random(1, #random_limbs)]
		local bloodDmg = (5000 * (baseDamage / 100))
		local shockDmg = bloodDmg * 2

		baseDamage = baseDamage * 2
		
		character:TakeLimbDamage(limb, baseDamage)

		bloodDmgInfo:SetBlood(250)
		bloodDmgInfo:SetShock(500)
		bloodDmgInfo:SetBleedChance(50)
		bloodDmgInfo:SetBleedDmg(math.min(math.floor(character:GetDmgData().bleedDmg + (bloodDmg * 0.3)), 100))

		local infect = false

		if math.random(0, 100) <= 10 then
			infect = true
			ix.plugin.Get("apocalypse"):InfectCharacter(character)
		end
		
		self:PlayerAdvancedHurt(client, attacker, baseDamage, bloodDmgInfo:GetBlood(), bloodDmgInfo:GetShock(), (names[limb] or "GENERIC")..(infect and " INFECT" or ""))
	elseif dmgInfo:IsDamageType(DMG_ACID) then
		character:TakeOverallLimbDamage(baseDamage * 2)
		character:SetRadLevel(character:GetRadLevel() + (baseDamage * 10))

		self:PlayerAdvancedHurt(client, client, baseDamage, 0, 0, "ALL")
	elseif dmgInfo:IsDamageType(DMG_RADIATION) then
		character:TakeOverallLimbDamage(5 * baseDamage)

		character:SetBleeding(true, self.hitBones[HITGROUP_CHEST][1], 1000)

		bloodDmgInfo:SetShock(200)

		self:PlayerAdvancedHurt(client, client, baseDamage, 0, 0, "ALL")
	elseif dmgInfo:IsExplosionDamage() then
		if armored then
			baseDamage = baseDamage / 4
		end
		
		local mul = baseDamage / 100

		character:TakeOverallLimbDamage(baseDamage / 2)

		baseDamage = baseDamage * 2
		local bloodDmg = math.floor(1300 * mul)
		local shockDmg = math.floor(2800 * mul)

		bloodDmgInfo:SetBlood(bloodDmg)
		bloodDmgInfo:SetShock(shockDmg)
		bloodDmgInfo:SetBleedChance(95)
		bloodDmgInfo:SetBleedDmg(math.min(math.floor(character:GetDmgData().bleedDmg + (bloodDmg * 0.3)), 100))

		self:PlayerAdvancedHurt(client, client, baseDamage, bloodDmg, shockDmg, "ALL")
	elseif dmgInfo:IsFallDamage() then
		if client.IsNeo then
			return
		end
		
		if armored then
			baseDamage = baseDamage / 3
		end

		local dmg = (baseDamage * 1.5)

		if client:IsOTA() then
			dmg = dmg * 0.5
		end
		
		character:TakeLimbDamage(HITGROUP_RIGHTLEG, dmg*4)
		character:TakeLimbDamage(HITGROUP_LEFTLEG, dmg*4)

		local right = character:GetLimbDamage(HITGROUP_RIGHTLEG)
		local left = character:GetLimbDamage(HITGROUP_LEFTLEG)
		local legsDmg = math.max(right, left)
		local delta = (dmg - legsDmg)

		if right > 99 or left > 99 and !character:IsBleeding() then
			if math.random(1, 100) < legsDmg then
				character:SetBleeding(true, table.Random(self.hitBones[math.random(0, 1) == 1 and HITGROUP_RIGHTLEG or HITGROUP_LEFTLEG]), math.max(1, 25 * (baseDamage / 100)))
			end
		end

		if right < 100 and left < 100 and delta <= 0 then
			dmgInfo:ScaleDamage(0)
		elseif delta > 0 then
			dmgInfo:SetDamage(delta)
			bloodDmgInfo:SetBlood(delta * 25)
			bloodDmgInfo:SetBleedChance(75)
		end

		bloodDmgInfo:SetShock(baseDamage * 10)
	else
		local isHead = lastHitGroup == HITGROUP_HEAD
		local isChest = lastHitGroup == HITGROUP_CHEST or lastHitGroup == HITGROUP_STOMACH
		local isMinor = (!isHead and !isChest)
		local attackerChar = attacker.GetCharacter and attacker:GetCharacter()

		if inflictor.IsFists and damageType == DMG_CLUB and !IsValid(client.ixRagdoll) then
			local dmg = (attackerChar:GetSkillModified("unarmed") + 1) * 4.5

			if isMinor then
				dmg = dmg * 0.5
			end
			
			if character:GetData("armored") then
				dmg = dmg / 10
			elseif character:GetData("armor134") then
				dmg = math.max(dmg - (dmg * 0.25), 0)
			elseif armored then
				dmg = dmg / 4
			elseif client:IsOTA() then
				dmg = dmg / 3
			end

			local value = client:GetLocalVar("stm", 0) - dmg

			if value < 0 then
				client:DropActiveWeaponItem()
				client:SetRagdolled(true, 60)
			end

			client:ConsumeStamina(dmg)

			self:PlayerAdvancedHurt(client, dmgInfo:GetAttacker(), dmg, 0, 0, names[lastHitGroup] or "GENERIC")

			dmgInfo:SetDamage(0)
			return
		end

		local baseBloodDmgInfo = self:GetBloodDamageInfo(inflictor)
		local bloodDmg, shockDmg, bleedChance = baseDamage * 5, baseDamage * 5, 75
		local strengthMul = 1

		if attackerChar then
			if damageType == DMG_CLUB then
				strengthMul = math.Clamp(math.Remap(attackerChar:GetSpecial("st"), 1, 10, 0.25, 3), 0.25, 3)
			end

			if inflictor.IsFists and damageType == DMG_CLUB and IsValid(client.ixRagdoll) then
				baseDamage = (attackerChar:GetSkillModified("unarmed") + 1) * 0.75
			end
		end

		if baseBloodDmgInfo then
			bloodDmg = baseBloodDmgInfo:GetBlood() * multiplier
			shockDmg = baseBloodDmgInfo:GetShock() * multiplier
			bleedChance = baseBloodDmgInfo:GetBleedChance()
		end

		if attacker:IsPlayer() and attacker:GetNetVar("isCreature") then
			local rate = (baseDamage / 100)

			shockDmg = 5000 * rate
			bloodDmg = 1500 * rate
			bleedChance = 50
		end

		baseDamage = baseDamage * strengthMul

		local dmgReduction = self:GetArmorDamageReduction(client, lastHitGroup, baseDamage)

		if armored then
			dmgReduction = math.min(dmgReduction, 4)
		end

		if inflictor.IsVortibeam then
			dmgReduction = 1
		end

		if !inflictor.IsVortibeam and character:GetData("armored") then
			dmgReduction = 5
		end
		
		if IsValid(attackerWeapon) and attackerWeapon.IsDominator and character:GetData("armored") then
			dmgReduction = dmgReduction / 3
		end

		-- if character:GetData("armor134") then
		-- 	dmgReduction = math.min(dmgReduction + 0.34, 4.34)
		-- end

		baseDamage = baseDamage / dmgReduction
		bleedChance = bleedChance / dmgReduction

		character:TakeLimbDamage(lastHitGroup, baseDamage)

		shockDmg = shockDmg * strengthMul
		bloodDmg = bloodDmg * strengthMul

		if character:GetData("armor134") and isChest then
			baseDamage = baseDamage * 0.80
			shockDmg = shockDmg * 0.80
		end

		dmgInfo:SetDamage(0)

		if isMinor then
			shockDmg = shockDmg * 0.1
			bloodDmg = bloodDmg * 0.1
		elseif isHead then
			shockDmg = shockDmg * 1.5
		end

		if client:IsOTA() and damageType != DMG_SHOCK then
			shockDmg = shockDmg * 0.25
			bloodDmg = bloodDmg * 0.9
			bleedChance = bleedChance * 0.1
		end

		shockDmg = shockDmg / dmgReduction
		bloodDmg = bloodDmg / dmgReduction

		if (inflictor.IsVortibeam or (IsValid(attackerWeapon) and attackerWeapon.IsDominator)) and client.shieldx then
			local q = client.shieldx:GetQuality()
			if q > 0 then
				local discharge = ents.Create("point_tesla")
				discharge:SetPos(client:GetPos() + Vector( 0, 0, 36 ))
				discharge:SetKeyValue("texture", "trails/laser.vmt")
				discharge:SetKeyValue("m_Color", "255 255 255")
				discharge:SetKeyValue("m_flRadius", "72" )
				discharge:SetKeyValue("interval_min", "0.3" )
				discharge:SetKeyValue("interval_max", "0.4" )
				discharge:SetKeyValue("beamcount_min", "5" )
				discharge:SetKeyValue("beamcount_max", "10" )
				discharge:SetKeyValue("thick_min", "0.75" )
				discharge:SetKeyValue("thick_max", "0.75")
				discharge:SetKeyValue("lifetime_min", "0.05" )
				discharge:SetKeyValue("lifetime_max", "0.1")
				discharge:Fire("DoSpark", "", 0)
				discharge:Fire("TurnOn", "", 0)

				net.Start("ShieldX")
				net.Broadcast()

				client:EmitSound("npc/roller/mine/rmine_explode_shock1.wav", 75, 100, 0.5)

				timer.Simple(1, function()
					if IsValid(client) then client:EmitSound("npc/attack_helicopter/aheli_damaged_alarm1.wav", 75, 100, 0.25) end
				end)

				bloodDmg = 0
				shockDmg = 0
				bleedChance = 0

				client.shieldx:SetQuality(math.Clamp(q - 3, 0, 10))
			end
		end

		if character:GetData("armor134") then
			bloodDmg = bloodDmg * 0.80
		end

		bloodDmgInfo:SetBlood(bloodDmg)
		bloodDmgInfo:SetShock(shockDmg)
		bloodDmgInfo:SetBleedChance(bleedChance)
		bloodDmgInfo.targetBone = table.Random(self.hitBones[lastHitGroup])
		bloodDmgInfo:SetBleedDmg(math.min(math.floor(character:GetDmgData().bleedDmg + (bloodDmg * 0.3)), 100))

		self:PlayerAdvancedHurt(client, dmgInfo:GetAttacker(), baseDamage, bloodDmgInfo:GetBlood(), bloodDmgInfo:GetShock(), names[lastHitGroup] or "GENERIC")
	end

	if character:GetData("armored") then
		bloodDmgInfo:SetBleedChance(0)
	end

	if !client:InCriticalState() then
		local minHealth = math.max(self:GetMinimalHealth(character) or 100, 1)
		client:SetHealth(minHealth)

		if minHealth <= 1 then
			dmgInfo:SetDamage(1)
		else
			dmgInfo:SetDamage(0)
		end
	end
	character:TakeAdvancedDamage(bloodDmgInfo)
end

local mapInflictors = {
	["trigger_hurt"] = true,
	["train_hurt"] = true,
	["train_nodraw"] = true,
	["func_door"] = true
}
local gamemode = GM or GAMEMODE

function gamemode:GetFallDamage(player, velocity)
	return math.max((velocity - 464) * 0.225225225, 0)
end

function gamemode:ScalePlayerDamage(ply, hitgroup, dmginfo) end

function gamemode:EntityTakeDamage(entity, dmgInfo)
	local inflictor = dmgInfo:GetInflictor()
	local inflictorClass = inflictor:GetClass()
	local amount = dmgInfo:GetDamage()

	if (IsValid(inflictor) and inflictorClass == "ix_item") then
		dmgInfo:SetDamage(0)
		return
	end

	

	/*

	if (IsValid(entity.ixPlayer)) then
		if (IsValid(entity.ixHeldOwner)) then
			dmgInfo:SetDamage(0)
			return
		end

		if (dmgInfo:IsDamageType(DMG_CRUSH)) then
			if ((entity.ixFallGrace or 0) < CurTime()) then
				if (dmgInfo:GetDamage() <= 10) then
					dmgInfo:SetDamage(0)
				end

				entity.ixFallGrace = CurTime() + 0.5
			else
				return
			end
		end

		entity.ixPlayer:TakeDamageInfo(dmgInfo)
	end
	*/

	if !IsValid(entity) or mapInflictors[inflictorClass] then
		return
	end

	if IsValid(entity.ixPlayer) then
		if IsValid(entity.ixHeldOwner) then
			dmgInfo:SetDamage(0)
			return
		end
	end

	local isRagdoll = IsValid(entity.ixPlayer) and entity.ixPlayer or nil
	local player = isRagdoll and isRagdoll or entity

	if entity:IsPlayer() or isRagdoll then
		local lastHitGroup = player:LastHitGroup()

		if isRagdoll then
			lastHitGroup = GetRagdollHitGroup(entity, dmgInfo:GetDamagePosition())
		end

		local scale = PLUGIN:ScaleDamageByHitGroup(player, lastHitGroup, dmgInfo)

		if !player:GetNetVar("isCreature") then
			PLUGIN:CalculatePlayerDamage(player, lastHitGroup, dmgInfo, scale)

			local health = player:Health()
			local newDmg = math.min((health - 1) - dmgInfo:GetDamage(), 0)

			dmgInfo:SetDamage(newDmg)
		else
			PLUGIN:CalculateCreatureDamage(player, lastHitGroup, dmgInfo, scale)
		end

		if isRagdoll then
			player:TakeDamageInfo(dmgInfo)
		end
	end
end

function PLUGIN:OnPlayerObserve(client, state)
	if !state then
		local character = client:GetCharacter()
		if character then
			character:HandleBrokenBones()
		end
	end
end

do
	local function DoAction(self, time, condition, callback)
		local uniqueID = "ixCritApply"..self:UniqueID()

		timer.Create(uniqueID, 0.1, time / 0.1, function()
			if (IsValid(self)) then
				if (condition and !condition()) then
					timer.Remove(uniqueID)

					if (callback) then
						callback(false)
					end
				elseif (callback and timer.RepsLeft(uniqueID) == 0) then
					callback(true)
				end
			else
				timer.Remove(uniqueID)

				if (callback) then
					callback(false)
				end
			end
		end)
	end

	ix.log.AddType("critKillStart", function(client, target)
		return string.format("%s пытается добить персонажа %s.", client:GetName(), target:GetName())
	end)

	ix.log.AddType("critStopped", function(client, target)
		return string.format("%s перестал добивать персонажа %s.", client:GetName(), target:GetName())
	end)

	ix.log.AddType("critKilled", function(client, target)
		return string.format("%s добил персонажа %s.", client:GetName(), target:GetName())
	end)

	net.Receive("ixCritApply", function(len, client)
		local state = net.ReadBool()
		local target = client.ixCritUsing

		if !IsValid(target) or target.ixCritUsedBy != client then
			return
		end

		if state then
			ix.chat.Send(nil, "dmgMsg", "", nil, {target}, {t = 1, attacker = client})
			ix.chat.Send(nil, "dmgAdminMsg", "", nil, nil, {
				t = 1,
				attacker = client,
				crit = target
			})

			ix.log.Add(client, "critKillStart", target)

			local character = client:GetCharacter()
			client:SetAction("Вы добиваете персонажа...", 15)
			DoAction(client, 15, function()
				if !client:Alive() or client:IsRestricted() or client:GetCharacter() != character then
					return false
				end

				local traceEnt = client:GetEyeTraceNoCursor().Entity

				if !target:Alive() or (traceEnt != (target.ixRagdoll and target.ixRagdoll or target)) then
					return false
				end

				return true
			end, function(success)
				if success then
					local character = target:GetCharacter()

					target.KilledByRP = true
					target:Kill()

					if !target:IsOTA() then
						character:Ban()
						character:Save()
					end

					ix.chat.Send(nil, "dmgAdminMsg", "", nil, nil, {
						t = 2,
						attacker = client,
						crit = target
					})

					ix.log.Add(client, "critKilled", target)
				else
					if IsValid(target) then
						ix.chat.Send(nil, "dmgMsg", "", nil, {target}, {t = 3})

						ix.log.Add(client, "critStopped", target)
					end
				end

				client:SetAction()
				client.ixCritUsing = nil
				target.ixCritUsedBy = nil
			end)
		else
			client.ixCritUsing = nil
			target.ixCritUsedBy = nil
		end
	end)
end

net.Receive("ixCritUse", function(len, client)
	local target = net.ReadEntity()

	if !IsValid(target) or client:IsRestricted() then
		return
	end

	if client:GetPos():DistToSqr(target:GetPos()) > 4000 then
		return
	end

	if !IsValid(target.ixPlayer) then
		return
	end

	if client:GetCharacter():GetLevel() < 3 then
		client:Notify("Недостаточный уровень!")
		return
	end

	local admins = 0
	for k, v in ipairs(player.GetAll()) do
		if v:IsSuperAdmin() or CAMI.PlayerHasAccess(v, "Helix - Ban Character", nil) then
			admins = admins + 1
		end
	end

	if admins <= 0 then
		client:Notify("На сервере нет администраторов!")
		return
	end

	local curtime = CurTime()

	if client.ixNextCritUse and curtime < client.ixNextCritUse then
		return
	end

	client.ixNextCritUse = curtime + 0.5

	target = target.ixPlayer

	if IsValid(target.ixCritUsedBy) then
		return
	end

	net.Start("ixCritUse")
	net.Send(client)

	client.ixCritUsing = target
	target.ixCritUsedBy = client
end)

hook.Add("prone.CanExit", "bsBrokenLegs", function(player)
	local character = player:GetCharacter()

	if character then
		local rightLeg = character:GetLimbDamage(HITGROUP_RIGHTLEG)
		local leftLeg = character:GetLimbDamage(HITGROUP_LEFTLEG)

		if rightLeg > 99 or leftLeg > 99 then
			return false
		end
	end
end)
