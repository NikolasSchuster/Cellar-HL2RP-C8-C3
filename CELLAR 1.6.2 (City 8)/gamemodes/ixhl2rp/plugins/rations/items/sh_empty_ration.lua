ITEM.name = "Empty Ration"
ITEM.PrintName = "iRationPackage"
ITEM.category = "categoryJunk"
ITEM.model = Model("models/weapons/w_packate.mdl")
ITEM.description = "iRationPackageDesc2"

function ITEM:GetDescription()
	return L("iRationPackageDesc", L(self:GetData("D", "iRationPackageDesc2")))
end

if SERVER then
	local ITEM_A = "citizen_supplements"
	local ITEM_B = "breens_water"

	function ITEM:OnEntityCreated(ent)
		ent.Touch = function(ent, target)
			if (self) then
				self:Touch(ent, target)
			end
		end

		self:SetData("A", false)
		self:SetData("B", false)
	end
	
	function ITEM:Touch(itemEntity, ent)
		local factory = itemEntity:GetData("T", false)

		if !factory then
			return
		end

		if itemEntity.nextUse and itemEntity.nextUse > CurTime() then
			return
		end

		if ent.GetItemID then
			local item = ent:GetItemTable()

			if item then
				local hasItem1 = itemEntity:GetData("A", false)
				local hasItem2 = itemEntity:GetData("B", false)

				if item.uniqueID == ITEM_A and !hasItem1 then
					self:SetData("A", true)
					hasItem1 = itemEntity:GetData("A", false)

					ent:Remove()
					itemEntity:EmitSound("items/medshot4.wav")
				elseif item.uniqueID == ITEM_B and !hasItem2 then
					self:SetData("B", true)
					hasItem2 = itemEntity:GetData("B", false)

					ent:Remove()
					itemEntity:EmitSound("items/medshot4.wav")
				end

				if itemEntity:GetData("A", false) and itemEntity:GetData("B", false) and !itemEntity.isMerging then
					itemEntity.isMerging = true
					local pos, ang = itemEntity:GetPos(), itemEntity:GetAngles()
					itemEntity:Remove()
					ix.item.Spawn("filled_ration", pos, nil, ang)

					return false
				end
			end
		end

		itemEntity.nextTick = CurTime() + .75
	end
end