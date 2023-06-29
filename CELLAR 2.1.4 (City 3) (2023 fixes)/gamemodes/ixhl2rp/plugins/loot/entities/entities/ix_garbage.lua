DEFINE_BASECLASS("base_gmodentity")

ENT.Type = "anim"
ENT.Author = "SchwarzKruppzo"
ENT.PrintName = "Garbage Point"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminSpawnable = true

if SERVER then
	local garbageModels = {
		Model("models/props_junk/garbage128_composite001a.mdl"),
		Model("models/props_junk/garbage128_composite001b.mdl"),
		Model("models/props_junk/TrashCluster01a.mdl"),
		Model("models/props_junk/garbage128_composite001d.mdl")
	}

	function ENT:Initialize()
		self:SetModel(table.Random(garbageModels))
		
		self:SetMoveType(MOVETYPE_NONE)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetSolid(SOLID_VPHYSICS)
		
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		
		local phys = self:GetPhysicsObject()
		phys:SetMass(120)

		self.nextRespawn = nil
	end

	function ENT:OnRespawned()
		self:SetModel(table.Random(garbageModels))
	end

	function ENT:UpdateTransmitState()
		if self.nextRespawn and self.nextRespawn > CurTime() then
			return TRANSMIT_NEVER
		end

		return TRANSMIT_PVS
	end

	function ENT:Think()
		if self.nextRespawn && self.nextRespawn < CurTime() then
			self.nextRespawn = nil

			self:OnRespawned()

			self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
		end

		self:NextThink(CurTime() + 1)
	end

	function ENT:OnSuccess(client)
		if math.Rand(0, 100) <= 50 then
			local character = client:GetCharacter()
			local loot = {}
			loot = ix.loot.Get("garbage_common"):Process(loot, true, client)

			if loot[1] then
				local item = ix.item.Get(loot[1])

				if item then
					if !character:GetInventory():Add(loot[1]) then
						ix.item.Spawn(loot[1], client)
					end

					ix.chat.Send(client, "it", L("garbageNotify", client, L(item:GetName(), client)), false, {client})
				end
			end
		else
			ix.chat.Send(client, "it", "Вы ничего не нашли в мусоре.", false, {client})
		end

		hook.Run("OnPlayerClearGarbage", client, character)

		client.ixTrash = nil
		self.searching = nil

		self.nextRespawn = CurTime() + ix.config.Get("garbage_respawn_tick", 400)
		self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	end

	function ENT:OnFailed(client, reason)
		client:SetAction()

		if reason then
			client:NotifyLocalized(reason)
		end

		client.ixTrash = nil
		self.searching = nil
	end

	function ENT:Use(client)
		if client.ixTrash or self.searching then
			return
		end

		if self.nextRespawn and CurTime() < self.nextRespawn then
			return
		end

		if self.nextUse and CurTime() < self.nextUse then
			return
		end

		self.nextUse = CurTime() + 0.5

		if client:IsRestricted() then
			return
		end

		if !client:Crouching() then
			client:NotifyLocalized("Вы должны присесть чтобы начать рыться в мусоре.")
			return
		end

		self.searching = client
		client.ixTrash = self

		local cleantime = ix.config.Get("garbage_clean_time", 5)
		client:SetAction("@cleaning", cleantime)

		local uniqueID = "ixTrashSearch"..client:UniqueID()
		local data = {}
		data.filter = client
		timer.Create(uniqueID, 0.1, cleantime / 0.1, function()
			if (IsValid(client) and IsValid(self)) then
				data.start = client:GetShootPos()
				data.endpos = data.start + client:GetAimVector() * 96

				if (util.TraceLine(data).Entity != self or client:IsRestricted() or client:GetVelocity():LengthSqr() > 0) then
					timer.Remove(uniqueID)

					self:OnFailed(client)
				elseif !client:Crouching() then
					timer.Remove(uniqueID)

					self:OnFailed(client, "Вы должны присесть чтобы начать рыться в мусоре.")
				elseif (timer.RepsLeft(uniqueID) == 0) then
					self:OnSuccess(client)
				end
			else
				timer.Remove(uniqueID)

				self:OnFailed(client, "Мусор был убран до того как вы успели его собрать.")
			end
		end)
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	ENT.PopulateEntityInfo = false
end