ITEM.name = "Тяжелый штурмовой шлем Катафрактарий-М1"
ITEM.description = [[Очень трудная в изготовке серия шлемов Катафрактарий, 
это адаптированная версия шлема Подавителей Альянса. 
Визорная часть была кардинально преобразована, для возможности 
использования обычным человеком без интеграции зрительных имплантов. 
Наклонная прочная броня этого шлема выдерживает попадания даже из 
крупнокалиберного оружия, без риска получить контузию. Левая часть 
оптики подключена к адаптивному интерфейсу, схожему с интерфейсом шлема Око-М2. 
Единственное возможное неудобство - тяжесть и неудобство при его ношении неподготовленным бойцом.]]
ITEM.model = Model("models/union_of_freedom/helmet.mdl")
ITEM.rarity = 2
ITEM.bodyGroups = {
	[0] = 10
}
ITEM.Filters = {
	["filter_epic"] = true,
	["filter_good"] = true,
	["filter_medium"] = true,
	["filter_standard"] = true
}
ITEM.Stats = {
	[HITGROUP_GENERIC] = 0,
	[HITGROUP_HEAD] = 17,
	[HITGROUP_CHEST] = 0,
	[HITGROUP_STOMACH] = 0,
	[4] = 0,
	[5] = 0,
}
ITEM.WeaponSkillBuff = 3
ITEM.CPMask = false
ITEM.visorLevel = 2
ITEM.bodyGroups = {
	[3] = 2,
}
ITEM.withOutfit = true