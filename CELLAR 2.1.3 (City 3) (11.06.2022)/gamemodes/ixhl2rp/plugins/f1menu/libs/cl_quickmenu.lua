local ix = ix

ix.quickmenu = {}
ix.quickmenu.stored = {}


function ix.quickmenu:AddCallback(name, icon, callback, shouldShow)
	self.stored[#ix.quickmenu.stored+1] = {
		shouldShow = shouldShow,
		callback = callback,
		name = name,
		icon = icon
	};
end;

ix.quickmenu:AddCallback("Изменить описание", "icon16/note_edit.png", function()
	ix.command.Send("CharDesc")
end)

ix.quickmenu:AddCallback("Выбросить токены", "icon16/money_delete.png", function()
	local description = string.format("Сколько вы хотите выбросить? У вас есть %s.", LocalPlayer():GetCharacter():GetMoney())

	Derma_StringRequest("Выбросить токены", description, 20, function(text)
		ix.command.Send("DropTokens", text)
	end, nil, "Выбросить", "Отмена")
end)

ix.quickmenu:AddCallback("Упасть", "icon16/user.png", function()
	Derma_StringRequest("Упасть", "Введите время (от 5 до 60 секунд).", 5, function(text)
		ix.command.Send("CharFallOver", math.Clamp(tonumber(text) or 60, 60, 120))
	end, nil, "Упасть", "Отмена")
end)

ix.quickmenu:AddCallback("Сменить походку", "icon16/user.png", function()
	local menu = DermaMenu()
	local moods = ix.plugin.list["emotemoods"].MoodTextTable
	for i = 1, 4 do
		menu:AddOption(L(moods[i - 1]), function()
			ix.command.Send("CharSetMood", i - 1)
		end)
	end
	menu:Open()
end)
