local langEn = {}
local langRu = {}
langEn["iEmptyCan"] = "Empty Can"
langRu["iEmptyCan"] = "Пустая банка"
langEn["iEmptyCanDesc"] = "An empty can, its label is long gone to say what its contents once held."
langRu["iEmptyCanDesc"] = "Пустая алюминиевая банка."


local ITEM = ix.item.New2()
ITEM.name = "Empty Can";
ITEM.PrintName = "iEmptyCan"
ITEM.model = "models/props_junk/popcan01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "categoryJunk"
ITEM.description = "iEmptyCanDesc"
ITEM.cost = 1

function ITEM:GetSkin()
	return self:GetData("S", 0)
end

function ITEM:GetModel()
	return self:GetData("M", self.model)
end

ITEM:Register()


langEn["iEmptyTinCan"] = "Empty Plastic Can";
langRu["iEmptyTinCan"] = "Пустая пластиковая банка";
langEn["iEmptyTinCanDesc"] = "An empty plastic can. It is impossible to determine what was stored in it before.";
langRu["iEmptyTinCanDesc"] = "Пустая пластиковая банка. Выглядит очень изношенной и невозможно определить что в ней хранили раньше.";
local ITEM = ix.item.New2()
ITEM.name = "Empty Plastic Can";
ITEM.PrintName = "iEmptyTinCan"
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.width = 1
ITEM.height = 1
ITEM.category = "categoryJunk"
ITEM.description = "iEmptyTinCanDesc"
ITEM.cost = 1
ITEM:Register()

langEn["iEmptyPBottle"] = "Empty Plastic Can";
langRu["iEmptyPBottle"] = "Пустая пластиковая бутылка";
langEn["iEmptyPBottleDesc"] = "An empty plastic bottle, it's fairly big.";
langRu["iEmptyPBottleDesc"] = "Пустая пластиковая бутылка большого размера.";
local ITEM = ix.item.New2();
ITEM.PrintName = "iEmptyPBottle"
ITEM.name = "Empty Plastic Bottle"
ITEM.model = "models/props_junk/garbage_plasticbottle003a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "categoryJunk"
ITEM.description = "iEmptyPBottleDesc"
ITEM.cost = 1
ITEM:Register()

langEn["iEmptyGBottle"] = "Empty Glass Bottle";
langRu["iEmptyGBottle"] = "Пустая стеклянная бутылка";
langEn["iEmptyGBottleDesc"] = "An empty glass bottle.";
langRu["iEmptyGBottleDesc"] = "Пустая стеклянная бутылка, похоже, что из под какого-то алкоголя.";
local ITEM = ix.item.New2();
ITEM.PrintName = "iEmptyGBottle"
ITEM.name = "Empty Glass Bottle";
ITEM.model = "models/props_junk/garbage_glassbottle003a.mdl";
ITEM.width = 1
ITEM.height = 1
ITEM.category = "categoryJunk"
ITEM.description = "iEmptyGBottleDesc";
ITEM.cost = 1

function ITEM:GetModel()
	return self:GetData("M", self.model)
end

function ITEM:OnDrop(player, position) end
ITEM:Register()

langEn["iEmptyTcan"] = "Empty Tin Can";
langRu["iEmptyTcan"] = "Пустая консервная банка";
langEn["iEmptyTcanDesc"] = "An empty old can, the label is worn off.";
langRu["iEmptyTcanDesc"] = "Старая пустая консервная банка, все надписи стёрты.";
local ITEM = ix.item.New2();
ITEM.PrintName = "iEmptyTcan"
ITEM.name = "Empty Tin Can";
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.width = 1
ITEM.height = 1
ITEM.category = "categoryJunk"
ITEM.description = "iEmptyTcanDesc";
ITEM.cost = 1

function ITEM:GetModel()
	return self:GetData("M", self.model)
end

ITEM:Register()

langEn["iEmptyMCarton"] = "Empty Carton";
langRu["iEmptyMCarton"] = "Пустая картонная упаковка";
langEn["iEmptyMCartonDesc"] = "An empty carton."
langRu["iEmptyMCartonDesc"] = "Пустая картонная упаковка из под молока.";
local ITEM = ix.item.New2()
ITEM.PrintName = "iEmptyMCarton"
ITEM.name = "Empty Carton"
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "categoryJunk"
ITEM.description = "iEmptyMCartonDesc"
ITEM.cost = 1

function ITEM:GetModel()
	return self:GetData("M", self.model)
end
ITEM:Register()

langEn["iEmptyJug"] = "Empty Jug";
langRu["iEmptyJug"] = "Пустой пластиковый кувшин";
langEn["iEmptyJugDesc"] = "An empty jug."
langRu["iEmptyJugDesc"] = "Пустой пластиковый кувшин из под молока.";
local ITEM = ix.item.New2()
ITEM.PrintName = "iEmptyJug"
ITEM.name = "Empty Jug"
ITEM.model = "models/props_junk/garbage_milkcarton001a.mdl";
ITEM.width = 1
ITEM.height = 1
ITEM.business = false;
ITEM.category = "categoryJunk"
ITEM.description = "iEmptyJugDesc"
ITEM.cost = 1
function ITEM:GetModel()
	return self:GetData("M", self.model)
end
ITEM:Register()

langEn["iEmptyChinese"] = "Empty Chinese Takeout"
langRu["iEmptyChinese"] = "Пустая картонная коробка"
langEn["iEmptyChineseDesc"] = "An empty cardboard container."
langRu["iEmptyChineseDesc"] = "Пустая картонная коробка из под китайской лапши."
local ITEM = ix.item.New2()
ITEM.name = "Empty Chinese Takeout"
ITEM.PrintName = "iEmptyChinese"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "categoryJunk"
ITEM.description = "iEmptyChineseDesc"
ITEM.cost = 1
ITEM:Register()

ix.lang.AddTable("russian", langRu)
ix.lang.AddTable("english", langEn)