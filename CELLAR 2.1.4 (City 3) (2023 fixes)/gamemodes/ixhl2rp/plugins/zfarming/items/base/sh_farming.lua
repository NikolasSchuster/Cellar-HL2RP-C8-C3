ITEM.name = "Base Farming"
ITEM.description = "Небольшая упаковка с семенами."
ITEM.model = Model("models/props_lab/box01a.mdl")
ITEM.category = "categoryFarming"
ITEM.width = 1
ITEM.height = 1
ITEM.rarity = 1

local surfaces = {
	[MAT_DIRT] = true,
	[MAT_GRASS] = true
}

ITEM.functions.Plant = {
	name = "plant",
	icon = "icon16/accept.png",
	OnRun = function(item)
		local client = item.player
		local tr = client:GetEyeTraceNoCursor()

		if client:EyePos():Distance(tr.HitPos) > 90 then
			client:NotifyLocalized("surfaceTooFar")
			return false
		end

		if (tr.Hit and surfaces[tr.MatType]) then
			if tr.Entity:IsPlayer() then
				client:NotifyLocalized("wrongSurface")
				return false
			end

			local plant = ents.Create("ix_plant")
			plant:SetPlantClass(item.uniqueID)
			tr.HitPos[3] = tr.HitPos[3] - 2
			plant:SetPos(tr.HitPos)
			plant:SetPlantName(item.plantName)
			plant.product = item.product
			plant:Spawn()
			client:GetCharacter():DoAction("farmingPlant")
			return true
		end

		return false
	end
}
