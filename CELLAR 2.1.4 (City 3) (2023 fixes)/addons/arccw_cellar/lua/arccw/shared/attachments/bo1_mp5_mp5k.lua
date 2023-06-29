att.PrintName = "MP5K Conversion"
att.Icon = Material("entities/acwatt_bo2_longbarrel.png", "mips smooth")
att.Description = "Short-barreled MP5 variant equipped with a foregrip by default which improves recoil control slightly. Reduced weight improves sight time, sighted movement speed, and overall movement speed. Accuracy and range decrease due to the shorter barrel."

att.SortOrder = 98

att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Slot = "bo1_mp5_barrel"
att.GivesFlags = {"mp5k", "mp5k_rail", "mp5kk"}
att.ExcludeFlags = {"nomp5k"}

att.AutoStats = true

att.Override_HoldtypeActive = "smg"
att.Override_HoldtypeSights = "smg"

att.Mult_Recoil = 0.85
att.Mult_RecoilSide = 1.5

att.Mult_SightTime = 0.75
att.Mult_Range = 0.75
att.Mult_AccuracyMOA = 2
att.Mult_HipDispersion = 1.25
att.Mult_MoveDispersion = 0.5

att.Mult_RPM = 900 / 800

att.Add_BarrelLength = -4