att.PrintName = "M231 11.5 in. Barrel"
att.AbbrevName = "Patriot"
att.Icon = Material("entities/acwatt_bo2_longbarrel.png", "mips smooth")
att.Description = "Short 11.5 inch barrel with a round smooth handguard and no front sight. Cannot accept UBGLs."

att.SortOrder = 97

att.AutoStats = true

att.Desc_Pros = {
    "+ Provides better sight picture for low profile sights when combined with a flat top receiver."
}
att.Desc_Cons = {
}
att.Slot = "kali_barrel"
att.GivesFlags = {"kali_barrel_patriot", "kali_barrel_carbine", "kali_barrel_short", "notwood"}

att.Mult_Range = 0.75
att.Mult_Recoil = 1.2
att.Mult_RecoilSide = 1.2
att.Mult_SpeedMult = 1.2
att.Mult_SightedSpeedMult = 1.2
att.Mult_SightTime = 0.8
att.Mult_AccuracyMOA = 1.5
att.Override_MuzzleEffectAttachment = 1

att.RandomWeight = 0.1