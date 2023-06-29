local PLUGIN = PLUGIN

/*
local stored = dispatch.crc_table or {}
dispatch.crc_table = stored or {}

local t = math.Truncate
local function GenerateCRC(entity)
	local pos = entity:GetPos()
	return util.CRC(entity:GetClass() .. t(pos[1]) .. t(pos[2]) .. t(pos[3]))
end

function dispatch.SetupCRC(entity, callback)
	if entity.SaveCRC then
		return
	end

	local class = entity:GetClass()

	entity.SaveCRC = GenerateCRC(entity)

	stored[class] = stored[class] or {}
	stored[class][entity] = entity.SaveCRC

	if callback then
		entity:SetNetVar("cam", callback())
	end

	local data = PLUGIN:GetData()
	local crc = tonumber(entity.SaveCRC)

	if data[class] and data[class][crc] then
		entity:SetNetVar("cam", data[class][crc])
	end
end

function PLUGIN:SaveData()
	local data = {}

	for class, v in pairs(stored) do
		data[class] = data[class] or {}

		for entity, crc in pairs(v) do
			if !IsValid(entity) then continue end

			data[class][crc] = entity:GetNetVar("cam")
		end
	end

	self:SetData(data)
end
*/

function PLUGIN:SaveData()
	local objects = {}
	
	for k, v in ipairs(ents.FindByClass("npc_combine_camera")) do
		objects[#objects + 1] = {
			v:GetAngles(),
			v:GetPos(),
			v:GetNetVar("cam") or "UNKNOWN"
		}
	end

	self:SetData(objects)
end

function PLUGIN:LoadData()
	local stored = self:GetData()

	if stored then
		for k, v in ipairs(stored) do
			local entity = ents.Create("npc_combine_camera")
			entity:SetAngles(v[1])
			entity:SetPos(v[2])
			entity:Spawn()
			entity:SetNetVar("cam", v[3] or "UNKNOWN")
		end
	end
end