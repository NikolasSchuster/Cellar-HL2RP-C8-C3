local PLUGIN = PLUGIN

PLUGIN.name = "Jobs"
PLUGIN.author = "SchwarzKruppzo, maxxoft"
PLUGIN.desc = "Adds a job system."


ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")


ix.option.Add("drawTools", ix.type.bool, false, {
	hidden = function()
		return LocalPlayer():IsAdmin()
	end
})
--[[
ix.dialogues.Add("mark_pootis", {
	["GREETINGS"] = {
		response = "Привет. Чем могу быть полезен?",
		choices = {
			"GarbageWorkDone",
			"WaterWorkDone",
			"ToolsWorkDone",
			"CWUWork",
			"WhereIam",
			"CWUSetup",
			"GOODBYE"
		}
	},
	["OKAY_NO_WORK"] = {
		response = "Ладно.",
		topic = {
			[1] = {
				text = "Я передумала.",
				gender = GENDER_FEMALE
			},
			[2] = {
				text = "Я передумал, извини.",
				gender = GENDER_MALE
			},
		},
		choices = {"CWUWork", "WhereIam", "CWUSetup", "GOODBYE"}
	},
	["NoWork"] = {
		response = "Сегодня у меня работы для тебя нет. Обратись в другой раз.",
		topic = {
			[1] = {
				text = "Привет. Я бы хотела взять работу в вашем офисе.",
				gender = GENDER_FEMALE
			},
			[2] = {
				text = "Привет. Я бы хотел взять работу в вашем офисе.",
				gender = GENDER_MALE
			},
		},
	},
	["CWUWork"] = {
		response = {
			[1] = {
				condition = function(client, npc, self)
					local gender = client:GetCharacter():GetGender()

					if self.data.haswork then
						return gender == GENDER_MALE and "Ты уже брал работу. Для начала выполни ее, а потом уже обращайся." or "Ты уже брала работу. Для начала выполни ее, а потом уже обращайся."
					elseif self.data.workcooldown and os.time() < self.data.workcooldown then
						return gender == GENDER_MALE and "Извини. Для тебя лимиты пока что превышены, так что приходи чуть позже." or "Извини. Для тебя лимиты пока что превышены, так что приходи чуть позже."
					end

					return "Ну, по другому вопросу ко мне, обычно, и не обращаются. Чем хочешь заняться сегодня?"
				end
			}
		},
		topic = {
			[1] = {
				text = "Привет. Я бы хотела взять работу в вашем офисе.",
				gender = GENDER_FEMALE
			},
			[2] = {
				text = "Привет. Я бы хотел взять работу в вашем офисе.",
				gender = GENDER_MALE
			},
		},
		choices = function(client, npc, dialogue)
			local choices = {}

			if (!dialogue.data.workcooldown or (dialogue.data.workcooldown and os.time() > dialogue.data.workcooldown)) and !dialogue.data.haswork then
				choices = {
					--{label = "Влажная уборка.", work = 1, topic = "GET_WORK1"},
					{label = "Уборка мусора в городе.", work = 2},
					--{label = "Разнос корреспонденции.", topic = "GET_WORK3"},
					{label = "Замена картриджей автоматов с водой.", work = 4},
					{label = "Поиск инструментов.", work = 5},
					{label = "Я передумал, извини.", topic = "OKAY_NO_WORK"}
				}
			else
				choices = {
					{label = "...", topic = "OKAY_NO_WORK"}
				}
			end

			return choices
		end,
		choose = function(choice, client, npc, dialogue)
			local character = client:GetCharacter()

			if choice.work == 2 then
				if SERVER then
					local quests = character:GetData("quests", {})
					quests["cwu_garbage"] = true
					character:SetData("cwuGarbage", 0)
					character:SetData("quests", quests)
					net.Start("ixUpdateQuests")
					net.Send(client)
				end

				dialogue.data.haswork = true

				return "GarbageWork"

			elseif choice.work == 4 then
				if SERVER then
					local quests = character:GetData("quests", {})
					quests["cwu_water"] = os.time()
					character:SetData("cwuWater", 0)
					character:SetData("quests", quests)
					net.Start("ixUpdateQuests")
					net.Send(client)
				end

				dialogue.data.haswork = true

				return "WaterWork"

			elseif choice.work == 5 then
				if SERVER then
					local quests = character:GetData("quests", {})
					quests["cwu_tools"] = true
					character:SetData("cwuTools", 0)
					character:SetData("quests", quests)
					net.Start("ixUpdateQuests")
					net.Send(client)
				end

				dialogue.data.haswork = true

				return "ToolsWork"
			end

			return choice.topic and choice.topic or "OKAY_NO_WORK"
		end,
		flags = DFLAG_DYNAMIC
	},
	["GarbageWorkDone"] = {
		response = {
			[1] = {
				text = {
					"Неплохо, такие работники мне нравятся! Вот, твои десять токенов за работу.",
					"Хорошая работа. Вот твоя награда.",
					"Достойная плата за достойную работу.",
				},
			},
		},
		topic = {
			[1] = {
				text = "Я собрала мусор, который только смогла найти.",
				gender = GENDER_FEMALE
			},
			[2] = {
				text = "Я собрал мусор, который только смог найти.",
				gender = GENDER_MALE
			},
		},
		select = function(client, npc, self)
			local character = client:GetCharacter()
			if SERVER then
				local quests = character:GetData("quests", {})
				quests["cwu_garbage"] = nil

				character:SetData("quests", quests)
				character:SetMoney(character:GetMoney() + 10)
				net.Start("ixUpdateQuests")
				net.Send(client)

				client:NotifyLocalized("Вы получили 10 токенов.")
			end

			self.data.haswork = false
			self.data.workcooldown = os.time() + 14400
		end,
		condition = function(client, npc, self)
			local character = client:GetCharacter()

			return self.data.haswork and character:GetData("quests", {})["cwu_garbage"] and character:GetData("cwuGarbage", 0) == 4
		end
	},
	["GarbageWork"] = {
		data = {
			haswork = true,
		},
		response = "Бери перчатки, пакет и шуруй на улицу. Уберешь 4 кучи, которых тут довольно много, после чего можешь возвращаться. И не смей мухлевать - мы следим.",
		choices = {"GOODBYE"}
	},
	["WaterWork"] = {
		data = {
			haswork = true,
		},
		response = "Вот тебе картриджи. Пополни три городских автомата с водой и возвращайся за наградой.",
		choices = {"GOODBYE"}
	},
	["WaterWorkDone"] = {
		response = {
			[1] = {
				text = {
					"Неплохо, такие работники мне нравятся! Вот, твои десять токенов за работу.",
					"Хорошая работа. Вот твоя награда.",
					"Достойная плата за достойную работу.",
				},
			},
		},
		topic = {
			[1] = {
				text = "Я пополнила автоматы с водой.",
				gender = GENDER_FEMALE
			},
			[2] = {
				text = "Я пополнил автоматы с водой.",
				gender = GENDER_MALE
			},
		},
		select = function(client, npc, self)
			local character = client:GetCharacter()
			if SERVER then
				local quests = character:GetData("quests", {})
				quests["cwu_water"] = nil

				character:SetData("quests", quests)
				character:SetMoney(character:GetMoney() + 10)
				net.Start("ixUpdateQuests")
				net.Send(client)

				client:NotifyLocalized("Вы получили 10 токенов.")
			end

			self.data.haswork = false
			self.data.workcooldown = os.time() + 14400
		end,
		condition = function(client, npc, self)
			local character = client:GetCharacter()

			return self.data.haswork and character:GetData("quests", {})["cwu_water"] and character:GetData("cwuWater", 0) == 3
		end
	},
	["ToolsWork"] = {
		data = {
			haswork = true,
		},
		response = "Есть информация, что по городу разбросано немало инструментов после некоторых событий. Лишними они не будут, так что если сможешь найти штук пять, то приноси.",
		choices = {"GOODBYE"}
	},
	["ToolsWorkDone"] = {
		response = {
			[1] = {
				text = {
					"Неплохо, такие работники мне нравятся! Вот, твои десять токенов за работу.",
					"Хорошая работа. Вот твоя награда.",
					"Достойная плата за достойную работу.",
				},
			},
		},
		topic = {
			[1] = {
				text = "Я собрала инструменты.",
				gender = GENDER_FEMALE
			},
			[2] = {
				text = "Я собрал инструменты.",
				gender = GENDER_MALE
			}
		},
		select = function(client, npc, self)
			local character = client:GetCharacter()
			if SERVER then
				local quests = character:GetData("quests", {})
				quests["cwu_tools"] = nil

				character:SetData("quests", quests)
				character:SetMoney(character:GetMoney() + 10)
				net.Start("ixUpdateQuests")
				net.Send(client)

				client:NotifyLocalized("Вы получили 10 токенов.")
			end

			self.data.haswork = false
			self.data.workcooldown = os.time() + 14400
		end,
		condition = function(client, npc, self)
			local character = client:GetCharacter()

			return self.data.haswork and character:GetData("quests", {})["cwu_tools"] and character:GetData("cwuTools", 0) >= 5
		end
	},
	["WhereIam"] = {
		response = "Ты находишься в офисе Гражданского Союза Рабочих. Тут, обычно, люди получают разную работу - подай и принеси, ну или устраиваются на более престижные должности на завод, например. Если тебе интересно узнать подробнее - поймай другого сотрудника, который не будет так занят, как я. Они помогут тебе.",
		topic = "Где я нахожусь?",
	},
	["CWUSetup"] = {
		response = "Тебе нужно обратиться к нашему начальнику. Обычно, он тут довольно часто появляется и он носит на себе престижный костюм. Если же его нет рядом, то обратись к кому-то, кто не сидит со мной за одним столом. Увы, заняться твоим вопросом самостоятельно я не смогу.",
		topic = "Как мне получить такую же классную рубашку как у тебя и постоянную работу?",
	},
	["LatestRumours"] = {
		response = "@r_mark_rumours",
		topic = "@t_mark_rumours",
		rumours = true
	},
	["GOODBYE"] = {
		topic = "До встречи.",
		flags = DFLAG_GOODBYE
	}
})
--]]