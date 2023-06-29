ITEM.name = "Bandage"
ITEM.PrintName = "iBandage"
ITEM.description = "iBandageDesc"
ITEM.model = Model("models/items/bandage.mdl")
ITEM.useSound = nil --"items/bandage_open.wav"
ITEM.cost = 10
ITEM.dUses = 5
ITEM.dIsInject = true
ITEM.dUseTime = 5

function ITEM:OnConsume(player, injector, mul, character)
	local isBleeding, bleedDmg = character:IsBleeding(), character:GetDmgData().bleedDmg or 0

	character:SetBleeding(false)

	return {bleed = isBleeding, bleedDmg = bleedDmg}
end
