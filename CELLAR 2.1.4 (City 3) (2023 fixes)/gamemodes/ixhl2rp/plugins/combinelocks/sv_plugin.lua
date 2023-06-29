function PLUGIN:SaveCombineLocks()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_combinelock")) do
		if (IsValid(v.door)) then
			data[#data + 1] = {
				v.door:MapCreationID(),
				v:GetLocalPos(),
				v:GetLocalAngles(),
				v:GetLocked(),
				v:GetAccess(),
				v:GetNetVar("cam") or "",
			}
		end
	end

	ix.data.Set("combineLocks", data)
end

function PLUGIN:LoadCombineLocks()
	for _, v in ipairs(ix.data.Get("combineLocks") or {}) do
		local door = ents.GetMapCreatedEntity(v[1])

		if (IsValid(door) and door:IsDoor()) then
			local lock = ents.Create("ix_combinelock")

			lock:SetPos(door:GetPos())
			lock:Spawn()
			lock:SetDoor(door, door:LocalToWorld(v[2]), door:LocalToWorldAngles(v[3]))
			lock:SetLocked(v[4])
			lock:SetAccess(v[5])
			lock:SetNetVar("cam", v[6] or "")
		end
	end
end
