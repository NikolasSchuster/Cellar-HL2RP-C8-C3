-- ixhl2rp\schema\items\base

ITEM.name = "Base Useable"
ITEM.description = "An item you can use multiple times."
ITEM.model = Model("models/props_junk/watermelon01.mdl")
ITEM.category = "Useable"
ITEM.width = 1
ITEM.height = 1
ITEM.dUses = 1
ITEM.dJunkItem = nil
ITEM.useSound = nil

if CLIENT then
	function ITEM:PopulateTooltip(tooltip)
		local uses = tooltip:AddRowAfter("rarity")
		uses:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		uses:SetText(L("usesDesc", self:GetData("uses", self.dUses), self.dUses))
	end
end

function ITEM:OnInstanced(invID, x, y, item)
	item:SetData("uses", self.dUses)
end

function ITEM:OnCanUse(client)
	return true
end

function ITEM:OnUse(client)
	return true
end

ITEM.functions.Use = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local uses = item:GetData("uses", item.dUses)

		if item:OnUse(client) == false then
			return false
		end

		if uses == 1 then
			local isWorld = false
			local pos, ang
			local data = {
				S = item:GetSkin(),
				M = item:GetModel()
			}

			if isfunction(item.OnJunkCreated) then
				data = item:OnJunkCreated() or data
			end

			if IsValid(item.entity) then
				isWorld = true
				pos, ang = item.entity:GetPos(), item.entity:GetAngles()
			end
			
			item:Remove()

			if isstring(item.junk) then
				if isWorld then
					ix.item.Spawn(item.junk, pos, nil, ang, data)
				else
					local junkItem = character:GetInventory():Add(item.junk, nil, data)

					if !junkItem then
						junkItem = ix.item.Spawn(item.junk, client, nil, nil, data)
					end
				end
			end
		else
			item:SetData("uses", item:GetData("uses", item.dUses) - 1)
		end

		return false
	end,
	OnCanRun = function(item)
		return item:OnCanUse(item.player)
	end
}
