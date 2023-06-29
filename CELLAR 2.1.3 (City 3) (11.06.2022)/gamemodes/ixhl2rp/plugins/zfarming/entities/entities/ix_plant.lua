ENT.Type = "anim"
ENT.Author = "Vintage Thief, maxxoft"
ENT.PrintName = "Растение"
ENT.Description = "Посаженное растение"
ENT.Spawnable = false
ENT.PopulateEntityInfo = true

if (SERVER) then

	local PLUGIN = PLUGIN

	function ENT:Initialize()
		local pos = self:GetPos()

		self:SetMoveType(MOVETYPE_NONE)
		self:SetUseType(SIMPLE_USE)
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetCollisionBounds(pos - Vector(3, 3, 3), pos + Vector(3, 3, 3))
		self:PhysicsInit(SOLID_BBOX)

		local physicsObject = self:GetPhysicsObject()
		if (IsValid(physicsObject)) then
			physicsObject:Wake()
			physicsObject:EnableMotion(false)
		end

		self.timerName = "phasetimer" .. self:EntIndex()

		local phaseTime = ix.config.Get("phasetime")
		self.growthPoints = 0
		self.phase = 0

		timer.Create(self.timerName, phaseTime, 0, function()
			local phaseAmount = ix.config.Get("phaseamount")
			local phaseRate = ix.config.Get("phaserate")
			local phases = ix.config.Get("phases")
			self.growthPoints = self.growthPoints + phaseRate

			if (self.growthPoints >= phaseAmount) then
				self.phase = self.phase + 1
				self.growthPoints = 0
				PLUGIN:SaveData()
			end

			if (self.phase >= phases) then
				self:EndGrowth()
			end
		end)

		self:SetModel(PLUGIN.growmodels[math.random(1, #PLUGIN.growmodels)])
	end

	function ENT:SetPlantClass(class)
		self.class = class
	end

	function ENT:SetPlantName(name)
		self.name = name
		self:SetNetVar("name", name)
	end

	function ENT:Use(activator)
		if (activator:IsPlayer() and self.grown) then
			ix.item.Spawn(self.product, self:GetPos() + Vector(0, 0, 2))
			if (math.random(0, 1) == 1) then
				ix.item.Spawn(self.class, self:GetPos() + Vector(0, 0, 3))
			end
			self:Remove()
		end
	end

	function ENT:GetPlantClass()
		return self.class
	end

	function ENT:SetPhase(iPhase)
		self.phase = math.Clamp(iPhase, 0, ix.config.Get("phases"))
	end

	function ENT:GetPhase()
		return self.phase
	end

	function ENT:SetGrowthPoints(iPoints)
		self.growthPoints = iPoints
	end

	function ENT:GetGrowthPoints()
		return self.growthPoints
	end

	function ENT:EndGrowth()
		self.grown = true
		self:SetNetVar("grown", true)
		timer.Remove(self.timerName)
	end

	function ENT:OnRemove()
		if (self.timerName) then
			timer.Remove(self.timerName)
		end
	end

else

	function ENT:OnPopulateEntityInfo(tooltip)
		local name = self:GetPlantName()
		local description

		if (self:GetNetVar("grown")) then
			description = "Растение выросло."
		else
			description = "Растение еще не выросло."
		end

		local title = tooltip:AddRow("name")
		title:SetText(name)
		title:SetImportant()
		title:SizeToContents()

		local panel = tooltip:AddRow("description")
		panel:SetText(description)
		panel:SizeToContents()
	end

end

do

	function ENT:GetPlantName()
		return self.name or self:GetNetVar("name")
	end

end
