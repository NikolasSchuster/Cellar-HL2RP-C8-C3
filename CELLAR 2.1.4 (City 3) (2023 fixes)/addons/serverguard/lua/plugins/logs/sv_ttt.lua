--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:Hook("TTTPrepareRound", "logs.TTTPrepareRound", function()
	plugin:Log("Preparing for new round.")
end);

plugin:Hook("TTTBeginRound", "logs.TTTBeginRound", function()
	plugin:Log("A new round has begun.");
end);

plugin:Hook("TTTEndRound", "logs.TTTEndRound", function(result)
	local text = "undetermined ";

	if (result == WIN_TRAITOR) then
		text = "the traitors have won.";
	elseif (result == WIN_INNOCENT or result == WIN_TIMELIMIT) then
		text = "the innocents have won.";
	end;

	plugin:Log("The round has ended; " .. text);
end);

plugin:Hook("TTTKarmaLow", "logs.TTTKarmaLow", function(player)
	plugin:Log(string.format("Player %s has been kicked and/or banned for having low karma.", player:Nick()))
end);