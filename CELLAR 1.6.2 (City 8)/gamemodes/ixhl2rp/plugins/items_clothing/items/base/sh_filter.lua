ITEM.base = "base_outfit"
ITEM.name = "Filter"
ITEM.description = "A filter you can screw onto a gasmask."
ITEM.model = "models/gibs/hgibs.mdl"
ITEM.category = "categoryFilters"
ITEM.outfitCategory = "filter"
ITEM.width = 1
ITEM.height = 1
ITEM.business = false
ITEM.filterQuality = 100

function ITEM:GetDescription()
	return L("filterDesc", L(self.description), math.Round(100 * (self:GetFilterQuality() / self.filterQuality)))
end

function ITEM:OnInstanced(invID, x, y, item)
	item:SetData("filterQuality", self.filterQuality)
end

function ITEM:SetFilterQuality(amount)
	self:SetData("filterQuality", amount)
end

function ITEM:GetFilterQuality()
	return self:GetData("filterQuality", self.filterQuality)
end

function ITEM:CanEquipOutfit()
	local client = self.player

	if (!IsValid(client)) then
		return false
	end

	local inventory = client:GetCharacter():GetEquipment()
	local gasmask = inventory:HasItemOfBase("base_gasmask", {equip = true})

	if gasmask and !gasmask.Filters[self.uniqueID] then
		return false
	end

	if (SERVER and gasmask) then
		gasmask:AddAttachment(self:GetID())
	end

	return gasmask != false
end

function ITEM:OnDetached(client)
	self:RemoveOutfit(client)
end
