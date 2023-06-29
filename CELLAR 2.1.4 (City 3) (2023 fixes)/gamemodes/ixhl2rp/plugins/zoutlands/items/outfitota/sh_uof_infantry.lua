ITEM.name = "Бронежилет Патруля Пехотинец-М1"
ITEM.description = [[Форма неизвестных милитаризированных сил, приспособленная для длительного 
ношения в условиях очень холодной зимы. 
Сама одежда состоит из самого комбенизона с коричневым горным камуфляжем, 
теплого термобелья, а также черных кожанных берцев. Бронированные части окрашены в серый металлик, 
ровно как и ощутимо тяжелый бронежилет Патруля высокого класса защиты. 
К комплекту прилагаются прикрепляемые подсумки, белый камуфляжный плащ-палатка, 
а также встроенная система жизнеобеспечения.]]
ITEM.genderReplacement = {
	[GENDER_MALE] = "models/cellar/custom/ac_male.mdl",
	[GENDER_FEMALE] = "models/cellar/custom/ac_female.mdl"
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 10,
	[HITGROUP_HEAD] = 0,
	[HITGROUP_CHEST] = 25,
	[HITGROUP_STOMACH] = 10,
	[4] = 6, -- hands
	[5] = 6, -- legs
}
ITEM.RadResist = 98
ITEM.primaryVisor = Vector(0.15, 0.8, 2)
ITEM.secondaryVisor = Vector(0.15, 0.8, 2)
ITEM.rarity = 3
ITEM.thermalIsolation = 3
ITEM.model = "models/cellar/items/city3/clothing/vest_02.mdl"