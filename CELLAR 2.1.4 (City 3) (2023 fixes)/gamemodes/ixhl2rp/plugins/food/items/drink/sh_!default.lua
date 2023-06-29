local langEn = {}
local langRu = {}

langEn["iCoffee"] = "Coffee mug"
langRu["iCoffee"] = "Кружка кофе"
langEn["iCoffeeDesc"] = "A mug filled with unfiltered coffee. Something strange is floating on the surface of the coffee itself. The taste is very bitter mush."
langRu["iCoffeeDesc"] = "Кружка, наполненная нефильтрованым кофе. На поверхности самого кофе плавает что-то странное. На вкус очень горькое месиво."
langEn["iUBSpoiledbeer"] = "Bottle of spoiled beer"
langRu["iUBSpoiledbeer"] = "Бутылка испорченного пива"
langEn["iUBSpoiledbeerDesc"] = "A bottle filled with light beer. It is already very old, without gas, but it tastes pretty good. Even a little intoxicates."
langRu["iUBSpoilerbeerDesc"] = "Бутылка, в которую налито светлое пиво. Оно уже очень старое, без газа, но на вкус довольно сносно. Даже немного пьянит."
langEn["iUBSpoiledwhiskey"] = "Bottle of spoiled whiskey"
langRu["iUBSpoiledwhiskey"] = "Бутылка испорченного виски"
langEn["iUBSpoiledwhiskeyDesc"] = "A bottle wrapped in a thick layer of paper to hide the contents. Filled with bitter whiskey, which is almost impossible to drink, except that only for the effect of 'deja vu'"
langRu["iUBSpoilerwhiskeyDesc"] = "Бутылка, обернутая в толстый слой бумаги для скрытия содержимого. Наполнено горьким виски, который практически невозможно пить, разве что только ради эффекта 'дежа вю'"
langEn["iUBPurifiedwater"] = "Bottle of purified water"
langRu["iUBPurifiedwater"] = "Бутылка очищенной воды"
langEn["iUBPurifiedwaterDesc"] = "A bottle filled with water from still clean sources. It is quite tasty and 'useful', but no one has cleaned up the water completely, therefore, it is likely that it can be contaminated."
langRu["iUBPurifiedwaterDesc"] = "Бутылка, наполненная водой из ещё чистых источников. Она довольно вкусная и 'полезная', но полной отчисткой воды никто не занимался, по этому, скорее всего, она может быть заражена."
langEn["iUBPrewarcanfood"] = "Pre-war canned food"
langRu["iUBPrewarcanfood"] = "Довоенные консервы"
langEn["iUBPrewarcanfoodDesc"] = "Pre-war canned food, the label has long been ripped off, but judging by the consistency, there is meat inside. Holes on the sides of canned food alarm that this canned food can be spoiled."
langRu["iUBPrewarcanfoodDesc"] = "Довоенные консервы, этикетка давным давно сорвана, но, судя по консистенции, внутри есть мясо. Дырки по бокам консервов настораживают, что этот консерв может быть испорчен."
langEn["iMilkcarton"] = "Milk catron"
langRu["iMilkcarton"] = "Пакет молока"
langEn["iMilkcartonDesc"] = "White carton with milk. Inside it is really milk - it is true, it is not cleaned and it is very much in vain. The cow, most likely, is sick. Nevertheless, this is the only milk that has at least some useful properties."
langRu["iMilkcartonDesc"] = "Белый пакет с молоком. Внутри действительно молоко - правда, оно не очищено и от него очень сильно несет выменем. Корова, скорее всего, больная. Тем не менее, это единственное молоко, которое обладает хоть какими-то полезными свойствами."
langEn["iUBOil"] = "Old bottle of olive oil"
langRu["iUBOil"] = "Старая бутылка оливкового масла"
langEn["iUBOilDesc"] = "Old, tasteless, smelly olive oil, which was widely used by housewives before the war. It's almost impossible to drink, but if you try, and from this shit you can get something really useful."
langRu["iUBOilDesc"] = "Старое, бесвкусное, вонючее оливковое масло, которое широко использовали домохозяйки до войны. Его практически не возможно пить, но, если постараться, и из этого дерьма можно получить что-то действительно полезное."
langEn["iUBOldsoda"] = "Bottle with old soda"
langRu["iUBOldsoda"] = "Бутылка со старой газировкой"
langEn["iUBOldsodaDesc"] = "Brown bottle with old soda inside. It has long been exhausted, but the sweet taste covers this unpleasant flaw."
langRu["iUBOldsodaDesc"] = "Коричневая бутылка со старой газировкой внутри. Она уже давным давно выдохлась, но сладковатый вкус покрывает этот неприятный недостаток."
langEn["iUBOldfastfood"] = "Old fast food"
langRu["iUBOldfastfood"] = "Старая еда быстрого приготовления"
langEn["iUBOldfastfoodDesc"] = "Package without labels, inside there is dry noodles and sachets with condiments. The noodles themselves were slightly moldy because of the dampness, but is this a problem?"
langRu["iUBOldfastfoodDesc"] = "Пакет без этикеток, внутри находится сухая лапша и пакетики с приправами. Сама лапша немного покрылась плесенью из-за сыроватости, но разве это проблема?"
langEn["iUBHawthorn"] = "Bottle of hawthorn"
langRu["iUBHawthorn"] = "Бутылка боярышника"
langEn["iUBHawthornDesc"] = "A bottle of the long-forgotten fun of the Russian people."
langRu["iUBHawthornDesc"] = "Бутылка давно забытого веселья русского народа."

ix.lang.AddTable("russian", langRu)
ix.lang.AddTable("english", langEn)

local ITEM = ix.item.New2("base_drink")
ITEM.name = "coffee_mug"
ITEM.PrintName = "iCoffee"
ITEM.description = "iCoffeeDesc"
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl"
ITEM.cost = 7
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 0
ITEM.dThirst = 10
ITEM:Register()

local ITEM = ix.item.New2("base_drink")
ITEM.name = "spoiled_beer"
ITEM.PrintName = "iUBSpoiledbeer"
ITEM.description = "iUBSpoiledbeerDesc"
ITEM.model = "models/props_junk/garbage_glassbottle001a.mdl"
ITEM.cost = 4
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 0
ITEM.dThirst = 6
ITEM.junk =  "empty_glass_bottle"
ITEM:Register()

local ITEM = ix.item.New2("base_drink")
ITEM.name = "spoiled_whiskey"
ITEM.PrintName = "iUBSpoiledwhiskey"
ITEM.description = "iUBSpoiledwhiskeyDesc"
ITEM.model = "models/props_junk/garbage_glassbottle002a.mdl"
ITEM.cost = 6
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 0
ITEM.dThirst = 9
ITEM.junk =  "empty_glass_bottle"
ITEM:Register()

local ITEM = ix.item.New2("base_drink")
ITEM.name = "purified_water"
ITEM.PrintName = "iUBPurifiedwater"
ITEM.description = "iUBPurifiedwaterDesc"
ITEM.model = "models/props_junk/GlassBottle01a.mdl"
ITEM.cost = 18
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 0
ITEM.dThirst = 20
ITEM.rarity = 1
ITEM.junk =  "empty_glass_bottle"
ITEM:Register()

local ITEM = ix.item.New2("base_food")
ITEM.name = "pre-war_canned_food"
ITEM.PrintName = "iUBPrewarcanfood"
ITEM.description = "iUBPrewarcanfoodDesc"
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.cost = 25
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 14
ITEM.dThirst = 4
ITEM.rarity = 2
ITEM.junk =  "empty_tin_can"
ITEM:Register()

local ITEM = ix.item.New2("base_drink")
ITEM.name = "milk_carton"
ITEM.PrintName = "iMilkcarton"
ITEM.description = "iMilkcartonDesc"
ITEM.model = "models/props_junk/garbage_milkcarton001a.mdl"
ITEM.cost = 18
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 0
ITEM.dThirst = 10
ITEM.rarity = 1
ITEM.junk =  "empty_carton"
ITEM:Register()

local ITEM = ix.item.New2("base_drink")
ITEM.name = "olive_oil"
ITEM.PrintName = "iUBOil"
ITEM.description = "iUBOilDesc"
ITEM.model = "models/props_junk/garbage_plasticbottle002a.mdl"
ITEM.cost = 4
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 6
ITEM.dHunger = 2.5
ITEM.dThirst = 1.7
ITEM:Register()

local ITEM = ix.item.New2("base_drink")
ITEM.name = "old_soda"
ITEM.PrintName = "iUBOldsoda"
ITEM.description = "iUBOldsodaDesc"
ITEM.model = "models/props_junk/garbage_plasticbottle003a.mdl"
ITEM.cost = 7
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 8
ITEM.dHunger = 0
ITEM.dThirst = 5.25
ITEM.rarity = 1
ITEM.junk =  "empty_plastic_bottle"
ITEM:Register()

local ITEM = ix.item.New2("base_food")
ITEM.name = "old_fast_food"
ITEM.PrintName = "iUBOldfastfood"
ITEM.description = "iUBOldfastfoodDesc"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.cost = 11
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 11
ITEM.dThirst = -2
ITEM.rarity = 1
ITEM.junk =  "empty_chinese_takeout"
ITEM:Register()

local ITEM = ix.item.New2("base_drink")
ITEM.name = "hawthorn"
ITEM.PrintName = "iUBHawthorn"
ITEM.description = "iUBHawthornDesc"
ITEM.model = "models/props_junk/glassjug01.mdl"
ITEM.cost = 13
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 8
ITEM.dHunger = 0
ITEM.dThirst = 7.5
ITEM.rarity = 2
ITEM.junk =  "empty_glass_bottle"
ITEM:Register()