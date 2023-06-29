ITEM.name = "Weapon"
ITEM.description = "A Weapon."
ITEM.category = "Weapons [TEST]"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "weapon_pistol"
ITEM.width = 2
ITEM.height = 2
ITEM.isWeapon = true
ITEM.isGrenade = false
ITEM.weaponCategory = "sidearm"
ITEM.useSound = "items/ammo_pickup.wav"
ITEM.hasLock = false

-- Inventory drawing
if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end

	local PANEL = {}
	function PANEL:Init()
		self:SetTall(24 + 3)
		self:Dock(TOP)
		self:DockMargin(4, 0, 5, 0, 0)
		self:DockPadding(24 + 4, 0, 0, 0)

		self.text = self:Add("DLabel")
		self.text:SetFont("ixSmallFont")
		self.text:SetText(L("unknown"))
		self.text:SetTextColor(color_white)
		self.text:SetTextInset(4, 0)
		self.text:SetContentAlignment(4)
		self.text:Dock(FILL)

		self.icon = nil
	end
	function PANEL:SizeToContents()
		self.text:SizeToContents()
	end
	function PANEL:SetIcon(icon)
		self.icon = icon
	end
	function PANEL:SetText(value)
		self.text:SetText(value)
	end
	function PANEL:Paint(width, height)
		if self.icon then
			surface.SetMaterial(self.icon)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(0, 0, 24, 24)
		end
	end
	vgui.Register("ixTooltipRowIcon", PANEL, "Panel")


	local function AddIconRow(tooltip)
		local row = tooltip:Add("ixTooltipRowIcon")
		row:SetZPos(#tooltip:GetChildren() * 10)

		return row
	end

	local icons = {
		[1] = Material("cellar/ui/weaponry/ap.png"),
		[2] = Material("cellar/ui/weaponry/attack.png"),
		[3] = Material("cellar/ui/weaponry/limbdmg.png"),
		[4] = Material("cellar/ui/weaponry/shockdmg.png"),
		[5] = Material("cellar/ui/weaponry/blooddmg.png"),
		[6] = Material("cellar/ui/weaponry/bleed.png"),
	}
	local Dist = {
		[1] = "На ближней: %s",
		[2] = "На средней: %s",
		[3] = "На дальней: %s",
		[4] = "На очень дальней: %s"
	}
	local Types = {
		[1] = "дробящее",
		[2] = "режущее",
	}

	local greenClr = Color(50, 200, 50)
	local redClr = Color(200, 50, 50)
	local grayClr = Color(122, 122, 122)
	function ITEM:PopulateTooltip(tooltip)
		if self:GetData("equip") then
			local name = tooltip:GetRow("name")
			name:SetBackgroundColor(derma.GetColor("Success", tooltip))
		end
		
		if self.hasLock then
			local lock = tooltip:AddRow("lock")
			lock:SetText("Имеется защита от несанкционированного использования биологического типа.")
			lock:SetBackgroundColor(redClr)
			lock:SizeToContents()
		end

		if self.Info then
			if self.Info.Type then
				local skill = tooltip:AddRow("skill")
				skill:SetText(string.format("Тип: %s", Types[self.Info.Type]))
				skill:SetBackgroundColor(grayClr)
				skill:SizeToContents()
			end

			local skill = tooltip:AddRow("skill")
			skill:SetText(string.format("Навык: %s", string.utf8lower(L((ix.skills.list[self.Info.Skill] or {}).name) or "неизвестный")))
			skill:SetBackgroundColor(grayClr)
			skill:SizeToContents()

			if self.Info.Distance then
				local penalty = tooltip:AddRow("penalty")
				penalty:SetText("Бонус от дистанции:")
				penalty:SetBackgroundColor(grayClr)
				penalty:SizeToContents()

				for i = 1, 4 do
					local mod = self.Info.Distance[i]
					local color = mod == 0 and grayClr or (mod > 0 and greenClr or redClr)
					local a = tooltip:AddRow("penalty"..i)

					a:SetText(string.format(Dist[i], (mod > 0 and "+" or "")..mod))
					a:SetTextColor(color)
					a:SizeToContents()
				end
			end

			if self.Info.Dmg then
				local stats = tooltip:AddRow("attack")
				stats:SetText("Характеристики:")
				stats:SizeToContents()

				if self.Info.Dmg.Attack then
					local AP = AddIconRow(tooltip)
					AP:SetIcon(icons[2])
					AP:SetText(string.format("%s АТАКА", self.Info.Dmg.Attack))
					AP:SizeToContents()
				end

				if self.Info.Dmg.AP then
					local AP = AddIconRow(tooltip)
					AP:SetIcon(icons[1])
					AP:SetText(string.format("%s ПРОБИВАЕМОСТЬ", self.Info.Dmg.AP))
					AP:SizeToContents()
				end

				if self.Info.Dmg.Limb then
					local DMG = AddIconRow(tooltip)
					DMG:SetIcon(icons[3])
					DMG:SetText(string.format("%s УРОН", self.Info.Dmg.Limb))
					DMG:SizeToContents()
				end

				if self.Info.Dmg.Shock then
					local DMG = AddIconRow(tooltip)
					DMG:SetIcon(icons[4])
					DMG:SetText(string.format("%s — %s ШОК", self.Info.Dmg.Shock[1], self.Info.Dmg.Shock[2]))
					DMG:SizeToContents()
				end

				if self.Info.Dmg.Blood then
					local DMG = AddIconRow(tooltip)
					DMG:SetIcon(icons[5])
					DMG:SetText(string.format("%s — %s КРОВЬ", self.Info.Dmg.Blood[1], self.Info.Dmg.Blood[2]))
					DMG:SizeToContents()
				end

				if self.Info.Dmg.Bleed then
					local Bleed = AddIconRow(tooltip)
					Bleed:SetIcon(icons[6])
					Bleed:SetText(string.format("%s%% ШАНС", self.Info.Dmg.Bleed))
					Bleed:SizeToContents()
				end
			end
		end
	end
end

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:Hook("drop", function(item)
	local inventory = ix.item.inventories[item.invID]

	if (!inventory) then
		return
	end

	-- the item could have been dropped by someone else (i.e someone searching this player), so we find the real owner
	local owner

	for client, character in ix.util.GetCharacters() do
		if (character:GetID() == inventory.owner) then
			owner = client
			break
		end
	end

	if (!IsValid(owner)) then
		return
	end

	if (item:GetData("equip")) then
		item:SetData("equip", nil)

		owner.carryWeapons = owner.carryWeapons or {}

		local weapon = owner.carryWeapons[item.weaponCategory]

		if (!IsValid(weapon)) then
			weapon = owner:GetWeapon(item.class)
		end

		if (IsValid(weapon)) then
			item:SetData("ammo", weapon:Clip1())

			owner:StripWeapon(item.class)
			owner.carryWeapons[item.weaponCategory] = nil
			owner:EmitSound(item.useSound, 80)
		end

		item:RemovePAC(owner)
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item:Unequip(item.player, true)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		item:Equip(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		if item.hasLock then
			if item:CheckBiolock(client) == false then
				return false
			end
		end

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.awFix = {
	name = "Исправить",
	OnRun = function(item)

		local repairtime = 4

		local client = item.player

		local uniqueID = "FixingWeapon"..client:UniqueID()

		client:SetAction("Исправляю неисправность",repairtime,function()

			client:Notify("Вы успешно исправили неисправность.")
			
			item:SetData("CantWeaponShoot",nil)

		end)

		timer.Create(uniqueID,0.1,repairtime/0.1,function()

			if !IsValid(client) or (IsValid(client) and client:GetVelocity():Length() != 0) then
				
				timer.Remove(uniqueID)
	
				client:SetAction()
	
			end                            
	
		end)

		return false

	end,
	OnCanRun = function(item)
		return item:GetData("CantWeaponShoot",false)
	end
}


function ITEM:WearPAC(client)
	if (ix.pac and self.pacData) then
		client:AddPart(self.uniqueID, self)
	end
end

function ITEM:RemovePAC(client)
	if (ix.pac and self.pacData) then
		client:RemovePart(self.uniqueID)
	end
end

function ITEM:CheckBiolock(client)
	local lockedBy = self:GetData("locked")

	if client:IsOTA() then
		return true
	end

	if !lockedBy or (lockedBy and lockedBy == client:GetCharacter():GetID()) then
		return true
	end

	return false
end

function ITEM:Equip(client, bNoSelect, bNoSound)
	if self.hasLock then
		if !self:GetData("locked") then
			self:SetData("locked", client:GetCharacter():GetID())
		end
	end

	local items = client:GetCharacter():GetInventory():GetItems()

	client.carryWeapons = client.carryWeapons or {}

	for _, v in pairs(items) do
		if (v.id != self.id) then
			local itemTable = ix.item.instances[v.id]

			if (!itemTable) then
				client:NotifyLocalized("tellAdmin", "wid!xt")

				return false
			else
				if (itemTable.isWeapon and client.carryWeapons[self.weaponCategory] and itemTable:GetData("equip")) then
					client:NotifyLocalized("weaponSlotFilled", self.weaponCategory)

					return false
				end
			end
		end
	end

	if (client:HasWeapon(self.class)) then
		client:StripWeapon(self.class)
	end

	local weapon = client:Give(self.class, !self.isGrenade)

	if (IsValid(weapon)) then
		local ammoType = weapon:GetPrimaryAmmoType()

		client.carryWeapons[self.weaponCategory] = weapon

		if (!bNoSelect) then
			client:SelectWeapon(weapon:GetClass())
		end

		if (!bNoSound) then
			client:EmitSound(self.useSound, 80)
		end

		-- Remove default given ammo.
		if (client:GetAmmoCount(ammoType) == weapon:Clip1() and self:GetData("ammo", 0) == 0) then
			client:RemoveAmmo(weapon:Clip1(), ammoType)
		end

		-- assume that a weapon with -1 clip1 and clip2 would be a throwable (i.e hl2 grenade)
		-- TODO: figure out if this interferes with any other weapons
		if (weapon:GetMaxClip1() == -1 and weapon:GetMaxClip2() == -1 and client:GetAmmoCount(ammoType) == 0) then
			client:SetAmmo(1, ammoType)
		end

		self:SetData("equip", true)

		if (self.isGrenade) then
			weapon:SetClip1(0)
			client:SetAmmo(1, ammoType)
		else
			weapon:SetClip1(self:GetData("ammo", 0))
		end

		weapon.ixItem = self

		if (self.OnEquipWeapon) then
			self:OnEquipWeapon(client, weapon)
		end
	else
		print(Format("[Helix] Cannot equip weapon - %s does not exist!", self.class))
	end
end

function ITEM:Unequip(client, bPlaySound, bRemoveItem)
	client.carryWeapons = client.carryWeapons or {}

	local weapon = client.carryWeapons[self.weaponCategory]

	if (!IsValid(weapon)) then
		weapon = client:GetWeapon(self.class)
	end

	if (IsValid(weapon)) then
		weapon.ixItem = nil

		self:SetData("ammo", weapon:Clip1())
		client:StripWeapon(self.class)
	else
		print(Format("[Helix] Cannot unequip weapon - %s does not exist!", self.class))
	end

	if (bPlaySound) then
		client:EmitSound(self.useSound, 80)
	end

	client.carryWeapons[self.weaponCategory] = nil
	self:SetData("equip", nil)
	self:RemovePAC(client)

	if (self.OnUnequipWeapon) then
		self:OnUnequipWeapon(client, weapon)
	end

	if (bRemoveItem) then
		self:Remove()
	end
end

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			owner:NotifyLocalized("equippedWeapon")
		end

		return false
	end

	return true
end

function ITEM:OnLoadout()
	if (self:GetData("equip")) then
		local client = self.player
		client.carryWeapons = client.carryWeapons or {}

		local weapon = client:Give(self.class, true)

		if (IsValid(weapon)) then
			client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			client.carryWeapons[self.weaponCategory] = weapon

			weapon.ixItem = self
			weapon:SetClip1(self:GetData("ammo", 0))

			if (self.OnEquipWeapon) then
				self:OnEquipWeapon(client, weapon)
			end
		else
			print(Format("[Helix] Cannot give weapon - %s does not exist!", self.class))
		end
	end
end

function ITEM:OnSave()
	local weapon = self.player:GetWeapon(self.class)

	if (IsValid(weapon) and weapon.ixItem == self and self:GetData("equip")) then
		self:SetData("ammo", weapon:Clip1())
	end
end

function ITEM:OnRemoved()
	local inventory = ix.item.inventories[self.invID]
	local owner = inventory.GetOwner and inventory:GetOwner()

	if (IsValid(owner) and owner:IsPlayer()) then
		local weapon = owner:GetWeapon(self.class)

		if (IsValid(weapon)) then
			weapon:Remove()
		end

		self:RemovePAC(owner)
	end
end

ITEM.functions.devLock = {
	name = "Admin Remove Biolock",
	icon = "icon16/wrench.png",
	OnRun = function(item)
		item:SetData("locked", nil)

		return false
	end,
	OnCanRun = function(item)
		return item.hasLock and item.player:IsSuperAdmin()
	end
}

hook.Add("PlayerDeath", "ixStripClip", function(client)
	client.carryWeapons = {}

	for _, v in pairs(client:GetCharacter():GetInventory():GetItems()) do
		if (v.isWeapon and v:GetData("equip")) then
			v:SetData("ammo", nil)
			v:SetData("equip", nil)

			if (v.pacData) then
				v:RemovePAC(client)
			end
		end
	end
end)
