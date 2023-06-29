local PLUGIN = PLUGIN

PLUGIN.name = "Basic Level System"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

PLUGIN.maxLevel = 10

ix.char.RegisterVar("level", {
	field = "level",
	fieldType = ix.type.number,
	default = 1,
	isLocal = false,
	bNoDisplay = true
})

ix.char.RegisterVar("levelXP", {
	field = "levelXP",
	fieldType = ix.type.number,
	default = 0,
	isLocal = true,
	bNoDisplay = true
})

ix.chat.Register("level", {
	OnCanHear = function(self, speaker, listener)
		return true
	end,
	CanSay = function(self, speaker)
		return !IsValid(speaker)
	end,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		if data.t == 1 then
			chat.AddText(color_white, string.format("Ваш уровень повышен до %s! Введите /lvl, чтобы распределить новые очки.", LocalPlayer():GetCharacter():GetLevel()))
		elseif data.t == 2 then
			local name = L((ix.skills.list[data.skill] or {}).name) or "Unknown"

			chat.AddText(color_white, string.format("Ваш навык %s повышен до %s!", name, data.value))
		elseif data.t == 3 then
			chat.AddText(color_white, string.format("Ваш уровень понижен до %s!", LocalPlayer():GetCharacter():GetLevel()))
		elseif data.t == 4 then
			local name = L((ix.skills.list[data.skill] or {}).name) or "Unknown"

			chat.AddText(color_white, string.format("Ваш навык %s понижен до %s!", name, data.value))
		end
	end
})

function PLUGIN:GetRequiredLevelXP(currentLevel)
	return 50 * (currentLevel - 1) ^ 2.25 + (75 + (currentLevel * 25))
end

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("Roll", {
	description = "@cmdRoll",
	OnRun = function(self, client, maximum)
		local rolls = client:GetCharacter():GetRolls()
		local value = math.random(rolls[1], rolls[2])

		ix.chat.Send(client, "roll", tostring(value), nil, nil, {
			max = rolls[2]
		})

		ix.log.Add(client, "roll", value, rolls[2])
	end
})

ix.command.Add("CharSetLevel", {
	description = "",
	privilege = "Manage Character Levels",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client, target, targetValue)
		local lastLVL = target:GetLevel()
		targetValue = math.Clamp(targetValue, 1, PLUGIN.maxLevel)

		target:SetLevel(targetValue)

		if targetValue > lastLVL then
			target:SetData("levelup", true)
			ix.chat.Send(nil, "level", "", nil, {target:GetPlayer()}, {
				t = 1,
			})
		else
			ix.chat.Send(nil, "level", "", nil, {target:GetPlayer()}, {
				t = 3,
			})
		end

		return "Вы успешно изменили уровень персонажа."
	end
})

ix.command.Add("CharAddLevel", {
	description = "",
	privilege = "Manage Character Levels",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client, target, targetValue)
		local lastLVL = target:GetLevel()
		targetValue = math.Clamp(lastLVL + targetValue, 1, PLUGIN.maxLevel)

		target:SetLevel(targetValue)

		if targetValue > lastLVL then
			target:SetData("levelup", true)
			ix.chat.Send(nil, "level", "", nil, {target:GetPlayer()}, {
				t = 1,
			})
		else
			ix.chat.Send(nil, "level", "", nil, {target:GetPlayer()}, {
				t = 3,
			})
		end

		return "Вы успешно добавили уровни персонажу."
	end
})

ix.command.Add("CharAddLevelXP", {
	description = "",
	privilege = "Manage Character Levels",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client, target, xp)
		target:AddLevelXP(xp)

		return "Вы успешно добавили опыт персонажу."
	end
})