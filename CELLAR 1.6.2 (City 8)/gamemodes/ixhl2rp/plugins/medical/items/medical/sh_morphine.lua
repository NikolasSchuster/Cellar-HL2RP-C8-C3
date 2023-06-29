ITEM.name = "Morphine"
ITEM.PrintName = "iMorphine"
ITEM.description = "iMorphineDesc"
ITEM.model = Model("models/items/morphine.mdl")
ITEM.useSound = "items/medshot4.wav"
ITEM.cost = 100
ITEM.dUses = 1
ITEM.dIsInject = true
ITEM.rarity = 1
ITEM.dUseTime = 5

function ITEM:OnConsume(player, injector, mul, character)
	local healedLimbs = 0
	local limbs = character:GetLimbData()
	for k, v in pairs(limbs) do
		healedLimbs = healedLimbs + (10 - math.max(10 - v, 0))
	end

	local rightLeg = character:GetLimbDamage(HITGROUP_RIGHTLEG)
	local leftLeg = character:GetLimbDamage(HITGROUP_LEFTLEG)

	character:HealLimbs(10)

	if rightLeg > 80 then
		character:HealLimbDamage(HITGROUP_RIGHTLEG, 100)

		healedLimbs = healedLimbs + 20
	end

	if leftLeg > 80 then
		character:HealLimbDamage(HITGROUP_LEFTLEG, 100)

		healedLimbs = healedLimbs + 20
	end

	return {
		limbs = healedLimbs,
	}
end