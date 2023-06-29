--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local command = {};

command.help = "Cleanup a player's props.";
command.command = "cleanup";
command.arguments = {"player"};
command.permissions = "Manage Prop-Protection";
command.bSingleTarget = true;
command.immunity = SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(player, target, arguments)
	local name = target:Name();
	local steamID = target:SteamID();

	for k, entity in ipairs(ents.GetAll()) do
		if (IsValid(entity) and entity.serverguard and entity.serverguard.owner != game.GetWorld() and !entity:IsPlayer()) then
			if (entity.serverguard.steamID == steamID) then					
				entity:Remove();
			end;
		end;
	end;

	return true;
end;

function command:OnNotify(player, targets)
	local name = targets[1]:Name();

	return SGPF("command_cleanup", serverguard.player:GetName(player), name, string.Ownership(name, true));
end;

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Cleanup Props", function()
		serverguard.command.Run("cleanup", false, player:Name());
	end);
	
	option:SetImage("icon16/cross.png");
end;

plugin:AddCommand(command);