ITEM.name = "Drugs"
ITEM.description = "Simple."
ITEM.category = "Drugs"
ITEM.model = "models/props/furnitures/gob/l6_jar_oil/l6_jar_oil.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.force = 0
ITEM.quantity = 1
ITEM.empty = nil

ITEM.functions.use = {
	icon = "icon16/drink.png",
	OnRun = function(item)
		if (CLIENT) then return end

		local client = item.player
		local quantity = item:GetData("quantity", item.quantity)

		quantity = quantity - 1

		if (quantity >= 1) then			
			client:GetCharacter():SetData("drugged", client:GetCharacter():GetData("drugged") + item.force)
			item:SetData("quantity", quantity)
			client:EmitSound( "physics/flesh/flesh_bloody_break.wav", 75, 200 )
			hook.Run("Drugged", client)

			return false
		end

		if quantity == 0 then 
			if empty then
				client:GetCharacter():GetInventory():Add(item.empty)
			end

			return true
		end
	end
}