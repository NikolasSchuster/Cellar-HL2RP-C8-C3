local PLUGIN = PLUGIN or {}

PLUGIN.name = ""
PLUGIN.author = ""
PLUGIN.description = ""


Schema.voices.Add("Combine", "ДВИГАЮСЬ", "Двигаюсь.", "HLAComVoice/grunt/advancing_on_target_01.wav")
Schema.voices.Add("Combine", "ДВИГАЮСЬ2", "Двигаюсь сейчас.", "HLAComVoice/grunt/advancing_on_target_02.wav")
Schema.voices.Add("Combine", "ДВИГАЮСЬ СЕЙЧАС", "Двигаюсь сейчас.", "HLAComVoice/grunt/advancing_on_target_02.wav")
Schema.voices.Add("Combine", "ДВИГАЮСЬ3", "Подавляю.", "HLAComVoice/grunt/advancing_on_target_03.wav")
Schema.voices.Add("Combine", "ПОДАВЛЯЮ", "Подавляю.", "HLAComVoice/grunt/advancing_on_target_03.wav")
Schema.voices.Add("Combine", "СБЛИЖАЮСЬ С ЦЕЛЬЮ", "Сближаюсь с целью.", "HLAComVoice/grunt/advancing_on_target_04.wav")
Schema.voices.Add("Combine", "ПОДАВЛЯЙ", "Подавляй.", "HLAComVoice/grunt/advancing_on_target_05.wav")
Schema.voices.Add("Combine", "СБЛИЖАЮСЬ С ЗАРАЖЕННЫМ", "Сближаюсь с зараженным.", "HLAComVoice/grunt/advancing_on_target_06.wav")
Schema.voices.Add("Combine", "АККУРАТНО ВПЕРЕД", "Аккуратно вперед.", "HLAComVoice/grunt/advancing_on_target_07.wav")
Schema.voices.Add("Combine", "ПРОДВИГАЮСЬ2", "Продвигаюсь вперед.", "HLAComVoice/grunt/advancing_on_target_08.wav")
Schema.voices.Add("Combine", "ПРОДВИГАЮСЬ ВПЕРЕД", "Продвигаюсь вперед.", "HLAComVoice/grunt/advancing_on_target_08.wav")
Schema.voices.Add("Combine", "ДВИГАЮСЬ К ЗАГРЯЗНЕНИЮ", "Двигаюсь к загрязнению.", "HLAComVoice/grunt/advancing_on_target_10.wav")
Schema.voices.Add("Combine", "ПРОДВИГАЕМСЯ2", "Продвигаемся!", "HLAComVoice/grunt/advancing_on_target_11.wav")
Schema.voices.Add("Combine", "ПРОДВИГАЕМСЯ", "Продвигаемся!", "HLAComVoice/grunt/advancing_on_target_11.wav")
Schema.voices.Add("Combine", "СБЛИЖАЮСЬ С ИНФИЦИРОВАННЫМ", "Сближаюсь с инфицированным.", "HLAComVoice/grunt/advancing_on_target_13.wav")
Schema.voices.Add("Combine", "ПРОДВИГАЮСЬ", "Продвигаюсь.", "HLAComVoice/grunt/advancing_on_target_14.wav")
Schema.voices.Add("Combine", "ПРОДВИГАЮСЬ3", "Продвигаюсь в сектор.", "HLAComVoice/grunt/advancing_on_target_16.wav")
Schema.voices.Add("Combine", "ПРОДВИГАЮСЬ", "Продвигаюсь в сектор.", "HLAComVoice/grunt/advancing_on_target_16.wav")
Schema.voices.Add("Combine", "СБЛИЖАЮСЬ С ЗАРАЖЕННЫМ", "Сближаюсь с зараженным.", "HLAComVoice/grunt/advancing_on_target_17.wav")

-- Announcing Attack

Schema.voices.Add("Combine", "АТАКУЮ", "Атакую!", "HLAComVoice/grunt/announceattack_01.wav")
Schema.voices.Add("Combine", "СОСРЕДОТОЧИТЬСЯ", "Сосредоточиться!", "HLAComVoice/grunt/announceattack_01.wav")
Schema.voices.Add("Combine", "АТАКУЮ2", "Сближаюсь!", "HLAComVoice/grunt/announceattack_02.wav")
Schema.voices.Add("Combine", "СБЛИЖАЮСЬ", "Сокращаю расстояние!", "HLAComVoice/grunt/announceattack_02.wav")
Schema.voices.Add("Combine", "АТАКУЮ3", "Цель атакована.", "HLAComVoice/grunt/announceattack_03.wav")
Schema.voices.Add("Combine", "АТАКУЮ4", "Преследую.", "HLAComVoice/grunt/announceattack_04.wav")
Schema.voices.Add("Combine", "ПРЕСЛЕДУЮ", "Преследую.", "HLAComVoice/grunt/announceattack_04.wav")
Schema.voices.Add("Combine", "АТАКУЮ5", "Отвечаю огнем на упреждение.", "HLAComVoice/grunt/announceattack_05.wav")
Schema.voices.Add("Combine", "АТАКУЮ6", "Под огнем.", "HLAComVoice/grunt/announceattack_06.wav")
Schema.voices.Add("Combine", "ПОД ОГНЕМ", "Под огнем.", "HLAComVoice/grunt/announceattack_06.wav")
Schema.voices.Add("Combine", "АТАКУЮ7", "Атакую на упреждение.", "HLAComVoice/grunt/announceattack_07.wav")
Schema.voices.Add("Combine", "АТАКУЮ8", "Пользуюсь преимуществом.", "HLAComVoice/grunt/announceattack_08.wav")
Schema.voices.Add("Combine", "АТАКУЮ9", "Цель зафиксировани, оружие наведено.", "HLAComVoice/grunt/announceattack_09.wav")
Schema.voices.Add("Combine", "ОТКРЫТЬ ОГОНЬ", "Открыть огонь.", "HLAComVoice/grunt/announceattack_11.wav")

-- Announcing Attack on Player/Alyx

Schema.voices.Add("Combine", "ЦЕЛЬ НОМЕР ОДИН", "Цель номер один в поле зрения.", "HLAComVoice/grunt/announceattack_alyx_01.wav")
Schema.voices.Add("Combine", "ОСТАНОВИТЬСЯ СЕЙЧАС", "Остановиться, сейчас!", "HLAComVoice/grunt/announceattack_alyx_02.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ НОМЕР ОДИН2", "Сорвали куш.", "HLAComVoice/grunt/announceattack_alyx_03.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ НОМЕР ОДИН РАНЕНА", "Цель номер один ранена.", "HLAComVoice/grunt/announceattack_alyx_04.wav")
Schema.voices.Add("Combine", "Я ДЕРЖУ ЕЕ", "Я держу ее!", "HLAComVoice/grunt/announceattack_alyx_05.wav")
Schema.voices.Add("Combine", "ЭТО ОНА", "Это она!", "HLAComVoice/grunt/announceattack_alyx_11.wav")

-- Announcing Attack on Cover

Schema.voices.Add("Combine", "РАЗБИВАЮ УКРЫТИЕ", "Раскрываю маскировку.", "HLAComVoice/grunt/announceattack_cover_01.wav")
Schema.voices.Add("Combine", "РАСКРЫВАЮ МАСКИРОВКУ", "Раскрываю маскировку.", "HLAComVoice/grunt/announceattack_cover_01.wav")
Schema.voices.Add("Combine", "РАЗБИВАЮ УКРЫТИЕ2", "Меняю цель, код облавы.", "HLAComVoice/grunt/announceattack_cover_02.wav")
Schema.voices.Add("Combine", "РАЗБИВАЮ УКРЫТИЕ3", "Обозначить цель как тень.", "HLAComVoice/grunt/announceattack_cover_03.wav")
Schema.voices.Add("Combine", "РАСКРЫВАЕМ ВРАГА ЧЕРЕЗ 3", "Раскрываем врага через 3...", "HLAComVoice/grunt/announceattack_cover_04.wav")
Schema.voices.Add("Combine", "РАЗБИВАЮ УКРЫТИЕ4", "Цель бронирована, исправляем.", "HLAComVoice/grunt/announceattack_cover_05.wav")
Schema.voices.Add("Combine", "РАЗБИВАЮ УКРЫТИЕ5", "Открываю огонь по укрытию.", "HLAComVoice/grunt/announceattack_cover_08.wav")
Schema.voices.Add("Combine", "РАЗБИВАЮ УКРЫТИЕ6", "Код облавы!", "HLAComVoice/grunt/announceattack_cover_10.wav")

-- Announcing Attack with Grenade

Schema.voices.Add("Combine", "КИДАЮ ГРАНАТУ", "Граната!", "HLAComVoice/grunt/announceattack_grenade_01.wav")
Schema.voices.Add("Combine", "КИДАЮ ГРАНАТУ2", "Кидаю гранату!", "HLAComVoice/grunt/announceattack_grenade_02.wav")
Schema.voices.Add("Combine", "КИДАЮ ГРАНАТУ3", "...чека выдернута!", "HLAComVoice/grunt/announceattack_grenade_03.wav")
Schema.voices.Add("Combine", "КИДАЮ ГРАНАТУ4", "Граната, граната!", "HLAComVoice/grunt/announceattack_grenade_04.wav")
Schema.voices.Add("Combine", "ГРАНАТА ГРАНАТА", "Граната, граната!", "HLAComVoice/grunt/announceattack_grenade_04.wav")
Schema.voices.Add("Combine", "КИДАЮ ГРАНАТУ5", "Граната, ищу укрытие!", "HLAComVoice/grunt/announceattack_grenade_05.wav")
Schema.voices.Add("Combine", "В УКРЫТИЕ", "В укрытие!", "HLAComVoice/grunt/announceattack_grenade_05.wav")
Schema.voices.Add("Combine", "ГРАНА НА 3", "Граната на 3...", "HLAComVoice/grunt/announceattack_grenade_06.wav")
Schema.voices.Add("Combine", "КИДАЮ ГРАНАТУ6", "...выдернута!", "HLAComVoice/grunt/announceattack_grenade_07.wav")
Schema.voices.Add("Combine", "КИДАЮ ГРАНАТУ7", "Кидаю гранату!", "HLAComVoice/grunt/announceattack_grenade_08.wav")
Schema.voices.Add("Combine", "КИДАЮ ГРАНАТУ8", "Всем назад!", "HLAComVoice/grunt/announceattack_grenade_09.wav")
Schema.voices.Add("Combine", "КИДАЮ ГРАНАТУ9", "Лови гранату!", "HLAComVoice/grunt/announceattack_grenade_10.wav")

-- Announcing Enemy Antlion (Virome)

Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ2", "Муравьиный лев!", "HLAComVoice/grunt/announceenemy_antlion_01.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ3", "Цель муравьиный лев!", "HLAComVoice/grunt/announceenemy_antlion_02.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ4", "Контакт, муравьиный лев!", "HLAComVoice/grunt/announceenemy_antlion_03.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ5", "Муравьиные львы наступают!", "HLAComVoice/grunt/announceenemy_antlion_04.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ6", "Контакт, лев!", "HLAComVoice/grunt/announceenemy_antlion_05.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ7", "Визуальный контакт, муравьиный лев!", "HLAComVoice/grunt/announceenemy_antlion_06.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ8", "Муравьиный лев, здесь!", "HLAComVoice/grunt/announceenemy_antlion_10.wav")

-- Announcing Enemy Headcrab

Schema.voices.Add("Combine", "ХЭДКРАБ2", "Паразиты!", "HLAComVoice/grunt/announceenemy_headcrabs_01.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ3", "Паразиты в секторе.", "HLAComVoice/grunt/announceenemy_headcrabs_02.wav")
Schema.voices.Add("Combine", "3 ХЭДКРАБА", "Фу, контакт с тремя паразитами.", "HLAComVoice/grunt/announceenemy_headcrabs_03.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ4", "Контакт, паразиты.", "HLAComVoice/grunt/announceenemy_headcrabs_05.wav")
Schema.voices.Add("Combine", "Я НЕНАВИЖУ", "Я ненавижу эти штуки.", "HLAComVoice/grunt/announceenemy_headcrabs_06.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ5", "У нас паразиты здесь!", "HLAComVoice/grunt/announceenemy_headcrabs_07.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ6", "Паразиты здесь!", "HLAComVoice/grunt/announceenemy_headcrabs_09.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ7", "Паразитическое заражение подтверждено.", "HLAComVoice/grunt/announceenemy_headcrabs_10.wav")

-- Announcing Enemy Headcrab

Schema.voices.Add("Combine", "ЗОМБИ2", "Некротики!", "HLAComVoice/grunt/announceenemy_zombie_01.wav")
Schema.voices.Add("Combine", "ЗОМБИ3", "Некротики пребывают!", "HLAComVoice/grunt/announceenemy_zombie_02.wav")
Schema.voices.Add("Combine", "УГРОЗА ЗАРАЖЕНИЯ", "Угроза заражения!", "HLAComVoice/grunt/announceenemy_zombie_03.wav")
Schema.voices.Add("Combine", "ЗОМБИ4", "Контакт, некротики!", "HLAComVoice/grunt/announceenemy_zombie_05.wav")
Schema.voices.Add("Combine", "ЗОМБИ5", "Я вижу некротиков!", "HLAComVoice/grunt/announceenemy_zombie_06.wav")
Schema.voices.Add("Combine", "ЗОМБИ6", "У нас некротики!", "HLAComVoice/grunt/announceenemy_zombie_07.wav")
Schema.voices.Add("Combine", "ЗОМБИ7", "Некротики активны.", "HLAComVoice/grunt/announceenemy_zombie_08.wav")
Schema.voices.Add("Combine", "ЗОМБИ8", "Контакт с некротиками!", "HLAComVoice/grunt/announceenemy_zombie_09.wav")
Schema.voices.Add("Combine", "ЗОМБИ9", "Тут некротики.", "HLAComVoice/grunt/announceenemy_zombie_10.wav")

-- Announce Kill

Schema.voices.Add("Combine", "УБИТ", "Враг убит.", "HLAComVoice/grunt/announcekill_01.wav")
Schema.voices.Add("Combine", "УБИТ2", "Цель убит.", "HLAComVoice/grunt/announcekill_02.wav")
Schema.voices.Add("Combine", "УБИТ3", "Убийство подтверждено.", "HLAComVoice/grunt/announcekill_03.wav")
Schema.voices.Add("Combine", "В ГОЛОВУ", "В голову.", "HLAComVoice/grunt/announcekill_04.wav")
Schema.voices.Add("Combine", "УБИТ5", "Еще один убит.", "HLAComVoice/grunt/announcekill_05.wav")
Schema.voices.Add("Combine", "УБИТ6", "Прикончил.", "HLAComVoice/grunt/announcekill_06.wav")
Schema.voices.Add("Combine", "ПРИКОНЧИЛ", "Прикончил.", "HLAComVoice/grunt/announcekill_06.wav")
Schema.voices.Add("Combine", "УБИТ7", "Мертв.", "HLAComVoice/grunt/announcekill_07.wav")
Schema.voices.Add("Combine", "МЕРТВ", "Мертв.", "HLAComVoice/grunt/announcekill_07.wav")
Schema.voices.Add("Combine", "УБИТ8", "В голову!", "HLAComVoice/grunt/announcekill_08.wav")
Schema.voices.Add("Combine", "УБИТ9", "Цель убита!", "HLAComVoice/grunt/announcekill_09.wav")
Schema.voices.Add("Combine", "ОНИ МЕРТВЫ", "Они мертвы.", "HLAComVoice/grunt/announcekill_11.wav")
Schema.voices.Add("Combine", "УБИТ4", "Противник нейтрализован.", "HLAComVoice/grunt/announcekill_13.wav")
Schema.voices.Add("Combine", "ЗАКОНЧИЛИ", "Закончили.", "HLAComVoice/grunt/announcekill_14.wav")
Schema.voices.Add("Combine", "ПРОТИВНИК СКОНЧАЛСЯ", "Противник скончался.", "HLAComVoice/grunt/announcekill_15.wav")

-- Announce Kill - Antlion

Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ МЕРТВ", "Львы убиты.", "HLAComVoice/grunt/announcekill_antlion_01.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ МЕРТВ2", "Чисто.", "HLAComVoice/grunt/announcekill_antlion_02.wav")
Schema.voices.Add("Combine", "ЧИСТО", "Чисто.", "HLAComVoice/grunt/announcekill_antlion_02.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ МЕРТВ3", "Цель стерилизована.", "HLAComVoice/grunt/announcekill_antlion_03.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ МЕРТВ4", "Стерт.", "HLAComVoice/grunt/announcekill_antlion_04.wav")
Schema.voices.Add("Combine", "СТЕРТ", "Стерт.", "HLAComVoice/grunt/announcekill_antlion_04.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ МЕРТВ5", "Паразит сдержан!", "HLAComVoice/grunt/announcekill_antlion_05.wav")

-- Announce Kill - Headcrab

Schema.voices.Add("Combine", "ХЭДКРАБ МЕРТВ", "Чисто.", "HLAComVoice/grunt/announcekill_headcrab_01.wav")
Schema.voices.Add("Combine", "ЧИСТО", "Чисто.", "HLAComVoice/grunt/announcekill_headcrab_01.wav")
Schema.voices.Add("Combine", "СЕКТОР ЗАЧИЩЕН", "Сектор зачищен, продвигаюсь.", "HLAComVoice/grunt/announcekill_headcrab_02.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ МЕРТВ2", "Подстрелил одного.", "HLAComVoice/grunt/announcekill_headcrab_03.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ МЕРТВ3", "Загрязнение сдержано.", "HLAComVoice/grunt/announcekill_headcrab_04.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ МЕРТВ4", "Очищено.", "HLAComVoice/grunt/announcekill_headcrab_05.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ МЕРТВ5", "Гадость.", "HLAComVoice/grunt/announcekill_headcrab_06.wav")
Schema.voices.Add("Combine", "ГАДОСТЬ", "Гадость.", "HLAComVoice/grunt/announcekill_headcrab_06.wav")
Schema.voices.Add("Combine", "ПРОРЫВ ЛИКВИДИРОВАН", "Прорыв ликвидирован.", "HLAComVoice/grunt/announcekill_headcrab_07.wav")
Schema.voices.Add("Combine", "ПРОРЫВ СДЕРЖАН", "Прорыв сдержан.", "HLAComVoice/grunt/announcekill_headcrab_08.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ МЕРТВ6", "Паразит аннулирован.", "HLAComVoice/grunt/announcekill_headcrab_09.wav")

-- Announce Kill - Player/Alyx

Schema.voices.Add("Combine", "ВИП МЕРТВ", "Первоочередная цель сдержана.", "HLAComVoice/grunt/announcekill_player_01.wav")
Schema.voices.Add("Combine", "ВИП МЕРТВ2", "Цель номер один заткнулась.", "HLAComVoice/grunt/announcekill_player_02.wav")
Schema.voices.Add("Combine", "ОНА ЗАТКНУЛАСЬ", "Она заткнулась.", "HLAComVoice/grunt/announcekill_player_03.wav")
Schema.voices.Add("Combine", "МЕРТВ2", "Мертв.", "HLAComVoice/grunt/announcekill_player_07.wav")
Schema.voices.Add("Combine", "ВИП УБИТ", "И-и-и главный противник ликвидирован.", "HLAComVoice/grunt/announcekill_player_08.wav")

-- Announce Kill - Zombie

Schema.voices.Add("Combine", "ЗОМБИ МЕРТВ", "Некро сдержан.", "HLAComVoice/grunt/announcekill_zombie_01.wav")
Schema.voices.Add("Combine", "ЗОМБИ МЕРТВ2", "Некротик сдержан.", "HLAComVoice/grunt/announcekill_zombie_02.wav")
Schema.voices.Add("Combine", "ЗОМБИ МЕРТВ3", "Оставайся мертвым!", "HLAComVoice/grunt/announcekill_zombie_03.wav")
Schema.voices.Add("Combine", "ОСТАВАЙСЯ МЕРТВЫМ", "Оставайся мертвым!", "HLAComVoice/grunt/announcekill_zombie_03.wav")
Schema.voices.Add("Combine", "ЗОМБИ МЕРТВ4", "Инфицированный уничтожен.", "HLAComVoice/grunt/announcekill_zombie_04.wav")
Schema.voices.Add("Combine", "ЗОМБИ МЕРТВ5", "Обратно спать.", "HLAComVoice/grunt/announcekill_zombie_05.wav")
Schema.voices.Add("Combine", "ОБРАТНО СПАТЬ", "Обратно спать.", "HLAComVoice/grunt/announcekill_zombie_05.wav")
Schema.voices.Add("Combine", "ЗОМБИ МЕРТВ6", "Оно мертво.", "HLAComVoice/grunt/announcekill_zombie_06.wav")
Schema.voices.Add("Combine", "ОНО МЕРТВО", "Оно мертво.", "HLAComVoice/grunt/announcekill_zombie_06.wav")
Schema.voices.Add("Combine", "ЗОМБИ МЕРТВ7", "Зачистка успешна.", "HLAComVoice/grunt/announcekill_zombie_07.wav")

-- Breathing Sounds

Schema.voices.Add("Combine", "ДЫШИТ", "*Тяжелое дыхание*", "HLAComVoice/grunt/breathing_01.wav")
Schema.voices.Add("Combine", "ДЫШИТ2", "*Тяжелое дыхание*", "HLAComVoice/grunt/breathing_02.wav")
Schema.voices.Add("Combine", "ДЫШИТ3", "*Тяжелое дыхание*", "HLAComVoice/grunt/breathing_03.wav")
Schema.voices.Add("Combine", "ДЫШИТ4", "*Тяжелое дыхание*", "HLAComVoice/grunt/breathing_04.wav")
Schema.voices.Add("Combine", "ДЫШИТ5", "*Тяжелое дыхание*", "HLAComVoice/grunt/breathing_05.wav")

-- Panting

Schema.voices.Add("Combine", "ЗАДЫХАЕТСЯ", "*Задыхается*", "HLAComVoice/grunt/panting_01.wav")
Schema.voices.Add("Combine", "ЗАДЫХАЕТСЯ2", "*Задыхается*", "HLAComVoice/grunt/panting_02.wav")
Schema.voices.Add("Combine", "ЗАДЫХАЕТСЯ3", "*Задыхается*", "HLAComVoice/grunt/panting_03.wav")
Schema.voices.Add("Combine", "ЗАДЫХАЕТСЯ4", "*Задыхается*", "HLAComVoice/grunt/panting_04.wav")
Schema.voices.Add("Combine", "ЗАДЫХАЕТСЯ5", "*Задыхается*", "HLAComVoice/grunt/panting_05.wav")

-- Pain / Panic / On Fire

Schema.voices.Add("Combine", "УТЕЧКА ТОПЛИВА НА БАЛЛОНЕ", "Угх! Утечка топлива с баллона... помогите... помогите, агх!", "HLAComVoice/grunt/onfire_010.wav")
Schema.voices.Add("Combine", "УТЕЧКА ТОПЛИВА НА БАЛЛОНЕ2", "Угх! Топ... помогите... помогите, ах, угх!", "HLAComVoice/grunt/onfire_011.wav")
Schema.voices.Add("Combine", "ПАНИКА", "Ааах! *Инстинктивная паника*", "HLAComVoice/grunt/onfire_030.wav")
Schema.voices.Add("Combine", "КРИТИЧЕСКИЕ ПОКАЗАТЕЛИ БИОДАТЧИКОВ", "Критические показатели биодатчиков... истекают через, четыре, три, два-", "HLAComVoice/grunt/onfire_050.wav")
Schema.voices.Add("Combine", "КРИТИЧЕСКИЕ ПОКАЗАТЕЛИ БИОДАТЧИКОВ2", "Ах... Критические показатели биодатчиков... истекают через, четыре... тр-", "HLAComVoice/grunt/onfire_051.wav")
Schema.voices.Add("Combine", "КРИТИЧЕСКИЕ ПОКАЗАТЕЛИ БИОДАТЧИКОВ3", "Ах! Утечка топлива с баллона!", "HLAComVoice/grunt/onfire_060.wav")
Schema.voices.Add("Combine", "КРИТИЧЕСКИЕ ПОКАЗАТЕЛИ БИОДАТЧИКОВ4", "Ах! Утечка топлива с баллона!", "HLAComVoice/grunt/onfire_061.wav")
Schema.voices.Add("Combine", "ПАНИКА2", "*Инстинктивная паника*", "HLAComVoice/grunt/onfire_070.wav")
Schema.voices.Add("Combine", "ПАНИКА3", "*Инстинктивная паника*", "HLAComVoice/grunt/onfire_080.wav")
Schema.voices.Add("Combine", "КРИК", "*Кричит*", "HLAComVoice/grunt/onfire_081.wav")
Schema.voices.Add("Combine", "КРИК2", "*Кричит*", "HLAComVoice/grunt/onfire_090.wav")
Schema.voices.Add("Combine", "СНИМИ ЭТО С МЕНЯ", "Ах! Н-нет! Нет! Нет! Сними это с меня!", "HLAComVoice/grunt/onfire_091.wav")
Schema.voices.Add("Combine", "КРИК3", "*Кричит*", "HLAComVoice/grunt/onfire_100.wav")
Schema.voices.Add("Combine", "КРИК4", "*Кричит*", "HLAComVoice/grunt/onfire_101.wav")

-- Alphabet A-E

Schema.voices.Add("Combine", "АЛЬФА", "Альфа.", "HLAComVoice/grunt/calloutcode_alpha_01.wav")
Schema.voices.Add("Combine", "БРАВО", "Браво.", "HLAComVoice/grunt/calloutcode_bravo_01.wav")
Schema.voices.Add("Combine", "ЧАРЛИ", "Чарли.", "HLAComVoice/grunt/calloutcode_charlie_01.wav")
Schema.voices.Add("Combine", "ДЕЛЬТА", "Дельта.", "HLAComVoice/grunt/calloutcode_delta_01.wav")
Schema.voices.Add("Combine", "ЭХО", "Эхо.", "HLAComVoice/grunt/calloutcode_echo_01.wav")
Schema.voices.Add("Combine", "И", "И.", "HLAComVoice/grunt/calloutcode_and_01.wav")
Schema.voices.Add("Combine", "ТИРЕ", "Тире.", "HLAComVoice/grunt/calloutcode_dash_01.wav")

-- Numbers

Schema.voices.Add("Combine", "НОЛЬ", "Ноль.", "HLAComVoice/grunt/calloutcode_null_01.wav")
Schema.voices.Add("Combine", "ОДИН", "Один.", "HLAComVoice/grunt/calloutcode_one_01.wav")
Schema.voices.Add("Combine", "ДВА", "Два.", "HLAComVoice/grunt/calloutcode_two_01.wav")
Schema.voices.Add("Combine", "ТРИ", "Три.", "HLAComVoice/grunt/calloutcode_three_01.wav")
Schema.voices.Add("Combine", "ЧЕТЫРЕ", "Четыре.", "HLAComVoice/grunt/calloutcode_four_01.wav")
Schema.voices.Add("Combine", "ПЯТЬ", "Пять.", "HLAComVoice/grunt/calloutcode_five_01.wav")
Schema.voices.Add("Combine", "ШЕСТЬ", "Шесть.", "HLAComVoice/grunt/calloutcode_six_01.wav")
Schema.voices.Add("Combine", "СЕМЬ", "Семь.", "HLAComVoice/grunt/calloutcode_seven_01.wav")
Schema.voices.Add("Combine", "ВОСЕМЬ", "Восемь.", "HLAComVoice/grunt/calloutcode_eight_01.wav")
Schema.voices.Add("Combine", "ДЕВЯТЬ", "Девять.", "HLAComVoice/grunt/calloutcode_niner_01.wav")
Schema.voices.Add("Combine", "ДЕСЯТЬ", "Десять.", "HLAComVoice/grunt/calloutcode_ten_01.wav")
Schema.voices.Add("Combine", "ОДИННАДЦАТЬ", "Одиннадцать.", "HLAComVoice/grunt/calloutcode_eleven_01.wav")
Schema.voices.Add("Combine", "ДВЕНАДЦАТЬ", "Двенадцать.", "HLAComVoice/grunt/calloutcode_twelve_01.wav")

Schema.voices.Add("Combine", "0", "Ноль.", "HLAComVoice/grunt/calloutcode_null_01.wav")
Schema.voices.Add("Combine", "1", "Один.", "HLAComVoice/grunt/calloutcode_one_01.wav")
Schema.voices.Add("Combine", "2", "Два.", "HLAComVoice/grunt/calloutcode_two_01.wav")
Schema.voices.Add("Combine", "3", "Три.", "HLAComVoice/grunt/calloutcode_three_01.wav")
Schema.voices.Add("Combine", "4", "Четыре.", "HLAComVoice/grunt/calloutcode_four_01.wav")
Schema.voices.Add("Combine", "5", "Пять.", "HLAComVoice/grunt/calloutcode_five_01.wav")
Schema.voices.Add("Combine", "6", "Шесть.", "HLAComVoice/grunt/calloutcode_six_01.wav")
Schema.voices.Add("Combine", "7", "Семь.", "HLAComVoice/grunt/calloutcode_seven_01.wav")
Schema.voices.Add("Combine", "8", "Восемь.", "HLAComVoice/grunt/calloutcode_eight_01.wav")
Schema.voices.Add("Combine", "10", "Десять.", "HLAComVoice/grunt/calloutcode_ten_01.wav")
Schema.voices.Add("Combine", "11", "Одиннадцать.", "HLAComVoice/grunt/calloutcode_eleven_01.wav")
Schema.voices.Add("Combine", "12", "Двенадцать.", "HLAComVoice/grunt/calloutcode_twelve_01.wav")

Schema.voices.Add("Combine", "ДВАДЦАТЬ", "Двадцать.", "HLAComVoice/grunt/calloutcode_twenty_01.wav")
Schema.voices.Add("Combine", "ТРИДЦАТЬ", "Тридцать.", "HLAComVoice/grunt/calloutcode_thirty_01.wav")
Schema.voices.Add("Combine", "СОРОК", "Сорок.", "HLAComVoice/grunt/calloutcode_forty_01.wav")
Schema.voices.Add("Combine", "ПЯТЬДЕСЯТ", "Пятьдесят.", "HLAComVoice/grunt/calloutcode_fifty_01.wav")
Schema.voices.Add("Combine", "ШЕСТЬДЕСЯТ", "Шестьдесят.", "HLAComVoice/grunt/calloutcode_sixty_01.wav")
Schema.voices.Add("Combine", "СЕМЬДЕСЯТ", "Семьдесят.", "HLAComVoice/grunt/calloutcode_seventy_01.wav")

Schema.voices.Add("Combine", "20", "Двадцать.", "HLAComVoice/grunt/calloutcode_twenty_01.wav")
Schema.voices.Add("Combine", "30", "Тридцать.", "HLAComVoice/grunt/calloutcode_thirty_01.wav")
Schema.voices.Add("Combine", "40", "Сорок.", "HLAComVoice/grunt/calloutcode_forty_01.wav")
Schema.voices.Add("Combine", "50", "Пятьдесят.", "HLAComVoice/grunt/calloutcode_fifty_01.wav")
Schema.voices.Add("Combine", "60", "Шестьдесят.", "HLAComVoice/grunt/calloutcode_sixty_01.wav")
Schema.voices.Add("Combine", "70", "Семьдесят.", "HLAComVoice/grunt/calloutcode_seventy_01.wav")

Schema.voices.Add("Combine", "СТО", "Сто.", "HLAComVoice/grunt/calloutcode_hundred_01.wav")
Schema.voices.Add("Combine", "ТЫСЯЧА", "Тысяча.", "HLAComVoice/grunt/calloutcode_thousand_01.wav")

-- Entities

Schema.voices.Add("Combine", "НАРУШИТЕЛИ", "Нарушители.", "HLAComVoice/grunt/calloutentity_anticitizens_01.wav")
Schema.voices.Add("Combine", "МУРАВЬИНЫЙ ЛЕВ", "Муравьиный лев.", "HLAComVoice/grunt/calloutentity_antlion_01.wav")
Schema.voices.Add("Combine", "ПОДАВИТЕЛЬ", "Подавитель.", "HLAComVoice/grunt/calloutentity_apf_01.wav")
Schema.voices.Add("Combine", "БТР", "БТР.", "HLAComVoice/grunt/calloutentity_aps_01.wav")
Schema.voices.Add("Combine", "ЗАГРАДИТЕЛЬНЫЙ БАРЬЕР", "Заградительный барьер.", "HLAComVoice/grunt/calloutentity_bladewall_01.wav")
Schema.voices.Add("Combine", "СТЕНА АЛЬЯНСА", "Стена Альянса.", "HLAComVoice/grunt/calloutentity_cowall_01.wav")
Schema.voices.Add("Combine", "ДРУЖЕСТВЕННЫЙ", "Дружественный.", "HLAComVoice/grunt/calloutentity_friendly_01.wav")
Schema.voices.Add("Combine", "МОЛОТОБОЕЦ", "Молотобоец", "HLAComVoice/grunt/calloutentity_hammerwall_01.wav")
Schema.voices.Add("Combine", "ПРОТИВНИКИ", "Противники.", "HLAComVoice/grunt/calloutentity_hostiles_01.wav")
Schema.voices.Add("Combine", "ЗОМБИ", "Некротик.", "HLAComVoice/grunt/calloutentity_necrotic_01.wav")
Schema.voices.Add("Combine", "НАДЗОР", "Надзор.", "HLAComVoice/grunt/calloutentity_overwatch_01.wav")
Schema.voices.Add("Combine", "ХЭДКРАБ", "Паразит.", "HLAComVoice/grunt/calloutentity_parasitic_01.wav")
Schema.voices.Add("Combine", "СПАСАТЕЛЬ", "Спасатель.", "HLAComVoice/grunt/calloutentity_safeman_01.wav")
Schema.voices.Add("Combine", "МОЛОТОБОЕЦ", "Молотобоец.", "HLAComVoice/grunt/calloutentity_wallhammer_01.wav")

-- Locations
Schema.voices.Add("Combine", "СВЕРХУ", "Сверху.", "HLAComVoice/grunt/calloutlocation_above_01.wav")
Schema.voices.Add("Combine", "АПАРТАМЕНТЫ", "Апартаменты.", "HLAComVoice/grunt/calloutlocation_apartment_01.wav")
Schema.voices.Add("Combine", "БОЧКИ", "Бочки.", "HLAComVoice/grunt/calloutlocation_barrells_01.wav")
Schema.voices.Add("Combine", "СЗАДИ", "Сзади.", "HLAComVoice/grunt/calloutlocation_behind_01.wav")
Schema.voices.Add("Combine", "СНИЗУ", "Снизу.", "HLAComVoice/grunt/calloutlocation_below_01.wav")
Schema.voices.Add("Combine", "КИРПИЧИ", "Кирпичи.", "HLAComVoice/grunt/calloutlocation_bricks_01.wav")
Schema.voices.Add("Combine", "МОСТ", "Мост.", "HLAComVoice/grunt/calloutlocation_bridge_01.wav")
Schema.voices.Add("Combine", "ЗДАНИЕ", "Здание.", "HLAComVoice/grunt/calloutlocation_building_01.wav")
Schema.voices.Add("Combine", "МАШИНА", "Машина.", "HLAComVoice/grunt/calloutlocation_car_01.wav")
Schema.voices.Add("Combine", "КРАН", "Кран.", "HLAComVoice/grunt/calloutlocation_crane_01.wav")
Schema.voices.Add("Combine", "ДВЕРЬ", "Дверь.", "HLAComVoice/grunt/calloutlocation_door_01.wav")
Schema.voices.Add("Combine", "ЛИФТ", "Лифт.", "HLAComVoice/grunt/calloutlocation_elevator_01.wav")
Schema.voices.Add("Combine", "ПЕРЕДНЯЯ", "Передняя.", "HLAComVoice/grunt/calloutlocation_front_01.wav")
Schema.voices.Add("Combine", "ХИЖИНА", "Хижина", "HLAComVoice/grunt/calloutlocation_hut_01.wav")
Schema.voices.Add("Combine", "ТРУБЫ", "Трубы.", "HLAComVoice/grunt/calloutlocation_pipes_01.wav")
Schema.voices.Add("Combine", "ЛАЧУГА", "Лачуга.", "HLAComVoice/grunt/calloutlocation_shack_01.wav")
Schema.voices.Add("Combine", "ТУАЛЕТ", "Туалет.", "HLAComVoice/grunt/calloutlocation_toilet_01.wav")
Schema.voices.Add("Combine", "ВАГОН", "Вагон.", "HLAComVoice/grunt/calloutlocation_traincar_01.wav")
Schema.voices.Add("Combine", "МУСОР", "Мусор.", "HLAComVoice/grunt/calloutlocation_trash_01.wav")
Schema.voices.Add("Combine", "ГРУЗОВИК", "Грузовик.", "HLAComVoice/grunt/calloutlocation_truck_01.wav")
Schema.voices.Add("Combine", "ТУННЕЛЬ", "Туннель.", "HLAComVoice/grunt/calloutlocation_tunnel_01.wav")
Schema.voices.Add("Combine", "ФУРГОН", "Фургон.", "HLAComVoice/grunt/calloutlocation_van_01.wav")
Schema.voices.Add("Combine", "КОЛЕСА", "Колеса.", "HLAComVoice/grunt/calloutlocation_wheels_01.wav")
Schema.voices.Add("Combine", "ПОЛЕННИЦА", "Поленница.", "HLAComVoice/grunt/calloutlocation_woodpile_01.wav")

-- Combat Idle

Schema.voices.Add("Combine", "АКТИВНЫЕ ПРОТИВНИКИ", "Надзор, у нас активные не приятели. Запрашиваю препараты.", "HLAComVoice/grunt/combat_idle_012.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ ЕЩЕ ЖИВА", "Никак нет, цель еще жива.", "HLAComVoice/grunt/combat_idle_020.wav")
Schema.voices.Add("Combine", "ПРИНЯТО ФОРМИРУЕМ ПОСТРОЕНИЕ", "Принято, формируем построение Альфа.", "HLAComVoice/grunt/combat_idle_030.wav")
Schema.voices.Add("Combine", "ОЖИДАЮ УКАЗАНИЙ", "Ожидаю дальнейших указаний, конец связи.", "HLAComVoice/grunt/combat_idle_040.wav")
Schema.voices.Add("Combine", "ПЕРЕКАЛИБРОВАНИЕ", "Подтверждаю, перекалибрование.", "HLAComVoice/grunt/combat_idle_050.wav")
Schema.voices.Add("Combine", "ОБУСТРАИВАЮСЬ", "Принято, обустраиваю позицию.", "HLAComVoice/grunt/combat_idle_060.wav")
Schema.voices.Add("Combine", "ОНИ ЕЩЕ ЖИВЫ", "Они еще живы.", "HLAComVoice/grunt/combat_idle_070.wav")
Schema.voices.Add("Combine", "КОНТРОЛЬ СДЕРЖИВАНИЯ", "Принято, произвожу контроль сдерживания.", "HLAComVoice/grunt/combat_idle_080.wav")
Schema.voices.Add("Combine", "РЕШАЮ", "Решаю.", "HLAComVoice/grunt/combat_idle_090.wav")
Schema.voices.Add("Combine", "НЕТ СМЕНЕ ЦЕЛИ", "10-4, никак нет смене цели. На прицеле, готов.", "HLAComVoice/grunt/combat_idle_100.wav")
Schema.voices.Add("Combine", "ОБЛАДАЮ ТАКТИЧЕСКОЙ ИНИЦИАТИВОЙ", "Обладаю тактической инициативой.", "HLAComVoice/grunt/combat_idle_110.wav")
Schema.voices.Add("Combine", "ЕЩЕ ДЕРЖИМСЯ2", "Еще держимся!", "HLAComVoice/grunt/combat_idle_120.wav")
Schema.voices.Add("Combine", "ЕЩЕ ДЕРЖИМСЯ", "Еще держимся.", "HLAComVoice/grunt/combat_idle_121.wav")
Schema.voices.Add("Combine", "ОЖИДАЕМ ОБНОВЛЕНИЯ ПОКАЗАТЕЛЕЙ", "Ожидаем обновления органических показателей.", "HLAComVoice/grunt/combat_idle_130.wav")
Schema.voices.Add("Combine", "ПРИГОТОВИТЬСЯ К ЗАКАТУ", "Приготовится к Закату.", "HLAComVoice/grunt/combat_idle_141.wav")
Schema.voices.Add("Combine", "ПРИГОТОВИТЬ КОММУНИКАЦИИ", "Приготовить коммуникации для продолжительного конфликта.", "HLAComVoice/grunt/combat_idle_150.wav")
Schema.voices.Add("Combine", "БОЕПРИПАСЫ НЕ НУЖНЫ", "Никак нет, боеприпасы не нужны.", "HLAComVoice/grunt/combat_idle_160.wav")
Schema.voices.Add("Combine", "ПРОДЛЕВАЕМ КОНФЛИКТ", "Продлеваем длительность конфликта.", "HLAComVoice/grunt/combat_idle_170.wav")
Schema.voices.Add("Combine", "СКАНИРУЮ ОРГАНИЧЕСКИЕ ПОКАЗАТЕЛИ", "Сканирую вражеские органические показатели.", "HLAComVoice/grunt/combat_idle_180.wav")
Schema.voices.Add("Combine", "ИГНОРИРУЙТЕ", "Игнорируйте последний вызов.", "HLAComVoice/grunt/combat_idle_190.wav")
Schema.voices.Add("Combine", "НАДЗОР ДЕСЯТЬ-ДЕВЯТЬ", "Надзор, десять-девять.", "HLAComVoice/grunt/combat_idle_200.wav")

-- Request Cover

Schema.voices.Add("Combine", "ПРИКРОЙ МЕНЯ", "Прикрой меня!", "HLAComVoice/grunt/coverme_01.wav")
Schema.voices.Add("Combine", "ПРИКРОЙ", "Прикрой!", "HLAComVoice/grunt/coverme_02.wav")
Schema.voices.Add("Combine", "ПРОДОЛЖАЙ ПОДАВЛЕНИЕ", "Продолжай огонь на подавление!", "HLAComVoice/grunt/coverme_04.wav")
Schema.voices.Add("Combine", "ПРИГОТОВИТЬ СТИМУЛЯТОР", "Приготовить стимулятор!", "HLAComVoice/grunt/coverme_06.wav")
Schema.voices.Add("Combine", "ЗАПРАШИВАЮ ПОДДЕРЖКУ НА", "Запрашиваю поддержку на...", "HLAComVoice/grunt/coverme_07.wav")

-- Danger, grenade

Schema.voices.Add("Combine", "УКЛОНЯЙСЯ", "Уклоняйся!", "HLAComVoice/grunt/danger_grenade_01.wav")
Schema.voices.Add("Combine", "ГРАНАТА", "Граната!", "HLAComVoice/grunt/danger_grenade_02.wav")
Schema.voices.Add("Combine", "В УКРЫТИЕ", "В укрытие!", "HLAComVoice/grunt/danger_grenade_03.wav")
Schema.voices.Add("Combine", "ГРАНАТА2", "Настоящая граната!", "HLAComVoice/grunt/danger_grenade_04.wav")
Schema.voices.Add("Combine", "ВОЗМОЖНО ЭКСТРАКТ", "Возможно взведена, уклоняюсь!", "HLAComVoice/grunt/danger_grenade_05.wav")
Schema.voices.Add("Combine", "ГРАНАТА3", "Граната, двигайся!", "HLAComVoice/grunt/danger_grenade_06.wav")
Schema.voices.Add("Combine", "БЕГИ В УКРЫТИЕ", "Беги в укрытие!", "HLAComVoice/grunt/danger_grenade_07.wav")
Schema.voices.Add("Combine", "ГРАНАТА4", "Слышу гранату в секторе!", "HLAComVoice/grunt/danger_grenade_08.wav")
Schema.voices.Add("Combine", "НАЗАД2", "Назад!", "HLAComVoice/grunt/danger_grenade_09.wav")
Schema.voices.Add("Combine", "ГРАНАТА5", "Граната, ищу укрытие!", "HLAComVoice/grunt/danger_grenade_10.wav")

-- Establishing Line of Fire

Schema.voices.Add("Combine", "СБЛИЖАЮСЬ", "Сближаюсь.", "HLAComVoice/grunt/establishinglof_01.wav")
Schema.voices.Add("Combine", "УСТАНАВЛИВАЮ ЗРИТЕЛЬНЫЙ КОНТАКТ", "Устанавливаю зрительный контакт.", "HLAComVoice/grunt/establishinglof_03.wav")
Schema.voices.Add("Combine", "ДЕРЖУ В ПОЛЕ ЗРЕНИЯ", "Держу в поле зрения.", "HLAComVoice/grunt/establishinglof_04.wav")
Schema.voices.Add("Combine", "ПЕРЕСТРАИВАЮСЬ", "Перестраиваюсь к противнику.", "HLAComVoice/grunt/establishinglof_05.wav")
Schema.voices.Add("Combine", "ФОРМИРУЮ ВИЗУАЛЬНЫЙ КОНТАКТ", "Формирую визуальное подтверждение.", "HLAComVoice/grunt/establishinglof_06.wav")
Schema.voices.Add("Combine", "РАСЧИЩАЮ ЗАСЛОН", "Расчищаю заслон!", "HLAComVoice/grunt/establishinglof_07.wav")
Schema.voices.Add("Combine", "ПЕРЕСТРАИВАЮСЬ2", "Перестраиваюсь в формирование Дельта.", "HLAComVoice/grunt/establishinglof_09.wav")
Schema.voices.Add("Combine", "ОСТАВАЙСЯ ТУТ", "Оставайся тут!", "HLAComVoice/grunt/establishinglof_10.wav")
Schema.voices.Add("Combine", "МЕНЯЮ ПОЗИЦИЮ", "Меняю позицию.", "HLAComVoice/grunt/establishinglof_11.wav")
Schema.voices.Add("Combine", "МЕНЯЮ ПОЗИЦИЮ2", "Оптимизирую местоположение.", "HLAComVoice/grunt/establishinglof_12.wav")
Schema.voices.Add("Combine", "МЕНЯЮ ПОЗИЦИЮ3", "Улучшаю контакт на противнике.", "HLAComVoice/grunt/establishinglof_13.wav")
Schema.voices.Add("Combine", "МЕНЯЮ ПОЗИЦИЮ4", "Помеха зрительному контакту, двигаю.", "HLAComVoice/grunt/establishinglof_14.wav")
Schema.voices.Add("Combine", "ПРЯМОЕ НАБЛЮДЕНИЕ", "Прямое наблюдение.", "HLAComVoice/grunt/establishinglof_15.wav")
Schema.voices.Add("Combine", "КОНТАКТ ЧЕРЕЗ 3", "Контакт через 3.", "HLAComVoice/grunt/establishinglof_17.wav")
Schema.voices.Add("Combine", "РАСКРЫВАЮ ЦЕЛЬ", "Раскрываю основную цель.", "HLAComVoice/grunt/establishinglof_18.wav")
Schema.voices.Add("Combine", "НЕ ДВИГАЙСЯ", "Не двигайся.", "HLAComVoice/grunt/establishinglof_19.wav")

-- Fakeout Ceasefire

Schema.voices.Add("Combine", "ПРЕКРАТИТЬ ОГОНЬ ДРУГ", "Прекратить огонь, цель дружественная!", "HLAComVoice/grunt/fakeout_responseceasefire_01.wav")
-- Fakeout Success

Schema.voices.Add("Combine", "ХАХА", "Хаха.", "HLAComVoice/grunt/fakeout_success_01.wav")
Schema.voices.Add("Combine", "ИГРА В ДРУГА", "Хехехе, игра в друга была эффективной.", "HLAComVoice/grunt/fakeout_success_02.wav")
Schema.voices.Add("Combine", "ПРОТИВНИК РАЗМАЗАН", "Хаха, противник размазан.", "HLAComVoice/grunt/fakeout_success_03.wav")

-- Firing

Schema.voices.Add("Combine", "СТРЕЛЯЮ", "Стреляю!", "HLAComVoice/grunt/firing_01.wav")
Schema.voices.Add("Combine", "АТАКУЮ", "Атакую цель!", "HLAComVoice/grunt/firing_02.wav")
Schema.voices.Add("Combine", "ОТКРЫТЬ ОГОНЬ2", "Открыть огонь на противника!", "HLAComVoice/grunt/firing_03.wav")
Schema.voices.Add("Combine", "ОТКРЫТЬ ОГОНЬ3", "Открыть огонь!", "HLAComVoice/grunt/firing_04.wav")
Schema.voices.Add("Combine", "ОТКРЫТЬ ОГОНЬ4", "Врассыпную, открыть огонь.", "HLAComVoice/grunt/firing_06.wav")
Schema.voices.Add("Combine", "ОТКРЫТЬ ОГОНЬ5", "Подавить противника.", "HLAComVoice/grunt/firing_07.wav")
Schema.voices.Add("Combine", "ЗАЧИЩАЮ СЕКТОР", "Зачищаю сектор!", "HLAComVoice/grunt/firing_08.wav")
Schema.voices.Add("Combine", "ПОДТВЕРЖДЕНО", "Подтверждено.", "HLAComVoice/grunt/firing_09.wav")
Schema.voices.Add("Combine", "ПРОДВИГАЮСЬ ПО СЕКТОРУ", "Продвигаюсь по сектору.", "HLAComVoice/grunt/firing_10.wav")
Schema.voices.Add("Combine", "ПРОВОЖУ СТАБИЛИЗАЦИЮ", "Провожу стабилизацию главной цели!", "HLAComVoice/grunt/firing_120.wav")
Schema.voices.Add("Combine", "ОГОНЬ7", "Цель на прицеле!", "HLAComVoice/grunt/firing_130.wav")
Schema.voices.Add("Combine", "ОГОНЬ8", "Цель на прицеле и под обстрелом.", "HLAComVoice/grunt/firing_131.wav")
Schema.voices.Add("Combine", "ПРИМЕНЯЮ СИЛУ", "Применяю силу к главной цели.", "HLAComVoice/grunt/firing_140.wav")
Schema.voices.Add("Combine", "ОНИ НЕСУТ ПОТЕРИ", "Они несут потери.", "HLAComVoice/grunt/firing_150.wav")
Schema.voices.Add("Combine", "ОНИ НЕСУТ ПОТЕРИ2", "Они несут потери!", "HLAComVoice/grunt/firing_152.wav")
Schema.voices.Add("Combine", "ПОЧТИ ЗАКОНЧИЛИ", "Почти закончили.", "HLAComVoice/grunt/firing_160.wav")
Schema.voices.Add("Combine", "ЭТО ПОЧТИ ЗАКОНЧИЛОСЬ", "Это почти закончилось!", "HLAComVoice/grunt/firing_161.wav")
Schema.voices.Add("Combine", "ВЕДУ ОГОНЬ", "Веду огонь!", "HLAComVoice/grunt/firing_170.wav")
Schema.voices.Add("Combine", "ВЕДУ ОГОНЬ2", "Трачу все патроны на главную цель!", "HLAComVoice/grunt/firing_180.wav")
Schema.voices.Add("Combine", "НЕ СОПРОТИВЛЯЙТЕСЬ", "Не сопротивляйтесь.", "HLAComVoice/grunt/firing_200.wav")
Schema.voices.Add("Combine", "НЕ СОПРОТИВЛЯЙТЕСЬ2", "Не сопротивляйтесь!", "HLAComVoice/grunt/firing_201.wav")
Schema.voices.Add("Combine", "МОЛОТОБОЕЦ СТРЕЛЯЕТ", "Молотобоец в бою и стреляет.", "HLAComVoice/grunt/firing_210.wav")
Schema.voices.Add("Combine", "ОРДИНАЛ СТРЕЛЯЕТ", "Ординал в бою и стреляет.", "HLAComVoice/grunt/firing_220.wav")
Schema.voices.Add("Combine", "ПОДАВИТЕЛЬ СТРЕЛЯЕТ", "Подавитель в бою и стреляет.", "HLAComVoice/grunt/firing_230.wav")

-- Firing at Player/Alyx

Schema.voices.Add("Combine", "СТРЕЛЯЮ В ВИП", "Открываю огонь по цели номер один.", "HLAComVoice/grunt/firing_player_01.wav")
Schema.voices.Add("Combine", "СТРЕЛЯЮ В ВИП2", "Открываю огонь по нарушителю номер один.", "HLAComVoice/grunt/firing_player_04.wav")
Schema.voices.Add("Combine", "СТРЕЛЯЮ В ВИП3", "По нам ведется огонь, организовать ответ.", "HLAComVoice/grunt/firing_player_05.wav")
Schema.voices.Add("Combine", "СТРЕЛЯЮ В ВИП4", "Зверь попал в капкан.", "HLAComVoice/grunt/firing_player_07.wav")
Schema.voices.Add("Combine", "СТРЕЛЯЮ В ВИП5", "Сорвали куш, стреляем.", "HLAComVoice/grunt/firing_player_08.wav")

-- Flushing

Schema.voices.Add("Combine", "ЗАЧИЩАЮ", "Зачищаю последнее известное местоположение.", "HLAComVoice/grunt/flushing_01.wav")
Schema.voices.Add("Combine", "ЗАЧИЩАЮ2", "Распределяемся на 3...", "HLAComVoice/grunt/flushing_02.wav")
Schema.voices.Add("Combine", "ЗАЧИЩАЮ3", "Зачищаю сектор.", "HLAComVoice/grunt/flushing_03.wav")
Schema.voices.Add("Combine", "ЗАЧИЩАЮ4", "Прибыл на последнее известное местоположение.", "HLAComVoice/grunt/flushing_04.wav")
Schema.voices.Add("Combine", "ЗАЧИЩАЮ5", "Помечаю последнее местоположение противника, кидаю фальшфеер!", "HLAComVoice/grunt/flushing_05.wav")
Schema.voices.Add("Combine", "ЗАЧИЩАЮ6", "Зачищаю противника.", "HLAComVoice/grunt/flushing_06.wav")
Schema.voices.Add("Combine", "ЗАЧИЩАЮ7", "Гранату, гранату на последнее местоположение противника.", "HLAComVoice/grunt/flushing_07.wav")

-- Grenade Out

Schema.voices.Add("Combine", "ОТКРЫТ", "Я открыт.", "HLAComVoice/grunt/getback_01.wav")
Schema.voices.Add("Combine", "КИДАЮ2", "Кидаю из укрытия.", "HLAComVoice/grunt/getback_02.wav")
Schema.voices.Add("Combine", "ЗАПАЛ ЗАЖЖЕН", "Запал зажжен.", "HLAComVoice/grunt/getback_03.wav")
Schema.voices.Add("Combine", "ГРАНАТА", "Граната граната!", "HLAComVoice/grunt/getback_04.wav")
Schema.voices.Add("Combine", "ОТПУСКАЮ", "Отпускаю.", "HLAComVoice/grunt/getback_05.wav")

-- Hear Something

Schema.voices.Add("Combine", "АКТИВНОСТЬ", "Их слышно в секторе.", "HLAComVoice/grunt/hear_suspicious_01.wav")
Schema.voices.Add("Combine", "АКТИВНОСТЬ2", "Возможно наличие нарушителей.", "HLAComVoice/grunt/hear_suspicious_02.wav")
Schema.voices.Add("Combine", "АКТИВНОСТЬ3", "Слышу возможного противника.", "HLAComVoice/grunt/hear_suspicious_03.wav")
Schema.voices.Add("Combine", "ДВИЖЕНИЕ", "Движение.", "HLAComVoice/grunt/hear_suspicious_04.wav")
Schema.voices.Add("Combine", "ВНИМАНИЕ", "Внимание.", "HLAComVoice/grunt/hear_suspicious_05.wav")

-- Idle

Schema.voices.Add("Combine", "НИЧЕГО", "Ага, да, ничего, конец связи.", "HLAComVoice/grunt/idle_01.wav")
Schema.voices.Add("Combine", "ОЖИДАНИЕ", "Первый, четырнадцатый, третий, шестой, одинацатый, чисто. И все чисто у Эхо-4, твой черед, конец связи.", "HLAComVoice/grunt/idle_02.wav")
Schema.voices.Add("Combine", "ОЖИДАНИЕ2", "Принял. Продолжайте наблюдение за сектором кило-три-тире-шесть.", "HLAComVoice/grunt/idle_03.wav")
Schema.voices.Add("Combine", "ОЖИДАНИЕ3", "Передача принята, отрицательный запрос касаемо поддержки. Ах... Стоп, нет. В округе чисто, Конец связи.", "HLAComVoice/grunt/idle_06.wav")
Schema.voices.Add("Combine", "ОЖИДАНИЕ4", "Сектор наблюдается как нужно, стабилен. И... все еще ожидаю передачи, конец связи.", "HLAComVoice/grunt/idle_08.wav")
Schema.voices.Add("Combine", "ОЖИДАНИЕ5", "Надзор подтверждает изолирование сектора. Нарушитель номер один... Э... проявляет активность. Держите каналы связи открытыми.", "HLAComVoice/grunt/idle_09.wav")
Schema.voices.Add("Combine", "ОЖИДАНИЕ6", "Так точно, Текущий статус дельта-семь. Команда Заката передвигается. Вас понял", "HLAComVoice/grunt/idle_10.wav")
Schema.voices.Add("Combine", "ОЖИДАНИЕ7", "Никак нет, принял. Сектор чист. Не можем подтвердить присутствие цели номер один. Ожидаем вторичные коды.", "HLAComVoice/grunt/idle_11.wav")
Schema.voices.Add("Combine", "ОБНОВЛЕНИЕ БИОДАННЫХ", "Обновляю биоданные. Доза стимуляторов 32, патронов 78, топливо 100, жизненные показатели 73, слуховые устройства 3, датчики органики 15, Эхо выбыл.", "HLAComVoice/grunt/idle_12.wav")
Schema.voices.Add("Combine", "ОЖИДАНИЕ8", "Вас понял, высылаю мэнхеков на Апекс-5. У нас биотики по периметру . Эм... ожидаем контакта, конец связи.", "HLAComVoice/grunt/idle_13.wav")
Schema.voices.Add("Combine", "НЕИЗВЕСТНОЕ ЗАРАЖЕНИЕ", "Надзор подтверждает ... Эм, наличие неизвестного заражения. Внимание всем сотрудникам, приготовиться к контакту.", "HLAComVoice/grunt/idle_14.wav")
Schema.voices.Add("Combine", "НА МЕСТЕ", "Вас понял, на месте.", "HLAComVoice/grunt/idle_16.wav")
Schema.voices.Add("Combine", "ПОНЯЛ", "Понял.", "HLAComVoice/grunt/idle_17.wav")
Schema.voices.Add("Combine", "ПРИНЯТО ОБНОВЛЕНИЕ ", "Так точно, принято. Обновление биодатчиков мыслительного подавителя. Обновление состоится через три секунды. Несоответстие устранено.", "HLAComVoice/grunt/idle_18.wav")
Schema.voices.Add("Combine", "ОБНОВЛЕНИЕ НЕСООТВЕТСТВИЯ", "Надзор запрашивает обновление всех юнитов. Несоответствие будет устранено. Отрицательно, воспоминания тоже. Обновление получено, ринятие обязательно.", "HLAComVoice/grunt/idle_19.wav")
Schema.voices.Add("Combine", "ОЖИДАНИЕ9", "Команда стабилизации держит позиции. Датчики жизнеобеспечения 73, наушники... 15. Надзор подтверждает нахождение в периметре целей особой важности. Будьте наготове.", "HLAComVoice/grunt/idle_20.wav")

-- Injured

Schema.voices.Add("Combine", "МЕДИК", "Медик!", "HLAComVoice/grunt/injured_01.wav")
Schema.voices.Add("Combine", "РАНЕН", "Меня задело, нужна аптечка.", "HLAComVoice/grunt/injured_02.wav")
Schema.voices.Add("Combine", "РАНЕН2", "Под обстрелом.", "HLAComVoice/grunt/injured_03.wav")
Schema.voices.Add("Combine", "РАНЕН3", "Нужны баллоны.", "HLAComVoice/grunt/injured_04.wav")
Schema.voices.Add("Combine", "РАНЕН4", "Баллоны получены.", "HLAComVoice/grunt/injured_05.wav")
Schema.voices.Add("Combine", "ПОДСТРЕЛЕН", "Я ранен!", "HLAComVoice/grunt/injured_07.wav")

-- Laughter

Schema.voices.Add("Combine", "ХАХА2", "Хаха.", "HLAComVoice/grunt/laugh_01.wav")
Schema.voices.Add("Combine", "ХАХА3", "Хэхэ.", "HLAComVoice/grunt/laugh_02.wav")
Schema.voices.Add("Combine", "ХАХА4", "Хихи.", "HLAComVoice/grunt/laugh_03.wav")
Schema.voices.Add("Combine", "ХАХА5", "Хэхэ.", "HLAComVoice/grunt/laugh_04.wav")
Schema.voices.Add("Combine", "ХАХА6", "Хаха.", "HLAComVoice/grunt/laugh_05.wav")

-- Lost Enemy

Schema.voices.Add("Combine", "ПОТЕРЯ ВРАГА", "Потеря визуального контакта.", "HLAComVoice/grunt/lostenemy_01.wav")
Schema.voices.Add("Combine", "ЧЕРТ ВОЗЬМИ", "Черт возьми.", "HLAComVoice/grunt/lostenemy_02.wav")
Schema.voices.Add("Combine", "ПОТЕРЯ ВРАГА2", "Локация подтверждена!", "HLAComVoice/grunt/lostenemy_05.wav")
Schema.voices.Add("Combine", "ПОТЕРЯ ВРАГА3", "Вражеские силы не обнаружены.", "HLAComVoice/grunt/lostenemy_06.wav")
Schema.voices.Add("Combine", "ПОТЕРЯ ВРАГА4", "Нет признаков присутствия.", "HLAComVoice/grunt/lostenemy_07.wav")
Schema.voices.Add("Combine", "ПОТЕРЯ ВРАГА5", "Наблюдение не подтверждаю.", "HLAComVoice/grunt/lostenemy_08.wav")

-- Lost Visual

Schema.voices.Add("Combine", "ПОТЕРЯ ВИЗУАЛЬНОГО КОНТАКТА", "Враг скрылся, сектор не известен.", "HLAComVoice/grunt/lostvisual_01.wav")
Schema.voices.Add("Combine", "ПОТЕРЯ ВИЗУАЛЬНОГО КОНТАКТА2", "Запрашиваю положение врага.", "HLAComVoice/grunt/lostvisual_02.wav")
Schema.voices.Add("Combine", "ПОТЕРЯ ВИЗУАЛЬНОГО КОНТАКТА3", "Запрашиваю локацию.", "HLAComVoice/grunt/lostvisual_03.wav")
Schema.voices.Add("Combine", "ПОТЕРЯ ВИЗУАЛЬНОГО КОНТАКТА4", "Враг скрылся.", "HLAComVoice/grunt/lostvisual_04.wav")
Schema.voices.Add("Combine", "ПОТЕРЯ ВИЗУАЛЬНОГО КОНТАКТА5", "Помогите с навигацией.", "HLAComVoice/grunt/lostvisual_06.wav")
Schema.voices.Add("Combine", "НЕ ВИЖУ ЦЕЛЬ", "Не вижу цель. Надзор - ведите.", "HLAComVoice/grunt/lostvisual_08.wav")
Schema.voices.Add("Combine", "ПОТЕРЯ ВИЗУАЛЬНОГО КОНТАКТА6", "Возможное бегство, запрашиваю координаты!", "HLAComVoice/grunt/lostvisual_10.wav")
Schema.voices.Add("Combine", "ВОЗМОЖНОЕ БЕГСТВО", "Возможное бегство, запрашиваю локацию!", "HLAComVoice/grunt/lostvisual_10.wav")

-- Lost Visual - Player/Alyx

Schema.voices.Add("Combine", "ЦЕЛЬ ЗАТИХЛА", "Цель затихла, запрашиваю последний известный сектор нахождения.", "HLAComVoice/grunt/lostvisual_player_01.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ ПОТЕРЯНА", "У нас полностью утерян визуальный контакт с целью номер один.", "HLAComVoice/grunt/lostvisual_player_02.wav")
Schema.voices.Add("Combine", "ПРОТИВНИК ЗАТИХ", "Противник затих.", "HLAComVoice/grunt/lostvisual_player_03.wav")
Schema.voices.Add("Combine", "ДОЛОЖИТЬ", "Цель уклоняется — ординалу доложить!.", "HLAComVoice/grunt/lostvisual_player_04.wav")
Schema.voices.Add("Combine", "ПРОВЕРЯЮ УКРЫТИЕ", "Проверяю укрытие!", "HLAComVoice/grunt/lostvisual_player_05.wav")
Schema.voices.Add("Combine", "ПОТЕРЯН ВИЗУАЛЬНЫЙ КОНТАКТ", "Потерян визуальный контакт, рассредоточиться.", "HLAComVoice/grunt/lostvisual_player_07.wav")
Schema.voices.Add("Combine", "ЗАПРАШИВАЮ СОСТОЯНИЕ", "Все цели затихли, запрашиваю разведку.", "HLAComVoice/grunt/lostvisual_player_08.wav")

-- Near Panic

Schema.voices.Add("Combine", "СБЛИЖЕНИЕ", "Сближение!", "HLAComVoice/grunt/nearpanic_01.wav")
Schema.voices.Add("Combine", "СБЛИЖЕНИЕ2", "Подходят!", "HLAComVoice/grunt/nearpanic_02.wav")
Schema.voices.Add("Combine", "СТОООП", "Стоооп!", "HLAComVoice/grunt/nearpanic_03.wav")
Schema.voices.Add("Combine", "ПОДДЕРЖКА", "Запрашиваю поддержку, поддержку, поддержку!", "HLAComVoice/grunt/nearpanic_04.wav")
Schema.voices.Add("Combine", "ТВОЮ МАТЬ", "Твою ма-!", "HLAComVoice/grunt/nearpanic_05.wav")
Schema.voices.Add("Combine", "ОТХОДИМ", "Отходим назад, назад!", "HLAComVoice/grunt/nearpanic_07.wav")
Schema.voices.Add("Combine", "СЛИШКОМ БЛИЗКО", "Слишком близко, сменить позиции!", "HLAComVoice/grunt/nearpanic_10.wav")

-- Positive Response

Schema.voices.Add("Combine", "ПОНЯЛ", "Понял.", "HLAComVoice/grunt/orderresponse_positive_01.wav")
Schema.voices.Add("Combine", "ВАС ПОНЯЛ", "Вас понял.", "HLAComVoice/grunt/orderresponse_positive_02.wav")
Schema.voices.Add("Combine", "ПРИНЯЛ", "Принял.", "HLAComVoice/grunt/orderresponse_positive_03.wav")
Schema.voices.Add("Combine", "МОГУ", "Могу.", "HLAComVoice/grunt/orderresponse_positive_04.wav")
Schema.voices.Add("Combine", "ВЫПОЛНЯЮ", "Выполняю.", "HLAComVoice/grunt/orderresponse_positive_05.wav")
Schema.voices.Add("Combine", "ПОДТВЕРЖДАЮ", "Подтверждаю.", "HLAComVoice/grunt/orderresponse_positive_06.wav")

-- Taking Overwatch

Schema.voices.Add("Combine", "УДЕРЖИВАЮ3", "Держу позицию.", "HLAComVoice/grunt/overwatch_01.wav")
Schema.voices.Add("Combine", "ЗАКРЕПИЛИСЬ НА ТОЧКЕ", "Закрепились на точке.", "HLAComVoice/grunt/overwatch_02.wav")
Schema.voices.Add("Combine", "ОРУЖИЕ ГОТОВО", "Оружие готово.", "HLAComVoice/grunt/overwatch_03.wav")
Schema.voices.Add("Combine", "ЗАМЕЧЕН НА ЛОКАЦИИ", "Замечен на прошлой локации!", "HLAComVoice/grunt/overwatch_04.wav")
Schema.voices.Add("Combine", "СЛЕДИТЕ ЗА ПОЗИЦИЕЙ", "Следите за последней известной позицией!", "HLAComVoice/grunt/overwatch_05.wav")
Schema.voices.Add("Combine", "НАБЛЮДАЮ", "Наблюдаю.", "HLAComVoice/grunt/overwatch_06.wav")
Schema.voices.Add("Combine", "СОСРЕДОТОЧИТЬСЯ", "Сосредоточиться.", "HLAComVoice/grunt/overwatch_08.wav")
Schema.voices.Add("Combine", "ВСЕМ ТИХО", "Всем тихо, всем тихо!", "HLAComVoice/grunt/overwatch_09.wav")
Schema.voices.Add("Combine", "ПРОТИВНИК ДВИГАЕТСЯ", "Противник двигается, ожидайте.", "HLAComVoice/grunt/overwatch_10.wav")
Schema.voices.Add("Combine", "УДЕРЖИВАЮ", "Удерживаю.", "HLAComVoice/grunt/overwatch_11.wav")
Schema.voices.Add("Combine", "ОЖИДАЮ СТОЛКНОВЕНИЯ", "Ожидаю столкновения.", "HLAComVoice/grunt/overwatch_12.wav")
Schema.voices.Add("Combine", "ОЦЕНКА СИТУАЦИИ", "Оцениваю ситуацию.", "HLAComVoice/grunt/overwatch_13.wav")
Schema.voices.Add("Combine", "ОЖИДАЕМ ПРОБЛЕМЫ", "Ожидаем проблем.", "HLAComVoice/grunt/overwatch_14.wav")
Schema.voices.Add("Combine", "ГОТОВЫ К ЗАДЕРЖАНИЮ", "К задержанию готовы.", "HLAComVoice/grunt/overwatch_15.wav")
Schema.voices.Add("Combine", "УДЕРЖИВАЮ2", "Держу позицию.", "HLAComVoice/grunt/overwatch_16.wav")
Schema.voices.Add("Combine", "ВНИМАНИЕ", "Внимание!", "HLAComVoice/grunt/overwatch_17.wav")
Schema.voices.Add("Combine", "ОСМАТРИВАЮ ПЕРИМЕТР", "Осматриваю периметр.", "HLAComVoice/grunt/overwatch_20.wav")

-- Player/Alyx is Hurt

Schema.voices.Add("Combine", "ЦЕЛЬ ПОД РИСКОМ", "Цель под риском смерти.", "HLAComVoice/grunt/playerishurt_02.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ РАСКРЫТА", "Цель раскрыта.", "HLAComVoice/grunt/playerishurt_03.wav")
Schema.voices.Add("Combine", "ПОШЕЛ", "Пошел, пошел!", "HLAComVoice/grunt/playerishurt_04.wav")
Schema.voices.Add("Combine", "УТЕЧКА ТОПЛИВА", "Утечка топлива у противника.", "HLAComVoice/grunt/playerishurt_09.wav")
Schema.voices.Add("Combine", "ВИЖУ ГЛАВНОГО", "Вижу главного!", "HLAComVoice/grunt/playerishurt_10.wav")
Schema.voices.Add("Combine", "СМОТРЕТЬ В ОБА", "Смотреть в оба, код ноль-девять!", "HLAComVoice/grunt/playerishurt_11.wav")
Schema.voices.Add("Combine", "НЕ РАСХОДОВАТЬ АПТЕЧКИ", "Не тратьте аптечки на главную цель.", "HLAComVoice/grunt/playerishurt_12.wav")
Schema.voices.Add("Combine", "С ЦЕЛЬЮ ОДИН ПОКОНЧЕНО", "С целью номер один покончено.", "HLAComVoice/grunt/playerishurt_13.wav")

-- Reconnoiter - Finish

Schema.voices.Add("Combine", "ВСЕ СЕКТОРЫ СКАНИРОВАНЫ", "Завершено сканирование секторов.", "HLAComVoice/grunt/reconnoiter_01.wav")
Schema.voices.Add("Combine", "НЕТ СИГНАЛОВ", "Сигналов не обнаружено.", "HLAComVoice/grunt/reconnoiter_02.wav")
Schema.voices.Add("Combine", "СЕКТОР ЧИСТ", "В секторе чисто, ждем дальнейших указаний.", "HLAComVoice/grunt/reconnoiter_03.wav")
Schema.voices.Add("Combine", "ОБЛАСТЬ ЧИСТА", "В округе никого.", "HLAComVoice/grunt/reconnoiter_04.wav")
Schema.voices.Add("Combine", "ВРАГ ЗАТИХ", "Враг затих.", "HLAComVoice/grunt/reconnoiter_05.wav")
Schema.voices.Add("Combine", "НЕТ КОНТАКТА", "Не наблюдаю вражеских сил.", "HLAComVoice/grunt/reconnoiter_06.wav")
Schema.voices.Add("Combine", "ТЕРРИТОРИЯ ЗАЧИЩЕНА ", "Территория зачищена.", "HLAComVoice/grunt/reconnoiter_07.wav")
Schema.voices.Add("Combine", "ВЫГЛЯДИТ ЧИСТО", "Выглядит чисто.", "HLAComVoice/grunt/reconnoiter_08.wav")
Schema.voices.Add("Combine", "КОНТАКТ ПОТЕРЯН", "Контакт потерян, выглядит чисто.", "HLAComVoice/grunt/reconnoiter_09.wav")
Schema.voices.Add("Combine", "ЗДЕСЬ ПУСТО", "Здесь пусто.", "HLAComVoice/grunt/reconnoiter_10.wav")
Schema.voices.Add("Combine", "ОСТАВАТЬСЯ НАГОТОВЕ", "Оставаться наготове.", "HLAComVoice/grunt/reconnoiter_11.wav")
Schema.voices.Add("Combine", "ПУСТО", "Пусто.", "HLAComVoice/grunt/reconnoiter_14.wav")
Schema.voices.Add("Combine", "ЧИСТО", "Чисто.", "HLAComVoice/grunt/reconnoiter_15.wav")
Schema.voices.Add("Combine", "ЗАПРОС КОДА ТЕНЬ", "Запрашиваю окончание протокола тень.", "HLAComVoice/grunt/reconnoiter_16.wav")
Schema.voices.Add("Combine", "НЕ ТУТ", "Тут никого.", "HLAComVoice/grunt/reconnoiter_18.wav")
Schema.voices.Add("Combine", "ЛОКАЦИЯ ЧИСТА", "Локация зачищена, поддержка не требуется.", "HLAComVoice/grunt/reconnoiter_19.wav")
Schema.voices.Add("Combine", "ВСЕ СЕКТОРЫ ЧИСТЫ", "Все секторы зачищены, отходим.", "HLAComVoice/grunt/reconnoiter_20.wav")

-- Reconnoiter - Searching

Schema.voices.Add("Combine", "ПОИСК2", "Установка наблюдения в процессе.", "HLAComVoice/grunt/reconnoiter_search_01.wav")
Schema.voices.Add("Combine", "ЕЩЕ ВЕДУ ПОИСК", "Еще веду поиск.", "HLAComVoice/grunt/reconnoiter_search_02.wav")
Schema.voices.Add("Combine", "ЕЩЁ ЗАЧИЩАЮ", "Все еще зачищаю.", "HLAComVoice/grunt/reconnoiter_search_03.wav")
Schema.voices.Add("Combine", "ЕЩЕ СКАНИРУЮ", "Еще сканирую.", "HLAComVoice/grunt/reconnoiter_search_04.wav")
Schema.voices.Add("Combine", "ПОИСК3", "Разведка в процессе.", "HLAComVoice/grunt/reconnoiter_search_05.wav")
Schema.voices.Add("Combine", "ТЕНЬ АКТИВИРОВАН", "Начат протокол тень.", "HLAComVoice/grunt/reconnoiter_search_06.wav")
Schema.voices.Add("Combine", "РАЗВЕДКА В ПРОЦЕССЕ", "Разведка в процессе.", "HLAComVoice/grunt/reconnoiter_search_07.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ ВСЕ ЕЩЕ СКРЫВАЕТСЯ", "Цель все еще скрывается.", "HLAComVoice/grunt/reconnoiter_search_09.wav")
Schema.voices.Add("Combine", "СЕКТОР ЧИСТ", "Сектор чист.", "HLAComVoice/grunt/reconnoiter_search_10.wav")
Schema.voices.Add("Combine", "ПУСТОЙ СЕКТОР", "Пустой сектор, идем дальше.", "HLAComVoice/grunt/reconnoiter_search_11.wav")
Schema.voices.Add("Combine", "ОБЛАСТЬ ЧИСТА", "Область чиста, заходим.", "HLAComVoice/grunt/reconnoiter_search_12.wav")
Schema.voices.Add("Combine", "ПРОДОЛЖАЮ НАБЛЮДЕНИЕ", "Продолжаю наблюдение.", "HLAComVoice/grunt/reconnoiter_search_13.wav")
Schema.voices.Add("Combine", "ПУСТО2", "Ничего.", "HLAComVoice/grunt/reconnoiter_search_14.wav")
Schema.voices.Add("Combine", "ВРАГА НЕ ВИДНО", "Врага не видно.", "HLAComVoice/grunt/reconnoiter_search_15.wav")
Schema.voices.Add("Combine", "СКАНИРОВАНИЕ ЗАВЕРШЕНО", "Сканирование закончено, продолжаю.", "HLAComVoice/grunt/reconnoiter_search_16.wav")
Schema.voices.Add("Combine", "НЕТ ВИЗУАЛЬНОГО КОНТАКТА", "Все еще вне зрения.", "HLAComVoice/grunt/reconnoiter_search_17.wav")
Schema.voices.Add("Combine", "ОКРУГА ЧИСТА", "Округа чиста, продолжаем.", "HLAComVoice/grunt/reconnoiter_search_18.wav")

-- Reconnoiter - Start

Schema.voices.Add("Combine", "РАССРЕДОТОЧИТЬСЯ", "Рассредоточиться.", "HLAComVoice/grunt/reconnoiter_start_01.wav")
Schema.voices.Add("Combine", "ВЫСТАВЛЯЮ УСЛОВИЕ АЛЬФА", "Выставляю условие альфа.", "HLAComVoice/grunt/reconnoiter_start_02.wav")
Schema.voices.Add("Combine", "РАСПРОСТРАНЕНИЕ", "Распространяю.", "HLAComVoice/grunt/reconnoiter_start_03.wav")
Schema.voices.Add("Combine", "СМОТРЕТЬ В ОБА", "Смотреть в оба.", "HLAComVoice/grunt/reconnoiter_start_05.wav")
Schema.voices.Add("Combine", "РАЗВЕРТЫВАНИЕ И СКАНИРОВАНИЕ", "Развернут и начинаю сканирование.", "HLAComVoice/grunt/reconnoiter_start_06.wav")
Schema.voices.Add("Combine", "НАЧИНАЮ ЗАЧИСТКУ", "Начинаю зачистку.", "HLAComVoice/grunt/reconnoiter_start_07.wav")
Schema.voices.Add("Combine", "ДОКЛАД ОБСТАНОВКИ", "Докладываю обстановку.", "HLAComVoice/grunt/reconnoiter_start_08.wav")
Schema.voices.Add("Combine", "ПОИСК ВРАГОВ", "Высматриваю врагов.", "HLAComVoice/grunt/reconnoiter_start_09.wav")
Schema.voices.Add("Combine", "ПОИСК ПОДОЗРЕВАЕМОГО", "Ищу подозреваемого.", "HLAComVoice/grunt/reconnoiter_start_10.wav")
Schema.voices.Add("Combine", "ПОИСК", "Веду поиск.", "HLAComVoice/grunt/reconnoiter_start_11.wav")
Schema.voices.Add("Combine", "ПРИСТУПАЮ К ЗАДЕРЖАНИЮ", "Приступаю к задержанию.", "HLAComVoice/grunt/reconnoiter_start_13.wav")
Schema.voices.Add("Combine", "ПОДТВЕРДИТЬ НАБЛЮДЕНИЕ", "Вас понял, юниты — наблюдать!.", "HLAComVoice/grunt/reconnoiter_start_14.wav")
Schema.voices.Add("Combine", "СКАНИРОВАТЬ ОБЛАСТЬ", "Сканировать область.", "HLAComVoice/grunt/reconnoiter_start_16.wav")
Schema.voices.Add("Combine", "ПРОТОКОЛ ТЕНЬ", "Инициировать протокол тень.", "HLAComVoice/grunt/reconnoiter_start_17.wav")

-- Refind Enemy

Schema.voices.Add("Combine", "ЦЕЛЬ ЗАХВАЧЕНА", "Цель захвачена!", "HLAComVoice/grunt/refindenemy_02.wav")
Schema.voices.Add("Combine", "ВИЗУАЛЬНЫЙ КОНТАКТ", "Визуальный контакт, контакт!", "HLAComVoice/grunt/refindenemy_03.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ ОБНАРУЖЕНА", "Цель обнаружена!", "HLAComVoice/grunt/refindenemy_04.wav")
Schema.voices.Add("Combine", "ВИЗУАЛЬНЫЙ КОНТАКТ2", "Контакт, вижу цель!", "HLAComVoice/grunt/refindenemy_05.wav")
Schema.voices.Add("Combine", "СЮДА", "Сюда!", "HLAComVoice/grunt/refindenemy_06.wav")
Schema.voices.Add("Combine", "ДВИЖЕНИЕ", "Движение!", "HLAComVoice/grunt/refindenemy_07.wav")
Schema.voices.Add("Combine", "КОНТАКТ", "Контакт с врагом!", "HLAComVoice/grunt/refindenemy_09.wav")
Schema.voices.Add("Combine", "ВПЕРЕД ВПЕРЕД ВПЕРЕД", "Вперед вперед вперед!", "HLAComVoice/grunt/refindenemy_10.wav")
Schema.voices.Add("Combine", "ВРАГ ЖИВ", "Противник жив, проверить округу.", "HLAComVoice/grunt/refindenemy_12.wav")
Schema.voices.Add("Combine", "НАВОДКА", "Подтверждаю наведение на цель.", "HLAComVoice/grunt/refindenemy_13.wav")
Schema.voices.Add("Combine", "НАВОДКА2", "Навелся на цель номер один.", "HLAComVoice/grunt/refindenemy_14.wav")
Schema.voices.Add("Combine", "ПОДТВЕРЖДАЮ ЛОКАЦИЮ", "Локация подтверждена, провожу стабилизацию.", "HLAComVoice/grunt/refindenemy_16.wav")

-- Reload

Schema.voices.Add("Combine", "ПЕРЕЗАРЯДКА", "Перезарядка!", "HLAComVoice/grunt/reload_01.wav")
Schema.voices.Add("Combine", "ПЕРЕЗАРЯДКА6", "Перезарядить оружие!", "HLAComVoice/grunt/reload_02.wav")
Schema.voices.Add("Combine", "ПЕРЕЗАРЯДКА3", "Перезаряжаюсь!", "HLAComVoice/grunt/reload_05.wav")
Schema.voices.Add("Combine", "ПЕРЕЗАРЯДКА2", "Пустой!", "HLAComVoice/grunt/reload_06.wav")
Schema.voices.Add("Combine", "ПЕРЕЗАРЯДКА4", "Боезапас на исходе, перезаряжаюсь!", "HLAComVoice/grunt/reload_08.wav")
Schema.voices.Add("Combine", "ПЕРЕЗАРЯДКА5", "Зарядить оружие!", "HLAComVoice/grunt/reload_09.wav")

-- Retreat

Schema.voices.Add("Combine", "УХОДИМ", "Уходим!", "HLAComVoice/grunt/retreat_01.wav")
Schema.voices.Add("Combine", "УХОДИМ2", "Уходим, уходим!", "HLAComVoice/grunt/retreat_02.wav")
Schema.voices.Add("Combine", "ОТСТУПАЕМ", "Отступаем!", "HLAComVoice/grunt/retreat_04.wav")
Schema.voices.Add("Combine", "ОТСТУПЛЕНИЕ", "Отходим!", "HLAComVoice/grunt/retreat_05.wav")
Schema.voices.Add("Combine", "СЛИШКОМ ЖАРКО", "В секторе становиться слишком жарко!", "HLAComVoice/grunt/retreat_06.wav")
Schema.voices.Add("Combine", "ПОИСК УКРЫТИЯ", "Ищу укрытие!", "HLAComVoice/grunt/retreat_07.wav")
Schema.voices.Add("Combine", "ПЕРЕГРУППИРОВКА", "Перегруппироваться.", "HLAComVoice/grunt/retreat_08.wav")
Schema.voices.Add("Combine", "ВЫХОДИМ", "Выходим!", "HLAComVoice/grunt/retreat_09.wav")

-- Target has Company / Multiple Targets

Schema.voices.Add("Combine", "ВИЖУ НЕИЗВЕСТНЫХ", "Вижу неизвестных.", "HLAComVoice/grunt/sees_company_01.wav")
Schema.voices.Add("Combine", "НЕСКОЛЬКО НЕИЗВЕСТНЫХ", "Наблюдение на нескольких неизвестных.", "HLAComVoice/grunt/sees_company_02.wav")
Schema.voices.Add("Combine", "НАБЛЮДЕНИЕ ЗА ВТОРОСТЕПЕННЫМИ", "Наблюдаем за неизвестными.", "HLAComVoice/grunt/sees_company_03.wav")
Schema.voices.Add("Combine", "ПРОВЕРКА СИЛУЭТОВ", "Судя по силуэтам их несколько.", "HLAComVoice/grunt/sees_company_04.wav")
Schema.voices.Add("Combine", "НЕСКОЛЬКО НАРУШИТЕЛЕЙ", "У нас тут несколько нарушителей.", "HLAComVoice/grunt/sees_company_05.wav")

-- Target has Grenades

Schema.voices.Add("Combine", "ВИЖУ ГРАНАТЫ", "У цели есть гранаты.", "HLAComVoice/grunt/sees_grenades_01.wav")
Schema.voices.Add("Combine", "ВИЖУ ГРАНАТЫ2", "У врага есть гранаты, осоторожнее.", "HLAComVoice/grunt/sees_grenades_02.wav")
Schema.voices.Add("Combine", "ВИЖУ ГРАНАТЫ3", "Враг вооружен гранатами!", "HLAComVoice/grunt/sees_grenades_03.wav")
Schema.voices.Add("Combine", "ВИЖУ ГРАНАТЫ4", "Внимание наземной группе, у врагов гранаты.", "HLAComVoice/grunt/sees_grenades_04.wav")

-- Target is Reloading

Schema.voices.Add("Combine", "ВИЖУ ПЕРЕЗАРЯДКУ", "Враг перезаряжается, стреляй!", "HLAComVoice/grunt/sees_reloading_01.wav")
Schema.voices.Add("Combine", "ВИЖУ ПЕРЕЗАРЯДКУ2", "Цель перезаряжается, открыть огонь!", "HLAComVoice/grunt/sees_reloading_02.wav")
Schema.voices.Add("Combine", "ВИЖУ ПЕРЕЗАРЯДКУ3", "Одерживаем преимущество.", "HLAComVoice/grunt/sees_reloading_03.wav")
Schema.voices.Add("Combine", "ВИЖУ ПЕРЕЗАРЯДКУ4", "Противник уязвим.", "HLAComVoice/grunt/sees_reloading_04.wav")

-- Target has Upgrades

Schema.voices.Add("Combine", "ВИЖУ УЛУЧШЕНИЯ", "У цели номер один модернизированные патроны.", "HLAComVoice/grunt/sees_upgrades_01.wav")
Schema.voices.Add("Combine", "ВИЖУ УЛУЧШЕНИЯ2", "Надзор, у первой цели модернизации.", "HLAComVoice/grunt/sees_upgrades_02.wav")
Schema.voices.Add("Combine", "ВИЖУ УЛУЧШЕНИЯ3", "Внимание наземной группе, у цели один модернизированное оружие.", "HLAComVoice/grunt/sees_upgrades_03.wav")
Schema.voices.Add("Combine", "ВИЖУ УЛУЧШЕНИЯ4", "Визуальный контакт, незаконное оружие.", "HLAComVoice/grunt/sees_upgrades_04.wav")
Schema.voices.Add("Combine", "ВИЖУ УЛУЧШЕНИЯ5", "Модернизации идентифицированы, действуйте осторожно .", "HLAComVoice/grunt/sees_upgrades_05.wav")

-- Squad Member Down

Schema.voices.Add("Combine", "МИНУС ОДИН2", "Надзор, запрашиваем подкрепление!", "HLAComVoice/grunt/squadmemberlost_01.wav")
Schema.voices.Add("Combine", "МИНУС ОДИН3", "Надзор, в секторе небезопасно!", "HLAComVoice/grunt/squadmemberlost_02.wav")
Schema.voices.Add("Combine", "ПРОРЫВ", "Прорыв, прорыв, прорыв!", "HLAComVoice/grunt/squadmemberlost_03.wav")
Schema.voices.Add("Combine", "МИНУС ОДИН4", "Надзор, наземный юнит на позиции, сектор неконтролируем!", "HLAComVoice/grunt/squadmemberlost_05.wav")
Schema.voices.Add("Combine", "МИНУС ОДИН5", "Надзор фиксирую прорыв сектора, повторяю, прорыв сектора!", "HLAComVoice/grunt/squadmemberlost_06.wav")
Schema.voices.Add("Combine", "МИНУС ОДИН6", "Надзор, запрашиваю прикрытие с возуха!", "HLAComVoice/grunt/squadmemberlost_07.wav")
Schema.voices.Add("Combine", "МИНУС ОДИН7", "Преимущество потеряно, приготовиться к проблемам!", "HLAComVoice/grunt/squadmemberlost_08.wav")
Schema.voices.Add("Combine", "МИНУС ОДИН8", "Надзор, рекомендуйте новое построение.", "HLAComVoice/grunt/squadmemberlost_09.wav")
Schema.voices.Add("Combine", "МИНУС ОДИН", "Свой выбит!", "HLAComVoice/grunt/squadmemberlost_10.wav")

-- Squad Down, Last Man

Schema.voices.Add("Combine", "СРОЧНОЕ ПРИКРЫТИЕ", "Ах, срочно нужен протокол тень!", "HLAComVoice/grunt/squadmemberlost_lastman_03.wav")
Schema.voices.Add("Combine", "ПРОЛОМ НЕКОНТРОЛИРУЕМ", "Надзор, пролом неконтролируем!", "HLAComVoice/grunt/squadmemberlost_lastman_04.wav")
Schema.voices.Add("Combine", "НЕТ НАЗЕМНОЙ КОМАНДЫ", "Надзор, наземной команды не осталось!", "HLAComVoice/grunt/squadmemberlost_lastman_06.wav")
Schema.voices.Add("Combine", "СПАСАТЕЛЬНЫЙ МАЯЧОК", "Активирован спасательный маячок!", "HLAComVoice/grunt/squadmemberlost_lastman_07.wav")

-- Squad Leader Down

Schema.voices.Add("Combine", "ЛИДЕР УМЕР", "Надзор, командующий убит!", "HLAComVoice/grunt/squadmemberlost_leader_01.wav")
Schema.voices.Add("Combine", "ЛИДЕР УМЕР2", "Нет связи с командующим, запрашиваю помощь!", "HLAComVoice/grunt/squadmemberlost_leader_02.wav")
Schema.voices.Add("Combine", "ЛИДЕР УМЕР3", "Надзор, командующий ушёл в закат - подтвердить!", "HLAComVoice/grunt/squadmemberlost_leader_03.wav")
Schema.voices.Add("Combine", "ЛИДЕР УМЕР4", "Командующий скончался.", "HLAComVoice/grunt/squadmemberlost_leader_04.wav")
Schema.voices.Add("Combine", "ЛИДЕР УМЕР5", "Командующий затих. Полный самоконтроль!", "HLAComVoice/grunt/squadmemberlost_leader_06.wav")
Schema.voices.Add("Combine", "ЛИДЕР УМЕР6", "Командующий обнулен.", "HLAComVoice/grunt/squadmemberlost_leader_07.wav")

-- Suppressing

Schema.voices.Add("Combine", "ПОДАВЛЯЮ", "Подавляю!", "HLAComVoice/grunt/suppressing_01.wav")
Schema.voices.Add("Combine", "ПОДАВЛЯЮ2", "Огонь на поражение!", "HLAComVoice/grunt/suppressing_02.wav")
Schema.voices.Add("Combine", "ПОДАВЛЯЮ", "Залп по последней позиции!", "HLAComVoice/grunt/suppressing_05.wav")
Schema.voices.Add("Combine", "ПОДАВЛЯЮ4", "Направляйте огонь на последнюю известную позицию!", "HLAComVoice/grunt/suppressing_06.wav")

-- Taking Fire

Schema.voices.Add("Combine", "ПОД ОБСТРЕЛОМ", "Под обстрелом, повреждений нет!", "HLAComVoice/grunt/takingfire_01.wav")
Schema.voices.Add("Combine", "ПРОМАЗАЛ", "Промазал!", "HLAComVoice/grunt/takingfire_02.wav")
Schema.voices.Add("Combine", "ОШИБКА ЦЕЛИ", "Цель ошибласть, захватываем преимущество!", "HLAComVoice/grunt/takingfire_03.wav")
Schema.voices.Add("Combine", "НЕТОЧЕН", "Враг неточен.", "HLAComVoice/grunt/takingfire_04.wav")
Schema.voices.Add("Combine", "ПОЧТИ", "Почти!", "HLAComVoice/grunt/takingfire_05.wav")
Schema.voices.Add("Combine", "НАРАСТИМ ПРЕИМУЩЕСТВО", "Построим преимущество на ошибке врага!", "HLAComVoice/grunt/takingfire_06.wav")
Schema.voices.Add("Combine", "ОШИБКА ЦЕЛИ", "Цель оплошалась!", "HLAComVoice/grunt/takingfire_08.wav")
Schema.voices.Add("Combine", "ВРАГ ДОПУСТИЛ ОШИБКУ", "Враг ошибся, вперед!", "HLAComVoice/grunt/takingfire_10.wav")
Schema.voices.Add("Combine", "ОШИБКА ЦЕЛИ3", "Оружие врага неэффективно, цель не подготовлена!", "HLAComVoice/grunt/takingfire_11.wav")

-- Taunts

Schema.voices.Add("Combine", "ВРАГ ПАНИКУЕТ", "Враг испытывает огромную панику.", "HLAComVoice/grunt/taunt_010.wav")
Schema.voices.Add("Combine", "ВРАГ ПРОРВАН", "Враг не справляется с натиском.", "HLAComVoice/grunt/taunt_020.wav")
Schema.voices.Add("Combine", "ЗАМЕЧАНИЕ4", "Врагу с низкой моралью.", "HLAComVoice/grunt/taunt_031.wav")
Schema.voices.Add("Combine", "ВЫ МОЖЕТЕ ВЫХОДИТЬ", "Вы можете выходить теперь!", "HLAComVoice/grunt/taunt_042.wav")
Schema.voices.Add("Combine", "МЫ ВАМ ПОМОЖЕМ", "Мы можем помочь вам, это безопасно!", "HLAComVoice/grunt/taunt_051.wav")
Schema.voices.Add("Combine", "ПОДОЗРЕВАЕМЫЙ АГРЕССИВЕН", "Подозреваемый действует выше дозволенного уровня агрессии, приступить к задержанию!", "HLAComVoice/grunt/taunt_060.wav")
Schema.voices.Add("Combine", "ВОЙТИ В БОЙ", "Войти в бой!", "HLAComVoice/grunt/taunt_070.wav")
Schema.voices.Add("Combine", "ВРАГ КОЛЕБЛЕТСЯ", "Враг колеблется!", "HLAComVoice/grunt/taunt_081.wav")
Schema.voices.Add("Combine", "ВРАЖЕСКИЕ АТАКИ НЕЭФФЕКТИВНЫ", "Атаки врага неэффективны, приступить к задержанию!", "HLAComVoice/grunt/taunt_090.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ ЭТО ДРУГ", "Прекратить огонь, цель дружеская!", "HLAComVoice/grunt/taunt_111.wav")
Schema.voices.Add("Combine", "ЖДИТЕ", "Ожидайте, код 10-40.", "HLAComVoice/grunt/taunt_120.wav")
Schema.voices.Add("Combine", "ПРЕКРАТИТЬ ОГОНЬ", "Прекратить огонь, цель не враждебна!", "HLAComVoice/grunt/taunt_131.wav")
Schema.voices.Add("Combine", "МЕРЫ ПРИНЯТЫ", "Так точно, не стрелять. выполняем.", "HLAComVoice/grunt/taunt_140.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ ДРУЖЕСТВЕННА", "Цель дружественна!", "HLAComVoice/grunt/taunt_150.wav")
Schema.voices.Add("Combine", "НЕ СТРЕЛЯТЬ ПО СВОИМ", "Прекратить наступление, цель дружественна!", "HLAComVoice/grunt/taunt_151.wav")
Schema.voices.Add("Combine", "НЕ СТРЕЛЯТЬ ПО СВОИМ2", "Всем юнитам, отбой, цель дружественна.", "HLAComVoice/grunt/taunt_152.wav")
Schema.voices.Add("Combine", "ПОДТВЕРДИТЬ ДРУЖЕСТВЕННОСТЬ", "Подтверждаю дружественность, прекратить огонь!", "HLAComVoice/grunt/taunt_160.wav")
Schema.voices.Add("Combine", "НУЖНО РАЗВЕДАТЬ", "Надзор, нам нужно разведать и пронаблюдать.", "HLAComVoice/grunt/taunt_171.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ НЕЗНАЧИТЕЛЬНАЯ", "Так точно, цель незначительной важности.", "HLAComVoice/grunt/taunt_182.wav")
Schema.voices.Add("Combine", "ЗАМЕЧАНИЕ5", "Враг показывает изнуренность, приготовиться к задержанию!", "HLAComVoice/grunt/taunt_200.wav")

-- Negative Response

Schema.voices.Add("Combine", "НИКАК НЕТ", "Никак нет.", "HLAComVoice/grunt/unabletocommence_01.wav")
Schema.voices.Add("Combine", "НЕ МОГУ ИСПОЛНИТЬ", "Эм… не могу исполнить.", "HLAComVoice/grunt/unabletocommence_02.wav")
Schema.voices.Add("Combine", "ОТРИЦАТЕЛЬНО", "Отрицательно.", "HLAComVoice/grunt/unabletocommence_03.wav")
Schema.voices.Add("Combine", "НЕТ", "Нет.", "HLAComVoice/grunt/unabletocommence_04.wav")
Schema.voices.Add("Combine", "ОТКЛОНЕНО", "Отклонено.", "HLAComVoice/grunt/unabletocommence_05.wav")
Schema.voices.Add("Combine", "НЕ МОГУ", "Не могу исполнить.", "HLAComVoice/grunt/unabletocommence_06.wav")
Schema.voices.Add("Combine", "НИКАК НЕТ2", "Не представляется возможным.", "HLAComVoice/grunt/unabletocommence_07.wav")

-- Under Attack

Schema.voices.Add("Combine", "ПОД ОБСТРЕЛОМ", "Под обстрелом, сформироваться!", "HLAComVoice/grunt/underattack_01.wav")
Schema.voices.Add("Combine", "ПОД ОБСТРЕЛОМ2", "Враг активен!", "HLAComVoice/grunt/underattack_02.wav")
Schema.voices.Add("Combine", "ПОД ОБСТРЕЛОМ3", "Рассредоточиться.", "HLAComVoice/grunt/underattack_06.wav")
Schema.voices.Add("Combine", "ПОД ОБСТРЕЛОМ4", "Цель захвачена, разрешаю огонь!", "HLAComVoice/grunt/underattack_07.wav")
Schema.voices.Add("Combine", "ПОД ОБСТРЕЛОМ5", "Враг сопротивляется!", "HLAComVoice/grunt/underattack_08.wav")
Schema.voices.Add("Combine", "ПОД ОБСТРЕЛОМ6", "Надзор, у нас огневой контакт!", "HLAComVoice/grunt/underattack_09.wav")
Schema.voices.Add("Combine", "ПОД ОБСТРЕЛОМ7", "Ох, готовим маневр дельта!", "HLAComVoice/grunt/underattack_10.wav")
Schema.voices.Add("Combine", "ПОД ОБСТРЕЛОМ8", "Под обстрелом!", "HLAComVoice/grunt/underattack_11.wav")
Schema.voices.Add("Combine", "ОТВЕТИТЬ", "Ответить со всех орудий!", "HLAComVoice/grunt/underattack_12.wav")

-- Choreo Lines, Grunt1

Schema.voices.Add("Combine", "РУКИ ВВЕРХ", "Руки вверх, ни с места!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0001.wav")
Schema.voices.Add("Combine", "НАЗАД", "Назад!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0002.wav")
Schema.voices.Add("Combine", "СТОП НАЗАД", "Стоп, назад!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0003.wav")
Schema.voices.Add("Combine", "РУКИ ОТ КНОПКИ", "Руки от кнопки!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0004.wav")
Schema.voices.Add("Combine", "НЕ ТРОГАТЬ КНОПКУ", "Не трогай кнопку!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0005.wav")
Schema.voices.Add("Combine", "НЕСЕМ ПОТЕРИ", "Надзор, мы понесли тяжелые потери от цели один.", "HLAComVoice/Grunt/Choreo/Grunt1/29_0006.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ ОБНАРУЖЕНА", "Цель обнаружена, отступить назад и переоснастится!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0007.wav")
Schema.voices.Add("Combine", "ЭЙ ОСТОРОЖНЕЕ", "Эй, осторожнее. Я не хочу проронить и капли этого дерьма на себя.", "HLAComVoice/Grunt/Choreo/Grunt1/29_0008.wav")
Schema.voices.Add("Combine", "МЫ СБРАСЫВАЕМ ЭТО", "Мы сбрасываем это в яму не потому что оно безопасное. Двигаемся.", "HLAComVoice/Grunt/Choreo/Grunt1/29_0009.wav")
Schema.voices.Add("Combine", "ЦЕЛЬ ПОДТВЕРЖДЕНА", "Цель подтверждена, цель подтверждена", "HLAComVoice/Grunt/Choreo/Grunt1/29_0015.wav")
Schema.voices.Add("Combine", "ДЕРЖИ РУКИ ПОДНЯТЫМИ", "Держи руки поднятыми!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0019.wav")
Schema.voices.Add("Combine", "ТАК И ДЕРЖИ", "Так и держи!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0019.wav")
Schema.voices.Add("Combine", "РУКИ ВВЕРХ ЧТОБЫ ВИДЕЛ", "Руки так ,что бы я их видел!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0020.wav")
Schema.voices.Add("Combine", "РУКИ ВВЕРХ2", "Руки в верх, я сказал!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0021.wav")
Schema.voices.Add("Combine", "РУКИ ВВЕРХ", "Руки вверх!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0021.wav")
Schema.voices.Add("Combine", "ПОДНИМИ РУКИ", "Подними руки!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0022.wav")
Schema.voices.Add("Combine", "РУКИ ВВЕРХ3", "Руки вверх!", "HLAComVoice/Grunt/Choreo/Grunt1/29_0022.wav")
Schema.voices.Add("Combine", "ОНА ЧИСТА", "У нее ничего.", "HLAComVoice/Grunt/Choreo/Grunt1/29_0023.wav")
Schema.voices.Add("Combine", "НАЗАД3", "Назад!", "HLAComVoice/Grunt/Choreo/Grunt1/29_00033.wav")
Schema.voices.Add("Combine", "ДВИГАЙСЯ2", "Двигайся!", "HLAComVoice/Grunt/Choreo/Grunt1/29_00500.wav")
Schema.voices.Add("Combine", "ВПЕРЕД", "Вперед!", "HLAComVoice/Grunt/Choreo/Grunt1/29_00501.wav")
Schema.voices.Add("Combine", "ТЫ ДВИГАЙСЯ", "Ты, двигайся.", "HLAComVoice/Grunt/Choreo/Grunt1/29_00502.wav")
Schema.voices.Add("Combine", "ПРОДВИГАЙСЯ2", "Продвигайся.", "HLAComVoice/Grunt/Choreo/Grunt1/29_00503.wav")
Schema.voices.Add("Combine", "ПРОДОЛЖАЙ ДВИГАТЬСЯ", "Ты, продолжай двигаться.", "HLAComVoice/Grunt/Choreo/Grunt1/29_00504.wav")
Schema.voices.Add("Combine", "УЙДИ С УЛИЦЫ", "Уйди с улицы, сейчас.", "HLAComVoice/Grunt/Choreo/Grunt1/29_00505.wav")
Schema.voices.Add("Combine", "ВОЗВРАЩАЙСЯ В ЖИЛУЮ ЯЧЕЙКУ", "Возвращайся в свою жилую ячейку, сейчас!", "HLAComVoice/Grunt/Choreo/Grunt1/29_00506.wav")
Schema.voices.Add("Combine", "ПРОХОДИ3", "Проходи.", "HLAComVoice/Grunt/Choreo/Grunt1/29_00507.wav")
Schema.voices.Add("Combine", "ПРОХОДИ2", "Не задерживайся.", "HLAComVoice/Grunt/Choreo/Grunt1/2900508_.wav")
Schema.voices.Add("Combine", "ТЫ ЧИСТ ПРОХОДИ2", "Ты чист, проходи.", "HLAComVoice/Grunt/Choreo/Grunt1/29_00509.wav")
Schema.voices.Add("Combine", "ЗАЛЕЗАЙ2", "Залезай!", "HLAComVoice/Grunt/Choreo/Grunt1/29_00510.wav")
Schema.voices.Add("Combine", "ЗАЛЕЗАЙ В ФУРГОН2", "Полезай в фургон!", "HLAComVoice/Grunt/Choreo/Grunt1/29_00511.wav")
Schema.voices.Add("Combine", "ТЫ ДВИГАЙСЯ2", "Ты, двигайся !", "HLAComVoice/Grunt/Choreo/Grunt1/29_00512.wav")
Schema.voices.Add("Combine", "МЫ ИХ ВЗЯЛИ", "Мы их взяли.", "HLAComVoice/Grunt/Choreo/Grunt1/29_00513.wav")
Schema.voices.Add("Combine", "ВОЗМОЖНЫЙ АНТИ-ГРАЖДАНИН2", "Возможный анти-гражданин. Пошлите сканер .", "HLAComVoice/Grunt/Choreo/Grunt1/29_00524.wav")

-- Choreo Lines, Grunt2

Schema.voices.Add("Combine", "СТОП", "Стоп, Стоп!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0001.wav")
Schema.voices.Add("Combine", "НАЗАД4", "Назад!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0002.wav")
Schema.voices.Add("Combine", "РУКИ С КНОПОК2", "Убери руки от кнопок!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0003.wav")
Schema.voices.Add("Combine", "ПОЧЕМУ ЭТО ОПАСНО", "Что такое, это опасно?", "HLAComVoice/Grunt/Choreo/Grunt2/30_0006.wav")
Schema.voices.Add("Combine", "ВЫЧЕТАНИЕ УРОНА", "...урон... семьдесят... восемьдесят процентов... девять... всего.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0007.wav")
Schema.voices.Add("Combine", "ВСЕГО", "Всего.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0008.wav")
Schema.voices.Add("Combine", "РЕМОНТ ИЛИ ЗАМЕНА", "Необходим ремонт или замена.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0009.wav")
Schema.voices.Add("Combine", "Я НЕ ЗНАЮ", "Я не знаю.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0010.wav")
Schema.voices.Add("Combine", "НЕ ЗНАЮ", "Не знаю.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0011.wav")
Schema.voices.Add("Combine", "ПРЕКРАЩАЙ", "Прекращай.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0012.wav")
Schema.voices.Add("Combine", "ПРЕКРАТИ РАБОТАТЬ", "Надзор говорит прекратить работать над этим.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0013.wav")
Schema.voices.Add("Combine", "ОН ПРЕКРАТИЛ ЭТО", "Он прекратил это.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0014.wav")
Schema.voices.Add("Combine", "ПРИГНИСЬ ОНА ЗДЕСЬ", "Пригнись, она здесь!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0015.wav")
Schema.voices.Add("Combine", "НЕИЗВЕСТНАЯ ЦЕЛЬ", "Неизвестная цель.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0016.wav")
Schema.voices.Add("Combine", "ПРИНЯЛ2", "Принял.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0020.wav")
Schema.voices.Add("Combine", "РУКИ ВВЕРХ3", "Держи их поднятыми!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0023.wav")
Schema.voices.Add("Combine", "ЛЕРЖИ ИХ ПОДНЯТЫМИ2", "Держи их поднятыми!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0023.wav")
Schema.voices.Add("Combine", "РУКИ ВВЕРХ4", "Держи эти руки поднятыми!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0024.wav")
Schema.voices.Add("Combine", "ДЕРЖИ ЭТИ РУКИ ПОДНЯТЫМИ", "Держи эти руки поднятыми!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0024.wav")
Schema.voices.Add("Combine", "РУКИ ВВЕРХ", "Подними руки вверх!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0025.wav")
Schema.voices.Add("Combine", "ПОДНИМИ РУКИ ВВЕРХ", "Подними руки вверх!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0025.wav")
Schema.voices.Add("Combine", "РУКИ ВВЕРХ5", "Подними эти руки вверх!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0026.wav")
Schema.voices.Add("Combine", "ПОДНИМИ ЭТИ РУКИ ВВЕРХ", "Подними эти руки вверх!", "HLAComVoice/Grunt/Choreo/Grunt2/30_0026.wav")
Schema.voices.Add("Combine", "ОНА ЧИСТАЯ", "У нее ничего.", "HLAComVoice/Grunt/Choreo/Grunt2/30_0027.wav")
Schema.voices.Add("Combine", "ДВИГАЙСЯ", "Двигайся!", "HLAComVoice/Grunt/Choreo/Grunt2/30_00500.wav")
Schema.voices.Add("Combine", "ВПЕРЕД ВПЕРЕД", "Вперед, вперед!", "HLAComVoice/Grunt/Choreo/Grunt2/30_00501.wav")
Schema.voices.Add("Combine", "ПРОДВИГАЙСЯ", "Продвигайся.", "HLAComVoice/Grunt/Choreo/Grunt2/30_00503.wav")
Schema.voices.Add("Combine", "ДВИГАЙСЯ2", "Двигайся.", "HLAComVoice/Grunt/Choreo/Grunt2/30_00504.wav")
Schema.voices.Add("Combine", "ОЧИСТИТЕ УЛИЦЫ2", "Очистите улицы!", "HLAComVoice/Grunt/Choreo/Grunt2/30_00505.wav")
Schema.voices.Add("Combine", "RETURN TO YOUR HOUSING BLOCK2", "Вернитесь в свои жилые блоки!", "HLAComVoice/Grunt/Choreo/Grunt2/30_00506.wav")
Schema.voices.Add("Combine", "ПРОХОДИ", "Проходи.", "HLAComVoice/Grunt/Choreo/Grunt2/30_00507.wav")
Schema.voices.Add("Combine", "ПРОХОДИ4", "Проходи.", "HLAComVoice/Grunt/Choreo/Grunt2/30_00508.wav")
Schema.voices.Add("Combine", "ТЫ ЧИСТ ПРОХОДИ", "Все в порядке, проходите.", "HLAComVoice/Grunt/Choreo/Grunt2/30_00509.wav")
Schema.voices.Add("Combine", "ЗАЛЕЗАЙ", "Залезай.", "HLAComVoice/Grunt/Choreo/Grunt2/30_00510.wav")
Schema.voices.Add("Combine", "ЗАЛЕЗАЙ В ФУРГОН", "Залезай в фугон.", "HLAComVoice/Grunt/Choreo/Grunt2/30_00511.wav")
Schema.voices.Add("Combine", "МЫ ИХ ВЗЯЛИ", "Мы их взяли!", "HLAComVoice/Grunt/Choreo/Grunt2/30_00517.wav")
Schema.voices.Add("Combine", "ВОЗМОЖНЫЙ АНТИ-ГРАЖДАНИН", "Возможный анти-гражданин, просканировать.", "HLAComVoice/Grunt/Choreo/Grunt2/30_00524.wav")

-- Custom Lines

Schema.voices.Add("Combine", "НЕСООТВЕТСТВИЕ", "Несоответствие не будет допускаться.", "HLAComVoice/grunt/custom/cognitivedissonance.wav")
Schema.voices.Add("Combine", "ГРАЖДАНИН", "Гражданин.", "HLAComVoice/grunt/custom/citizen.wav")
Schema.voices.Add("Combine", "ГРАЖДАНИН2", "Гражднин.", "HLAComVoice/grunt/custom/citizen2.wav")
Schema.voices.Add("Combine", "ГРАЖДАНЕ", "Граждане.", "HLAComVoice/grunt/custom/citizens.wav")
Schema.voices.Add("Combine", "ТАК ТОЧНО2", "Так точно.", "HLAComVoice/grunt/custom/rogerthat2.wav")
Schema.voices.Add("Combine", "ТАК ТОЧНО", "Так точно.", "HLAComVoice/grunt/custom/rogerthat.wav")
Schema.voices.Add("Combine", "10-2 КОНЕЦ СВЯЗИ", "10-2, конец сявзи.", "HLAComVoice/grunt/custom/102over.wav")
Schema.voices.Add("Combine", "10-2", "10-2.", "HLAComVoice/grunt/custom/102.wav")
Schema.voices.Add("Combine", "10-4", "10-4.", "HLAComVoice/grunt/custom/104.wav")
Schema.voices.Add("Combine", "10-4 КОНЕЦ СВЯЗИ", "10-4, конец связи.", "HLAComVoice/grunt/custom/104over.wav")
Schema.voices.Add("Combine", "ПРИНЯЛ КОНЕЦ СВЯЗИ", "Принял, конец связи.", "HLAComVoice/grunt/custom/copyover.wav")
Schema.voices.Add("Combine", "9", "Девять.", "HLAComVoice/grunt/custom/nine.wav")
Schema.voices.Add("Combine", "ДЕВЯТЬ", "Девять.", "HLAComVoice/grunt/custom/nine.wav")

Schema.voices.Add("Combine", "ДА", "Да.", "HLAComVoice/grunt/custom/yep.wav")
Schema.voices.Add("Combine", "КИДАЮ ФАЛЬШФЕЕР", "Кидаю фальшфеер.", "HLAComVoice/grunt/custom/flaredown.wav")
Schema.voices.Add("Combine", "ТЫ", "Ты.", "HLAComVoice/grunt/custom/you.wav")
Schema.voices.Add("Combine", "ТЫ2", "Ты.", "HLAComVoice/grunt/custom/you2.wav")
Schema.voices.Add("Combine", "ТЫ3", "Ты.", "HLAComVoice/grunt/custom/you3.wav")
Schema.voices.Add("Combine", "ТЫ!", "Ты!", "HLAComVoice/grunt/custom/you4.wav")