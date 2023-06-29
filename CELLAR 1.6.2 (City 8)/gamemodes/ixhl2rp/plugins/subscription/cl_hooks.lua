local PLUGIN = PLUGIN

function PLUGIN:GetPlayerIcon(speaker)
	if IsValid(speaker) and speaker:IsDonator() then
		return "icon16/heart.png"
	end
end

function PLUGIN:PopulatePlayerTooltip(client, tooltip)
	if !client:IsDonator() then
		return
	end

	local panel = tooltip:AddRowAfter("name", "donator")
	panel:SetText("Меценат")
	panel:SetBackgroundColor(Color(100, 200, 255))
	panel:SizeToContents()
end
/*
function PLUGIN:PrePACEditorOpen()
	if LocalPlayer():IsDonator() then
		return true
	end
end
*/
do
	local clr = Color(100, 200, 255)

	net.Receive("donateNotify", function()
		local msg = net.ReadUInt(2)

		if msg == 3 then
			chat.AddText(clr, "Ваша ежемесячная подписка была аннулирована высшей администрацией! Обратитесь к Владельцам сервера для большей информации.")
		elseif msg == 2 then
			chat.AddText(clr, "Ваша ежемесячная подписка окончена. Если Вы желаете продлить ее, то обратитесь к Владельцам сервера. Мы надеемся на Вас!")
		elseif msg == 1 then
			local timeLeft = os.date("%d.%m.%Y %X", LocalPlayer():GetData("donateTime", 0))

			chat.AddText(clr, "Ваша ежемесячная подписка все еще активирована! Вы сохраните статус игрока, поддерживающего сервер до: "..timeLeft)
			chat.AddText(clr, "Для того, чтобы открыть персональный контейнер, используйте команду /хранилище!")
		elseif msg == 0 then
			local timeLeft = os.date("%d.%m.%Y %X", LocalPlayer():GetData("donateTime", 0))

			chat.AddText(clr, "Администрация активировала Вашу месячную подписку. Благодарим Вас за поддержку сервера CELLARPROJECT! Благодаря Вам мы станем еще лучше, чем вчера. Вы сохраните статус игрока, поддерживающего сервер до: "..timeLeft)
			chat.AddText(clr, "Для того, чтобы открыть персональный контейнер, используйте команду /хранилище!")
		end
	end)
end