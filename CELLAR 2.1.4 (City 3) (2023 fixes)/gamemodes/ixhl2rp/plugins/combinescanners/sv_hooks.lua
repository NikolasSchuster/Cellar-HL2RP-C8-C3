local PLUGIN = PLUGIN

function PLUGIN:RemoveScanner(player)
	if player:IsPilotScanner() then
		SafeRemoveEntity(player:GetPilotingScanner())
	end

	local activeid = self:GetActiveScanners()[player]
	if IsValid(activeid) then
		SafeRemoveEntity(activeid)
		self:GetActiveScanners()[player] = nil
	end
end

function PLUGIN:PlayerSwitchFlashlight(player)
	if player:IsPilotScanner() then
		return false;
	end
end

function PLUGIN:PlayerNoClip(player)
	if player:IsPilotScanner() then
		return false
	end
end

function PLUGIN:PlayerUse(player)
	if player:IsPilotScanner() then
		return false
	end
end

function PLUGIN:DoPlayerDeath(player)
	self:RemoveScanner(player)
end

function PLUGIN:CharacterLoaded(character)
	local client = character:GetPlayer()
	
	self:RemoveScanner(client)
end

--function PLUGIN:CanEnterObserverMode(player)
	--local scanner = player:IsPilotScanner() and player:GetPilotingScanner() or false

	--return scanner
--end

local SCANNER_SOUNDS = {
	Sound("npc/scanner/scanner_blip1.wav"),
	Sound("npc/scanner/scanner_scan1.wav"),
	Sound("npc/scanner/scanner_scan2.wav"),
	Sound("npc/scanner/scanner_scan4.wav"),
	Sound("npc/scanner/scanner_scan5.wav"),
	Sound("npc/scanner/combat_scan1.wav"),
	Sound("npc/scanner/combat_scan2.wav"),
	Sound("npc/scanner/combat_scan3.wav"),
	Sound("npc/scanner/combat_scan4.wav"),
	Sound("npc/scanner/combat_scan5.wav"),
	Sound("npc/scanner/cbot_servoscared.wav"),
	Sound("npc/scanner/cbot_servochatter.wav")
}

local SCANNER_SOUNDS2 = {
	Sound("npc/scanner/scanner_talk1.wav"),
	Sound("npc/scanner/scanner_talk2.wav")
}

function PLUGIN:KeyPress(player, key)
	if player:IsPilotScanner() and (player.scnNextSound or 0) < CurTime() then
		local source

		if key == IN_USE then
			source = table.Random(SCANNER_SOUNDS)
			player.scnNextSound = CurTime() + 1.75
		elseif key == IN_RELOAD then
			source = table.Random(SCANNER_SOUNDS2)
			player.scnNextSound = CurTime() + 10
		end

		if source then
			player:GetPilotingScanner():EmitSound(source)
		end
	end
end

function PLUGIN:LoadData()
    self:LoadScannerTerminals()
end

function PLUGIN:SaveData()
	self:SaveScannerTerminals()
end