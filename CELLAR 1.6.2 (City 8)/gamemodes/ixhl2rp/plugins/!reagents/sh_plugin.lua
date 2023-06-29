local PLUGIN = PLUGIN

PLUGIN.name = "Reagents"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

ix.util.Include("meta/sh_reagents.lua")

Schema.reagents:New("absinthe", "Абсент", Color(10, 206, 0))
Schema.reagents:New("ale", "Эль", Color(102, 67, 0))
Schema.reagents:New("jaloe", "Алоевый сок", Color(163, 196, 139))
Schema.reagents:New("japple", "Яблочный сок", Color(236, 255, 86))
Schema.reagents:New("jbanana", "Банановый сок", Color(175, 175, 0))
Schema.reagents:New("beer", "Пиво", Color(102, 67, 0))
Schema.reagents:New("jberry", "Ягодный сок", Color(134, 51, 51))
Schema.reagents:New("jcarrot", "Морковный сок", Color(151, 56, 0))
Schema.reagents:New("champ", "Шампанское", Color(255, 255, 193))
Schema.reagents:New("coffee", "Кофе", Color(72, 32, 0))
Schema.reagents:New("cognac", "Коньяк", Color(171, 60, 5))
Schema.reagents:New("ccocon", "Кокосовый крем", Color(247, 240, 208))
Schema.reagents:New("cmenthe", "Мятный крем", Color(0, 204, 0))
Schema.reagents:New("ccacao", "Какао крем", Color(153, 102, 51))
Schema.reagents:New("gin", "Джин", Color(102, 67, 0))
Schema.reagents:New("jgranat", "Гранатовый сироп", Color(234, 29, 38))
Schema.reagents:New("cider", "Крепкий сидр", Color(205, 104, 57))
Schema.reagents:New("jlemon", "Лимоновый сок", Color(175, 175, 0))
Schema.reagents:New("lemlim", "Лимон-Лайм", Color(135, 255, 0))
Schema.reagents:New("jlime", "Сок лайма", Color(54, 94, 48))
Schema.reagents:New("milk", "Молоко", Color(223, 223, 223))
Schema.reagents:New("cream", "Сливки", Color(223, 215, 175))
Schema.reagents:New("jorange", "Апельсиновый сок", Color(231, 129, 8))
Schema.reagents:New("jpeach", "Персиковый сок", Color(231, 129, 8))
Schema.reagents:New("jpine", "Ананасовый сок", Color(247, 212, 53))
Schema.reagents:New("rum", "Ром", Color(102, 67, 0))
Schema.reagents:New("sake", "Сакэ", Color(221, 221, 221))
Schema.reagents:New("soda", "Содовая", Color(97, 148, 148))
Schema.reagents:New("cola", "Кола", Color(16, 8, 0))
Schema.reagents:New("kahlua", "Кофейный ликёр", Color(102, 67, 0))
Schema.reagents:New("tripsec", "Апельсин. ликёр", Color(255, 204, 102))
Schema.reagents:New("tea", "Чай", Color(16, 16, 0))
Schema.reagents:New("tequil", "Текила", Color(255, 255, 145))
Schema.reagents:New("jtomat", "Томатный сок", Color(115, 16, 8))
Schema.reagents:New("tonic", "Тоник", Color(0, 100, 200))
Schema.reagents:New("vermout", "Вермут", Color(145, 255, 145))
Schema.reagents:New("vodka", "Водка", Color(0, 100, 200))
Schema.reagents:New("water", "Вода", Color(70, 70, 70))
Schema.reagents:New("jmelon", "Арбузный сок", Color(134, 51, 51))
Schema.reagents:New("whiski", "Виски", Color(102, 67, 0))
Schema.reagents:New("wine", "Вино", Color(126, 64, 67))
Schema.reagents:New("ice", "Лёд", true)
Schema.reagents:New("sugar", "Сахар", true)
Schema.reagents:New("gold", "Золотая пыль", true)
Schema.reagents:New("silver", "Серебряная пыль", true)

Schema.reagents:New("irishcream", "Ирландские сливки", Color(102, 67, 0))
Schema.reagents:New("armstrong", "Коктейль \"Армстронг\"", Color(196, 196, 100))
Schema.reagents:New("andalusia", "Коктейль \"Андалузия\"", Color(102, 67, 0))
Schema.reagents:New("antifreeze", "Коктейль \"Антифриз\"", Color(0, 255, 255))
Schema.reagents:New("bacardi", "Коктейль \"Бакарди\"", Color(238, 50, 34))
Schema.reagents:New("b52", "Коктейль \"B-52\"", Color(102, 67, 0))
Schema.reagents:New("bahama_mama", "Коктейль \"Багама Мама\"", Color(255, 127, 59))
Schema.reagents:New("bananadai", "Коктейль \"Банановый Дайкири\"", Color(240, 243, 149))
Schema.reagents:New("barefoot", "Коктейль \"Barefoot\"", Color(255, 93, 182))
Schema.reagents:New("blackrus", "Коктейль \"Black Russian\"", Color(0, 0, 0))
Schema.reagents:New("bloodymary", "Коктейль \"Кровавая Мэри\"", Color(199, 126, 139))
Schema.reagents:New("bravebull", "Коктейль \"Храбрый Бык\"", Color(164, 157, 149))
Schema.reagents:New("martini", "Классический Мартини", Color(145, 255, 145))
Schema.reagents:New("commodore", "Коктейль \"Розовая Леди\"", Color(167, 76, 59))
Schema.reagents:New("chacha", "Напиток \"Чача\"", Color(205, 205, 136))
Schema.reagents:New("deathresur", "Коктейль \"Оживляющий Мертвеца\"", Color(91, 229, 128))
Schema.reagents:New("cubalibre", "Коктейль \"Cuba Libre\"", Color(62, 27, 0))
Schema.reagents:New("deathafter", "Коктейль \"Смерть После Полудня\"", Color(69, 202, 122))
Schema.reagents:New("erikasurpr", "Коктейль \"Сюрприз Эрики\"", Color(90, 177, 67))
Schema.reagents:New("martiniespre", "Эспрессо Мартини", Color(57, 42, 35))
Schema.reagents:New("ginfizz", "Шипучий Джин", Color(255, 255, 111))
Schema.reagents:New("gintonic", "Напиток \"Джин Тоник\"", Color(196, 196, 174))
Schema.reagents:New("glintwane", "Коктейль \"Глинтвейн\"", Color(190, 70, 0))
Schema.reagents:New("goldschlag", "Коктейль \"Гольдшлягер\"", Color(255, 205, 58))
Schema.reagents:New("grog", "Напиток \"Грог\"", Color(201, 205, 0))
Schema.reagents:New("icedbeer", "Охлажденное пиво", Color(201, 194, 82))
Schema.reagents:New("icedcoffe", "Охлажденный кофе", Color(159, 163, 128))
Schema.reagents:New("icedtea", "Охлажденный чай", Color(213, 170, 74))
Schema.reagents:New("irishcoffee", "Ирландский кофе", Color(120, 89, 39))
Schema.reagents:New("lemonade", "Лимонад", Color(255, 255, 78))
Schema.reagents:New("islanditea", "Коктейль \"Long Island Iced Tea\"", Color(255, 123, 0))
Schema.reagents:New("manhattan", "Коктейль \"Манхеттэн\"", Color(228, 16, 78))
Schema.reagents:New("margarita", "Коктейль \"Маргарита\"", Color(200, 255, 145))
Schema.reagents:New("milkshake", "Коктейль \"Милкшейк\"", Color(225, 150, 174))
Schema.reagents:New("mohito", "Напиток \"Мохито\"", Color(132, 198, 116))
Schema.reagents:New("patron", "Коктейль \"Патрон\"", Color(205, 201, 155))
Schema.reagents:New("screwdriver", "Коктейль \"Отвертка\"", Color(218, 179, 145))
Schema.reagents:New("sexbeach", "Коктейль \"Секс На Пляже\"", Color(255, 100, 0))
Schema.reagents:New("tequilsun", "Коктейль \"Текила Санрайз\"", Color(255, 190, 0))
Schema.reagents:New("wesper", "Напиток \"Веспер\"", Color(240, 221, 174))
Schema.reagents:New("martinivodka", "Водка-мартини", Color(190, 255, 190))
Schema.reagents:New("vodkatonic", "Водка с тоником", Color(196, 196, 174))
Schema.reagents:New("whiskicola", "Коктейль \"Виски с колой\"", Color(145, 116, 103))
Schema.reagents:New("whiskisoda", "Коктейль \"Виски с содовой\"", Color(255, 179, 51))
Schema.reagents:New("whiterus", "Коктейль \"White Russian\"", Color(180, 182, 168))
Schema.reagents:New("zhenghe", "Коктейль \"Чжэн Хэ\"", Color(64, 81, 35))

Schema.reagents:AddReaction("irishcream", {
	[1] = {
		["irishcream"] = 3,
	},
	[2] = {
		["whiski"] = 2,
		["cream"] = 1
	}
})
Schema.reagents:AddReaction("armstrong", {
	[1] = {
		["armstrong"] = 4,
	},
	[2] = {
		["beer"] = 2,
		["vodka"] = 1,
		["jlime"] = 1
	}
})
Schema.reagents:AddReaction("andalusia", {
	[1] = {
		["andalusia"] = 3,
	},
	[2] = {
		["rum"] = 1,
		["whiski"] = 1,
		["jlemon"] = 1
	}
})
Schema.reagents:AddReaction("antifreeze", {
	[1] = {
		["antifreeze"] = 4,
	},
	[2] = {
		["vodka"] = 2,
		["ice"] = 1,
		["cream"] = 1
	}
})
Schema.reagents:AddReaction("bacardi", {
	[1] = {
		["bacardi"] = 4,
	},
	[2] = {
		["rum"] = 2,
		["jlime"] = 1,
		["jgranat"] = 1
	}
})
Schema.reagents:AddReaction("b52", {
	[1] = {
		["b52"] = 3,
	},
	[2] = {
		["irishcream"] = 1,
		["kahlua"] = 1,
		["cognac"] = 1
	}
})
Schema.reagents:AddReaction("bahama_mama", {
	[1] = {
		["bahama_mama"] = 4,
	},
	[2] = {
		["rum"] = 2,
		["jorange"] = 2,
		["jlime"] = 1,
		["ice"] = 1,
	}
})
Schema.reagents:AddReaction("bananadai", {
	[1] = {
		["bananadai"] = 8,
	},
	[2] = {
		["jbanana"] = 3,
		["ice"] = 2,
		["jlime"] = 1,
		["rum"] = 2,
	}
})
Schema.reagents:AddReaction("barefoot", {
	[1] = {
		["barefoot"] = 3,
	},
	[2] = {
		["cream"] = 1,
		["vermout"] = 1,
		["jberry"] = 1,
	}
})
Schema.reagents:AddReaction("blackrus", {
	[1] = {
		["blackrus"] = 3,
	},
	[2] = {
		["vodka"] = 2,
		["kahlua"] = 1,
	}
})
Schema.reagents:AddReaction("bloodymary", {
	[1] = {
		["bloodymary"] = 6,
	},
	[2] = {
		["vodka"] = 2,
		["jtomat"] = 3,
		["jlime"] = 1,
	}
})
Schema.reagents:AddReaction("bravebull", {
	[1] = {
		["bravebull"] = 3,
	},
	[2] = {
		["tequil"] = 2,
		["kahlua"] = 1,
	}
})
Schema.reagents:AddReaction("martini", {
	[1] = {
		["martini"] = 3,
	},
	[2] = {
		["gin"] = 2,
		["vermout"] = 1,
	}
})
Schema.reagents:AddReaction("commodore", {
	[1] = {
		["commodore"] = 5,
	},
	[2] = {
		["whiski"] = 2,
		["jlemon"] = 1,
		["jorange"] = 1,
		["jgranat"] = 1,
	}
})
Schema.reagents:AddReaction("chacha", {
	[1] = {
		["chacha"] = 5,
	},
	[2] = {
		["vodka"] = 3,
		["jberry"] = 2,
	}
})
Schema.reagents:AddReaction("deathresur", {
	[1] = {
		["deathresur"] = 10,
	},
	[2] = {
		["gin"] = 3,
		["wine"] = 3,
		["jorange"] = 2,
		["jlemon"] = 2,
	}
})
Schema.reagents:AddReaction("cubalibre", {
	[1] = {
		["cubalibre"] = 3,
	},
	[2] = {
		["rum"] = 2,
		["cola"] = 1,
	}
})
Schema.reagents:AddReaction("deathafter", {
	[1] = {
		["deathafter"] = 6,
	},
	[2] = {
		["wine"] = 4,
		["absinthe"] = 2,
	}
})
Schema.reagents:AddReaction("erikasurpr", {
	[1] = {
		["erikasurpr"] = 6,
	},
	[2] = {
		["ale"] = 2,
		["jlime"] = 1,
		["whiski"] = 1,
		["ice"] = 1,
		["jbanana"] = 1,
	}
})
Schema.reagents:AddReaction("martiniespre", {
	[1] = {
		["martiniespre"] = 5,
	},
	[2] = {
		["blackrus"] = 3,
		["coffee"] = 1,
		["sugar"] = 1
	}
})
Schema.reagents:AddReaction("ginfizz", {
	[1] = {
		["ginfizz"] = 3,
	},
	[2] = {
		["gin"] = 1,
		["soda"] = 1,
		["jlime"] = 1
	}
})
Schema.reagents:AddReaction("gintonic", {
	[1] = {
		["gintonic"] = 3,
	},
	[2] = {
		["gin"] = 2,
		["tonic"] = 1
	}
})
Schema.reagents:AddReaction("glintwane", {
	[1] = {
		["glintwane"] = 7,
	},
	[2] = {
		["wine"] = 3,
		["jorange"] = 2,
		["sugar"] = 2,
	}
})
Schema.reagents:AddReaction("goldschlag", {
	[1] = {
		["goldschlag"] = 10,
	},
	[2] = {
		["vodka"] = 10,
		["gold"] = 1,
	}
})
Schema.reagents:AddReaction("grog", {
	[1] = {
		["grog"] = 2,
	},
	[2] = {
		["water"] = 1,
		["rum"] = 1,
	}
})
Schema.reagents:AddReaction("icedbeer", {
	[1] = {
		["icedbeer"] = 6,
	},
	[2] = {
		["beer"] = 5,
		["ice"] = 1,
	}
})
Schema.reagents:AddReaction("icedcoffe", {
	[1] = {
		["icedcoffe"] = 3,
	},
	[2] = {
		["coffee"] = 2,
		["ice"] = 1,
	}
})
Schema.reagents:AddReaction("icedtea", {
	[1] = {
		["icedtea"] = 3,
	},
	[2] = {
		["tea"] = 2,
		["ice"] = 1,
	}
})
Schema.reagents:AddReaction("irishcoffee", {
	[1] = {
		["irishcoffee"] = 3,
	},
	[2] = {
		["irishcream"] = 2,
		["coffe"] = 1,
	}
})
Schema.reagents:AddReaction("lemonade", {
	[1] = {
		["lemonade"] = 3,
	},
	[2] = {
		["water"] = 1,
		["jlemon"] = 1,
		["sugar"] = 1,
	}
})
Schema.reagents:AddReaction("islanditea", {
	[1] = {
		["islanditea"] = 6,
	},
	[2] = {
		["vodka"] = 1,
		["gin"] = 1,
		["cubalibre"] = 3,
		["tequil"] = 1,
	}
})
Schema.reagents:AddReaction("manhattan", {
	[1] = {
		["manhattan"] = 3,
	},
	[2] = {
		["whiski"] = 2,
		["vermout"] = 1
	}
})
Schema.reagents:AddReaction("margarita", {
	[1] = {
		["margarita"] = 3,
	},
	[2] = {
		["tequil"] = 2,
		["jlime"] = 1
	}
})
Schema.reagents:AddReaction("milkshake", {
	[1] = {
		["milkshake"] = 5,
	},
	[2] = {
		["milk"] = 2,
		["cream"] = 1,
		["ice"] = 2,
	}
})
Schema.reagents:AddReaction("mohito", {
	[1] = {
		["mohito"] = 5,
	},
	[2] = {
		["rum"] = 1,
		["jlime"] = 1,
		["soda"] = 2,
		["sugar"] = 1,
	}
})
Schema.reagents:AddReaction("patron", {
	[1] = {
		["patron"] = 10,
	},
	[2] = {
		["vodka"] = 10,
		["silver"] = 1
	}
})
Schema.reagents:AddReaction("screwdriver", {
	[1] = {
		["screwdriver"] = 3,
	},
	[2] = {
		["vodka"] = 2,
		["jorange"] = 1
	}
})
Schema.reagents:AddReaction("sexbeach", {
	[1] = {
		["sexbeach"] = 5,
	},
	[2] = {
		["vodka"] = 2,
		["jlemon"] = 2,
		["tripsec"] = 1
	}
})
Schema.reagents:AddReaction("tequilsun", {
	[1] = {
		["tequilsun"] = 3,
	},
	[2] = {
		["tequil"] = 2,
		["jorange"] = 1
	}
})
Schema.reagents:AddReaction("wesper", {
	[1] = {
		["wesper"] = 5,
	},
	[2] = {
		["gin"] = 3,
		["vodka"] = 1,
		["wine"] = 1
	}
})
Schema.reagents:AddReaction("martinivodka", {
	[1] = {
		["martinivodka"] = 3,
	},
	[2] = {
		["vodka"] = 2,
		["vermout"] = 1
	}
})
Schema.reagents:AddReaction("vodkatonic", {
	[1] = {
		["vodkatonic"] = 3,
	},
	[2] = {
		["vodka"] = 2,
		["tonic"] = 1
	}
})
Schema.reagents:AddReaction("whiskicola", {
	[1] = {
		["whiskicola"] = 3,
	},
	[2] = {
		["whiski"] = 2,
		["cola"] = 1
	}
})
Schema.reagents:AddReaction("whiskisoda", {
	[1] = {
		["whiskisoda"] = 3,
	},
	[2] = {
		["whiski"] = 2,
		["soda"] = 1
	}
})
Schema.reagents:AddReaction("whiterus", {
	[1] = {
		["whiterus"] = 3,
	},
	[2] = {
		["blackrus"] = 2,
		["cream"] = 1
	}
})
Schema.reagents:AddReaction("zhenghe", {
	[1] = {
		["zhenghe"] = 3,
	},
	[2] = {
		["tea"] = 2,
		["vermout"] = 1
	}
})
