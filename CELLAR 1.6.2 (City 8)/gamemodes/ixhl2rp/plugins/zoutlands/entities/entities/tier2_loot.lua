DEFINE_BASECLASS("base_anim")

ENT.Type = "anim"
ENT.Author = "Schwarz Kruppzo"
ENT.PrintName = "LootBox Tier 2"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminSpawnable = true

local respawnTime = 14400
local models = {
	Model("models/Items/ammocrate_ar2.mdl"),
	Model("models/Items/ammocrate_grenade.mdl")
}

if SERVER then
	local TIER2 = ix.loot.NewLootTemplate("tier2_types")
		local a = ix.loot.NewLootGroup()

		a:AddEntry(ix.loot.NewLoot("outland_junk", 12))
		a:AddEntry(ix.loot.NewLoot("outland_medical", 42))
		a:AddEntry(ix.loot.NewLoot("outland_craft", 36))
		a:AddEntry(ix.loot.NewLoot("outland_gun", 10))

		TIER2:AddEntry(a)
	TIER2:Register()

	function ENT:Initialize()
		self:SetModel(table.Random(models))
		
		self:SetMoveType(MOVETYPE_NONE)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetSolid(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()
		phys:SetMass(120)

		local inventory = ix.inventory.Create(8, 8, os.time())
		inventory.vars.isBag = true
		inventory.vars.entity = self
		inventory.noSave = true

		self.Sessions = {}
		self.inventory = inventory
		self.nextRespawn = nil

		timer.Simple(0, function()
			self:GenerateLoot()
		end)
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end

	function ENT:GenerateLoot()
		local lootTypes = {}

		lootTypes = TIER2:Process(lootTypes)

		self.LootType = lootTypes[1]

		for k, item in pairs(self.inventory:GetItems(true)) do
			item:Remove()
		end

		local loot = {}

		loot = ix.loot.stored[self.LootType]:Process(loot)

		for k, item in ipairs(loot) do
			self.inventory:Add(item, 1)
		end
	end

	function ENT:Think()
		self:NextThink(CurTime() + 1)
	end

	function ENT:OpenInventory(client)
		if self.nextRespawn && self.nextRespawn < CurTime() then
			self:GenerateLoot()

			self.nextRespawn = CurTime() + respawnTime
		end

		if self.inventory then
			local invID = self.inventory:GetID()
			
			if ix.item.inventories[invID] then
				ix.item.inventories[invID].slots = self.inventory.slots
			end
			
			ix.storage.Open(client, self.inventory, {
				name = "Неизвестный ящик",
				entity = self,
				searchTime = 5,
				bMultipleUsers = true,
			})
		end

		self.nextRespawn = CurTime() + respawnTime
	end

	function ENT:Use(client)
		if client:IsRestricted() then
			return
		end

		local ota = 0
		for k, v in pairs(player.GetAll()) do
			if !v:GetCharacter() then continue end
			if v:IsOTA() then
				ota = ota + 1
			end
		end

		if ota < 4 then
			return
		end

		if self.inventory and (client.ixNextOpen or 0) < CurTime() then
			local character = client:GetCharacter()

			if character then
				self:OpenInventory(client)
			end

			client.ixNextOpen = CurTime() + 1
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText("Неизвестный ящик")
		title:SetBackgroundColor(RARITY_COLORS[3])
		title:SizeToContents()
	end
end