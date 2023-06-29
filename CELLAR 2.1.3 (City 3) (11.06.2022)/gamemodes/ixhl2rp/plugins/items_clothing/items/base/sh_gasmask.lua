ITEM.base = "base_equipment"
ITEM.name = "Gasmask"
ITEM.description = "A mask designed to prevent you from breathing in harmful substances."
ITEM.model = "models/gibs/hgibs.mdl"
ITEM.category = "categoryGasmask"
ITEM.slot = EQUIP_MASK
ITEM.width = 1
ITEM.height = 1
ITEM.business = false
ITEM.CanBreakDown = false

ITEM.functions.EnableCamera = {
	name = "Включить камеру",
	OnRun = function(item)
		item:SetData("bCamOn", true)
		return false
	end,
	OnCanRun = function(item)
		return item.CPMask and !item:GetData("bCamOn", false)
	end
}

ITEM.functions.DisableCamera = {
	name = "Выключить камеру",
	OnRun = function(item)
		item:SetData("bCamOn", false)
		if item.player.IsSpectatedBy and item:GetData("equip", false) then
			for disp, _ in pairs(item.player.IsSpectatedBy) do
				dispatch.StopSpectate(disp)
			end
		end
		return false
	end,
	OnCanRun = function(item)
		return item.CPMask and item:GetData("bCamOn", false)
	end
}

function ITEM:CanTransferEquipment(oldinv, newinv, slot)
	if !self.CPMask then return true end
	if slot != self.slot then return false end
	local client = newinv:GetOwner()
	return ix.util.StringMatches(client:GetModel(), "cca_")
end

function ITEM:OnItemUnequipped(client)
	if !self.CPMask then return end
	local owner = self:GetOwner()
	if owner and owner.IsSpectatedBy then
		for disp, _ in pairs(self.player.IsSpectatedBy) do
			dispatch.StopSpectate(disp)
		end
	end
end
