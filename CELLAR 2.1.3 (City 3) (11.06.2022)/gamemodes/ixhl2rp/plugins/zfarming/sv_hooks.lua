local PLUGIN = PLUGIN

function PLUGIN:SaveData()
	local data = {}
	for _, v in ipairs(ents.FindByClass("ix_plant")) do
		data[#data + 1] = {
			v:GetModel(),
			v:GetPos(),
			v:GetAngles(),
			v:GetPlantClass(),
			v:GetPhase(),
			v:GetGrowthPoints(),
			v.product,
			v:GetPlantName(),
		}
	end
	self:SetData(data)
end

function PLUGIN:LoadData()
	local data = self:GetData() or {}

	if (data) then
		for _, v in ipairs(data) do
			local entity = ents.Create("ix_plant")
			entity:SetPos(v[2])
			entity:SetAngles(v[3])
			entity:Spawn()
			entity:SetModel(v[1] or "models/props/de_train/bush2.mdl")
			entity:SetPlantClass(v[4])
			entity:SetPhase(v[5])
			entity:GetGrowthPoints(v[6])
			entity.product = v[7]
			entity:SetPlantName(v[8])
		end
	end
end

function PLUGIN:DoPluginIncludes(path)
	ix.plugin.Get("ixcraft").craft.LoadFromDir(path .. "/recipes", "recipe")
end
