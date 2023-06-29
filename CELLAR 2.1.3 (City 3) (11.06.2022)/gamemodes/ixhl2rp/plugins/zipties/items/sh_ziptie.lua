ITEM.name = "Стяжки"
ITEM.description = "Оранжевые стяжки."
ITEM.model = Model("models/items/crossbowrounds.mdl")
ITEM.maxStack = 8
ITEM.defaultStack = 1

function ITEM:Combine(targetItem)
    if targetItem.uniqueID == self.uniqueID then
        local sentStacks = 0

        -- Evaluating how many stacks we need to transfer between the two items.
        if (targetItem:GetStacks() + self:GetStacks()) <= targetItem.maxStack then
            sentStacks = self:GetStacks()
        else
            sentStacks = (targetItem.maxStack - targetItem:GetStacks())
        end

        -- Adding the stacks together.
        targetItem:SetData("stack", targetItem:GetStacks() + sentStacks)
        self:SetData("stack", math.Clamp(self:GetStacks() - sentStacks, 0, self.maxStack))

        -- If the original item has no more stacks, we need to delete it.
        if self:GetStacks() <= 0 then
            self:Remove()
        end
    end
end

function ITEM:GetStacks()
    return self:GetData("stack", 1)
end

function ITEM:OnInstanced(invID, x, y)
    self:SetData("stack", self.defaultStack)
end

function ITEM:CanSplit()
    if self:GetData("stack", 0) >= 2 then
        return true
    end

    return false
end

if CLIENT then
    function ITEM:PaintOver(item, w, h)
		ix.util.DrawText(item:GetStacks(), 5, 5, color_white, 0, 0, "ixSmallFont")
	end
end

ITEM.functions.Use = {
    name = "Связать",
    OnRun = function(itemTable)
        local client = itemTable.player
        local data = {}
            data.start = client:GetShootPos()
            data.endpos = data.start + client:GetAimVector() * 96
            data.filter = client
        local target = util.TraceLine(data).Entity
        local clientTarget = IsValid(target.ixPlayer) and target.ixPlayer or target

        if (IsValid(target) and clientTarget:IsPlayer() and clientTarget:GetCharacter()
        and !clientTarget:GetNetVar("tying") and !clientTarget:IsRestricted()) then
            itemTable.bBeingUsed = true

            client:SetAction("@tying", 5)

            client:DoStaredAction(target, function()
                local uses = itemTable:GetStacks()

                clientTarget:SetRestricted(true)
                clientTarget:SetNetVar("tying")
                clientTarget:NotifyLocalized("fTiedUp")

                if uses == 1 then
                    itemTable:Remove()
                else
                    itemTable:SetData("stack", uses - 1)
                end
            end, 5, function()
                client:SetAction()

                clientTarget:SetAction()
                clientTarget:SetNetVar("tying")

                itemTable.bBeingUsed = false
            end)

            clientTarget:SetNetVar("tying", true)
            clientTarget:SetAction("@fBeingTied", 5)
        else
            itemTable.player:NotifyLocalized("plyNotValid")
        end

        return false
    end,
    OnCanRun = function(itemTable)
        return !IsValid(itemTable.entity) or itemTable.bBeingUsed
    end
}

--function ITEM:CanTransfer(inventory, newInventory)
--    return !self.bBeingUsed
--end