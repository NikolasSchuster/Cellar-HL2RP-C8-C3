local PLUGIN = PLUGIN

PLUGIN.name = "Food and Drinks"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = "Adds a hunger and thirst with various useable items."

ix.lang.AddTable("english", {
	useDrink = "Drink",
	useDrinkAll = "Drink All",
	useFood = "Consume",
	useFoodAll = "Consume All",
	categoryFood = "Food",
	categoryDrink = "Drink",
	categoryJunk = "Junk",
	usesDesc = "Uses: %s/%s",
	foodNotify = "I have eaten %s.",
	drinkNotify = "I have drunk %s.",
	barThirst = "THIRST",
	barHunger = "HUNGER"
})

ix.lang.AddTable("russian", {
	useDrink = "Выпить",
	useDrinkAll = "Выпить всё",
	useFood = "Съесть",
	useFoodAll = "Съесть всё",
	categoryFood = "Еда",
	categoryDrink = "Напитки",
	categoryJunk = "Мусор",
	usesDesc = "Использований: %s/%s",
	foodNotify = "Вы съели %s.",
	drinkNotify = "Вы выпили %s.",
	barThirst = "ЖАЖДА",
	barHunger = "ГОЛОД"
})

ix.char.RegisterVar("thirst", {
	field = "thirst",
	fieldType = ix.type.number,
	default = 100,
	isLocal = true,
	bNoDisplay = true
})

ix.char.RegisterVar("hunger", {
	field = "hunger",
	fieldType = ix.type.number,
	default = 100,
	isLocal = true,
	bNoDisplay = true
})

ix.util.Include("sh_commands.lua")
ix.util.Include("sh_config.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")

-- refrigerator functionality
ix.util.Include("sv_plugin.lua")
