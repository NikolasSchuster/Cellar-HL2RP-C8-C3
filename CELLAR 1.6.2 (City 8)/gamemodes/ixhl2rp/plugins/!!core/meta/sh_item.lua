local ITEM = ix.meta.item

function ITEM:GetName()
	return (self.PrintName and (CLIENT and L(self.PrintName) or self.PrintName)) or (CLIENT and L(self.name) or self.name)
end

function ITEM:GetRarity()
	return (self.GetRare and self:GetRare()) or self:GetData("rare", nil) or self.rarity or 0
end

function ITEM:Register()
	return ix.item.Register2(self)
end

ix.meta.item = ITEM

if CLIENT then
	RARITY_COLORS = {
		[0] = Color(255, 255, 255, 255),
		[1] = Color(51, 204, 51, 255),
		[2] = Color(0, 102, 255, 255),
		[3] = Color(204, 0, 255, 255),
		[4] = Color(230, 188, 22, 255)
	}
	
	function ix.hud.PopulateItemTooltip(tooltip, item)
		local rColor = RARITY_COLORS[item:GetRarity()] or RARITY_COLORS[0]
		local name = tooltip:AddRow("name")
		name:SetImportant()
		name:SetText(item.GetName and item:GetName() or L(item.name))
		name:SetBackgroundColor(rColor)
		name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
		name:SizeToContents()

		local description = tooltip:AddRow("description")
		description:SetText(item:GetDescription() or "")
		description:SizeToContents()

		if (item.PopulateTooltip) then
			item:PopulateTooltip(tooltip)
		end

		hook.Run("PopulateItemTooltip", tooltip, item)
	end
end