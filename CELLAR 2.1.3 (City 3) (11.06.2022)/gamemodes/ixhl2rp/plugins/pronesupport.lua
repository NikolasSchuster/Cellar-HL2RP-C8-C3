local PLUGIN = PLUGIN

PLUGIN.name = "Prone Support"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

function PLUGIN:DoPlayerDeath(player)
	if player:IsProne() then
		prone.Exit(player)
	end
end

function PLUGIN:PlayerLoadedCharacter(player)
	if player:IsProne() then
		prone.Exit(player)
	end
end