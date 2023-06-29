
local shadeColor = Color(0, 0, 0, 200)
local blockSize = 4
local blockSpacing = 2

local ix_item = scripted_ents.GetStored("ix_item").t
ix_item.PopulateEntityInfo = true

function ix_item:OnPopulateEntityInfo(tooltip)
	local item = self:GetItemTable()

	if (!item) then
		return
	end

	local oldData = item.data
	local itemWidth, itemHeight = item.width, item.height

	item.data = self:GetNetVar("data", {})
	item.entity = self

	if (item.data["flip"]) then
		itemWidth, itemHeight = ix.item.RawFlip(item, true)
	end

	ix.hud.PopulateItemTooltip(tooltip, item)

	local name = tooltip:GetRow("name")
	local color = name and name:GetBackgroundColor() or ix.config.Get("color")

	-- set the arrow to be the same colour as the title/name row
	tooltip:SetArrowColor(color)

	if ((itemWidth > 1 or itemHeight > 1) and
		hook.Run("ShouldDrawItemSize", item) != false) then

		local sizeHeight = itemHeight * blockSize + itemHeight * blockSpacing
		local size = tooltip:Add("Panel")
		size:SetWide(tooltip:GetWide())

		if (tooltip:IsMinimal()) then
			size:SetTall(sizeHeight)
			size:Dock(TOP)
			size:SetZPos(-999)
		else
			size:SetTall(sizeHeight + 8)
			size:Dock(BOTTOM)
		end

		size.Paint = function(sizePanel, width, height)
			if (!tooltip:IsMinimal()) then
				surface.SetDrawColor(ColorAlpha(shadeColor, 60))
				surface.DrawRect(0, 0, width, height)
			end

			local x, y = width * 0.5 - 1, height * 0.5 - 1
			local itemWidth2 = itemWidth - 1
			local itemHeight2 = itemHeight - 1
			local heightDifference = ((itemHeight2 + 1) * blockSize + blockSpacing * itemHeight2)

			x = x - (itemWidth2 * blockSize + blockSpacing * itemWidth2) * 0.5
			y = y - heightDifference * 0.5

			for i = 0, itemHeight2 do
				for j = 0, itemWidth2 do
					local blockX, blockY = x + j * blockSize + j * blockSpacing, y + i * blockSize + i * blockSpacing

					surface.SetDrawColor(shadeColor)
					surface.DrawRect(blockX + 1, blockY + 1, blockSize, blockSize)

					surface.SetDrawColor(color)
					surface.DrawRect(blockX, blockY, blockSize, blockSize)
				end
			end
		end

		tooltip:SizeToContents()
	end

	item.entity = nil
	item.data = oldData
end
