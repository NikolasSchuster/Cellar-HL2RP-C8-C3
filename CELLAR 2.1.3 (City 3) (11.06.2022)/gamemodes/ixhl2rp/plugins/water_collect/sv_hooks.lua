local PLUGIN = PLUGIN

function PLUGIN:SaveData()
	local data = {}
	for _, v in ipairs(ents.FindByClass("ix_wcollector")) do
		data[#data + 1] = {
			v:GetModel(),
			v:GetPos(),
			v:GetAngles(),
			v:GetNetVar("wamount"),
		}
	end
	self:SetData(data)
end

function PLUGIN:LoadData()
	local data = self:GetData() or {}

	if (data) then
		for _, v in ipairs(data) do
			local entity = ents.Create("ix_wcollector")
			entity:SetPos(v[2])
			entity:SetAngles(v[3])
			entity:Spawn()
			entity:SetModel(v[1])
			entity:SetNetVar("wamount", v[4])
		end
	end
end