util.AddNetworkString("dispatch.spectate")
util.AddNetworkString("dispatch.spectate.stop")
util.AddNetworkString("dispatch.spectate.request")
util.AddNetworkString("dispatch.mode")
util.AddNetworkString("dispatch.scanner")
util.AddNetworkString("dispatch.scannerphoto")

function dispatch.SetDispatchMode(client, bool)
	client:SetNetVar("d", bool == true and bool or nil)

	net.Start("dispatch.mode")
		net.WriteBool(bool)
	net.Send(client)

	if bool then
		client:StripWeapons()
		client:StripAmmo()

		client:SetNoDraw(true)
		client:SetNotSolid(true)
		client:SetMoveType(MOVETYPE_NONE)
	else
		client:SetNoDraw(false)
		client:SetNotSolid(false)
		client:SetMoveType(MOVETYPE_WALK)

		dispatch.StopSpectate(client)
	end
end

function dispatch.Spectate(client, entity)
	if !IsValid(entity) or !IsValid(client) then return end
	if !dispatch.InDispatchMode(client) then return end
	if client:IsPilotScanner() then return end
	if entity:IsNPC() and entity:Health() <= 0 then return end

	if entity:IsPlayer() and (entity:Team() == FACTION_MPF) then
		local mask = entity:GetCharacter():GetEquipment():GetItemAtSlot(EQUIP_MASK)
		local bCamOn = mask and mask:GetData("bCamOn", false)

		if !bCamOn then
			ix.util.Notify("Камера юнита неактивна", client)
			return
		end
	end

	client:SetNetworkOrigin(dispatch.GetCameraOrigin(entity))
	client:SetViewEntity(entity)
	client:SetEyeAngles(dispatch.GetCameraViewAngle(entity))

	net.Start("dispatch.spectate")
		net.WriteEntity(entity)
	net.Send(client)

	local spec = client.Spectating

	if IsValid(spec) then
		spec.IsSpectatedBy = spec.IsSpectatedBy or {}
		spec.IsSpectatedBy[client] = nil
	end

	entity.IsSpectatedBy = entity.IsSpectatedBy or {}
	entity.IsSpectatedBy[client] = true
	client.Spectating = entity

	local id = "spectate" .. client:SteamID64()
	client.lastSpecPos = client:GetNetworkOrigin()
	timer.Create(id, 3, 0, function()
		if !IsValid(client) or (client:GetViewEntity() == client) then
			timer.Remove(id)
			return
		end

		if !IsValid(client:GetViewEntity()) then
			dispatch.StopSpectate(client)
			return
		end

		local newPos = dispatch.GetCameraOrigin(client:GetViewEntity())

		if client.lastSpecPos != newPos then
			client:SetNetworkOrigin(newPos)

			client.lastSpecPos = newPos
		end
	end)
end

function dispatch.StopSpectate(client)
	if !IsValid(client) then return end

	local spec = client.Spectating

	if IsValid(spec) then
		spec.IsSpectatedBy = spec.IsSpectatedBy or {}
		spec.IsSpectatedBy[client] = nil
	end

	client:SetViewEntity(nil)
	client.Spectating = nil

	net.Start("dispatch.spectate.stop")
	net.Send(client)

	timer.Remove("spectate" .. client:SteamID64())
end

net.Receive("dispatch.spectate.request", function(len, client)
	dispatch.Spectate(client, net.ReadEntity())
end)

do
	local SCANNERS, SPAWNS = ix.plugin.list["combinescanners"],  ix.plugin.list["spawns"]

	function dispatch.DeployScanner(client)
		if !dispatch.InDispatchMode(client) then
			return
		end

		if client:IsPilotScanner() or IsValid(SCANNERS:GetActiveScanners()[client]) then
			return
		end

		local spawnPoints = SPAWNS.spawns["metropolice"]["scanner"]

		if !spawnPoints or #spawnPoints <= 0 then
			return
		end

		local randomSpawn = math.random(1, #spawnPoints)
		local pos = spawnPoints[randomSpawn]

		SCANNERS.activeID = SCANNERS.activeID + 1

		local scanner = ents.Create("ix_scanner")
		scanner:SetPos(pos)
		scanner:Spawn()
		scanner:SetID(SCANNERS.activeID)

		SCANNERS:GetActiveScanners()[client] = scanner

		scanner:Transmit(client)
		client:SetNWEntity("Scanner", scanner)
	end

	net.Receive("dispatch.scanner", function(len, client)
		dispatch.DeployScanner(client)
	end)

	net.Receive("dispatch.scannerphoto", function(len, client)
		if !dispatch.InDispatchMode(client) then
			return
		end

		if (client.nextPicture or 0) >= CurTime() then
			return
		end

		client.nextPicture = CurTime() + 5

		local length = net.ReadUInt(16)
		local data = net.ReadData(length)

		if length != #data then
			return
		end

		local receivers = {}

		for _, v in ipairs(player.GetAll()) do
			if v:Team() == FACTION_MPF and SCANNERS:CanPlayerReceiveScan(v, client) then
				receivers[#receivers + 1] = v
			end
		end

		if #receivers > 0 then
			net.Start("ScannerData")
				net.WriteUInt(#data, 16)
				net.WriteData(data, #data)
			net.Send(receivers)
		end
	end)
end