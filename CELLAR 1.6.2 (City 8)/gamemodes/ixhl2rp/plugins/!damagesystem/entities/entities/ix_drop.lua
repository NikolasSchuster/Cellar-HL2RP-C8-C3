ENT.Type = "anim"
ENT.PrintName = "Dropped Items"
ENT.Category = "Helix"
ENT.Spawnable = false
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ID")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/garbage_bag001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self.receivers = {}

		local physObj = self:GetPhysicsObject()

		if IsValid(physObj) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
	end

	function ENT:SetInventory(inventory)
		if inventory then
			self:SetID(inventory:GetID())
		end
	end

	function ENT:SetMoney(amount)
		self.money = math.max(0, math.Round(tonumber(amount) or 0))
	end

	function ENT:GetMoney()
		return self.money or 0
	end

	function ENT:OpenInventory(activator)
		local inventory = self:GetInventory()

		if inventory then
			local name = "Вещи с трупа"

			ix.storage.Open(activator, inventory, {
				name = name,
				entity = self,
				searchTime = 15,
				data = {money = self:GetMoney()},
				OnPlayerClose = function()
					ix.log.Add(activator, "closeContainer", name, inventory:GetID())
				end
			})

			ix.log.Add(activator, "openContainer", name, inventory:GetID())
		end
	end

	function ENT:Use(activator)
		local inventory = self:GetInventory()

		if inventory and (activator.ixNextOpen or 0) < CurTime() then
			local character = activator:GetCharacter()

			if character then
				self:OpenInventory(activator)
			end

			activator.ixNextOpen = CurTime() + 1
		end
	end
else
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText("Вещи с трупа")
		title:SetBackgroundColor(ix.config.Get("color"))
		title:SizeToContents()
	end
end

function ENT:GetInventory()
	return ix.item.inventories[self:GetID()]
end
