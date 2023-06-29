ITEM.name = "Painkiller"
ITEM.PrintName = "iPainkill"
ITEM.description = "iPainkillDesc"
ITEM.model = Model("models/items/painkiller.mdl")
ITEM.cost = 20
ITEM.dUses = 4
ITEM.dIsInject = true
ITEM.rarity = 1
ITEM.dUseTime = 5

function ITEM:OnConsume(player, injector, mul, character)
	local shock = character:GetShock()
	local isPain = character:IsFeelPain()
	local newShock = math.max(shock - 3000, 0)

	character:SetFeelPain(false)
	character:SetShock(newShock)

	return {
		shock = math.abs(newShock - shock),
		pain = isPain
	}
end
