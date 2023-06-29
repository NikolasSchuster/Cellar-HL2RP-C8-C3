ix.util.Include("meta/sh_cams.lua")
ix.util.Include("sh_cameras.lua")

function dispatch.GetCameraOrigin(camera)
	if camera:IsPlayer() then
		return camera:GetShootPos()
	end

	if !camera.GetCameraData then
		return camera:GetPos()
	end

	local data = camera:GetCameraData()
	local pos = camera:GetPos()

	if data then
		local offset = data:ViewOffset(camera)

		if offset then
			pos = pos + (camera:GetForward() * offset.x) + (camera:GetRight() * offset.y) + (camera:GetUp() * offset.z)
		end
	end

	return pos
end

function dispatch.GetCameraViewAngle(camera)
	if camera:IsPlayer() then
		return camera:EyeAngles()
	end

	local data = camera:GetCameraData()
	local ang = camera:GetAngles()

	if data then
		local new_ang = data:ViewAngle(camera)

		if new_ang then
			ang = new_ang
		end
	end

	ang.z = 0

	return ang
end

function dispatch.InDispatchMode(client)
	return client:GetNetVar("d")
end

function dispatch.IsSpectating(client)
	local entity = client:GetViewEntity()

	if entity == client then
		return
	end

	return dispatch.InDispatchMode(client) and (IsValid(entity) and entity or false) or false
end

ix.util.Include("sv_spectate.lua")
ix.util.Include("cl_spectate.lua")
