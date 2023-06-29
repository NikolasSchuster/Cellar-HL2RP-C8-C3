ITEM.name = "Штурмовой бронежилет Катафрактарий-М1"
ITEM.description = [[Крайне тяжелый комплект боевой брони, имеющий запредельные баллистические параметры. 
Прочные инопланетные компоненты делают эту модификацию брони Подавителей очень надежной, 
и практически неизнашеваемой. Для удобства ношения, спина усилена подвижными металлическими штифтами, 
что поддерживают позвоночник своего владельца. Благодаря мягкому наполнителю внутреннего слоя, попавшие 
пули почти не фрагментируются, уменьшая риск появления рваных ранений. Носить такое сможет не каждый, но 
преимущество что дает эта модификация, может перевернуть ход затяжного сражения.]]
ITEM.genderReplacement = {
	[GENDER_MALE] = "models/cellar/custom/ac_male.mdl",
	[GENDER_FEMALE] = "models/cellar/custom/ac_female.mdl"
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 10,
	[HITGROUP_HEAD] = 0,
	[HITGROUP_CHEST] = 20,
	[HITGROUP_STOMACH] = 15,
	[4] = 10, -- hands
	[5] = 10, -- legs
}
ITEM.RadResist = 98
ITEM.primaryVisor = Vector(0.15, 0.8, 2)
ITEM.secondaryVisor = Vector(0.15, 0.8, 2)
ITEM.rarity = 3
ITEM.thermalIsolation = 3
ITEM.model = "models/cellar/items/city3/clothing/vest_03.mdl"