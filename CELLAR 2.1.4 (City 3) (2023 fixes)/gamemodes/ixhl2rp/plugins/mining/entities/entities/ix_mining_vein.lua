AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Mining Vein"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = false
ENT.bNoPersist = true
ENT.healthPoints = 100
ENT.isDrained = false

local PLUGIN = PLUGIN

function ENT:Initialize()
	self:SetModel(table.Random(PLUGIN.veinModels))
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)

	self.rounds = ix.config.Get("veinRounds")
end

if SERVER then

	function ENT:DrainHealth(health)
		local rounds = ix.config.Get("veinRounds")
		local roundDone = false

		self.healthPoints = math.Clamp(self.healthPoints - health, 0, 100)

		if self.healthPoints == 0 then
			self.rounds = math.Clamp(self.rounds - 1, 0, rounds)
			roundDone = true
		end

		if self.rounds == 0 then
			self.isDrained = true

			timer.Simple(ix.config.Get("veinDrainedTimer"), function()
				if IsValid(self) then
					self.isDrained = false
					self.healthPoints = 100
					self.rounds = rounds
				end
			end)
		end
		return roundDone
	end

	function ENT:OnTakeDamage(damage)
		local inflictor = damage:GetInflictor()
		local attacker = damage:GetAttacker()
		if not attacker:IsPlayer() then return end
		if inflictor:GetClass() != "arccw_pickaxe" then return end

		local character = attacker:GetCharacter()
		local strength = character:GetSpecial("st", 1)
		local points = ix.config.Get("baseVeinDamage") * strength

		local roundDone = self:DrainHealth(points)
		attacker:ConsumeStamina(ix.config.Get("miningStamina"))

		if inflictor.ixItem then
			local item = inflictor.ixItem
			local durability = item:GetData("durability", nil)
			if not durability then
				durability = item:GetData("durability")
				item:SetData("durability", 100)
			end
			item:SetData("durability", math.Clamp(durability - ix.config.Get("miningDurabilityDrain"), 0, 100))
		end

		if roundDone and not self.isDrained then
			self:GiveOre(attacker) -- BUG: not giving item on last round
		end
	end

	function ENT:GiveOre(client)
		print("GiveOre")
		local inventory = client:GetCharacter():GetInventory()
		local result, _ = inventory:Add(self.oreClass)

		if (not result) then
			local oreItem = ix.item.Get(self.oreClass)
			oreItem:Spawn(client:GetItemDropPos(oreItem))
		end
	end

	function ENT:SetOreClass(class)
		self.oreClass = class
	end

	function ENT:GetOreClass()
		return self.oreClass
	end
end
