ITEM.name = "Epinephrine"
ITEM.PrintName = "iEpine"
ITEM.description = "iEpineDesc"
ITEM.model = Model("models/items/w_eq_adrenaline.mdl")
ITEM.useSound = "items/medshot4.wav"
ITEM.dUses = 1
ITEM.dIsInject = true
ITEM.rarity = 1
ITEM.dUseTime = 5

function ITEM:OnConsume(player, injector, mul, character)
	local client = character:GetPlayer()
	local lastShock = character:GetShock()
	local isUnconscious = client:IsUnconscious()
	
	character:SetShock(0)

	if isUnconscious then
		client:SetAction("@wakingUp", 10, function(client)
			client.ixUnconsciousOut = nil
			client:SetLocalVar("knocked", false)
			client:SetRagdolled(false)
		end)

		client.ixUnconsciousOut = true
	end

	return {unconscious = isUnconscious, shock = lastShock}
end
