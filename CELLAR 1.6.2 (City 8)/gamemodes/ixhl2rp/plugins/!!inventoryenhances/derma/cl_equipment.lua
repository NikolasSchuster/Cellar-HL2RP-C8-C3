local PANEL = {}
PANEL.IsEquipmentSlot = true

function PANEL:Init()
	self.parent = self:GetParent()
	self.previewPanel = nil
	self.isEmpty = true
	self.iconSize = 64

	self.text = "N/A"
	self:SetSize(self.iconSize, self.iconSize)
	self:SetPos(0, 0)
	self:Receiver("ixInventoryItem", self.ReceiveDrop)
end;

function PANEL:Populate()
	local picture = string.format("materials/terranova/ui/charpane/slot_%s.png", self.slot)

	//self.mat = vgui.Create("Material", self)
	//self.mat:SetPos(0, 0)
	//self.mat:SetSize(64, 64)
	//self.mat:SetMaterial(picture)
	//self.mat.AutoSize = false
end

function PANEL:PaintDragPreview(width, height, mouseX, mouseY, itemPanel)
	ix.gui.equipment.dropSlot = self.slot or 0
	/*
	local item = itemPanel:GetItemTable()
	local canUse = true --hook.Run("CharPanelCanUse", self.parent:GetCharacter():GetPlayer())

	if item then
		if item.isEquipment and item.slot == self.slot and canUse != false then
			if self.isEmpty then
				surface.SetDrawColor(0, 255, 0, 40)
			else
				surface.SetDrawColor(255, 255, 0, 10)
			end
		else
			surface.SetDrawColor(255, 0, 0, 40)
		end

		surface.DrawRect(0, 0, 64, 64)
	end
	*/
end

function PANEL:Think()
	if self.isEmpty then
		--self.mat:SetVisible(true)
	else
		--self.mat:SetVisible(false)
	end
end

function PANEL:PaintOver(width, height)
	local panel = self.previewPanel

	if IsValid(panel) then
		local itemPanel = (dragndrop.GetDroppable() or {})[1]

		if IsValid(itemPanel) then
			self:PaintDragPreview(width, height, self.previewX, self.previewY, itemPanel)
		end
	end

	self.previewPanel = nil
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(25, 25, 25, 225)
	surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(90, 90, 90, 125)
    surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:OnTransfer(oldX, oldY, x, slot, oldInventory, noSend)
	return self.parent:OnTransfer(oldX, oldY, x, slot, oldInventory, noSend)
end

function PANEL:IsEmpty(x, y, this)
	return self.isEmpty
end

function PANEL:IsAllEmpty(x, y, width, height, this)
	return self.isEmpty
end

function PANEL:ReceiveDrop(panels, bDropped, menuIndex, x, y)
	local panel = panels[1]

	if (!IsValid(panel)) then
		self.previewPanel = nil
		return
	end

	if bDropped then
		if (panel.OnDrop) then
			if panel:OnDrop(true, self, self.parent:GetCharacter():GetEquipment(), 1, self.slot) then

				self.isEmpty = false
			end
		end

		self.previewPanel = nil
	else
		self.previewPanel = panel
		self.previewX = x
		self.previewY = y
	end
end

vgui.Register("ixEquipmentSlot", PANEL, "DPanel")
