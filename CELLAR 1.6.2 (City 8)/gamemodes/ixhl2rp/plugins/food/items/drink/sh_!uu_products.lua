local langEn = {}
local langRu = {}

langEn["iUBChocolate"] = "Union Branded Chocolate"
langRu["iUBChocolate"] = "Фирменный шоколад"
langEn["iUBChocolateDesc"] = "A carefully packaged bar of chocolate approved by the Universal Union. The distinct Union logo is printed on the top."
langRu["iUBChocolateDesc"] = "Бережно упакованная плитка шоколада, разрешённая Альянсом. Отчётливый знак Альянса напечатан на лицевой стороне."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Chocolate"
ITEM.PrintName = "iUBChocolate"
ITEM.description = "iUBChocolateDesc"
ITEM.model = "models/bioshockinfinite/hext_candy_chocolate.mdl"
ITEM.cost = 9
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 12
ITEM.dHunger = 2.5
ITEM.dHealth = 0

ITEM.rarity = 2
ITEM:Register()


langEn["iUBBread"] = "Union Branded Bread Loaf"
langRu["iUBBread"] = "Фирменный хлеб"
langEn["iUBBreadDesc"] = "A nice loaf of bread with a mark of the Universal Union. It has a dreadful aura about it."
langRu["iUBBreadDesc"] = "Хорошая буханка хлеба со знаком Альянса."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Bread"
ITEM.PrintName = "iUBBread"
ITEM.description = "iUBBreadDesc"
ITEM.model = "models/bioshockinfinite/dread_loaf.mdl"
ITEM.cost = 8
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 5
ITEM.dThirst = -2

ITEM.rarity = 1
ITEM:Register()


langEn["iUBFlakes"] = "Union Branded Bran Flakes"
langRu["iUBFlakes"] = "Фирменные хлопья"
langEn["iUBFlakesDesc"] = "A carefully packaged brown box containing bran flakes approved by the Universal Union. The Union logo is present on the front."
langRu["iUBFlakesDesc"] = "Тщательно упакованный коричневый ящик, содержащий хлопья. Логотип Альянса напечатан на лицевой стороне."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Bran Flakes"
ITEM.PrintName = "iUBFlakes"
ITEM.description = "iUBBreadDesc"
ITEM.model = "models/bioshockinfinite/hext_cereal_box_cornflakes.mdl"
ITEM.cost = 9
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 6
ITEM.dThirst = -3

ITEM.rarity = 1
ITEM:Register()


langEn["iUBTakeout"] = "Union Branded Chinese Takeout"
langRu["iUBTakeout"] = "Фирменная лапша"
langEn["iUBTakeoutDesc"] = "A nearly-square cardboard container with some chow mein and orange chicken inside. The noodles are rather dry, and the chicken tastes like silicone..."
langRu["iUBTakeoutDesc"] = "Почти квадратный картонный контейнер с чау-чау-мейном и оранжевым цыпленком внутри. Лапша довольно сухая, и курица похожа на силикон..."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Chinese Takeout"
ITEM.PrintName = "iUBTakeout"
ITEM.description = "iUBTakeoutDesc"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.cost = 10
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 10
ITEM.dThirst = -2

ITEM.junk = "empty_chinese_takeout"
ITEM.rarity = 1
ITEM:Register()

langEn["iUBMilkCarton"] = "Union Branded Milk Carton"
langRu["iUBMilkCarton"] = "Фирменный пакет молока"
langEn["iUBMilkCartonDesc"] = "A carton filled with slightly chunky-tasting synthetic milk. Somewhat unappetizing, but a decent source of calcium..."
langRu["iUBMilkCartonDesc"] = "Картонная коробка, заполненная синтетическим молоком. Немного неаппетитное, но хороший источник кальция..."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Union Branded Milk Carton"
ITEM.PrintName = "iUBMilkCarton"
ITEM.description = "iUBMilkCartonDesc"
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl"
ITEM.cost = 21
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 1
ITEM.dThirst = 8

ITEM.junk = "empty_carton"
ITEM.rarity = 2
ITEM:Register()


langEn["iUBMilkJug"] = "Union Branded Milk Jug"
langRu["iUBMilkJug"] = "Фирменный кувшин молока"
langEn["iUBMilkJugDesc"] = "A jug filled with slightly chunky-tasting synthetic milk. Somewhat unappetizing, but a decent source of calcium..."
langRu["iUBMilkJugDesc"] = "Закрытый, пластиковый кувшин с ручкой, заполненный синтетическим молоком. Немного неаппетитное, но хороший источник кальция..."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Union Branded Milk Jug"
ITEM.PrintName = "iUBMilkJug"
ITEM.description = "iUBMilkJugDesc"
ITEM.model = "models/props_junk/garbage_milkcarton001a.mdl"
ITEM.cost = 17
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 2
ITEM.dThirst = 10

ITEM.junk = "empty_jug"
ITEM.rarity = 2
ITEM:Register()


langEn["iUBSardines"] = "Union Branded Sardines"
langRu["iUBSardines"] = "Фирменные сардины"
langEn["iUBSardinesDesc"] = "A can with fishlike contents supposed to represent sardines. The fish-flavoured replacement makes you ponder if it truly is fish."
langRu["iUBSardinesDesc"] = "Консервная банка с рыбным содержимым, предположительно сардинами. Заменившая рыбу замена заставляет задуматься, действительно ли это рыба."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Sardines"
ITEM.PrintName = "iUBSardines"
ITEM.description = "iUBSardinesDesc"
ITEM.model = "models/bioshockinfinite/cardine_can_open.mdl"
ITEM.cost = 18
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 4
ITEM.dHunger = 15
ITEM.dThirst = 0

ITEM.rarity = 2
ITEM:Register()


langEn["iUBCrisps"] = "Union Branded Crisps"
langRu["iUBCrisps"] = "Фирменные чипсы"
langEn["iUBCrispsDesc"] = "A small, flimsy package with a printed logo of the Universal Union. The inscription reads 'Lightly Salted Union Crisps'"
langRu["iUBCrispsDesc"] = "Небольшой, надутый пакет с напечатанным знаком Альянса. Надпись гласит: «Слабосоленные чипсы Альянса»"
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Crisps"
ITEM.PrintName = "iUBCrisps"
ITEM.description = "iUBCrispsDesc"
ITEM.model = "models/bioshockinfinite/bag_of_hhips.mdl"
ITEM.cost = 11
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 12
ITEM.dHunger = 3.75
ITEM.dThirst = 0

ITEM.rarity = 1
ITEM:Register()


langEn["iUBCheeseWheel"] = "Union Branded Cheese Wheel"
langRu["iUBCheeseWheel"] = "Фирменный сыр"
langEn["iUBCheeseWheelDesc"] = "A delicious wheel of union-approved cheese. It has a strong artificial smell of cheese, whew!"
langRu["iUBCheeseWheelDesc"] = "Вкусное колесо одобренного Альянсом сыра. У него сильный искусственный запах сыра!"
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Cheese Wheel"
ITEM.PrintName = "iUBCheeseWheel"
ITEM.description = "iUBCheeseWheelDesc"
ITEM.model = "models/bioshockinfinite/pound_cheese.mdl"
ITEM.cost = 12
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 8
ITEM.dHunger = 5

ITEM.rarity = 2
ITEM:Register()


langEn["iUBCornCob"] = "Union Branded Corn Cob"
langRu["iUBCornCob"] = "Фирменная кукуруза"
langEn["iUBCornCobDesc"] = "A cob of corn with a stamped logo of the Universal Union. An artificial smell of corn surrounds it."
langRu["iUBCornCobDesc"] = "Кукуруза со штампом Альянса на ней. У неё искусственный запах."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Corn Cob"
ITEM.PrintName = "iUBCornCob"
ITEM.description = "iUBCornCobDesc"
ITEM.model = "models/bioshockinfinite/porn_on_cob.mdl"
ITEM.cost = 7
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 6
ITEM.dThirst = 0

ITEM.rarity = 1
ITEM:Register()


langEn["iUBPeanuts"] = "Union Branded Bag of Peanuts"
langRu["iUBPeanuts"] = "Фирменный арахис"
langEn["iUBPeanutsDesc"] = "A bag of salted peanuts. The Universal Union logo has been printed on both sides of the package."
langRu["iUBPeanutsDesc"] = "Мешочек солёного арахиса. Знак Альянса напечатан на обоих сторонах пачки."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Bag of Peanuts"
ITEM.PrintName = "iUBPeanuts"
ITEM.description = "iUBPeanutsDesc"
ITEM.model = "models/bioshockinfinite/rag_of_peanuts.mdl"
ITEM.cost = 2
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 2
ITEM.dThirst = -0.2

ITEM.rarity = 1
ITEM:Register()


langEn["iUBPopcorn"] = "Union Branded Popcorn"
langRu["iUBPopcorn"] = "Фирменный попкорн"
langEn["iUBPopcornDesc"] = "An open box of popcorn fabricated under the regulations of the Universal Union. Something's about to go down."
langRu["iUBPopcornDesc"] = "Открытый пакет с попкорном, приготовленный по стандартам Альянса."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Popcorn"
ITEM.PrintName = "iUBPopcorn"
ITEM.description = "iUBPopcornDesc"
ITEM.model = "models/bioshockinfinite/topcorn_bag.mdl"
ITEM.cost = 3
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 12
ITEM.dHunger = 1.25
ITEM.dThirst = 0

ITEM.rarity = 1
ITEM:Register()


langEn["iUBInstantPotatos"] = "Union Branded Instant Potatos"
langRu["iUBInstantPotatos"] = "Фирменные консервы"
langEn["iUBInstantPotatosDesc"] = "A tin can with a stamped logo of the Universal Union, filled with brown baked potatos in tomato sauce."
langRu["iUBInstantPotatosDesc"] = "Жестяная банка со знаком Альянса на ней, заполненная коричневым печеным картофелем в томатном соусе."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Union Branded Instant Potatos"
ITEM.PrintName = "iUBInstantPotatos"
ITEM.description = "iUBInstantPotatosDesc"
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.cost = 10
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 8
ITEM.dThirst = 1

ITEM.junk = "empty_tin_can"
ITEM.rarity = 1
ITEM:Register()


langEn["iMinimalSupplements"] = "Minimal Supplements"
langRu["iMinimalSupplements"] = "Пищевые добавки \"Минимум\""
langEn["iMinimalSupplementsDesc"] = "A vacuum-packed package containing a thick porridge-like substance. It is brown, has a heavy taste of salt and a plastic spoon is packed alongside it. There is just enough to keep one alive in terms of calories."
langRu["iMinimalSupplementsDesc"] = "Вакуумная упаковка, содержащая густую кашицу. Она коричневого цвета, с сильным вкусом соли. Пластиковая ложка упакована рядом. Этого достаточно, чтобы остаться в живых."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Minimal Supplements"
ITEM.PrintName = "iMinimalSupplements"
ITEM.description = "iMinimalSupplementsDesc"
ITEM.model = "models/gibs/props_canteen/vm_sneckol.mdl"
ITEM.cost = 14
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 14
ITEM.dThirst = 0
ITEM:Register()


langEn["iCitizenSupplements"] = "Citizen Supplements"
langRu["iCitizenSupplements"] = "Пищевые добавки \"Гражданин\""
langEn["iCitizenSupplementsDesc"] = "A normal-sized bag containing a thick porridge-like substance. It is brown, has a heavy taste of salt and a plastic spoon is packed alongside it. There is an alright amount inside."
langRu["iCitizenSupplementsDesc"] = "Небольшая упаковка, содержащая густую кашицу. Она коричневого цвета, с сильным вкусом соли. Пластиковая ложка упакована рядом. Здесь достаточное количество этой штуки."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Citizen Supplements"
ITEM.PrintName = "iCitizenSupplements"
ITEM.description = "iCitizenSupplementsDesc"
ITEM.model = "models/mres/consumables/tag_mre.mdl"
ITEM.cost = 20
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 20
ITEM.dThirst = 0
ITEM:Register()


langEn["iLoyalistSupplements"] = "Loyalist Supplements"
langRu["iLoyalistSupplements"] = "Пищевые добавки \"Лоялист\""
langEn["iLoyalistSupplementsDesc"] = "A normal-sized bag containing a thin gruel, with chunks of what appear to be meat; though, upon closer inspection, it is clearly synthetic. It happens to also come with a little plastic spork. There are also three small cracker bread pieces and a bar of Union chocolate."
langRu["iLoyalistSupplementsDesc"] = "Небольшая упаковка, содержащая тонкую кашу с кусками мяса, хотя, при ближайшем рассмотрении, она явно синтетическая. Пластиковая ложка упакована рядом. Есть также три небольших кусочка хлеба и плитка фирменного шоколада."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Loyalist Supplements"
ITEM.PrintName = "iLoyalistSupplements"
ITEM.description = "iLoyalistSupplementsDesc"
ITEM.model = "models/mres/consumables/pag_mre.mdl"
ITEM.cost = 31
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 25
ITEM.dThirst = 0
ITEM.rarity = 1
ITEM:Register()


langEn["iCPSupplements"] = "Civil Protection Supplements"
langRu["iCPSupplements"] = "Пищевые добавки \"Гражданская Оборона\""
langEn["iCPSupplementsDesc"] = "A large cardboard box that almost resembles that of a pre-war microwave dinner. There is a foil tin inside containing a choice of mutton, chicken or beef stew, with rice mixed into it and a full set of plastic cutlery. A small tub of assorted nuts is provided, as well as two chalky, white caffeine pills in a plastic packet. A sealed packet of crackers is separate, with a well sized tube of chocolate paste to spread onto them."
langRu["iCPSupplementsDesc"] = "Большая картонная коробка, почти напоминающая довоенный микроволновый обед. Внутри есть фольга, содержащая кусок баранины, курятины или говядины, с рисом, смешанным с ним, и полным набором пластиковых столовых приборов. Предоставляется небольшой пакет с различными орехами, а также две таблетки с кофеином в пластиковом пакете. Запечатанный пакетик сухарей, с хорошей шоколадной пастой в комплекте."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Civil Protection Supplements"
ITEM.PrintName = "iCPSupplements"
ITEM.description = "iCPSupplementsDesc"
ITEM.model = "models/mres/consumables/zag_mre.mdl"
ITEM.cost = 37
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 30
ITEM.dThirst = 0
ITEM.rarity = 1
ITEM:Register()


langEn["iUBSushi"] = "Sushi set"
langRu["iUBSushi"] = "Фирменный суши-сет"
langEn["iUBSushiDesc"] = "Not fresh at first sight, but looks tasty."
langRu["iUBSushiDesc"] = "Выглядит не так свежо на первый взгляд, но довольно аппетитно."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Sushi Set"
ITEM.PrintName = "iUBSushi"
ITEM.description = "iUBSushiDesc"
ITEM.model = "models/sushipack/fisheggsushi01.mdl"
ITEM.cost = 25
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 20
ITEM.dThirst = 0
ITEM.rarity = 1
ITEM:Register()


langEn["iUBSake"] = "Sake bottle"
langRu["iUBSake"] = "Сакэ"
langEn["iUBSakeDesc"] = "A usual bottle of sake, a bit dusty."
langRu["iUBSakeDesc"] = "Обычная бутылка с сакэ, немного пыльная."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Sake"
ITEM.PrintName = "iUBSake"
ITEM.description = "iUBSakeDesc"
ITEM.model = "models/foodnhouseholditems/champagne3.mdl"
ITEM.cost = 30
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 0
ITEM.dThirst = 20
ITEM.rarity = 3
ITEM:Register()


langEn["iUBKebab"] = "Kebab"
langRu["iUBKebab"] = "Шаурма"
langEn["iUBKebabDesc"] = "Not fresh at first sight, but looks tasty."
langRu["iUBKebabDesc"] = "Выглядит не так свежо на первый взгляд, но довольно аппетитно."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Kebab"
ITEM.PrintName = "iUBKebab"
ITEM.description = "iUBKebabDesc"
ITEM.model = "models/foodnhouseholditems/chicken_wrap.mdl"
ITEM.cost = 11
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 2
ITEM.dHunger = 30
ITEM.dThirst = -2.5
ITEM:Register()


langEn["iUBLobster"] = "Fried Lobster"
langRu["iUBLobster"] = "Фирменный жаренный лобстер"
langEn["iUBLobsterDesc"] = "Fried lobster's meat, smells tasty."
langRu["iUBLobsterDesc"] = "Жаренное мясо лобстера, пахнет вкусно."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Fried Lobster"
ITEM.PrintName = "iUBLobster"
ITEM.description = "iUBLobsterDesc"
ITEM.model = "models/foodnhouseholditems/lobster2.mdl"
ITEM.cost = 28
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 20
ITEM.dThirst = 4

ITEM.rarity = 1
ITEM:Register()


langEn["iUBFriedmeat"] = "Fried Meat"
langRu["iUBFriedmeat"] = "Фирменное жаренное мясо"
langEn["iUBFriedmeatDesc"] = "Spiced meat, looks fried."
langRu["iUBFriedmeatDesc"] = "Мясо покрытое специями, на вид пожаренное."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Fried Meat"
ITEM.PrintName = "iUBFriedmeat"
ITEM.description = "iUBFriedmeatDesc"
ITEM.model = "models/foodnhouseholditems/steak2.mdl"
ITEM.cost = 32
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 24
ITEM.dThirst = 3

ITEM.rarity = 1
ITEM:Register()


langEn["iUBCockCoco"] = "Coconut Cocktail"
langRu["iUBCockCoco"] = "Коктейль из кокоса"
langEn["iUBCockCocoDesc"] = "There is a cocktail in the coconut itself, a tube with an umbrella also sticks out of it."
langRu["iUBCockCocoDesc"] = "В самом кокосе находится коктейль, так же из него торчит трубочка с зонтиком."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Coconut Cocktail"
ITEM.PrintName = "iUBCockCoco"
ITEM.description = "iUBCockCocoDesc"
ITEM.model = "models/foodnhouseholditems/coconut_drink.mdl"
ITEM.cost = 30
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 2
ITEM.dThirst = 24

ITEM.rarity = 2
ITEM:Register()


langEn["iUBPapple"] = "Pineapple Cocktail"
langRu["iUBPapple"] = "Коктейль из ананаса"
langEn["iUBPappleDesc"] = "There is a cocktail in the pineapple itself, a tube with an umbrella also sticks out of it."
langRu["iUBPappleDesc"] = "В самом ананасе находится коктейль, так же из него торчит трубочка с зонтиком."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Pineapple Cocktail"
ITEM.PrintName = "iUBPapple"
ITEM.description = "iUBPineapplecocktailDesc"
ITEM.model = "models/foodnhouseholditems/pineapple_drink.mdl"
ITEM.cost = 30
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 2
ITEM.dThirst = 24

ITEM.rarity = 2
ITEM:Register()


langEn["iUBSpahnetti"] = "Spagnetti"
langRu["iUBSpahnetti"] = "Спагетти"
langEn["iUBSpahnettiDesc"] = "Nice and tasty spagnetti, no one touched it!"
langRu["iUBSpahnettiDesc"] = "Замечательные спагетти в тарелочке, никто не трогал их!"
local ITEM = ix.item.New2("base_food")
ITEM.name = "Spagnetti"
ITEM.PrintName = "iUBSpahnetti"
ITEM.description = "iUBSpahnettiDesc"
ITEM.model = "models/bowlofspaghetti01/bowlofspaghetti01.mdl"
ITEM.cost = 20
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 10
ITEM.dThirst = 0
ITEM:Register()


langEn["iUBPasta"] = "Pasta"
langRu["iUBPasta"] = "Макароны"
langEn["iUBPastaDesc"] = "Pasta with some ketchup on it and spices."
langRu["iUBPastaDesc"] = "Макароны с капелькой кетчупа на них а так же специй."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Pasta"
ITEM.PrintName = "iUBPasta"
ITEM.description = "iUBPastaDesc"
ITEM.model = "models/pennepasta01/pennepasta01.mdl"
ITEM.cost = 20
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 10
ITEM.dThirst = 0
ITEM:Register()


langEn["iUBChocotail"] = "Шоколадный коктейль"
langRu["iUBChocotail"] = "Chocolate cocktail"
langEn["iUBChocotailDesc"] = "Cocktail made of chocolate housing, some cream inside together with cherry."
langRu["iUBChocotailDesc"] = "Коктейль сделанный из шоколадного корпуса, внутри находятся сливки вместе с вишней."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Chocolate cocktail"
ITEM.PrintName = "iUBChocotail"
ITEM.description = "iUBChocotailDesc"
ITEM.model = "models/chocolateshake01/chocolateshake01.mdl"
ITEM.cost = 25
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 2
ITEM.dThirst = 20

ITEM.rarity = 2
ITEM:Register()


langEn["iUBChampagne"] = "Champagne"
langRu["iUBChampagne"] = "Шампанское"
langEn["iUBChampagneDesc"] = "Big bottle with yellow liquid inside of it."
langRu["iUBChampagneDesc"] = "Большая бутылка с жёлтой жидкостью внутри."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Champagne"
ITEM.PrintName = "iUBChampagne"
ITEM.description = "iUBChampagneDesc"
ITEM.model = "models/foodnhouseholditems/champagne3.mdl"
ITEM.cost = 47
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 1
ITEM.dThirst = 10

ITEM.rarity = 4
ITEM:Register()


langEn["iUBEdrink"] = "Energy Drink"
langRu["iUBEdrink"] = "Энергетик"
langEn["iUBEdrinkDesc"] = "Can with word Monster on it."
langRu["iUBEdrinkDesc"] = "Банка с надписью Monster."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Energy Drink"
ITEM.PrintName = "iUBEdrink"
ITEM.description = "iUBEdrinkDesc"
ITEM.model = "models/foodnhouseholditems/sodacanb01.mdl"
ITEM.cost = 36
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = -1
ITEM.dThirst = 11

ITEM.rarity = 4
ITEM:Register()


langEn["iUBNutella"] = "Chocolate pasta"
langRu["iUBNutella"] = "Шоколадная паста"
langEn["iUBNutellaDesc"] = "Glass jar with chocolate paste inside."
langRu["iUBNutellaDesc"] = "Стеклянная баночка с шоколадной пастой внутри."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Nutella"
ITEM.PrintName = "iUBNutella"
ITEM.description = "iUBNutellaDesc"
ITEM.model = "models/foodnhouseholditems/nutella.mdl"
ITEM.cost = 25
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 10 
ITEM.dThirst = -2

ITEM.rarity = 2
ITEM:Register()


langEn["iUBOldredwine"] = "Old red wine"
langRu["iUBOldredwine"] = "Старое красное вино"
langEn["iUBOldredwineDesc"] = "Old red wine bottle with dim red liquid in it."
langRu["iUBOldredwineDesc"] = "Старая красная бутылка вина с тускло-красной жидкостью внутри."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Old red wine"
ITEM.PrintName = "iUBOldredwine"
ITEM.description = "iUBOldredwineDesc"
ITEM.model = "models/foodnhouseholditems/winebottle4.mdl"
ITEM.cost = 60
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 3
ITEM.dThirst = 12

ITEM.rarity = 4
ITEM:Register()

ix.lang.AddTable("russian", langRu)
ix.lang.AddTable("english", langEn)