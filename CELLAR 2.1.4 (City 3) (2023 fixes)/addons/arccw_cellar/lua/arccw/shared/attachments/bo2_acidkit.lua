att.PrintName = "Acid Kit"
att.Icon = Material("entities/acwatt_bo2_acidkit.png", "mips smooth")
att.Description = "The Blundergat has been converted into the Acid Gat. Now shoots sticky explosive darts"
att.Desc_Pros = {
    "Fire explosive acid darts"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo2_blundergat_kit"}
att.GivesFlags = {"acidgat"}

att.Override_Damage = 1500
att.Override_DamageMin = 1500

att.Override_ClipSize = 3
att.Override_Num = 1
att.Override_Firemodes = {
    {
        Mode = -3,
        PostBurstDelay = 0.1,
        RunawayBurst = true,
        Mult_Recoil = 0.1,
        Mult_AccuracyMOA = 2,
        Mult_HipDispersion = 0.5,
    },
    {
        Mode = 0
    }
}
att.Hook_ModifyRPM = function(wep, delay)
    return 60 / 600
end

att.SortOrder = 100
att.Override_ShootEntity = "arccw_bo2_blundergat_dart"
att.Override_Ammo = "xbowbolt"

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == wep.ShootSound or sound == wep.FirstShootSound then return "ArcCW_BO2.Acidgat_Fire" end
end