att.PrintName = "KSG Modern Warfare 3 Sound"
att.AbbrevName = "Modern Warfare 3"

att.Icon = Material("entities/acwatt_mw3_generic.png", "smooth mips")
att.Description = "KSG sounds from Modern Warfare 3"
att.Slot = "bo2_ksg_sound"

att.Free = true
att.IgnorePickX = true
att.AltSound = true

att.Hook_GetShootSound = function(wep, sound)
    local sil = wep:GetBuff_Override("Silencer")
    if sil then
        return "ArcCW_BO2.S12_Sil"
    end
    return "ArcCW_MW3E.KSG_Fire"
end