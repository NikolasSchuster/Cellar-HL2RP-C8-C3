
local PLUGIN = PLUGIN

function PLUGIN:OnLoaded()
	for _, path in ipairs(self.paths or {}) do
		self.craft.LoadFromDir(path.."/recipes", "recipe")
		self.craft.LoadFromDir(path.."/stations", "station")
	end
end

function PLUGIN:LoadData()
	timer.Simple(1, function()
    	self:LoadStations()
    end)
end

function PLUGIN:SaveData()
	self:SaveStations()
end

function PLUGIN:LoadStations()
	local data = self:GetData()

	if data then
		for _, v in ipairs(data) do
			local entity = ents.Create("ix_station_"..v[1])
			if entity then
				entity:SetPos(v[2])
				entity:SetAngles(v[3])
				entity:Spawn()

				local physObject = entity:GetPhysicsObject()

				if IsValid(physObject) then
					physObject:EnableMotion(false)
				end
			end
		end
	end
end

function PLUGIN:SaveStations()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_station_*")) do
		data[#data + 1] = {
			v.uniqueID,
			v:GetPos(),
			v:GetAngles()
		}
	end

	self:SetData(data)
end

