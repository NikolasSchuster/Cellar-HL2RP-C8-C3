util.AddNetworkString("ixShockPain")
util.AddNetworkString("ixBleedingEffect")
util.AddNetworkString("ixCritData")
util.AddNetworkString("ixCritUse")
util.AddNetworkString("ixCritApply")
util.AddNetworkString('RagdollMenu')

function PLUGIN:TakeAdvancedDamage(entity, bloodDmgInfo)
	if !entity:IsPlayer() or !entity:Alive() then
		return
	end

	local character = entity:GetCharacter()

	if !character then
		return
	end

	character:TakeAdvancedDamage(bloodDmgInfo)
end

do
	local CHAR = ix.meta.character
	local PLUGIN = PLUGIN

	function CHAR:SetupUnconscious()
		local player = self:GetPlayer()
		local identifier = "bsUnconscious"..player:SteamID()

		timer.Create(identifier, 1, 0, function()
			if !IsValid(player) then
				timer.Remove(identifier)
				return
			end

			if !player:Alive() then
				return
			end

			local shock = self:GetShock()

			if shock > 0 then
				self:SetShock(math.max(shock - 5, 0))
			end

			local blood = self:GetBlood()
			local hp = PLUGIN:GetMinimalHealth(self)
			local head = self:GetLimbHealth("head")

			if (blood >= 3000) and (hp >= 38) and (head >= 5) then
				if player:IsUnconscious() and !player.ixUnconsciousOut then
					player:SetAction("@wakingUp", 100, function(player)
						player.ixUnconsciousOut = nil
						player:SetLocalVar("knocked", false)
						player:SetRagdolled(false)
					end)

					player.ixUnconsciousOut = true
				end

				return
			end

			if !player:IsUnconscious() then
				local ratio = math.Clamp(blood / 3000, 0, 1)
				local chance = 1 + (74 * (1 - ratio))

				if math.random(1, 100) <= chance and player:GetMoveType() != MOVETYPE_NOCLIP then
					player:DropActiveWeaponItem()

					player:SetRagdolled(true)
					player.ixRagdoll.ixGrace = nil
					player:SetLocalVar("knocked", true)
				end
			else
				local ratio = math.Clamp(blood / 3000, 0, 1)
				local chanceSuccess = 1 + (74 * ratio)
				local chanceFail = 1 + (74 * (1 - ratio))

				if math.random(1, 100) <= chanceSuccess and !player.ixRegainConscious then
					local time = 15 + math.Round(60 * math.max((1 - ratio), 0))

					player:SetAction("@wakingUp", time, function(player)
						player.ixUnconsciousOut = nil
						player:SetLocalVar("knocked", false)
						player:SetRagdolled(false)
					end)

					player.ixRegainConscious = true
				elseif player.ixRegainConscious and math.random(1, 100) <= chanceFail then
					player:SetAction()
					player.ixRegainConscious = false
				end
			end
		end)
	end

	function CHAR:SetupBleeding(status)
		status = status or self:IsBleeding()

		local player = self:GetPlayer()
		local identifier = "bsBleeding"..player:SteamID()

		player:SetNetVar("isBleeding", status)
		player:SetNetVar("bleedingBone", status and self:GetDmgData().bleedBone or 0)

		net.Start("ixBleedingEffect")
			net.WriteEntity(player)
		net.Broadcast()

		if status then
			timer.Create(identifier, 1, 0, function()
				if !IsValid(player) or player:GetCharacter() != self or !self:IsBleeding() then
					timer.Remove(identifier)
					return
				end

				local bleedDmg = self:GetDmgData().bleedDmg or 0

				self:AddBloodDamage(bleedDmg)
			end)
		else
			timer.Remove(identifier)
		end
	end

	function CHAR:SetupFeelPain(status)
		status = status or self:IsFeelPain()

		local player = self:GetPlayer()
		local identifier = "bsPain"..player:SteamID()

		if status then
			timer.Create(identifier, 1, 0, function()
				if !IsValid(player) or player:GetCharacter() != self or !self:IsFeelPain() then
					timer.Remove(identifier)
					return
				end

				local shock = self:GetShock()

				if shock > 0 then
					local curTime = CurTime()

					if !player.nextPainMoan or curTime >= player.nextPainMoan then
						if IsValid(player.ixRagdoll) then
							player.nextPainMoan = curTime + math.random(40, 120)
							return
						end

						local sound = hook.Run("GetPlayerPainSound", player)

						if sound then 
							player:EmitSound(sound) 
						end

						if math.random(1, 100) <= 25 then
							net.Start("ixShockPain")
								net.WriteUInt(1, 3)
							net.Send(player)
						end

						player.nextPainMoan = curTime + math.random(40, 120)
					end
				else
					if !self:IsBleeding() then
						if math.random(1, 100) < 40 then
							self:SetFeelPain(false)
						end
					end
				end
			end)
		else
			timer.Remove(identifier)
		end
	end

	function CHAR:AddShockDamage(shockDmg)
		if shockDmg <= 0 then 
			return
		end

		local player = self:GetPlayer()
		local result = math.Round(self:GetShock() + shockDmg)
		local delta = math.max(result - self:GetBlood(), 0)

		self:SetShock(result)

		if result >= 500 then 
			self:SetFeelPain(true)
		end

		net.Start("ixShockPain")
			net.WriteUInt(1, 5)
		net.Send(player)

		if player:Alive() then
			if delta >= 5000 then
				--death
				--player:Kill()--Silent()
				--hook.Run("DoPlayerDeath", player)
				player:SetCriticalState(true)
			elseif delta > 500 then
				if !IsValid(player.ixRagdoll) and !player:IsUnconscious() then
					player:DropActiveWeaponItem()

					local time = math.Round(30 + (30 * (delta / 5000)))
					player:SetRagdolled(true, time, time)
				end
			end
		end
	end

	function CHAR:AddBloodDamage(bloodDmg)
		if bloodDmg <= 0 then 
			return
		end

		local player = self:GetPlayer()
		local blood = self:GetBlood()
		local delta = blood - bloodDmg
		
		self:SetBlood(math.max(delta, -1))

		if delta <= 0 and player:Alive() then
			--death
			--player:Kill() --Silent()
			--hook.Run("DoPlayerDeath", self:GetPlayer())
			player:SetCriticalState(true)
		end
	end

	function CHAR:SetFeelPain(status)
		if self:IsOTA() then
			return
		end
		
		local dmgData = self:GetDmgData()

		dmgData.isPain = status

		self:SetDmgData(dmgData)
		self:SetupFeelPain(status)
	end

	function CHAR:SetBleeding(status, bone, dmg)
		dmg = dmg or 1
		status = status or false
		bone = bone or ""

		local dmgData = self:GetDmgData()

		if status then
			local bleedDmg = dmgData.bleedDmg or 5
			if dmg <= bleedDmg then
				dmg = bleedDmg
			end
		end

		dmgData.isBleeding = status
		dmgData.bleedBone = status and self:GetPlayer():LookupBone(bone) or 0
		dmgData.bleedDmg = status and math.Round(dmg) or 0

		self:SetDmgData(dmgData)
		self:SetupBleeding(status)
	end

	function CHAR:HandleBrokenBones()
		local player = self:GetPlayer()

		if player:GetMoveType() == MOVETYPE_NOCLIP then
			return
		end

		if self:IsOTA() then
			return
		end

		local rightLeg = self:GetLimbDamage(HITGROUP_RIGHTLEG)
		local leftLeg = self:GetLimbDamage(HITGROUP_LEFTLEG)

		if (rightLeg > 99 or leftLeg > 99) and !player:IsProne() and !player:IsRagdoll() then
			if !player.prone.lastrequest or CurTime() >= player.prone.lastrequest then
				player:ConCommand("prone")
				player.prone.lastrequest = CurTime() + 1.25
			end
		end
	end

	function CHAR:TakeAdvancedDamage(bloodDmgInfo)
		self:AddShockDamage(bloodDmgInfo:GetShock())
		self:AddBloodDamage(bloodDmgInfo:GetBlood())

		if math.random(1, 100) < bloodDmgInfo:GetBleedChance() then
			self:SetBleeding(true, bloodDmgInfo.targetBone, bloodDmgInfo.bleedDmg)
		end

		self:HandleBrokenBones()

		local owner = self:GetPlayer()
		local hp = PLUGIN:GetMinimalHealth(self)
		local head = self:GetLimbHealth("head")

		if ((hp < 38) or (head < 5)) and !owner:IsUnconscious() then
			owner:SetCriticalState(true)
		end
	end

	local PLAYER = FindMetaTable("Player")
	--- Sets this player's ragdoll status.
	-- @realm server
	-- @bool bState Whether or not to ragdoll this player
	-- @number[opt=0] time How long this player should stay ragdolled for. Set to `0` if they should stay ragdolled until they
	-- get back up manually
	-- @number[opt=5] getUpGrace How much time in seconds to wait before the player is able to get back up manually. Set to
	-- the same number as `time` to disable getting up manually entirely
	function PLAYER:SetRagdolled(bState, time, getUpGrace)
		if (!self:Alive() or self:Team() == FACTION_DISPATCH) then
			return
		end

		getUpGrace = getUpGrace or time or 5

		if (bState) then
			local entity

			if (IsValid(self.ixRagdoll)) then
				entity = self.ixRagdoll
			else
				entity = self:CreateServerRagdoll()
				entity:CallOnRemove("fixer", function()
					if (IsValid(self) and self:GetCharacter()) then
						self:SetLocalVar("blur", nil)
						self:SetLocalVar("ragdoll", nil)
						self:SetNetVar("doll", nil)

						if (!entity.ixNoReset) then
							self:SetPos(entity:GetPos())
						end

						self:SetNoDraw(false)
						self:SetNotSolid(false)
						self:SetMoveType(MOVETYPE_WALK)
						self:SetLocalVelocity(IsValid(entity) and entity.ixLastVelocity or vector_origin)

						self:SetCriticalState(false)
						/*
						net.Start("ixCritData")
							net.WriteEntity(self)
							net.WriteBool(false)
						net.Broadcast()
						*/
					end

					if (IsValid(self) and !entity.ixIgnoreDelete) then
						if (entity.ixWeapons) then
							for _, v in ipairs(entity.ixWeapons) do
								if (v.class) then
									local weapon = self:Give(v.class, true)

									if !IsValid(weapon) then continue end
									
									if (v.item) then
										weapon.ixItem = v.item
									end

									self:SetAmmo(v.ammo, weapon:GetPrimaryAmmoType())
									weapon:SetClip1(v.clip)
								elseif (v.item and v.invID == v.item.invID) then
									v.item:Equip(self, true, true)
									self:SetAmmo(v.ammo, self.carryWeapons[v.item.weaponCategory]:GetPrimaryAmmoType())
								end
							end
						end

						if (entity.ixActiveWeapon) then
							if (self:HasWeapon(entity.ixActiveWeapon)) then
								self:SetActiveWeapon(self:GetWeapon(entity.ixActiveWeapon))
							else
								local weapons = self:GetWeapons()
								if (#weapons > 0) then
									self:SetActiveWeapon(weapons[1])
								end
							end
						end
/*
						if (self:IsStuck()) then
							entity:DropToFloor()
							self:SetPos(entity:GetPos() + Vector(0, 0, 16))

							local positions = ix.util.FindEmptySpace(self, {entity, self})

							for _, v in ipairs(positions) do
								self:SetPos(v)

								if (!self:IsStuck()) then
									return
								end
							end
						end
						*/
					end
				end)

				self.ixRagdoll = entity

				entity.ixWeapons = {}
				entity.ixPlayer = self
				
				if (IsValid(self:GetActiveWeapon())) then
					entity.ixActiveWeapon = self:GetActiveWeapon():GetClass()
				end

				for _, v in ipairs(self:GetWeapons()) do
					if (v.ixItem and v.ixItem.Equip and v.ixItem.Unequip) then
						entity.ixWeapons[#entity.ixWeapons + 1] = {
							item = v.ixItem,
							invID = v.ixItem.invID,
							ammo = self:GetAmmoCount(v:GetPrimaryAmmoType())
						}
						v.ixItem:Unequip(self, false)
					else
						local clip = v:Clip1()
						local reserve = self:GetAmmoCount(v:GetPrimaryAmmoType())
						entity.ixWeapons[#entity.ixWeapons + 1] = {
							class = v:GetClass(),
							item = v.ixItem,
							clip = clip,
							ammo = reserve
						}
					end
				end
			end

			self:SetLocalVar("blur", 25)

			if (getUpGrace) then
				entity.ixGrace = CurTime() + getUpGrace
			end

			if (time and time > 0) then
				entity.ixStart = CurTime()
				entity.ixFinish = entity.ixStart + time

				self:SetAction("@wakingUp", nil, nil, entity.ixStart, entity.ixFinish)
			end

			self:GodDisable()
			self:StripWeapons()
			self:SetMoveType(MOVETYPE_OBSERVER)
			self:SetNoDraw(true)
			self:SetNotSolid(true)

			local uniqueID = "ixUnRagdoll" .. self:SteamID()

			if (time) then
				timer.Create(uniqueID, 0.33, 0, function()
					if (IsValid(entity) and IsValid(self) and self.ixRagdoll == entity) then
						local velocity = entity:GetVelocity()
						entity.ixLastVelocity = velocity

						self:SetPos(entity:GetPos())

						if (velocity:Length2D() >= 8) then
							if (!entity.ixPausing) then
								self:SetAction()
								entity.ixPausing = true
							end

							return
						elseif (entity.ixPausing) then
							self:SetAction("@wakingUp", time)
							entity.ixPausing = false
						end

						time = time - 0.33

						if (time <= 0) then
							entity:Remove()
						end
					else
						timer.Remove(uniqueID)
					end
				end)
			else
				timer.Create(uniqueID, 0.33, 0, function()
					if (IsValid(entity) and IsValid(self) and self.ixRagdoll == entity) then
						self:SetPos(entity:GetPos())
					else
						timer.Remove(uniqueID)
					end
				end)
			end

			self:SetLocalVar("ragdoll", entity:EntIndex())
			self:SetNetVar("doll", entity:EntIndex())
			hook.Run("OnCharacterFallover", self, entity, true)
			net.Start('RagdollMenu')
				net.WriteUInt(self:EntIndex(), 32)
				net.WriteUInt(entity:EntIndex(), 32)
			net.Broadcast()
		elseif (IsValid(self.ixRagdoll)) then
			self.ixRagdoll:Remove()

			hook.Run("OnCharacterFallover", self, nil, false)
		end
	end
end
