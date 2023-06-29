local langEn = {}
local langRu = {}

langEn["iUBDonuts"] = "Donuts in box"
langRu["iUBDounts"] = "Пончики в коробке"
langEn["iUBDonutsDesc"] = "Striped box with a bunch of scented donuts inside. Stimulates the credibility of the manufacturer."
langRu["iUBDonutsDesc"] = "Полосатая коробка с кучей душистых пончиков внутри. Внушает доверие к производителю."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Donuts"
ITEM.PrintName = "iUBDonuts"
ITEM.description = "iUBDonutsDesc"
ITEM.model = "models/bioshockinfinite/hext_cereal_box_cornflakes.mdl"
ITEM.cost = 17
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 8
ITEM.dHunger = 12.5
ITEM.dThirst = -2.5
ITEM:Register()



langEn["iUBPizza"] = "Pizza"
langRu["iUBPizza"] = "Пицца"
langEn["iUBPizzaDesc"] = "Still warm pizza in a white cardboard box. She smells of old times and dough. Black strips on the bottom of the pizza indicate that it was not cooked in the oven."
langRu["iUBPizzaDesc"] = "Ещё тёплая пицца в белой картонной коробке. От нее веет запах былых времен и теста. Чёрные полоски на дне пиццы указывают на то, что она была приготовлена не в печи."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Pizza"
ITEM.PrintName = "iUBPizza"
ITEM.description = "iUBPizzaDesc"
ITEM.model = "models/props_canteen/pizza_box.mdl"
ITEM.cost = 24
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 12
ITEM.dHunger = 9
ITEM.dThirst = -0.5

ITEM.rarity = 1
ITEM:Register()



langEn["iUBTaco"] = "Taco with pork"
langRu["iUBTaco"] = "Тако со свининой"
langEn["iUBTacoDesc"] = "Cool taco, inside of which there is a small piece of pork meat, as well as a huge number of all kinds of chemical spices that are very poorly tolerated by the body."
langRu["iUBTacoDesc"] = "Прохладное тако, внутри которого находится небольшой кусок свинного мяса, а так же огромное количество всевозможных химических специй, которые очень плохо переносит организм."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Taco"
ITEM.PrintName = "iUBTaco"
ITEM.description = "iUBTacoDesc"
ITEM.model = "models/props_canteen/taco.mdl"
ITEM.cost = 11
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 12
ITEM.dThirst = -1
ITEM:Register()



langEn["iUBCupoftea"] = "Cup of tea"
langRu["iUBCupoftea"] = "Кружка чая"
langEn["iUBCupofteaDesc"] = "Grayish tea, poured into a plastic mug. This mug is so badly made that you can notice the floating pieces of plastic on the surface of the tea."
langRu["iUBCupofteaDesc"] = "Сероватый чай, налитый в пластиковую кружку. Эта кружка на столько плохо сделана, что вы можете заметить плавающие куски пластмассы на поверхности чая."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Cup of tea"
ITEM.PrintName = "iUBCupoftea"
ITEM.description = "iUBCupofteaDesc"
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl"
ITEM.cost = 6
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 0
ITEM.dThirst = 8

ITEM:Register()



langEn["iUBBakedbeans"] = "Baked beans"
langRu["iUBBakedbeans"] = "Запечённые бобы"
langEn["iUBBakedbeansDesc"] = "Very suspicious light beans. I hope that I will not get irradiated if I eat them. Apparently, they were prepared in a nuclear reactor. However, they are very delicious!"
langRu["iUBBakedbeansDesc"] = "Очень подозрительные светлые бобы. Надеюсь, что я не облучусь, если съем их. По сей видимости, их готовили в ядерном реакторе. Тем не менее, они очень вкусные!"
local ITEM = ix.item.New2("base_food")
ITEM.name = "Baked beans"
ITEM.PrintName = "iUBBakedbeans"
ITEM.description = "iUBBakedbeansDesc"
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.cost = 6
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 8
ITEM.dThirst = -2
ITEM:Register()


langEn["iUBJuniper"] = "Tincture of a juniper"
langRu["iUBJuniper"] = "Настойка можжевельника"
langEn["iUBJuniperDesc"] = "Idle tincture of juniper. When you open the bottle there is a smell of quality alcohol and greens. But, the taste leaves much to be desired. The main thing - that drunk!"
langRu["iUBJuniperDesc"] = "Праздная настойка можжевельника. При открытии бутылки появляется запах качественного спирта и зелени. Но, вкус оставляет желать лучшего. Главное - что пьянит!"
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Juniper"
ITEM.PrintName = "iUBJuniper"
ITEM.description = "iUBJuniperDesc"
ITEM.model = "models/bioshockinfinite/jin_bottle.mdl"
ITEM.cost = 9
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 0
ITEM.dThirst = 10
ITEM.drunkTime = 72

ITEM.rarity = 1
ITEM:Register()



langEn["iUBBeer"] = "Bottled beer"
langRu["iUBBeer"] = "Бутылированное пиво"
langEn["iUBBeerDesc"] = "Fetid beer, rather sharp to the taste, but quite good intoxicating."
langRu["iUBBeerDesc"] = "Зловонное пиво, довольно резкое на вкус, но довольно хорошо пьянящее."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Beer"
ITEM.PrintName = "iUBBeer"
ITEM.description = "iUBBeerDesc"
ITEM.model = "models/bioshockinfinite/jin_bottle.mdl"
ITEM.cost = 10
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 0
ITEM.dThirst = 7
ITEM.drunkTime = 128

ITEM.junk = "empty_glass_bottle"
ITEM:Register()



langEn["iUBCola"] = "Bottled cola"
langRu["iUBCola"] = "Бутылированная кола"
langEn["iUBColaDesc"] = "It's pretty funny to see such a pop in a dark place like this city. But, nevertheless, this cola is even better than what was before!"
langRu["iUBColaDesc"] = "Довольно забавно видеть такую шипучку в таком тёмном месте, как этот город. Но, тем не менее, эта кола даже лучше, чем то, что было раньше!"
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Cola"
ITEM.PrintName = "iUBCola"
ITEM.description = "iUBColaDesc"
ITEM.model = "models/bioshockinfinite/dickle_jar.mdl"
ITEM.cost = 9
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 0
ITEM.dThirst = 6

ITEM.junk = "empty_glass_bottle"
ITEM:Register()



langEn["iUBSaltedring"] = "Salted ringlets"
langRu["iUBSaltedring"] = "Солёные колечки"
langEn["iUBSaltedringDesc"] = "Dry salted ringlets, they taste like they eat dry porridge. The reverse label indicates that solid particles can form in the rings. You can break your teeth."
langRu["iUBSaltedringDesc"] = "Сухие солёные колечки, вкус у них как будто бы ешь сухую кашу. Обратная этикетка указывает на то, что в колечках возможно образование твёрдых частичек. Можно сломать зубы."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Salted Ringlets"
ITEM.PrintName = "iUBSaltedring"
ITEM.description = "iUBSaltedringDesc"
ITEM.model = "models/foodnhouseholditems/applejacks.mdl"
ITEM.cost = 7
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 12
ITEM.dHunger = 4.2
ITEM.dThirst = -1.7

ITEM:Register()



langEn["iUBBaconsubstitute"] = "Bacon substitute"
langRu["iUBBaconsubstitute"] = "Заменитель бекона"
langEn["iUBBaconsubstituteDesc"] = "Has a yellowish tinge, which is why it causes mistrust. To taste - a stick of salt, but the taste of some meat is present."
langRu["iUBBaconsubstituteDesc"] = "Имеет желтоватый оттенок, из-за чего вызывает недоверие. На вкус - палочка соли, но вкус какого-то мяса присутствует."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Bacon substitute"
ITEM.PrintName = "iUBBaconsubstitute"
ITEM.description = "iUBBaconsubstituteDesc"
ITEM.model = "models/foodnhouseholditems/bacon.mdl"
ITEM.cost = 11
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 14
ITEM.dThirst = -4

ITEM:Register()



langEn["iUBCarrot"] = "Carrot"
langRu["iUBCarrot"] = "Морковь"
langEn["iUBCarrotDesc"] = "Carrots are red, looks rather wrinkled. Navrjadli from it it is possible to receive any vitamins, nevertheless it is chewed enough easily, than its present analogue."
langRu["iUBCarrotDesc"] = "Морковь красного цвета, выглядит довольно сморщеной. Наврядли из нее можно получить какие-либо витамины, тем не менее жуётся довольно легко, чем её настоящий аналог."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Carrot"
ITEM.PrintName = "iUBCarrot"
ITEM.description = "iUBCarrotDesc"
ITEM.model = "models/foodnhouseholditems/carrot.mdl"
ITEM.cost = 3
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 4
ITEM.dThirst = -1
ITEM:Register()



langEn["iUBWinewhite"] = "White wine"
langRu["iUBWinewhite"] = "Бутылка белого вина"
langEn["iUBWinewhiteDesc"] = "A bottle of white wine in a neat wrapper with a majestic Alliance sign on the labels. Very good smells of roses and peaches. The taste is quite idle. The Alliance takes care of its subjects!"
langRu["iUBWinewhiteDesc"] = "Бутылка белого вина в аккуратной обёртке с величественным знаком Альянса на этикетках. Очень хорошо пахнет розами и персиками. На вкус - довольно праздно. Альянс заботится о своих подданых!"
local ITEM = ix.item.New2("base_drink")
ITEM.name = "White wine"
ITEM.PrintName = "iUBWinewhite"
ITEM.description = "iUBWinewhiteDesc"
ITEM.model = "models/foodnhouseholditems/champagne.mdl"
ITEM.cost = 47
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 2
ITEM.dThirst = 10
ITEM.drunkTime = 256

ITEM.junk = "empty_glass_bottle"
ITEM.rarity = 4
ITEM:Register()



langEn["iUBWinered"] = "Red wine"
langRu["iUBWinered"] = "Бутылка красного вина"
langEn["iUBWineredDesc"] = "A bottle of very old wine, which was produced before the war. The opening of this bottle creates a real holiday, and the taste of this wine is like the tears of angels."
langRu["iUBWineredDesc"] = "Бутылка ну очень старого вина, которое производилось ещё до войны. Открытие этой бутылки создаёт настоящий праздник, а на вкус это вино - как слёзы ангелов."
local ITEM = ix.item.New2("base_drink")
ITEM.name = "Red wine"
ITEM.PrintName = "iUBWinered"
ITEM.description = "iUBWineredDesc"
ITEM.model = "models/foodnhouseholditems/champagne2.mdl"
ITEM.cost = 47
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 2
ITEM.dThirst = 10
ITEM.drunkTime = 200
ITEM.junk = "empty_glass_bottle"
ITEM.rarity = 4
ITEM:Register()



langEn["iUBSweetringlets"] = "Sweet ringlets"
langRu["iUBSweetringlets"] = "Сладкие колечки"
langEn["iUBSweetringletsDesc"] = "A cardboard box containing a bunch of colorful sweet rings. They taste sweet, but they are sour. It is possible, but it is better to drink this matter with milk."
langRu["iUBSweetringletsDesc"] = "Картонная коробка, содержащая в себе кучу разноцветных сладких колечек. На вкус они хоть и сладкие, но до жути кислые. Есть можно, но лучше запивать это дело молоком."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Sweet ringlets"
ITEM.PrintName = "iUBSweetringlets"
ITEM.description = "iUBSweetringletsDesc"
ITEM.model = "models/foodnhouseholditems/cheerios.mdl"
ITEM.cost = 7
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 12
ITEM.dHunger = 4.2
ITEM.dThirst = -1.7
ITEM:Register()



langEn["iUBPastrycookies"] = "Pastry cookies"
langRu["iUBSweetringlets"] = "Печенье в обёртке"
langEn["iUBPastrycookiesDesc"] = "Cookies in a beautiful wrapper with the symbols of the Alliance on the sides. It is quite fragile, you can notice already broken cookies inside. The taste is like sand, but you can get used to it."
langRu["iUBPastrycookiesDesc"] = "Печенье в красивой обёртке с символикой Альянса по бокам. Оно довольно хрупкое, можно заметить уже сломанные печеньки внутри. На вкус - как песок, но привыкнуть можно."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Pastry cookies"
ITEM.PrintName = "iUBPastrycookies"
ITEM.description = "iUBPastrycookiesDesc"
ITEM.model = "models/foodnhouseholditems/digestive.mdl"
ITEM.cost = 5
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 8
ITEM.dHunger = 3.75
ITEM.dThirst = -0.625
ITEM:Register()



langEn["iUBIcecream"] = "Ice cream"
langRu["iUBIcecream"] = "Мороженое"
langEn["iUBIcecreamDesc"] = "Chocolate ice cream, which for some reason does not want to melt in such a terrible heat as we have. The taste is really chocolate, but something is wrong with it. It's not cold!"
langRu["iUBIcecreamDesc"] = "Шоколадная мороженка, которая по каким-то причинам не хочет таять при такой ужасной жаре как у нас. На вкус - действительно шоколад, но что-то с ним не так. Оно не холодное!"
local ITEM = ix.item.New2("base_food")
ITEM.name = "Ice cream"
ITEM.PrintName = "iUBIcecream"
ITEM.description = "iUBIcecreamDesc"
ITEM.model = "models/foodnhouseholditems/icecream.mdl"
ITEM.cost = 19
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 4
ITEM.dThirst = 1

ITEM.rarity = 3
ITEM:Register()



langEn["iUBHotdog"] = "Hot-Dog"
langRu["iUBHotdog"] = "Хот-дог"
langEn["iUBHotdogDesc"] = "Literally sausage in the dough. True, the dough itself is more like sand, and the sausage is more like rubber."
langRu["iUBHotdogDesc"] = "Буквально сосиска в тесте. Правда, само тесто больше похоже на песок, а сосиска больше похожа на резину. С кетчупом пойдёт."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Hot-dog"
ITEM.PrintName = "iUBHotdog"
ITEM.description = "iUBHotdogDesc"
ITEM.model = "models/foodnhouseholditems/hotdog.mdl"
ITEM.cost = 8
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 4
ITEM.dHunger = 12.5
ITEM.dThirst = -2.5
ITEM:Register()



langEn["iUBRPepper"] = "Red Pepper"
langRu["iUBRPepper"] = "Красный перец"
langEn["iUBRPepperDesc"] = "Pretty big red pepper. Its peel has an unhealthy red color, which means that it is likely to be covered with rather dangerous chemicals. But nobody cares."
langRu["iUBRPepperDesc"] = "Довольно большой красный перец. Его кожица имеет нездоровый красный цвет, а значит, что он, скорее всего, покрыт довольно опасными химикатами. Но никого это не волнует."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Red Pepper"
ITEM.PrintName = "iUBRPepper"
ITEM.description = "iUBRPepperDesc"
ITEM.model = "models/foodnhouseholditems/pepper1.mdl"
ITEM.cost = 1
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 1
ITEM.dHunger = 5
ITEM.dThirst = 0
ITEM:Register()



langEn["iUBPickles"] = "Bottle with pickles"
langRu["iUBPickles"] = "Банка с соленьями"
langEn["iUBPicklesDesc"] = "A small bottle with a bunch of different pickles inside. The water inside is rather viscous, and the pickles are very difficult to chew. But, nevertheless, they are very tasty!"
langRu["iUBPicklesDesc"] = "Небольшая банка с кучей разных солений внутри. Вода внутри довольно вязкая, а соленья очень трудно жуются. Но, тем не менее, они очень вкусные!"
local ITEM = ix.item.New2("base_food")
ITEM.name = "Pickles"
ITEM.PrintName = "iUBPickles"
ITEM.description = "iUBPicklesDesc"
ITEM.model = "models/foodnhouseholditems/picklejar.mdl"
ITEM.cost = 6
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 8
ITEM.dHunger = 5
ITEM.dThirst = -2.5

ITEM.rarity = 1
ITEM:Register()


langRu["iUBBagel"] = "Рогалик"
langEn["iUBBagel"] = "Bagel"
langEn["iUBBagelDesc"] = "Bagel, consisting of a quality test and sprinkled with fragrant spices. Sweet before death!"
langRu["iUBBagelDesc"] = "Рогалик, состоящий из качественного теста и посыпанный душистыми специями. До смерти сладкий!"
local ITEM = ix.item.New2("base_food")
ITEM.name = "Bagel"
ITEM.PrintName = "iUBBagel"
ITEM.description = "iUBBagelDesc"
ITEM.model = "models/foodnhouseholditems/pretzel.mdl"
ITEM.cost = 6
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 3
ITEM.dHunger = 10
ITEM.dThirst = 0
ITEM:Register()



langEn["iUBSandwich"] = "Sandwich"
langRu["iUBSandwich"] = "Сэндвич"
langEn["iUBSandwichDesc"] = "Ready-to-eat sandwich. It consists of stale bread, dubious meat and dull greenery. What else is needed for happiness?"
langRu["iUBSandwichDesc"] = "Готовый к употреблению сэндвич. Он состоит из чёрствого хлеба, сомнительного мяса и затухшей зелени. Что ещё нужно для счастья?"
local ITEM = ix.item.New2("base_food")
ITEM.name = "Sandwich"
ITEM.PrintName = "iUBSandwich"
ITEM.description = "iUBSandwichDesc"
ITEM.model = "models/foodnhouseholditems/sandwich.mdl"
ITEM.cost = 6
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 16
ITEM.dThirst = -2
ITEM:Register()



langEn["iUBBurger"] = "Burger"
langRu["iUBBurger"] = "Бургер"
langEn["iUBBurgerDesc"] = "The burger glued from different parts reminds of old times. It is a pity that since then, the rest is only the bitterness of chemicals."
langRu["iUBBurgerDesc"] = "Склеяный из разных частей бургер напоминает о былых временах. Жаль, что с тех времен осталась только горечь химикатов."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Burger"
ITEM.PrintName = "iUBBurger"
ITEM.description = "iUBBurgerDesc"
ITEM.model = "models/foodnhouseholditems/mcdburger.mdl"
ITEM.cost = 22
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 20
ITEM.dThirst = -3

ITEM.rarity = 1
ITEM:Register()



langEn["iUBKetp"] = "Ketchup"
langRu["iUBKetp"] = "Кетчуп"
langEn["iUBKetpDesc"] = "Red viscous liquid in a transparent jar. The label says it's ketchup, but it tastes like more of a fused rusty metal."
langRu["iUBKetpDesc"] = "Красная вязкая жидкость в прозрачной баночке. Этикетка гласит, что это кетчуп, но на вкус похоже больше на плавленый ржавый металл."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Ketchup"
ITEM.PrintName = "iUBKetp"
ITEM.description = "iUBKetpDesc"
ITEM.model = "models/foodnhouseholditems/ketchup.mdl"
ITEM.cost = 2
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 5
ITEM.dHunger = 8
ITEM.dThirst = -8

ITEM:Register()




langEn["iUBWalnut"] = "Walnut Pie"
langRu["iUBWalnut"] = "Ореховый пирог"
langEn["iUBWalnutDesc"] = "A fresh pie, from which gives off a fragrance from a long time, when we all peed in our pants. It was a year ago."
langRu["iUBWalnutDesc"] = "Свежий пирог, от которого отдает ароматом из далёких времён, когда мы все мочились в штаны. Это было год назад."
local ITEM = ix.item.New2("base_food")
ITEM.name = "Walnut Pie"
ITEM.PrintName = "iUBWalnut"
ITEM.description = "iUBWalnutDesc"
ITEM.model = "models/foodnhouseholditems/pie.mdl"
ITEM.cost = 36
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 10
ITEM.dHunger = 12
ITEM.dThirst = 0

ITEM.rarity = 2
ITEM:Register()

ix.lang.AddTable("russian", langRu)
ix.lang.AddTable("english", langEn)