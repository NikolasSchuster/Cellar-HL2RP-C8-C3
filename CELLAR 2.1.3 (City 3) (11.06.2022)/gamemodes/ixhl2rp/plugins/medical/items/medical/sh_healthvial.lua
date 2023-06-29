ITEM.name = "Health Vial"
ITEM.PrintName = "iHealthVial"
ITEM.description = "iHealthVialDesc"
ITEM.model = Model("models/healthvial.mdl")
ITEM.useSound = "items/medshot4.wav"
ITEM.cost = 25
ITEM.dUses = 2
ITEM.dIsInject = true
ITEM.rarity = 2
ITEM.dUseTime = 5

function ITEM:OnConsume(player, injector, mul, character)
	if (not mul) then mul = 1 end
	local client = character:GetPlayer()
	local blood, shock, rad = character:GetBlood(), character:GetShock(), character:GetRadLevel()
	local isBleeding, isPain, bleedDmg = false, character:IsFeelPain(), 0
	local newBlood = math.Clamp(blood + (240 * mul), -1, 5000)
	local newShock = math.max(shock - (390 * mul), 0)
	local newRad = math.max(rad - (125 * mul), 0)

	character:SetBlood(newBlood)

	if math.random(0, 100) < 25 then
		isBleeding = character:IsBleeding()
		bleedDmg = (character:GetDmgData().bleedDmg or 0)

		character:SetBleeding(false)
	end

	local healedLimbs = 0
	local limbs = character:GetLimbData()
	for k, v in pairs(limbs) do
		healedLimbs = healedLimbs + (25 - math.max(25 - v, 0))
	end

	character:SetFeelPain(false)
	character:HealLimbs(25)

	local head = character:GetLimbDamage("head")
	local chest = character:GetLimbDamage("chest")
	local stomach = character:GetLimbDamage("stomach")
	local lleg = character:GetLimbDamage("leftLeg")
	local rleg = character:GetLimbDamage("rightLeg")
	local lhand = character:GetLimbDamage("leftHand")
	local rhand = character:GetLimbDamage("rightHand")
	local minHP = 100 - (head + ((chest + stomach) / 2) + ((lleg + rleg) / 2) + ((lhand + rhand) / 2)) / 4
	client:SetHealth(math.max(client:Health(), minHP))

	character:SetShock(newShock)
	character:SetRadLevel(newRad)

	return {
		bleed = isBleeding,
		bleedDmg = bleedDmg,
		blood = newBlood - blood,
		shock = math.abs(newShock - shock),
		rad = math.abs(newRad - rad),
		limbs = healedLimbs,
		pain = isPain
	}
end
