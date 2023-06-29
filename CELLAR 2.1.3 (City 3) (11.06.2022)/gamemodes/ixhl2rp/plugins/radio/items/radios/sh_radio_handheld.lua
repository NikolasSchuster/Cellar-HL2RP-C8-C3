ITEM.name = "Рация"
ITEM.category = "Коммуникация"
ITEM.description = "Обычная портативная рация с регулятором частоты."
ITEM.business = true
ITEM.price = 50
ITEM.stationaryCanAccess = true

function ITEM:GetFrequency()
	return self:GetData("frequency", "100.0")
end

function ITEM:GetFrequencyID()
	return string.format("freq_%d", string.gsub(self:GetData("frequency", "100.0"), "%p", ""))
end

ITEM.functions.Frequency = {
	name = "Выставить частоту",

	OnCanRun = function(item)
		return IsValid(item.player) and !IsValid(item.entity) and !item.player:IsRestricted()
	end,

	OnClick = function(item)
		Derma_StringRequest("Частота", "Введите новую частоту рации", item:GetData("frequency", "100.0"), function(text)
			netstream.Start("ixRadioFrequency", item:GetID(), text)
		end)
	end,

	OnRun = function()
		return false
	end
}
