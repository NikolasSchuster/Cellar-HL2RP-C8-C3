ITEM.name = "Blood Bag"
ITEM.PrintName = "iBloodB"
ITEM.description = "iBloodBDesc"
ITEM.model = Model("models/props_rpd/medical_blood.mdl")
ITEM.useSound = "items/medshot4.wav"
ITEM.cost = 200
ITEM.dUses = 1
ITEM.dIsInject = true
ITEM.dUseTime = 60

function ITEM:OnConsume(player, injector, mul, character)
	local blood = character:GetBlood()
	local newBlood = math.Clamp(blood + 3000, -1, 5000)

	character:SetBlood(newBlood)

	return {blood = (newBlood - blood)}
end
