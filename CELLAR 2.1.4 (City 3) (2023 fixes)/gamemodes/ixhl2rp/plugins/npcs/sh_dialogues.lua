ix.lang.AddTable("russian", {
	r_mark_greetings_1f = "Что я могу для Вас сделать, гражданка?",
	r_mark_greetings_2f = "Вам что-то нужно?",
	r_mark_greetings_3f = "Слушаю.",
	r_mark_greetings_1m = "Чем могу Вам помочь, гражданин?",
	r_mark_greetings_2m = "Я слушаю Вас.",
	r_mark_greetings_3m = "Да-да?",
	r_mark_neverseen = "Да, это правда.\nДепартамент жилья и собственности совместно с городской администрацией готовит в городе реформы, и в связи с этим здесь повсюду сплошные кадровые перестановки. Тяжкое время, особенно в такой кризис для пром-зоны города. Я тут теперь за выдачу почты отвечаю, ну и в скором времени - оформлением документов на аренду жилых квартир, новых точек бизнеса и прочей собственности...\nГоворят, экономику города хотят перезапускать. В общем, как-то так.",
	r_mark_rent = "Сейчас я не могу об этом говорить. Департамент ещё не готов к этому, возможно, в другой раз.",
	r_mark_rumours = "Нет. Пока всё тихо.",
	r_mark_checkmail = "Хорошо. Карту, пожалуйста.",
	t_mail_check_id = "Протянуть карту #%s.",
	t_mark_neverseen_f = "Я никогда не видела Вас здесь раньше.",
	t_mark_neverseen_m = "Никогда прежде тебя здесь не видел.",
	t_mark_rent_f = "Я бы хотела поговорить о аренде/покупке помещения.",
	t_mark_rent_m = "Я бы хотел поговорить о аренде/покупке помещения.",
	t_mark_checkmail_f = "Я бы хотела проверить почту.",
	t_mark_checkmail_m = "Я бы хотел проверить почту.",
	t_mark_rumours = "Что-нибудь слышно в последнее время?",
	t_generic_goodbye = "До встречи.",
	t_checkmail_no_m = "Я передумал.",
	t_checkmail_no_f = "Я передумала.",
	r_rumour1 = "Ходит слух, что в пром-зоне произошёл какой-то неудачный эксперимент, и теперь мы все здесь остались без рабочих фаз! Как долго это продлится, чёрт его знает.\nХвала Покровителям, что нам выплачивают пособия, а то так можно и с голода помереть...",
})

ix.lang.AddTable("english", {
	r_mark_greetings_1f = "What can I do for you?",
	r_mark_greetings_2f = "Do you need something?",
	r_mark_greetings_3f = "I'm listening.",
	r_mark_greetings_1m = "How can I help you?",
	r_mark_greetings_2m = "I am listening to you.",
	r_mark_greetings_3m = "Yes?",
	r_mark_neverseen = "Yes, that's true.\nThe Department of Housing and Property, together with the city administration, is preparing reforms in the city, and therefore there are continuous personnel shifts everywhere. A difficult time, especially in such a crisis for the city’s industrial zone. I’m here now for I am responding to the issuance of mail, and soon - drawing up documents for the rental of residential apartments, places of business and other property...\nIt is said that they want to restart the city’s economy. In general, somehow.",
	r_mark_rent = "Now I can’t talk about it. The department is not ready for this yet, maybe another time.",
	r_mark_rumours = "No. Everything is quiet.",
	r_mark_checkmail = "Okay. Citizen card please.",
	t_mail_check_id = "Gave him citizen card #%s.",
	t_mark_neverseen_f = "I've never seen you here before.",
	t_mark_neverseen_m = "I've never seen you here before.",
	t_mark_rent_f = "I would like to talk about renting / buying a room.",
	t_mark_rent_m = "I would like to talk about renting / buying a room.",
	t_mark_checkmail_f = "I would like to check my mail.",
	t_mark_checkmail_m = "I would like to check my mail.",
	t_mark_rumours = "Have you heard anything lately?",
	t_generic_goodbye = "See you.",
	t_checkmail_no_m = "I changed my mind.",
	t_checkmail_no_f = "I changed my mind.",
	r_rumour1 = "It is rumored that some unsuccessful experiment took place in the industrial zone, and now we are all left without working phases! How long will it last, damn him.\nPraise to the Union that we are paid benefits, otherwise it’s possible die of hunger...",
})

ix.dialogues.Add("cp", {
	["GREETINGS"] = {
		response = {
			[1] = {
				condition = function(client) 
					if client:IsCombine() or client:IsCityAdmin() then
						return "Служу Покровителям!"
					else
						return {
									"Проходи.",
									"...",
									"Двигай отсюда.",
									"Гражданин.",
									"Не трать моё время.",
									"Чего ты хочешь?",
								}
					end
				end,
			}
		},
		choices = {"GOODBYE"}
	},
	["GOODBYE"] = {
		topic = "...",
		flags = DFLAG_GOODBYE
	}
})

ix.dialogues.Add("_Rumours", {
	["ARumour1"] = {
		response = "@r_rumour1",
		flags = bit.bor(DFLAG_RUMOURS, DFLAG_ONCE)
	}
})

-- ix.dialogues.Add("mark_pootisman", {
-- 	["GREETINGS"] = {
-- 		response = {
-- 			[1] = {
-- 				text = {"@r_mark_greetings_1f", "@r_mark_greetings_2f", "@r_mark_greetings_3f"},
-- 				gender = GENDER_FEMALE
-- 			},
-- 			[2] = {
-- 				text = {"@r_mark_greetings_1m", "@r_mark_greetings_2m", "@r_mark_greetings_3m"},
-- 				gender = GENDER_MALE
-- 			},
-- 		},
-- 		choices = {"NeverSeenYou", "Rent", "CheckMail", "LatestRumours", "GOODBYE"}
-- 	},
-- 	["NeverSeenYou"] = {
-- 		response = "@r_mark_neverseen",
-- 		data = {
-- 			mailtopic = true,
-- 			renttopic = true
-- 		},
-- 		topic = {
-- 			[1] = {
-- 				text = "@t_mark_neverseen_f",
-- 				gender = GENDER_FEMALE
-- 			},
-- 			[2] = {
-- 				text = "@t_mark_neverseen_m",
-- 				gender = GENDER_MALE
-- 			},
-- 		},
-- 		flags = DFLAG_ONCE
-- 	},
-- 	["Rent"] = {
-- 		response = "@r_mark_rent",
-- 		topic = {
-- 			[1] = {
-- 				text = "@t_mark_rent_f",
-- 				gender = GENDER_FEMALE
-- 			},
-- 			[2] = {
-- 				text = "@t_mark_rent_m",
-- 				gender = GENDER_MALE
-- 			},
-- 		},
-- 		condition = function(client, npc, self) return self.data.renttopic end,
-- 	},
-- 	["CheckMail"] = {
-- 		response = "@r_mark_checkmail",
-- 		topic = {
-- 			[1] = {
-- 				text = "@t_mark_checkmail_f",
-- 				gender = GENDER_FEMALE
-- 			},
-- 			[2] = {
-- 				text = "@t_mark_checkmail_m",
-- 				gender = GENDER_MALE
-- 			},
-- 		},
-- 		choices = function(client, npc, dialogue) 
-- 			local choices = {}
-- 			for k, v in pairs(client:GetCharacter():GetInventory():GetItemsByUniqueID("cid")) do
-- 				local citizenID = v:GetData("id", "0000")

-- 				choices[#choices + 1] = {label = L("t_mail_check_id", client, citizenID), cid = citizenID}
-- 			end

-- 			choices[#choices + 1] = {label = client:GetCharacter():GetGender() == GENDER_MALE and "@t_checkmail_no_m" or "@t_checkmail_no_f"}

-- 			return choices
-- 		end,
-- 		choose = function(choice, client, npc, dialogue)
-- 			if SERVER and choice.cid then
-- 				client:OpenMailbox(choice.cid)
-- 			end
-- 			return choice.cid and "GOODBYE" or "GREETINGS"
-- 		end,
-- 		condition = function(client, npc, self) return self.data.mailtopic end,
-- 		flags = DFLAG_DYNAMIC
-- 	},
-- 	["LatestRumours"] = {
-- 		response = "@r_mark_rumours",
-- 		topic = "@t_mark_rumours",
-- 		rumours = true
-- 	},
-- 	["GOODBYE"] = {
-- 		topic = "@t_generic_goodbye",
-- 		flags = DFLAG_GOODBYE
-- 	}
-- })