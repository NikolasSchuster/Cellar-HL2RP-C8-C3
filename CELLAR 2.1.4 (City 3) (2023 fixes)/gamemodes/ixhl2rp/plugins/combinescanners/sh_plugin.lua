local PLUGIN = PLUGIN

PLUGIN.name = "Combine Scanners"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = "Adds a controllable combine scanners."

PLUGIN.buffer = PLUGIN.buffer or {}
PLUGIN.Picture = {
	w = 580,
	h = 420,
	w2 = 580 * 0.5,
	h2 = 420 * 0.5,
	delay = 15
}

function PLUGIN:StartCommand(player, cmd)
	if (IsValid(player:GetPilotingScanner())) then
		cmd:RemoveKey(bit.bor(IN_ATTACK, IN_ATTACK2))
		cmd:ClearMovement()
	end
end

function PLUGIN:SetupMove(player, mvd, cmd)
	if (player:IsPilotScanner()) then
		if mvd:KeyDown(IN_JUMP) then
			local newbuttons = bit.band(mvd:GetButtons(), bit.bnot(IN_JUMP))
			mvd:SetButtons(newbuttons)
		end
	end
end

do
	local PLAYER = FindMetaTable("Player")

	function PLAYER:IsPilotScanner()
		return IsValid(self:GetPilotingScanner())
	end

	function PLAYER:GetPilotingScanner()
		return self:GetNWEntity("Scanner")
	end
end

ix.util.Include("sh_commands.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sv_plugin.lua")