local PLUGIN = PLUGIN
function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_recyclefactory_metal")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetProductPos(), v:GetGarbageCount(), v:GetEjectStorage(), v.Garbages}
	end

	ix.data.Set("recycleFactoryMetal", data)


	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_recyclefactory_paper")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetProductPos(), v:GetGarbageCount(), v:GetEjectStorage(), v.Garbages}
	end

	ix.data.Set("recycleFactoryPaper", data)


	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_recyclefactory_plastic")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetProductPos(), v:GetGarbageCount(), v:GetEjectStorage(), v.Garbages}
	end

	ix.data.Set("recycleFactoryPlastic", data)
end

function PLUGIN:LoadData()
	for _, v in ipairs(ix.data.Get("recycleFactoryMetal") or {}) do
		local factory = ents.Create("ix_recyclefactory_metal")

		factory:SetPos(v[1])
		factory:SetAngles(v[2])
		factory:Spawn()
		factory:SetProductPos(v[3])
		factory:SetGarbageCount(v[4])
		factory:SetEjectStorage(v[5])
		factory.Garbages = v[6]

		local phys = factory:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	for _, v in ipairs(ix.data.Get("recycleFactoryPaper") or {}) do
		local factory = ents.Create("ix_recyclefactory_paper")

		factory:SetPos(v[1])
		factory:SetAngles(v[2])
		factory:Spawn()
		factory:SetProductPos(v[3])
		factory:SetGarbageCount(v[4])
		factory:SetEjectStorage(v[5])
		factory.Garbages = v[6]

		local phys = factory:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	for _, v in ipairs(ix.data.Get("recycleFactoryPlastic") or {}) do
		local factory = ents.Create("ix_recyclefactory_plastic")

		factory:SetPos(v[1])
		factory:SetAngles(v[2])
		factory:Spawn()
		factory:SetProductPos(v[3])
		factory:SetGarbageCount(v[4])
		factory:SetEjectStorage(v[5])
		factory.Garbages = v[6]

		local phys = factory:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end
netstream.Hook("aw_recyclemenuresult",function(player,data)
	if !player.TimeToNextUseRecycle or CurTime() > player.TimeToNextUseRecycle then
		player.TimeToNextUseRecycle = CurTime()+0.2
		local ent = Entity(data[1])
		if IsValid(ent) and player:GetPos():Distance(ent:GetPos()) < 250 then
			local act = PLUGIN.VariantsUse[data[2]] and PLUGIN.VariantsUse[data[2]](ent)
		end
	end
end)