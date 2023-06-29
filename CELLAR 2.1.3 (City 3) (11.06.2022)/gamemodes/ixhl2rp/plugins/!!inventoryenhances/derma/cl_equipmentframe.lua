local PANEL = {}
PANEL.IsEquipment = true
local PLUGIN = PLUGIN

MAX_EQUIPMENT_SLOTS = 16

EQUIP_HEAD = 1
EQUIP_EYE = 2
EQUIP_EARS = 3
EQUIP_MASK = 4
EQUIP_TORSO = 5
EQUIP_HANDS = 6
EQUIP_LEGS = 7
EQUIP_BACK = 8
EQUIP_CID = 9
EQUIP_RADIO = 10
EQUIP_LHAND = 11
EQUIP_RHAND = 12
EQUIP_RESERVED1 = 13
EQUIP_RESERVED2 = 14
EQUIP_RESERVED3 = 15
EQUIP_RESERVED4 = 16

PLUGIN.slotPlacements = {
	[EQUIP_HEAD] = {x = 6, y = 30, text = "Голова"},
	[EQUIP_MASK] = {x = 6, y = 100 + 8, text = "Лицо"},
	[EQUIP_TORSO] = {x = 6, y = 170 + 16, text = "Торс"},
	[EQUIP_LEGS] = {x = 285, y = 300, text = "Ноги"},
	[EQUIP_HANDS] = {x = 285, y = 170 + 16, text = "Руки"},
	[EQUIP_RADIO] = {x = 6, y = 300, text = "Рация"},
	[EQUIP_CID] = {x = 6, y = 370 + 16, text = "CID"},
	[EQUIP_EARS] = {x = 285, y = 30, text = "Ухо"}, 
	[EQUIP_RESERVED1] = {x = 285, y = 100 + 8, text = "Плечо"},
}

-- Called when this panel has been created.
function PANEL:Init()
	ix.gui.equipment = self

	self:SetSize(360, 525)
	self.panels = {}
	
	self:Receiver("ixInventoryItem", self.ReceiveDrop)
end

-- Called when we are setting the target of the character panel
function PANEL:SetCharacter(character, equipment)
	self.model = self:Add("ixModelPanel")
	self.model:Dock(FILL)
	self.model:SetFOV(50)
	self.model:SetAlpha(255)

	self.character = character

	self:UpdateModel()
	self:SetEquipment(equipment or self:GetCharacter():GetEquipment())
end

-- Returns the character tied to this character panel.
function PANEL:GetCharacter()
	if(self.character) then
		return self.character
	end

	return nil
end

function PANEL:OnTransfer(oldX, oldY, x, slot, oldInventory, noSend)
	local inventories = ix.item.inventories
	local inventory = inventories[oldInventory.invID]
	local inventory2 = inventories[self.invID]
	local item

	if (inventory) then
		item = inventory:GetItemAt(oldX, oldY)

		if (!item) then
			return false
		end

		local a, b = hook.Run("CanTransferEquipment", item, inventory, inventory2, slot)
		if (a == false) then
			if b then
				LocalPlayer():NotifyLocalized(b)
			end

			return false
		end

		if (item.CanTransfer and
			item:CanTransfer(inventory, inventory != inventory2 and inventory2 or nil, slot) == false) then
			return false
		end
	end

	if (!noSend) then
		net.Start("ixInventoryMove")
			net.WriteUInt(oldX, 6)
			net.WriteUInt(oldY, 6)
			net.WriteUInt(1, 6)
			net.WriteUInt(slot, 6)
			net.WriteUInt(oldInventory.invID, 32)
			net.WriteUInt(self != oldInventory and self.invID or oldInventory.invID, 32)
		net.SendToServer()
	end

	if (inventory) then
		inventory.slots[oldX][oldY] = nil
	end

	if (item and inventory2) then
		inventory2.slots[1] = inventory2.slots[1] or {}
		inventory2.slots[1][slot] = item
	end
end

-- Called when the panel receives a drop. Used to stop items from dropping to world if they are dropped on the panel's empty space.
function PANEL:ReceiveDrop(panels, bDropped, menuIndex, x, y)
	return 
end

-- Fixes model panel not fading out when the gui menu is closed.
function PANEL:Think()
	if(IsValid(ix.gui.menu) and ix.gui.menu.bClosing) then
		if(self.model) then
			self.model:Remove()
		end
	end

	local character = self:GetCharacter()

	if(character and IsValid(self.model)) then
		if(character:GetPlayer():GetModel() != self.model:GetModel()) then
			self:UpdateModel()
		end

		local showSlots = hook.Run("CharPanelCanUse", character:GetPlayer())

		if(showSlots != false) then
			showSlots = true
		end

		self:ToggleSlots(showSlots)
	end
end

-- Helper function to set the visibility of the slots.
function PANEL:ToggleSlots(bShow)
	for k, v in pairs(self.slots or {}) do
		if(IsValid(v)) then
			v:SetVisible(bShow)
		end
	end
end

-- Called when we need to update the model in the character panel.
function PANEL:UpdateModel()
	if (IsValid(self.model)) then
		self.model:SetModel(self:GetCharacter().model or self:GetCharacter():GetPlayer():GetModel(), self:GetCharacter().vars.skin or self:GetCharacter():GetData("skin", 0))

		for i = 0, (self:GetCharacter():GetPlayer():GetNumBodyGroups() - 1) do
			self.model.Entity:SetBodygroup(i, self:GetCharacter():GetPlayer():GetBodygroup(i))
		end

		self.model.Entity.ProxyOwner = LocalPlayer()
	end
end

-- Called when we are assigning all the character panel data to this panel.
function PANEL:SetEquipment(charPanel)
	self.invID = charPanel:GetID()

	self:BuildSlots();

	for x, items in pairs(charPanel.slots) do
		for y, data in pairs(items) do
			if (!data.id) then continue end

			local item = ix.item.instances[data.id]

			if (item and !IsValid(self.panels[item.id])) then
				local icon = self:AddIcon(
					item:GetModel() or "models/props_junk/popcan01a.mdl", nil, item.slot, item.width, item.height, item:GetSkin()
				)

				if (IsValid(icon)) then
					icon:SetHelixTooltip(function(tooltip)
						ix.hud.PopulateItemTooltip(tooltip, item)
					end)

					icon.itemID = item.id
					self.panels[item.id] = icon
				end

				self.slots[item.slot].isEmpty = false
			end
		end
	end
end

function PANEL:GetIconPlacement(category)
	return PLUGIN.slotPlacements[category]
end

-- Called when we need to build all the UI slots for the panel.
function PANEL:BuildSlots()
	self.slots = self.slots or {}

	for k, v in pairs(PLUGIN.slotPlacements) do
		if(v.condition or v.condition == nil) then
			local text = self:Add("DLabel")
			text:SetText(v.text)
			text:SetPos(v.x + 4, v.y + 4)

			local slot = self:Add("ixEquipmentSlot")
			slot.slot = k
			slot.text = k
			slot:SetPos(v.x + 2, v.y + 22)

			self.slots[k] = slot
			slot:Populate()
			slot.Paint = function(self, w, h)
				local eqFrame = Material('cellar/main/tab/equipmentbackground.png')

				/*surface.SetDrawColor(color_white)
				surface.SetMaterial(eqFrame)
				surface.DrawTexturedRect(0, 0, w, h)*/

				surface.SetDrawColor(35, 35, 35, 20)
				surface.DrawRect(1, 1, w - 2, h - 2)

				surface.SetDrawColor(ColorAlpha(cellar_blue, 86))
				surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
			end
		end
	end;
end

-- Called when we are adding items into their slots.
function PANEL:AddIcon(model, x, slot, w, h, skin)
	local panel = self:Add("ixItemIcon")
	local pos_x, pos_y = self.slots[slot]:GetPos()
	panel.IsEquip = true
	panel:SetSize(64 *w, 64 *h)
	panel:SetZPos(-999)
	panel:InvalidateLayout(true)
	panel:SetVisible(false)
	panel:SetModel(model, skin)
	panel:SetPos(pos_x, pos_y)
	panel.gridX = 1
	panel.gridY = slot
	panel.gridW = w
	panel.gridH = h

	local test = self:Add("ixItemIcon")
	test.IsEquip = true
	test:SetSize(64, 64)
	test:SetDragParent(panel)
	test:SetZPos(999)
	test:InvalidateLayout(true)
	test:SetModel(model, skin)
	test:SetPos(pos_x, pos_y)
	test.gridX = 1
	test.gridY = slot
	test.gridW = w
	test.gridH = h

	panel.OnRemove = function(self) self.Ghost:Remove() end
	panel.Ghost = test

	local inventory = ix.item.inventories[self.invID]

	if (!inventory) then
		return
	end

	local itemTable = inventory:GetItemAt(panel.gridX, panel.gridY)

	if !itemTable or !itemTable.GetID then
		panel:Remove()
		return
	end

	panel:SetInventoryID(inventory:GetID())
	panel:SetItemTable(itemTable)
	test:SetInventoryID(inventory:GetID())
	test:SetItemTable(itemTable)

	if (self.panels[itemTable:GetID()]) then
		self.panels[itemTable:GetID()]:Remove()
	end

	if (itemTable.exRender) then
		panel.Icon:SetVisible(false)
		panel.ExtraPaint = function(this, panelX, panelY)
			local exIcon = ikon:GetIcon(itemTable.uniqueID)
			if (exIcon) then
				surface.SetMaterial(exIcon)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect(0, 0, panelX, panelY)
			else
				ikon:renderIcon(
					itemTable.uniqueID,
					itemTable.width,
					itemTable.height,
					itemTable:GetModel(),
					itemTable.iconCam
				)
			end
		end
	else
		PLUGIN:RenderNewIcon(panel, itemTable)
		PLUGIN:RenderNewIcon(test, itemTable)
	end

	test:SetHelixTooltip(function(tooltip)
		ix.hud.PopulateItemTooltip(tooltip, itemTable)
	end)

	test.itemID = itemTable.id

	local slot = self.slots[slot]

	if IsValid(slot) then
		slot.item = panel
	end

	return panel
end

function PANEL:PaintDragPreview(width, height, itemPanel)
	if dragndrop.m_Receiver == self then 
		ix.gui.equipment.dropSlot = nil
	end

	local item = itemPanel:GetItemTable()
	local canUse = true --hook.Run("CharPanelCanUse", self.parent:GetCharacter():GetPlayer())

	if item then
		local slotPanel = ix.gui.equipment.slots[ix.gui.equipment.dropSlot]

		if IsValid(slotPanel) then
			if item.isEquipment and item.slot == ix.gui.equipment.dropSlot and canUse != false then
				if slotPanel.isEmpty then
					surface.SetDrawColor(0, 255, 0, 40)
				else
					surface.SetDrawColor(255, 255, 0, 40)
				end
			else
				surface.SetDrawColor(255, 0, 0, 40)
			end

			local x, y = slotPanel:GetPos()

			surface.DrawRect(x, y, 64, 64)
		end
	end
end

function PANEL:PaintOver(width, height)
	local itemPanel = (dragndrop.GetDroppable() or {})[1]

	if IsValid(itemPanel) then
		self:PaintDragPreview(width, height, itemPanel)
	end
end


local colors = {
	[1] = Color(56, 207, 248, 56),
	[2] = Color(43, 157, 189, 56)
}
-- Called every frame.
function PANEL:Paint()
	local frame = Material('cellar/main/tab/border360x525.png')
	local round = Material('cellar/main/tab/equipmentborderround27x27.png')
	local tsinSize = TimedSin(.1, 8, 32, 0)
	local anim1 = TimedSin(.9, 36, 99, 100)
	local anim2 = TimedSin(.9, 39, 89, 100)
	local prolongedW = TimedSin(.95, 8, 20, 33)
	--derma.SkinFunc("PaintCategoryPanel", self, "", ix.config.Get("color") or color_white)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(frame)
	surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())

	draw.RoundedBox(0, anim1, 32 * .33, prolongedW, 2, colors[1])
	draw.RoundedBox(0, -anim2 + 66, 32 * .7, prolongedW, 2, colors[2])

	--surface.SetFont("cellar.main.btn")
	--surface.SetTextColor(Color(255,255,255,255))
	--surface.SetTextPos(4, 4)
	--surface.DrawText("Снаряжение")
	--draw.SimpleText("Снаряжение", "cellar.main.btn", self:GetWide()/2, self:GetTall() * .035, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("ixEquipment", PANEL, "DPanel")