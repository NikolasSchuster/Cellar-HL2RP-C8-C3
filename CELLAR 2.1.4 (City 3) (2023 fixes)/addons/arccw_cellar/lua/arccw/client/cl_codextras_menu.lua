/*hook.Add( "PopulateToolMenu", "ArcCW_CoDExtras_Options", function()
    spawnmenu.AddToolMenuOption( "Options", "ArcCW", "ArcCW_CoDExtras_Options", "COD Extras", "", "", ArcCW_CoDExtras_Options)
end )

function ArcCW_CoDExtras_Options( CPanel )
    --CPanel:AddControl("Header", {Description = "The options below require admin privileges to change, and only work on Listen Servers."})
    CPanel:AddControl("Label", {Text = "The options below can be customized by server only."})
    CPanel:AddControl("Checkbox", {Label = "Merge COD Extras with Black Ops Pack.", Command = "arccw_codextras_merge" })
    CPanel:AddControl("Label", {Text = [[
        Will disable the original M16 and Commando.
        Requires a restart to take effect.
    ]]
})
end*/