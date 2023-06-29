
PLUGIN.name = "Customizable Items"
PLUGIN.description = "Adds items that you can customize on the fly."
PLUGIN.author = "`impulse"

ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")

do
	local COMMAND = {
		description = "@cmdCreateCustomItem",
		privilege = "Create Custom Items",
		superAdminOnly = true
	}

	function COMMAND:OnRun(client)
		net.Start("ixCreateCustomItem")
		net.Send(client)
	end

	ix.command.Add("CreateCustomItem", COMMAND)
end
