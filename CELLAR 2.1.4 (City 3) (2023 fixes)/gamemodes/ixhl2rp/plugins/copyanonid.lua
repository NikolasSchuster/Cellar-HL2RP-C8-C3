local PLUGIN = PLUGIN

PLUGIN.name = "Copy AnonID C Menu"
PLUGIN.author = "Vintage Thief"
PLUGIN.description = "Plugin allows to Copy AnonID of a player via C menu."

CAMI.RegisterPrivilege({
	Name = "Helix - Admin Context AnonID",
	MinAccess = "admin"
})

properties.Add("ixCopyPlayerAnonID", {
	MenuLabel = "#Copy AnonID",
	Order = 999,
	MenuIcon = "icon16/eye.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context AnonID", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, legth, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context AnonID", nil)) then
			local entity = net.ReadEntity()
			local name = entity:GetCharacter():GetName()
			local anonid = entity:GetAnonID()

			ix.util.Notify("AnonID игрока " .. name .. " - " .. anonid .. " скопирован в буфер обмена!", client)
			client:SendLua("SetClipboardText(\"" .. anonid .. "\")")
		end
	end
})