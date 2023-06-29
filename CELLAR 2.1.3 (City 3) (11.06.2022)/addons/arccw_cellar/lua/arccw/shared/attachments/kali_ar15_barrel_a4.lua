att.PrintName = "M16A4 20 in. Barrel"
att.AbbrevName = "A4 RIS Barrel"
att.Icon = Material("entities/acwatt_bo2_longbarrel.png", "mips smooth")
att.Description = "Standard 20 inch heavy barrel with a RIS quad-rail handguard and rail covers. Though the handguard is different the barrel remains a standard M16A2 barrel"

att.SortOrder = 92

att.AutoStats = true

att.RandomWeight = 0.75
att.Mult_Recoil = 0.925
att.Mult_RecoilSide = 0.925
att.Mult_SpeedMult = 0.925
att.Mult_SightedSpeedMult = 0.925
att.Mult_SightTime = 1.075
att.Mult_AccuracyMOA = 0.925

att.Desc_Pros = {
    "+Provides better sight picture for low profile sights when combined with a flat top receiver.",
    "+Accepts Integrated Bipod."
}
att.Desc_Cons = {
}
att.Slot = "kali_barrel"
att.GivesFlags = {"kali_barrel_a4", "kali_barrel_long", "notwood", "mk12_barrel", "mk12_bipod_ok"}