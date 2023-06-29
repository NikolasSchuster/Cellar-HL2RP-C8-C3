
local PLUGIN = PLUGIN

PLUGIN.name = "Bodygroup Manager"
PLUGIN.author = "Gary Tate"
PLUGIN.description = "Allows players and administration to have an easier time customising bodygroups."

ix.flag.Add("b", "Ability to edit your bodygroups.")

ix.lang.AddTable("english", {
	cmdEditBodygroup = "Bodygroup editor."
})
ix.lang.AddTable("russian", {
	cmdEditBodygroup = "Редактор бодигрупп."
})

ix.command.Add("CharEditBodygroup", {
	description = "@cmdEditBodygroup",
	adminOnly = false,
	arguments = {
		bit.bor(ix.type.player, ix.type.optional)
	},
	OnCheckAccess = function(self, client)
		return client:GetCharacter():HasFlags("b") or client:IsAdmin()
	end,
	OnRun = function(self, client, target)
		if client != target and !client:IsAdmin() then return end
		if !IsValid(target) then target = client end
		net.Start("ixBodygroupView")
			net.WriteEntity(target)
		net.Send(client)
	end
})

properties.Add("ixEditBodygroups", {
	MenuLabel = "#Edit Bodygroups",
	Order = 10,
	MenuIcon = "icon16/user_edit.png",

	Filter = function(self, entity, client)
		return (entity:IsPlayer() and #entity:GetBodyGroups() > 1 and ix.command.HasAccess(client, "CharEditBodygroup"))
	end,

	Action = function(self, entity)
		local panel = vgui.Create("ixBodygroupView")
		panel:Display(entity)
	end
})

ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")
