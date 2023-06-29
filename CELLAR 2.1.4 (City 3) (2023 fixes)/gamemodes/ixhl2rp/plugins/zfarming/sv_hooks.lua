local PLUGIN = PLUGIN

function PLUGIN:SaveData()
	local data = {}
	for _, v in ipairs(ents.FindByClass("ix_plant")) do
		data[#data + 1] = {
			v:GetModel(),
			v:GetPos(),
			v:GetAngles(),
			v:GetNetVar("health", 10),
			v:GetNetVar("dead", false),
			v:GetGrowthPoints(),
			v:GetPlantClass(),
			v:GetPhase(),
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
			entity:SetNetVar("health", v[4])
			entity:SetNetVar("dead", v[5])
			entity:SetGrowthPoints(v[6])
			entity:SetPlantClass(v[7])
			entity:SetPhase(v[8])
		end
	end
end