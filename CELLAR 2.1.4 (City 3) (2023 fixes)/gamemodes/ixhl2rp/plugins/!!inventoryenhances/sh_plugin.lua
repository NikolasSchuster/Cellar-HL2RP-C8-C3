PLUGIN.name = "Drag Drop Interaction"
PLUGIN.description = ""
PLUGIN.author = ""

ix.util.Include("sv_hooks.lua")
ix.util.Include("meta/sh_inventory.lua")

ix.inventory.Register("equipment", 1, MAX_EQUIPMENT_SLOTS)
ix.char.RegisterVar("equipID", {
	field = "equipID",
	fieldType = ix.type.number,
	default = 0,
	isLocal = true,
	bNoDisplay = true
})

do 
	local CHAR = ix.meta.character

	function CHAR:GetEquipment()
		local index = self:GetEquipID()

		if index == 0 then 
			return false
		end

		return ix.item.inventories[index]
	end
end

if CLIENT then
	ICON_RENDER_QUEUE = ICON_RENDER_QUEUE or {}

	function PLUGIN:RenderNewIcon(panel, itemTable)
		local model = itemTable:GetModel()

		-- re-render icons
		if ((itemTable.iconCam and !ICON_RENDER_QUEUE[string.lower(model)]) or itemTable.forceRender) then
			local iconCam = itemTable.iconCam
			iconCam = {
				cam_pos = iconCam.pos,
				cam_ang = iconCam.ang,
				cam_fov = iconCam.fov,
			}
			ICON_RENDER_QUEUE[string.lower(model)] = true

			panel.Icon:RebuildSpawnIconEx(
				iconCam
			)
		end
	end

	hook.Add("CreateMenuButtons", "ixInventory", function(tabs)
		if (hook.Run("CanPlayerViewInventory") == false) then
			return
		end

		tabs["inv"] = {
			bDefault = true,
			Create = function(info, container)
				local characterPanel = container:Add("DPanel")
				characterPanel.Paint = function() end;
				characterPanel:SetSize(400, container:GetTall());
				characterPanel:Dock(LEFT)	

				ix.gui.containerCharPanel = characterPanel

				local inventoryPanel = container:Add("DPanel");
				inventoryPanel.Paint = function() end;
				inventoryPanel:SetSize(container:GetWide(), container:GetTall());
				inventoryPanel:Dock(FILL)

				local equipPanel = characterPanel:Add("ixEquipment")
				equipPanel:SetCharacter(LocalPlayer():GetCharacter())

				local canvas = inventoryPanel:Add("DTileLayout")

				local canvasLayout = canvas.PerformLayout
				canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
				canvas:SetBorder(0)
				canvas:SetSpaceX(2)
				canvas:SetSpaceY(2)
				canvas:Dock(FILL)

				ix.gui.menuInventoryContainer = canvas

				local panel = canvas:Add("ixInventory")
				panel:SetPos(0, 0)
				panel:SetDraggable(false)
				panel:SetSizable(false)
				panel:SetTitle(nil)
				panel.bNoBackgroundBlur = true
				panel.childPanels = {}

				local inventory = LocalPlayer():GetCharacter():GetInventory()
				local equipment = LocalPlayer():GetCharacter():GetEquipment()

				if (inventory) then
					panel:SetInventory(inventory)
				end

				ix.gui.inv1 = panel

				if(equipment) then
					if (ix.option.Get("openBags", true)) then
						for _, v in pairs(equipment:GetItems()) do
							if (!v.isBag) then
								continue
							end

							v.functions.View.OnClick(v)
						end
					end
				end

				canvas.PerformLayout = canvasLayout
				canvas:Layout()

--[[
				local panel2 = canvas:Add("ixEquipment")
				panel2:SetPos(0, 0)
				panel2:SetDraggable(false)
				panel2:SetSizable(false)
				panel2:SetTitle(nil)
				panel2.bNoBackgroundBlur = true

				local inventory2 = LocalPlayer():GetCharacter():GetEquipment()

				if (inventory2) then
					panel2:SetInventory(inventory2)
				end
]]
				ix.gui["inv"..LocalPlayer():GetCharacter():GetEquipID()] = equipPanel
			end
		}
	end)

	hook.Add("PostRenderVGUI", "ixInvHelper", function()
		local pnl = ix.gui.inv1

		hook.Run("PostDrawInventory", pnl)
	end)
end

function PLUGIN:CanTransferEquipment(item, oldInv, newInv, slot)
	local canTransfer, error = item.CanTransferEquipment and item:CanTransferEquipment(oldInv, newInv, slot)

	if !item.isEquipment or item.slot != slot or canTransfer == false then
		return false, error
	end

	if item.isOutfit and item.slot == EQUIP_TORSO then
		for z = 1, 7 do
			if z == EQUIP_EARS then continue end
			
			if newInv:GetItemAtSlot(z) then
				return false, "Вы должны снять остальную одежду, прежде чем экипировать это!"
			end
		end
	end

	return true
end

function PLUGIN:CanPlayerEquipItem(client, item)
	return item.invID == client:GetCharacter():GetEquipID() or item.invID == client:GetCharacter():GetInventory():GetID()
end

function PLUGIN:CanPlayerUnequipItem(client, item)
	return item.invID == client:GetCharacter():GetEquipID() or item.invID == client:GetCharacter():GetInventory():GetID()
end

function PLUGIN:OnItemTransferred(item, oldInv, newInv)
	local slot = item.gridY

	if (newInv and (newInv.vars or {}).isEquipment) then
		local client = newInv:GetOwner()

		if item.CanEquip and item:CanEquip(client, slot) and hook.Run("CanPlayerEquipItem", client, item, slot) != false then
			item:OnEquipped(client, slot)
		end
	elseif oldInv and (oldInv:GetID() != 0) then
		local client = oldInv:GetOwner()

		if item.CanUnequip and item:CanUnequip(client, slot) and hook.Run("CanPlayerUnequipItem", client, item, slot) != false then
			item:OnUnequipped(client, slot)
		end
	end
end