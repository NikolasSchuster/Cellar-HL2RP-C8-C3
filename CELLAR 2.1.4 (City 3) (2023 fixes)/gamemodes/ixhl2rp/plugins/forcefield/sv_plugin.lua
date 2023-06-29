local PLUGIN = PLUGIN

function PLUGIN:SaveData()
	local terminal_data = {}
	local dissolver_data = {}

	for i = 1, #ents.FindByClass('ix_dissolver_terminal') do
		local terminal = ents.FindByClass('ix_dissolver_terminal')[i]

		terminal_data[#terminal_data + 1] = {
			id = terminal:id(),
			position = terminal:GetPos(),
			angles = terminal:GetAngles()
		}
	end

	for i = 1, #ents.FindByClass('ix_dissolver') do
		local dissolver = ents.FindByClass('ix_dissolver')[i]

		dissolver_data[#dissolver_data + 1] = {
			id = dissolver:id(),
			toggle = dissolver:GetToggle(),
			position = dissolver:GetPos(),
			angles = dissolver:GetAngles(),
			access = dissolver:GetAccess()
		}
	end

	ix.data.Set(PLUGIN.name .. '.terminal_data', terminal_data)
	ix.data.Set(PLUGIN.name .. '.dissolver_data', dissolver_data)
end

function PLUGIN:LoadData()
	for k, v in pairs(ix.data.Get(PLUGIN.name .. '.terminal_data') or {}) do
		local terminal = ents.Create('ix_dissolver_terminal')
		terminal:SetPos(v.position)
		terminal:SetAngles(v.angles)
		terminal:Spawn()
		terminal:SetNetVar('id', v.id)
	end

	for k, v in pairs(ix.data.Get(PLUGIN.name .. '.dissolver_data') or {}) do
		local dissolver = ents.Create('ix_dissolver')
		dissolver:SetPos(v.position)
		dissolver:SetAngles(v.angles)
		dissolver:Spawn()
		dissolver:SetNetVar('id', v.id)
		dissolver:toggle(v.toggle)
		dissolver:SetAccess(v.access)
	end
end