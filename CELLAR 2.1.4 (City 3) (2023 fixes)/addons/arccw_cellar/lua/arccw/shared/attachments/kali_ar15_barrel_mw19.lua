att.PrintName = "RIS 14.5 in. LP Barrel"
att.AbbrevName = "RIS Modern"
att.Icon = Material("entities/acwatt_bo2_longbarrel.png", "mips smooth")
att.Description = "Standard 14.5 inch barrel with a RIS quad-rail handguard that covers most of the barrel thanks to a low profile gas block. This means the weapon is equpped by default with a USGI flip-up front sight."

att.SortOrder = 90

att.AutoStats = true

att.Mult_Range = 0.85
att.Mult_Recoil = 1.1
att.Mult_RecoilSide = 1.1
att.Mult_SpeedMult = 1.1
att.Mult_SightedSpeedMult = 1.1
att.Mult_SightTime = 0.9
att.Mult_AccuracyMOA = 1.1

att.RandomWeight = 0.5

att.Desc_Pros = {
    "+Provides better sight picture for low profile sights when combined with a flat top receiver.",
    "+Accepts Integrated Bipod."
}
att.Desc_Cons = {
}
att.Slot = "kali_barrel"
att.GivesFlags = {"kali_barrel_mw19", "kali_barrel_carbine", "notwood", "mk12_barrel", "mk12_bipod_ok"}