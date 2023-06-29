--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:Hook("playerArrested", "logs.playerArrested", function(player, time, arrestor)
	if (!IsValid(player) or !IsValid(arrestor)) then
		return;
	end;

	plugin:Log(string.format("%s has been arrested by %s for %d.", player:Nick(), arrestor:Nick(), time));
end);

plugin:Hook("playerUnArrested", "logs.playerUnArrested", function(player, unarrestor)
	if (!IsValid(player) or !IsValid(unarrestor)) then
		return;
	end;

	plugin:Log(string.format("%s has been released from jail by %s.", player:Nick(), unarrestor:Nick()));
end);

plugin:Hook("playerWarranted", "logs.playerWarranted", function(player, warranter, reason)
	if (!IsValid(player) or !IsValid(warranter)) then
		return;
	end;

	plugin:Log(string.format("%s ordered a search warrant for %s. Reason: %s", warranter:Nick(), player:Nick(), reason));
end);

plugin:Hook("playerUnWarranted", "logs.playerUnWarranted", function(player, unwarranter)
	if (!IsValid(player) or !IsValid(unwarranter)) then
		return;
	end;

	plugin:Log(string.format("The search warrant for %s has expired.", player:Nick()));
end);

plugin:Hook("playerWanted", "logs.playerWanted", function(player, actor, reaon)
	if (!IsValid(player) or !IsValid(actor)) then
		return;
	end;

	plugin:Log(string.format("%s has made %s wanted, reason: %s", actor:Nick(), player:Nick(), reason));
end);

plugin:Hook("playerUnWanted", "logs.playerUnWanted", function(player, actor)
	if (!IsValid(player) or !IsValid(actor)) then
		return;
	end;

	plugin:Log(string.format("%s is no longer wanted by the Police. Revoked by: %s", player:Nick(), actor:Nick()));
end);
