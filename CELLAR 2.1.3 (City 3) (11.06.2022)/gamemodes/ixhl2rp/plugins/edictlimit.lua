
local PLUGIN = PLUGIN

PLUGIN.name = "Edict Limit Checker"
PLUGIN.author = "alexgrist"
PLUGIN.description = "Prevents multiple entity type spawns when close to edict limit."

function PLUGIN:CheckEdictLimit(client, class)
	local bEditLimit = ents.GetEdictCount() >= 7900

	if (bEditLimit) then
		ErrorNoHalt(string.format("[Helix] %s attempted to spawn '%s' but edict limit is too high!\n", client:Name(), class))
			client:Notify("The server is too close to the edict limit to spawn this!")
		return false
	end
end

PLUGIN.PlayerSpawnObject = PLUGIN.CheckEdictLimit
