function PLUGIN:CanPlayerHoldObject(client, entity)
	if entity.isRationCrate then
		return true
	end
end

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_ration_crate")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetCount()}
	end

	ix.data.Set("rationCrates", data)


	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_rationfactory_cd")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetLocked()}
	end

	ix.data.Set("rationFactoryCD", data)


	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_rationfactory_erd")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetLocked()}
	end

	ix.data.Set("rationFactoryERD", data)


	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_rationfactory_rs")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles()}
	end

	ix.data.Set("rationFactoryRS", data)


	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_rationfactory_sd")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetLocked()}
	end

	ix.data.Set("rationFactorySD", data)


	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_rationfactory_wd")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetLocked()}
	end

	ix.data.Set("rationFactoryWD", data)
end

function PLUGIN:LoadData()
	for _, v in ipairs(ix.data.Get("rationCrates") or {}) do
		local crate = ents.Create("ix_ration_crate")

		crate:SetPos(v[1])
		crate:SetAngles(v[2])
		crate:Spawn()
		crate:SetCount(v[3])

		local phys = crate:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	for _, v in ipairs(ix.data.Get("rationFactoryCD") or {}) do
		local cd = ents.Create("ix_rationfactory_cd")

		cd:SetPos(v[1])
		cd:SetAngles(v[2])
		cd:Spawn()
		cd:SetLocked(v[3])

		local phys = cd:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	for _, v in ipairs(ix.data.Get("rationFactoryERD") or {}) do
		local erd = ents.Create("ix_rationfactory_erd")

		erd:SetPos(v[1])
		erd:SetAngles(v[2])
		erd:Spawn()
		erd:SetLocked(v[3])

		local phys = erd:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	for _, v in ipairs(ix.data.Get("rationFactoryRS") or {}) do
		local rs = ents.Create("ix_rationfactory_rs")

		rs:SetPos(v[1])
		rs:SetAngles(v[2])
		rs:Spawn()

		local phys = rs:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	for _, v in ipairs(ix.data.Get("rationFactorySD") or {}) do
		local sd = ents.Create("ix_rationfactory_sd")

		sd:SetPos(v[1])
		sd:SetAngles(v[2])
		sd:Spawn()
		sd:SetLocked(v[3])

		local phys = sd:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	for _, v in ipairs(ix.data.Get("rationFactoryWD") or {}) do
		local wd = ents.Create("ix_rationfactory_wd")

		wd:SetPos(v[1])
		wd:SetAngles(v[2])
		wd:Spawn()
		wd:SetLocked(v[3])

		local phys = wd:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end