local PLUGIN = PLUGIN

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_basenpc")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel(),  v:GetTeamColor(), v:GetNPCName(), v:GetPhysDesc(), v:GetDialogue(), v.anim, v.bgs}
	end

	ix.data.Set("ixnpcs", data)
end

function PLUGIN:LoadData()
	for _, v in ipairs(ix.data.Get("ixnpcs") or {}) do
		local npc = ents.Create("ix_basenpc")

		npc:SetPos(v[1])
		npc:SetAngles(v[2])
		npc:Spawn()
		npc:Setup(v[5], v[6], v[4], v[7], v[3], v[8], v[9])
	end
end