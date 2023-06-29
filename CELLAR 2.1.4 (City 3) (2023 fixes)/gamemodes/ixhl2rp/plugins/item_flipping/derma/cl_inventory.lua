
FLIP_ICON_RENDER_QUEUE = FLIP_ICON_RENDER_QUEUE or {}

local function GetIconCamFlipping(width, height, iconCam)
	local ang, fov = iconCam.ang, iconCam.fov
	ang = Angle(ang.p, ang.y, ang.r - 90)
	fov = fov * (width / height)

	return ang, fov
end

local function RenderNewIcon(panel, itemTable)
	local bFLip = itemTable.data["flip"]
	local model = itemTable:GetModel()
	model = string.lower(model)

	-- re-render icons
	if (itemTable.iconCam and
		((!ICON_RENDER_QUEUE[model] and !bFLip or
		!FLIP_ICON_RENDER_QUEUE[model] and bFLip) or
		itemTable.forceRender)
	) then
		local iconCam = itemTable.iconCam
		local ang, fov = iconCam.ang, iconCam.fov

		if (bFLip) then
			ang, fov = GetIconCamFlipping(itemTable.width, itemTable.height, iconCam)
		end

		iconCam = {
			cam_pos = iconCam.pos,
			cam_ang = ang,
			cam_fov = fov,
		}

		if (!bFLip) then
			ICON_RENDER_QUEUE[model] = true
		else
			FLIP_ICON_RENDER_QUEUE[model] = true
		end

		panel.Icon:RebuildSpawnIconEx(iconCam)
	end
end

local PANEL = vgui.GetControlTable('ixInventory')

function PANEL:Init()
	self:SetIconSize(64)
	self:ShowCloseButton(false)
	self:SetDraggable(true)
	self:SetSizable(true)
	self:SetTitle(L"inv")
	self:Receiver("ixInventoryItem", self.ReceiveDrop)

	self.btnMinim:SetVisible(false)
	self.btnMinim:SetMouseInputEnabled(false)
	self.btnMaxim:SetVisible(false)
	self.btnMaxim:SetMouseInputEnabled(false)

	self.panels = {}

	-- only panel on wich "MakePopup" was called will accept keyboard input
	local parent = self

	while (true) do
		local nextParent = parent:GetParent()

		if (nextParent:GetName() == "GModBase") then
			break
		end

		parent = nextParent
	end

	function parent:OnKeyCodePressed(keyCode)
		local baseClass = baseclass.Get(self:GetName())

		if (baseClass.OnKeyCodePressed) then
			baseClass.OnKeyCodePressed(self, keyCode)
		end

		if (keyCode == KEY_SPACE) then
			local hoveredPanel = vgui.GetHoveredPanel()

			if (hoveredPanel.GetName and hoveredPanel:GetName() == "ixItemIcon") then
				local itemTable = hoveredPanel.itemTable

				if (itemTable.width != itemTable.height) then
					net.Start("ixInventoryFlipItem")
						net.WriteUInt(itemTable.id, 32)
						net.WriteUInt(hoveredPanel.inventoryID, 32)
					net.SendToServer()
				end
			end
		end
	end
end

function PANEL:AddIcon(model, x, y, w, h, skin)
	local iconSize = self.iconSize

	w = w or 1
	h = h or 1

	if (self.slots[x] and self.slots[x][y]) then
		local panel = self:Add("ixItemIcon")
		panel:SetSize(w * iconSize, h * iconSize)
		panel:SetZPos(999)
		panel:InvalidateLayout(true)
		panel:SetModel(model, skin)
		panel:SetPos(self.slots[x][y]:GetPos())
		panel.gridX = x
		panel.gridY = y
		panel.gridW = w
		panel.gridH = h

		local inventory = ix.item.inventories[self.invID]

		if (!inventory) then
			return
		end

		local itemTable = inventory:GetItemAt(panel.gridX, panel.gridY)

		if (!itemTable or !itemTable.GetID) then
			panel:Remove()

			return
		end

		panel:SetInventoryID(inventory:GetID())
		panel:SetItemTable(itemTable)

		if (self.panels[itemTable:GetID()]) then
			self.panels[itemTable:GetID()]:Remove()
		end

		if (itemTable.exRender) then
			local iconName = itemTable.uniqueID
			if (itemTable.data["flip"]) then
				iconName = iconName .. "_flipped"
			end

			panel.Icon:SetVisible(false)
			panel.ExtraPaint = function(this, panelX, panelY)
				local exIcon = ikon:GetIcon(iconName)

				if (exIcon) then
					surface.SetMaterial(exIcon)
					surface.SetDrawColor(color_white)
					surface.DrawTexturedRect(0, 0, panelX, panelY)
				else
					local iconCam = itemTable.iconCam

					if (itemTable.data["flip"]) then
						iconCam.ang, iconCam.fov = GetIconCamFlipping(itemTable.width, itemTable.height, iconCam)
					end

					ikon:renderIcon(
						iconName,
						itemTable.width,
						itemTable.height,
						itemTable:GetModel(),
						iconCam
					)
				end
			end
		else
			-- yeah..
			RenderNewIcon(panel, itemTable)
		end

		panel.slots = {}

		for i = 0, w - 1 do
			for i2 = 0, h - 1 do
				local slot = self.slots[x + i] and self.slots[x + i][y + i2]

				if (IsValid(slot)) then
					slot.item = panel
					panel.slots[#panel.slots + 1] = slot
				else
					for _, v in ipairs(panel.slots) do
						v.item = nil
					end

					panel:Remove()

					return
				end
			end
		end

		return panel
	end
end
