DEFINE_BASECLASS("base_anim")

ENT.Type = "anim"
ENT.Author = "Schwarz Kruppzo"
ENT.PrintName = "LootBox Tier 1"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminSpawnable = true

local respawnTime = 14400
local models = {
	Model("models/Items/ammocrate_ar2.mdl"),
	Model("models/Items/item_item_crate.mdl"),
	Model("models/props/CS_militia/footlocker01_closed.mdl"),
	Model("models/Items/ammocrate_grenade.mdl")
}

if SERVER then
	local JUNK = ix.loot.NewLootTemplate("outland_junk")
		for i = 1, 8 do
			local a = ix.loot.NewLootGroup()

			a:AddEntry(ix.loot.NewLoot("box_of_nails", 0))
			a:AddEntry(ix.loot.NewLoot("box_of_needles", 0))
			a:AddEntry(ix.loot.NewLoot("box_of_casings", 0))
			a:AddEntry(ix.loot.NewLoot("box_of_gunpowder", 0))
			a:AddEntry(ix.loot.NewLoot("varnish", 0))
			a:AddEntry(ix.loot.NewLoot("sandpaper", 0))
			a:AddEntry(ix.loot.NewLoot("electro_circuit", 0))
			a:AddEntry(ix.loot.NewLoot("mat_wood", 0))
			a:AddEntry(ix.loot.NewLoot("mat_plastic", 0))
			a:AddEntry(ix.loot.NewLoot("mat_cloth", 0))
			a:AddEntry(ix.loot.NewLoot("metal_armature", 0))
			a:AddEntry(ix.loot.NewLoot("metal_scrap", 0))
			a:AddEntry(ix.loot.NewLoot("tool_hammer", 0))
			a:AddEntry(ix.loot.NewLoot("tool_scissors", 0))
			a:AddEntry(ix.loot.NewLoot("tool_screw", 0))
			a:AddEntry(ix.loot.NewLoot("tool_welding", 0))
			a:AddEntry(ix.loot.NewLoot("tool_matches", 0))
			a:AddEntry(ix.loot.NewLoot("smallbag", 0))
			a:AddEntry(ix.loot.NewLoot("flashlight", 0))
			a:AddEntry(ix.loot.NewLoot("radio_handheld", 0))

			JUNK:AddEntry(a)
		end
	JUNK:Register()

	local MEDICAL = ix.loot.NewLootTemplate("outland_medical")
		for i = 1, 6 do
			local a = ix.loot.NewLootGroup()

			a:AddEntry(ix.loot.NewLoot("bloodbag", 0))
			a:AddEntry(ix.loot.NewLoot("epinephrine", 0))
			a:AddEntry(ix.loot.NewLoot("healthkit", 0))
			a:AddEntry(ix.loot.NewLoot("healthvial", 0))
			a:AddEntry(ix.loot.NewLoot("morphine", 0))
			a:AddEntry(ix.loot.NewLoot("painkiller", 0))
			a:AddEntry(ix.loot.NewLoot("filter_medium", 0))
			a:AddEntry(ix.loot.NewLoot("baked_beans", 0))
			a:AddEntry(ix.loot.NewLoot("pickles", 0))
			a:AddEntry(ix.loot.NewLoot("union_branded_instant_potatos", 0))
			a:AddEntry(ix.loot.NewLoot("union_branded_sardines", 0))
			a:AddEntry(ix.loot.NewLoot("union_branded_bran_flakes", 0))
			a:AddEntry(ix.loot.NewLoot("sweet_ringlets", 0))
			a:AddEntry(ix.loot.NewLoot("salted_ringlets", 0))
			a:AddEntry(ix.loot.NewLoot("pastry_cookies", 0))
			a:AddEntry(ix.loot.NewLoot("union_branded_bag_of_peanuts", 0))
			a:AddEntry(ix.loot.NewLoot("breens_water", 0))
			a:AddEntry(ix.loot.NewLoot("beer", 0))
			a:AddEntry(ix.loot.NewLoot("old_red_wine", 0))
			a:AddEntry(ix.loot.NewLoot("juniper", 0))
			a:AddEntry(ix.loot.NewLoot("hawthorn", 0))
			a:AddEntry(ix.loot.NewLoot("energy_drink", 0))
			a:AddEntry(ix.loot.NewLoot("cola", 0))

			MEDICAL:AddEntry(a)
		end
	MEDICAL:Register()

	local CRAFT = ix.loot.NewLootTemplate("outland_craft")
		for i = 1, 4 do
			local a = ix.loot.NewLootGroup()

			a:AddEntry(ix.loot.NewLoot("broken_mp7", 0))
			a:AddEntry(ix.loot.NewLoot("broken_shotgun", 0))
			a:AddEntry(ix.loot.NewLoot("broken_pistol", 0))
			a:AddEntry(ix.loot.NewLoot("broken_357", 0))
			a:AddEntry(ix.loot.NewLoot("electro_reclaimed", 0))
			a:AddEntry(ix.loot.NewLoot("electro_battery", 0))
			a:AddEntry(ix.loot.NewLoot("metal_reclaimed", 0))
			a:AddEntry(ix.loot.NewLoot("mat_resine", 0))
			a:AddEntry(ix.loot.NewLoot("chain", 0))
			a:AddEntry(ix.loot.NewLoot("filter_good", 0))
			a:AddEntry(ix.loot.NewLoot("bullets_buckshot", 0))
			a:AddEntry(ix.loot.NewLoot("bullets_9mm", 0))
			a:AddEntry(ix.loot.NewLoot("bullets_smg", 0))
			a:AddEntry(ix.loot.NewLoot("bullets_ar2", 0))
			a:AddEntry(ix.loot.NewLoot("bullets_ar2alt", 0))
			a:AddEntry(ix.loot.NewLoot("rpg_missile", 0))
			a:AddEntry(ix.loot.NewLoot("bag", 0))
			a:AddEntry(ix.loot.NewLoot("frag_grenade", 0))

			CRAFT:AddEntry(a)
		end
	CRAFT:Register()

	local GUN = ix.loot.NewLootTemplate("outland_gun")
		for i = 1, 3 do
			local a = ix.loot.NewLootGroup()

			a:AddEntry(ix.loot.NewLoot("filter_epic", 0))
			a:AddEntry(ix.loot.NewLoot("ar2", 0))	
			a:AddEntry(ix.loot.NewLoot("shotgun", 0))
			a:AddEntry(ix.loot.NewLoot("mp7", 0))
			a:AddEntry(ix.loot.NewLoot("magnum", 0))	
			a:AddEntry(ix.loot.NewLoot("uspmatch", 0))
			a:AddEntry(ix.loot.NewLoot("hazmat_medic", 0))
			a:AddEntry(ix.loot.NewLoot("hazmat_regular", 0))
			a:AddEntry(ix.loot.NewLoot("frag_grenade", 0))

			GUN:AddEntry(a)
		end
	GUN:Register()

	local TIER1 = ix.loot.NewLootTemplate("tier1_types")
		local a = ix.loot.NewLootGroup()

		a:AddEntry(ix.loot.NewLoot("outland_junk", 68))
		a:AddEntry(ix.loot.NewLoot("outland_medical", 20))
		a:AddEntry(ix.loot.NewLoot("outland_craft", 12))
		a:AddEntry(ix.loot.NewLoot("outland_gun", 2))

		TIER1:AddEntry(a)
	TIER1:Register()

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

		lootTypes = TIER1:Process(lootTypes)

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