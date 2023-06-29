ITEM.name = "Stackable Ammo Base";
ITEM.description = "No description avaliable.";
ITEM.model = "models/items/357ammo.mdl";
ITEM.category = "Ammunition"
ITEM.width = 1;
ITEM.height = 1;
ITEM.maxStack = 32;
ITEM.defaultStack = 32;

-- Called when this item is dragged onto another one.
function ITEM:Combine(targetItem)
    if(targetItem.uniqueID == self.uniqueID) then
        local sentStacks = 0

        -- Evaluating how many stacks we need to transfer between the two items.
        if((targetItem:GetStacks() + self:GetStacks()) <= targetItem.maxStack) then
            sentStacks = self:GetStacks()
        else
            sentStacks = (targetItem.maxStack - targetItem:GetStacks())
        end

        -- Adding the stacks together.
        targetItem:SetData("stack", targetItem:GetStacks() + sentStacks)
        self:SetData("stack", math.Clamp(self:GetStacks() - sentStacks, 0, self.maxStack))

        -- If the original item has no more stacks, we need to delete it.
        if(self:GetStacks() <= 0) then
            self:Remove()
        end
    end
end

-- Called as a get method when we need to get the item stacks.
function ITEM:GetStacks()
    return self:GetData("stack", 1)
end

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
    self:SetData("stack", self.defaultStack)
end

-- Called when we need to check if the item can split it's stacks.
function ITEM:CanSplit()
    if(self:GetData("stack", 0) >= 2) then
        return true
    end

    return false
end

-- Clientside inventory paintover
if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
		ix.util.DrawText(item:GetStacks(), 5, 5, color_white, 0, 0, "ixSmallFont")
	end
end