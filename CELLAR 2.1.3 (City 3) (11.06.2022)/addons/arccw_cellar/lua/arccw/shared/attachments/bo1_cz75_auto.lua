att.PrintName = "CZ 75 Automatic Barrel"
att.AbbrevName = "Auto Barrel"
att.Icon = Material("entities/acwatt_bo1_fcg_rapid.png", "mips smooth")
att.Description = "Extended barrel and internal modification for automatic fire."
att.Desc_Pros = {
    "bo1.automatic"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "bo1_czauto"
att.ActivateElements = {"cz_auto"}

att.Mult_RPM = 1000 / 600

att.Mult_AccuracyMOA = 1.5
att.Mult_Recoil = 0.9
att.Mult_RecoilSide = 1.5
att.Mult_HipDispersion = 1.5
att.Mult_MoveDispersion = 1.5

att.Override_MuzzleEffectAttachment = 4

att.Override_Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}