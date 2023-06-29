function PLUGIN:LoadData()
	self:LoadCombineLocks()
end

function PLUGIN:SaveData()
	self:SaveCombineLocks()
end

netstream.Hook("ixCombineLockPlace", function(client, id, access)
	local itemTable = client:GetCharacter():GetInventory():GetItemByID(id)

	if itemTable then
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client

		local lock = scripted_ents.Get("ix_combinelock"):SpawnFunction(client, util.TraceLine(data))

		if IsValid(lock) then
			lock:SetAccess(access)
			client:EmitSound("physics/metal/weapon_impact_soft2.wav", 75, 80)
			itemTable:Remove()
		else
			return false
		end
	end
end)