ITEM.name = "Портативный импульсный щит Mk. 1"
ITEM.description = "Экспериментальный прототип переносного устройства, генерирующее импульсное силовое поле радиусом 1 метр, которое способно отразить до десяти направленных электрических разрядов Вортигонтов. Устройство питается от микро-батарей темной энергии, излучения которой крайне отрицательно влияют на здоровье носителя."
ITEM.model = Model("models/items/battery.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.rarity = 2
ITEM.category = "Уникальное"
ITEM.outfitCategory = "shield"

local desc = "Экспериментальный прототип переносного устройства, генерирующее импульсное силовое поле радиусом 1 метр, которое способно отразить до десяти направленных электрических разрядов Вортигонтов. Устройство питается от микро-батарей темной энергии, излучения которой крайне отрицательно влияют на здоровье носителя.\n\nСостояние щита: %s/10"
function ITEM:GetDescription()
	return string.format(desc, self:GetQuality())
end

function ITEM:OnInstanced(invID, x, y, item)
	item:SetData("s", 10)
end

function ITEM:SetQuality(amount)
	self:SetData("s", amount)
end

function ITEM:GetQuality()
	return self:GetData("s", 10)
end

function ITEM:CanEquipOutfit()
	local client = self.player

	if !IsValid(client) then
		return false
	end

	return client:GetCharacter():GetData("armored") == true
end

function ITEM:OnEquipped()
	local client = self.player

	if !IsValid(client) then
		return
	end

	client.shieldx = self
	client:SetNWBool("shieldx", true)
end

function ITEM:OnUnequipped()
	local client = self.player

	if !IsValid(client) then
		return
	end

	client.shieldx = nil
	client:SetNWBool("shieldx", false)
end

hook.Add("CharacterLoaded", "shieldX", function(character)
	local client = character:GetPlayer()

	client.shieldx = nil
	client:SetNWBool("shieldx", nil)

	local item = character:GetInventory():HasItem("shieldx", {equip = true})

	if item then
		client.shieldx = item
		client:SetNWBool("shieldx", true)
	end
end)