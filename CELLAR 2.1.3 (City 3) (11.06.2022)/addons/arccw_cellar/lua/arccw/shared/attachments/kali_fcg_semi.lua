att.PrintName = "Civilian Comptetition S-1 FCG"
att.AbbrevName = "Semi"
att.Icon = Material("entities/acwatt_fcg_s13.png", "mips smooth")
att.Description = "Semi-Automatic only fire control group for civilian use. Weighted for reduced recoil and under specs for competition use."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "fcg_kali"
att.SortOrder = 103
att.IgnorePickX = true
att.Free = true

att.RandomWeight = 0.1
att.Mult_Recoil = 0.85
att.Mult_HipDispersion = 0.85
att.Mult_AccuracyMOA = 0.9
att.Mult_RPM = 600 / 900
att.Mult_Damage = 40 / 30
att.Mult_DamageMin = 30 / 20

att.Override_Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}