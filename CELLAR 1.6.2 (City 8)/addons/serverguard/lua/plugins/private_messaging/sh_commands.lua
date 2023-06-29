--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local command = {};

command.help = "Private message another player.";
command.command = "pm";
command.arguments = {"player", "message"};
command.bDisallowConsole = true;
command.bSingleTarget = true;
command.immunity = SERVERGUARD.IMMUNITY.ANY;
command.aliases = {"msg", "message"};

function command:Execute(player, silent, arguments)
	local curTime = CurTime();

	if (!player.sgPMCooldown or curTime > player.sgPMCooldown) then
		local target = util.FindPlayer(arguments[1], player);

		if (IsValid(target)) then
			if (target != player) then
				local messageData = {
					sender = serverguard.player:GetName(player), sender_steamid = player:SteamID(),
					receiver = serverguard.player:GetName(target), receiver_steamid = target:SteamID(),
					message = table.concat(arguments, " ", 2)
				};

				serverguard.Notify(player, SGPF("command_pm_sent", messageData.receiver, messageData.message));
				serverguard.Notify(target, SGPF("command_pm_received", messageData.sender, messageData.message));


				-- Disable all saving of PM's until fixed.
				/*local insertObj = serverguard.mysql:Insert("serverguard_pms");
					insertObj:Insert("sender", messageData.sender);
					insertObj:Insert("sender_steamid", messageData.sender_steamid);
					insertObj:Insert("receiver", messageData.receiver);
					insertObj:Insert("receiver_steamid", messageData.receiver_steamid);
					insertObj:Insert("message", messageData.message);
					insertObj:Callback(function()
						serverguard.mysql:RawQuery("SELECT MAX(id) FROM serverguard_pms", function(result)
							if (type(result) == "table" and #result > 0) then
								messageData.id = result[1]["MAX(id)"];
								table.insert(plugin.messages, messageData);
							end;
						end);
					end);
				insertObj:Execute();*/
			else
				serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "You can't private message yourself.");
			end;
		end;

		player.sgPMCooldown = curTime + 1;
	else
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, "Please wait a moment before sending another private message.");
	end;	
end;

plugin:AddCommand(command);