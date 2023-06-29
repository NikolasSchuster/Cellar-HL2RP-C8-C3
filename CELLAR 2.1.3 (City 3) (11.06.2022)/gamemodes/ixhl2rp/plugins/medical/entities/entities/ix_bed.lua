AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.Type = "anim"
ENT.PrintName = "Bed"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.bNoPersist = true

if (SERVER) then
	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetTrigger(true)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
	end

	function ENT:StartTouch(entity)
		if entity:IsPlayer() and !IsValid(self.user) then
			ix.plugin.list["medical"]:SetupHealTimer(entity, self)

			self.user = entity
		end
	end

	function ENT:EndTouch(entity)
		if entity:IsPlayer() and IsValid(self.user) and self.user == entity then
			ix.plugin.list["medical"]:RemoveHealTimer(entity)

			self.user = nil
		end
	end
else
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(tooltip)
		if !self.firstInit then
			local definition = ix.bed.stored[self:GetModel():lower()]

			if definition then
				self.color = RARITY_COLORS[definition.type] or RARITY_COLORS[0]
			end

			self.firstInit = true
		end

		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText("Кровать")
		title:SetBackgroundColor(self.color)
		title:SizeToContents()
	end
end
