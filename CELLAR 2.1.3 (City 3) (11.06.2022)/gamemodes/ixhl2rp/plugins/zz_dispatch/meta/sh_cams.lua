local empty = Vector()
local CAM = ix.meta.cameratype or {}
CAM.__index = CAM

function CAM:Name(entity) 
	return false
end

function CAM:Type() return self.cam_type end
function CAM:IsStatic() return self.locked_view end
function CAM:ViewAngle(entity) return entity:GetAngles() end
function CAM:ViewOffset(entity) return self.view_offset end
function CAM:MaxYaw() return self.max_yaw end
function CAM:MaxPitch() return self.max_pitch end
function CAM:DefaultName(entity) return nil end

function CAM:Setup(data)
	self.cam_type = data.CameraType
	self.locked_view = data.Static or false
	self.max_yaw = data.MaxYaw
	self.max_pitch = data.MaxPitch
	self.view_offset = data.Offset

	if data.Name then
		self.Name = data.Name
	end

	if data.DefaultName then
		self.DefaultName = data.DefaultName
	end

	if data.ViewAngle then
		self.ViewAngle = data.ViewAngle
	end
end

ix.meta.cameratype = CAM

do
	local ent_cache = CLIENT and {} or (dispatch.cameras_cache or {})
	dispatch.cameras_cache = ent_cache or {}
	dispatch.camdata = dispatch.camdata or {}

	function dispatch.FindCameras()
		return ent_cache
	end

	local function RevalidateCache()
		for k, v in ipairs(ent_cache) do
			if IsValid(v) then continue end

			ent_cache[k] = nil
		end
	end

	hook.Add("OnEntityCreated", "dispatch.camera", function(entity)
		if !IsValid(entity) then return end

		local camdata = dispatch.GetCameraData(entity:GetClass())

		if camdata then
			ent_cache[entity:EntIndex()] = entity

			entity.GetCameraData = function() return camdata end
			entity.MarkAsCam = true
		end
	end)

	hook.Add("EntityRemoved", "dispatch.camera", function(entity)
		if entity.MarkAsCam then
			RevalidateCache()
		end
	end)

	function dispatch.GetCameraData(classname)
		return dispatch.camdata[classname]
	end

	function dispatch.SetCameraData(classname, data)		
		local CAM = setmetatable({}, ix.meta.cameratype)
		CAM:Setup(data)

		dispatch.camdata[classname] = CAM
	end
end

