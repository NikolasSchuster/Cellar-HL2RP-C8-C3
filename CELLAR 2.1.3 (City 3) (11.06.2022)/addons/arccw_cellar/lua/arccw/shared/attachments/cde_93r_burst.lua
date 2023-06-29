att.PrintName = "93R S-1-3 FCG"
att.Icon = Material("entities/acwatt_fcg_s13.png", "mips smooth")
att.Description = "93R Conversion for the Beretta."
att.Desc_Pros = {
    "bo1.burst"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "fcg_diamatti"
att.SortOrder = 103

att.GivesFlags = {"93r", "93rskin"}

att.Mult_RPM = 1200 / 700
att.Mult_AccuracyMOA = 1.5
att.Mult_Recoil = 0.9
att.Mult_RecoilSide = 1.5
att.Mult_HipDispersion = 1.25
att.Mult_MoveDispersion = 1.5

att.Override_Firemodes = {
    {
        Mode = -3,
        PostBurstDelay = 0.2,
        RunawayBurst = true,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}