att.PrintName = "S-1-F FCG"
att.Icon = Material("entities/acwatt_fcg_s13.png", "mips smooth")
att.Description = "Firemode conversion allowing for full-auto and semi-auto fire modes. Adds a minor penalty for recoil and precision."
att.Desc_Pros = {
    "bo1.automatic"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "bo2_fcg_fullauto"
att.GivesFlags = {"bo2_fullauto"}
att.SortOrder = 99

att.Mult_Recoil = 1.15
att.Mult_AccuracyMOA = 1.25

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