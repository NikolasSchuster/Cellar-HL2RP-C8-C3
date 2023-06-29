local PLUGIN = PLUGIN

function PLUGIN:SaveData()
	local data = {}
	data["ix_vault_pla"] = {}
	data["ix_vault_overwatch"] = {}
	data["ix_vault_alaska"] = {}
	data["ix_vault_liberty_union"] = {}
	data["ix_vault_wolves"] = {}
	data["ix_vault_renegades"] = {}
	for _, v in ipairs(ents.FindByClass("ix_vault_pla")) do
		data["ix_vault_pla"][#data + 1] = {
			v:GetModel(),
			v:GetPos(),
			v:GetAngles(),
			v:GetNetVar("now_time"),
			v:GetNetVar("reward_done"),
		}
	end
	for _, v in ipairs(ents.FindByClass("ix_vault_overwatch")) do
		data["ix_vault_overwatch"][#data + 1] = {
			v:GetModel(),
			v:GetPos(),
			v:GetAngles(),
			v:GetNetVar("now_time"),
			v:GetNetVar("reward_done"),
		}
	end
	for _, v in ipairs(ents.FindByClass("ix_vault_alaska")) do
		data["ix_vault_alaska"][#data + 1] = {
			v:GetModel(),
			v:GetPos(),
			v:GetAngles(),
			v:GetNetVar("now_time"),
			v:GetNetVar("reward_done"),
		}
	end
	for _, v in ipairs(ents.FindByClass("ix_vault_liberty_union")) do
		data["ix_vault_liberty_union"][#data + 1] = {
			v:GetModel(),
			v:GetPos(),
			v:GetAngles(),
			v:GetNetVar("now_time"),
			v:GetNetVar("reward_done"),
		}
	end
	for _, v in ipairs(ents.FindByClass("ix_vault_wolves")) do
		data["ix_vault_wolves"][#data + 1] = {
			v:GetModel(),
			v:GetPos(),
			v:GetAngles(),
			v:GetNetVar("now_time"),
			v:GetNetVar("reward_done"),
		}
	end
	for _, v in ipairs(ents.FindByClass("ix_vault_renegades")) do
		data["ix_vault_renegades"][#data + 1] = {
			v:GetModel(),
			v:GetPos(),
			v:GetAngles(),
			v:GetNetVar("now_time"),
			v:GetNetVar("reward_done"),
		}
	end
	self:SetData(data)
end

function PLUGIN:LoadData()
	local data = self:GetData() or {}

	if (data) then
		for _, v in ipairs(data["ix_vault_pla"]) do
			local entity = ents.Create("ix_vault_pla")
			entity:SetPos(v[2])
			entity:SetAngles(v[3])
			entity:Spawn()
			entity:SetModel(v[1])
			entity:SetNetVar("now_time", v[4])
			entity:SetNetVar("reward_done", v[5])
		end
		for _, v in ipairs(data["ix_vault_overwatch"]) do
			local entity = ents.Create("ix_vault_overwatch")
			entity:SetPos(v[2])
			entity:SetAngles(v[3])
			entity:Spawn()
			entity:SetModel(v[1])
			entity:SetNetVar("now_time", v[4])
			entity:SetNetVar("reward_done", v[5])
		end
		for _, v in ipairs(data["ix_vault_alaska"]) do
			local entity = ents.Create("ix_vault_alaska")
			entity:SetPos(v[2])
			entity:SetAngles(v[3])
			entity:Spawn()
			entity:SetModel(v[1])
			entity:SetNetVar("now_time", v[4])
			entity:SetNetVar("reward_done", v[5])
		end
		for _, v in ipairs(data["ix_vault_liberty_union"]) do
			local entity = ents.Create("ix_vault_liberty_union")
			entity:SetPos(v[2])
			entity:SetAngles(v[3])
			entity:Spawn()
			entity:SetModel(v[1])
			entity:SetNetVar("now_time", v[4])
			entity:SetNetVar("reward_done", v[5])
		end
		for _, v in ipairs(data["ix_vault_wolves"]) do
			local entity = ents.Create("ix_vault_wolves")
			entity:SetPos(v[2])
			entity:SetAngles(v[3])
			entity:Spawn()
			entity:SetModel(v[1])
			entity:SetNetVar("now_time", v[4])
			entity:SetNetVar("reward_done", v[5])
		end
		for _, v in ipairs(data["ix_vault_renegades"]) do
			local entity = ents.Create("ix_vault_renegades")
			entity:SetPos(v[2])
			entity:SetAngles(v[3])
			entity:Spawn()
			entity:SetModel(v[1])
			entity:SetNetVar("now_time", v[4])
			entity:SetNetVar("reward_done", v[5])
		end
	end
end