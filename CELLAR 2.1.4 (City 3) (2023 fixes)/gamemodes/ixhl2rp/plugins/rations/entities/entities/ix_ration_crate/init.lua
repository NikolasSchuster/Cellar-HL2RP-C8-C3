include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local RATION_TO_FILL = "ration_tier_1"

function ENT:Initialize()
	self:SetModel("models/Items/item_item_crate.mdl")
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetHealth(50)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetCount(0)

	local physicsObject = self:GetPhysicsObject()
	
	if IsValid(physicsObject) then
		physicsObject:Wake()
		physicsObject:EnableMotion(true)
	end
end

function ENT:Explode()
	local effectData = EffectData()
	effectData:SetStart(self:GetPos())
	effectData:SetOrigin(self:GetPos())
	effectData:SetScale(8)
	
	util.Effect("GlassImpact", effectData, true, true)
	
	self:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav")
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:OnTakeDamage(damageInfo)
	self:SetHealth(math.max(self:Health() - damageInfo:GetDamage(), 0))
	
	if self:Health() <= 0 then
		self:Explode();
		self:Remove()
	end
end

local model = "models/items/item_item_crate.mdl"
function ENT:Touch(ent)
	if !ent.GetItemID then
		return
	end

	if self.nextUse and self.nextUse > CurTime() then
		return
	end

	local item = ent:GetItemTable()

	if !item or item.uniqueID != RATION_TO_FILL then
		return
	end
	
	ent:Remove()

	self:SetCount(self:GetCount() + 1)

	self:EmitSound("items/medshot4.wav")
	self.nextUse = CurTime() + .5

	if self:GetCount() >= 10 then
		if !self.spawnShipment then
			self.spawnShipment = true

			local container = ents.Create("ix_container")
			container:SetPos(self:GetPos())
			container:SetAngles(self:GetAngles())
			container:SetModel(model)
			container:Spawn()

			ix.inventory.New(0, "container:" .. model, function(inventory)
				-- we'll technically call this a bag since we don't want other bags to go inside
				inventory.vars.isBag = true
				inventory.vars.isContainer = true

				inventory:Add(RATION_TO_FILL, 10)

				if (IsValid(container)) then
					container:SetInventory(inventory)
					container:SetDisplayName("Ящик с рационами")
				end
			end)

			self:Remove()
			return false
		end
	end
end