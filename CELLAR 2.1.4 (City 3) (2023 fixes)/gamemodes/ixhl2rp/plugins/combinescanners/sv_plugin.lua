local PLUGIN = PLUGIN

util.AddNetworkString("ScannerPhoto")
util.AddNetworkString("ScannerData")
util.AddNetworkString("ScannerEnter")
util.AddNetworkString("ScannerExit")
util.AddNetworkString("ScannerTerminalAccess")
util.AddNetworkString("ScannerTerminalDeploy")
util.AddNetworkString("ScannerTerminalDeploy2")

local sndSpotlight = Sound("npc/turret_floor/click1.wav")

concommand.Add("scanner_spotlight", function(player)
	local scanner = player:GetPilotingScanner()

	if !IsValid(scanner) then return end

	if (scanner.nextLightToggle or 0) >= CurTime() then return end
	scanner.nextLightToggle = CurTime() + 0.5

	local spot = scanner:IsSpotlightOn()
	scanner:Spotlight(!spot)

	scanner:EmitSound(sndSpotlight, 50, spot and 240 or 250)
end)

concommand.Add("scanner_photo", function(player)
	local scanner = player:GetPilotingScanner()

	if !IsValid(scanner) then return end

	if ((scanner.nextPicture2 or 0) >= CurTime()) then return end
	scanner.nextPicture2 = CurTime() + (PLUGIN.Picture.delay - 1)

	if !scanner.Rebel then
		net.Start("ScannerPhoto")
		net.Send(player)
	end

	scanner:Flash()
end)

function PLUGIN:CanPlayerReceiveScan(client, photographer)
	return client:IsCombine()
end

function PLUGIN:GetActiveScanners()
	return self.buffer
end

function PLUGIN:LoadScannerTerminals()
	for _, v in ipairs(ix.data.Get("cmbScannerTerminals") or {}) do
		local rs = ents.Create("ix_scannerterminal")

		rs:SetPos(v[1])
		rs:SetAngles(v[2])
		rs:Spawn()

		local phys = rs:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	for _, v in ipairs(ix.data.Get("cmbScannerTerminals2") or {}) do
		local rs = ents.Create("ix_scannerterminal2")

		rs:SetPos(v[1])
		rs:SetAngles(v[2])
		rs:Spawn()

		local phys = rs:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end

function PLUGIN:SaveScannerTerminals()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_scannerterminal")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles()}
	end

	ix.data.Set("cmbScannerTerminals", data)

	data = {}

	for _, v in ipairs(ents.FindByClass("ix_scannerterminal2")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles()}
	end

	ix.data.Set("cmbScannerTerminals2", data)
end

net.Receive("ScannerData", function(len, client)
	local scanner = client:GetPilotingScanner()

	if client:IsPilotScanner() and (scanner.nextPicture or 0) < CurTime() and !scanner.Rebel then
		scanner.nextPicture = CurTime() + (PLUGIN.Picture.delay - 1)

		local length = net.ReadUInt(16)
		local data = net.ReadData(length)
		
		if length != #data then
			return
		end

		local receivers = {}

		for _, v in ipairs(player.GetAll()) do
			if PLUGIN:CanPlayerReceiveScan(v, client) then
				receivers[#receivers + 1] = v
			end
		end

		if #receivers > 0 then
			net.Start("ScannerData")
				net.WriteUInt(#data, 16)
				net.WriteData(data, #data)
			net.Send(receivers)
		end
	end
end)

PLUGIN.activeID = PLUGIN.activeID or 0
net.Receive("ScannerTerminalDeploy", function(len, player)
	local terminal = net.ReadEntity()

	if !IsValid(terminal) or !terminal.IsScannerTerminal then return end
	if player:GetShootPos():DistToSqr(terminal:GetPos()) > 9801 then return end
	if player:IsPilotScanner() or player:IsRagdoll() or !player:Alive() or !player:GetCharacter() then return end
	
	if IsValid(PLUGIN:GetActiveScanners()[player]) then
		return
	end


	local spawnPoints = ix.plugin.list["spawns"].spawns["metropolice"]["scanner"]

	if (!spawnPoints or #spawnPoints <= 0) then return end

	local randomSpawn = math.random(1, #spawnPoints)
	local pos = spawnPoints[randomSpawn]
	
	PLUGIN.activeID = PLUGIN.activeID + 1

	local scanner = ents.Create("ix_scanner")
	scanner:SetPos(pos)
	scanner:Spawn()
	scanner:SetID(PLUGIN.activeID)

	PLUGIN:GetActiveScanners()[player] = scanner

	scanner:Transmit(player)
	player:SetNWEntity("Scanner", scanner)
	--player:SetNetVar("IgnoreMoving", true)
	--player:SetNetVar("StancePos", player:GetPos())
	--player:SetNetVar("StanceAng", player:GetAngles())
	--player:SetNetVar("StanceIdle", true)
	--player:SetForcedAnimation("stances_stand03", 0, nil)
end)

net.Receive("ScannerTerminalDeploy2", function(len, player)
	local terminal = net.ReadEntity()

	if !IsValid(terminal) or !terminal.IsScannerTerminal then return end
	if player:GetShootPos():DistToSqr(terminal:GetPos()) > 9801 then return end
	if player:IsPilotScanner() or player:IsRagdoll() or !player:Alive() or !player:GetCharacter() then return end
	
	if IsValid(PLUGIN:GetActiveScanners()[player]) then
		return
	end


	local spawnPoints = ix.plugin.list["spawns"].spawns["metropolice"]["scanner2"]

	if (!spawnPoints or #spawnPoints <= 0) then return end

	local randomSpawn = math.random(1, #spawnPoints)
	local pos = spawnPoints[randomSpawn]
	
	PLUGIN.activeID = PLUGIN.activeID + 1

	local scanner = ents.Create("ix_scanner")
	scanner:SetPos(pos)
	scanner:Spawn()
	scanner.Rebel = true
	scanner:SetID(PLUGIN.activeID)
	scanner:SetModel("models/customscan/superbeescanner.mdl")
	scanner:PrecacheGibs()
	scanner:ResetSequence("idle")

	PLUGIN:GetActiveScanners()[player] = scanner

	scanner:Transmit(player)
	player:SetNWEntity("Scanner", scanner)
	--player:SetNetVar("IgnoreMoving", true)
	--player:SetNetVar("StancePos", player:GetPos())
	--player:SetNetVar("StanceAng", player:GetAngles())
	--player:SetNetVar("StanceIdle", true)
	--player:SetForcedAnimation("stances_stand03", 0, nil)
end)





