local PLUGIN = PLUGIN

PLUGIN.name = "StormFox"
PLUGIN.author = "alexgrist"
PLUGIN.description = "Syncs StormFox to the Helix time and date."

if (CLIENT) then
	return
end

hook.Add("StormFox.PostEntity", "ixStormFox", function()
	StormFox2.Time.Set(ix.date.GetFormatted("%H:%M"))
end)