local PLUGIN = PLUGIN

PLUGIN.name = "Perma All Protection"
PLUGIN.description = "Utilities to prevent Perma All errors and abuse."
PLUGIN.author = "maxxoft"

if SERVER then
	ix.log.AddType("permaall", function(client, entity)
		return L("%s used Perma All on %s.", client:Name(), tostring(entity))
	end, FLAG_NORMAL)

	function PLUGIN:CanTool(ply, tr, toolname, tool, button)
		if toolname == "permaall" and IsValid(tr.Entity) then
			if string.StartWith(tr.Entity:GetClass(), "ix_") then
				return false
			elseif IsValid(ply) then
				ix.log.Add(ply, "permaall", tr.Entity)
			end
		end
	end
end
