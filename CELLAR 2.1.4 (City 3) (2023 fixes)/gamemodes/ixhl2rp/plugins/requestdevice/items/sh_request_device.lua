local PLUGIN = PLUGIN

ITEM.name = "Устройство запроса"
ITEM.model = Model("models/gibs/shield_scanner_gib1.mdl")
ITEM.description = "Маленькое устройство с желтой кнопкой, имеется встроенный микрофон с динамиком и креплением для уха.\n\nИнструкция: Зарегистрируйте устройство, приложив его к CID карте, после чего вы сможете отправить запрос Гражданской Обороне. Имя и CID будет автоматически отправлено вместе с сообщением."
ITEM.category = "Коммуникация"
ITEM.rarity = 1
ITEM.isEquipment = true
ITEM.slot = EQUIP_EARS

function ITEM:GetDescription()
	local item = ix.item.instances[self:GetData("id")]

	return item and string.format(self.description.."\n\nПривязано к %s, CID #%s, RegID #%s.", item:GetData("name"), item:GetData("cid"), item:GetData("number")) or self.description
end

local cacheText = ""

ITEM.functions.Request = {
	name = "Запросить помощь",
	icon = "icon16/help.png",
	OnClick = function(item)
		Derma_StringRequest("Запросить помощь", "Введите ваш запрос. Привязанные данные к устройству будут автоматически отправлены.", cacheText, function(text)
				if text and string.utf8len(text) > 0 then
					netstream.Start("ixRequest", text)
				end

				cacheText = ""
			end, 
		function(text)
			cacheText = text
		end, "СДЕЛАТЬ ЗАПРОС", "ОТМЕНА")
	end,
	OnRun = function(item)
		item.player.ixRequestDevice = item

		return false
	end,
	OnCanRun = function(item)
		if IsValid(item.entity) or !item:GetData("id", false) then
			return false
		end

		return true
	end
}

ITEM.combine = {}
ITEM.combine.Transfer = {
	name = "Привязать CID карту",
	icon = "icon16/lock_edit.png",
	OnRun = function(from, to) 
		from:SetData("id", to:GetID())

		return false
	end,
	OnCanRun = function(from, to) 
		if isnumber(to.cardType) then
			return true
		end

		return false
	end
}