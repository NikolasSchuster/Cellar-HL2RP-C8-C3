
local PLUGIN = PLUGIN or {}

PLUGIN.name = "Context Inventory Menu"
PLUGIN.author = "Dysp"
PLUGIN.description = "Allows to check characters inventory"

CAMI.RegisterPrivilege({
    Name = "Helix - Admin Context Inventory",
    MinAccess = "admin"
})

properties.Add("ixViewPlayerInventory", {
    MenuLabel = "#View Inventory",
    Order = 1,
    MenuIcon = "icon16/eye.png",


    Filter = function(self, entity, client)
        return CAMI.PlayerHasAccess(client, "Helix - Admin Context Inventory", nil) and entity:IsPlayer()
    end,

    Action = function(self, entity)
        self:MsgStart()
            net.WriteEntity(entity)
        self:MsgEnd()
    end,

    Receive = function(self, length, client)
        if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Inventory", nil)) then
            local entity = net.ReadEntity()


            local name = entity:GetCharacter():GetName()
            local inventory = entity:GetCharacter():GetInventory()
            ix.storage.Open(client, inventory, {
                entity = entity,
                name = name,
                searchTime = 0
            })
        end
    end
})