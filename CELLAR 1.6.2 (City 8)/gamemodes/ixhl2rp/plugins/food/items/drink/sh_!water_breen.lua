local langEn = {}
local langRu = {}
langEn["iBreenWater"] = "Breen's Water"
langRu["iBreenWater"] = "Вода Брина"
langEn["iBreenWaterDesc"] = "A blue aluminium union branded can, it swishes when you shake it."
langRu["iBreenWaterDesc"] = "Алюминиевая банка голубого цвета с фирменным знаком Альянса на ней, если её встряхнуть можно услышать шипение газа."
langEn["iSmoothBreenWater"] = "Smooth Breen's Water"
langRu["iSmoothBreenWater"] = "Ароматная вода Брина"
langEn["iSmoothBreenWaterDesc"] = "A red aluminium union branded can, it swishes when you shake it."
langRu["iSmoothBreenWaterDesc"] = "Алюминиевая банка красного цвета с фирменным знаком Альянса на ней, если её встряхнуть можно услышать шипение газа."
langEn["iSpecialBreenWater"] = "Special Breen's Water"
langRu["iSpecialBreenWater"] = "Специальная вода Брина"
langEn["iSpecialBreenWaterDesc"] = "A yellow aluminium union branded can, it swishes when you shake it."
langRu["iSpecialBreenWaterDesc"] = "Алюминиевая банка жёлтого цвета с фирменным знаком Альянса на ней, если её встряхнуть можно услышать шипение газа."

local ITEM = ix.item.New2("base_drink")
	ITEM.name = "Breen's Water"
	ITEM.PrintName = "iBreenWater"
	ITEM.description = "iBreenWaterDesc"
	ITEM.model = "models/props_junk/popcan01a.mdl"
	ITEM.cost = 4
	ITEM.width = 1
	ITEM.height = 1
	ITEM.dUses = 5
	ITEM.dHunger = 0
	ITEM.dThirst = 10
	ITEM.dHealth = 0
	ITEM.junk = "empty_can"

	function ITEM:OnConsume(player)
		player:SetCharacterData("stamina", 100)
	end
ITEM:Register()


local ITEM = ix.item.New2("base_drink")
	ITEM.name = "Smooth Breen's Water"
	ITEM.PrintName = "iSmoothBreenWater"
	ITEM.description = "iSmoothBreenWaterDesc"
	ITEM.model = "models/props_junk/popcan01a.mdl"
	ITEM.skin = 1
	ITEM.cost = 10
	ITEM.width = 1
	ITEM.height = 1
	ITEM.dUses = 5
	ITEM.dHunger = 0
	ITEM.dThirst = 20
	ITEM.dHealth = 0
	ITEM.rarity = 1
	ITEM.junk = "empty_can"

	function ITEM:OnConsume(player)
		player:SetCharacterData("stamina", 100)
	end
ITEM:Register()


local ITEM = ix.item.New2("base_drink")
	ITEM.name = "Special Breen's Water"
	ITEM.PrintName = "iSpecialBreenWater"
	ITEM.description = "iSpecialBreenWaterDesc"
	ITEM.model = "models/props_junk/popcan01a.mdl"
	ITEM.skin = 2
	ITEM.cost = 25
	ITEM.width = 1
	ITEM.height = 1
	ITEM.dUses = 5
	ITEM.dHunger = 0
	ITEM.dThirst = 30
	ITEM.dHealth = 0
	ITEM.rarity = 2
	ITEM.junk = "empty_can"

	function ITEM:OnConsume(player)
		player:SetCharacterData("stamina", 100)
	end
ITEM:Register()

ix.lang.AddTable("russian", langRu)
ix.lang.AddTable("english", langEn)