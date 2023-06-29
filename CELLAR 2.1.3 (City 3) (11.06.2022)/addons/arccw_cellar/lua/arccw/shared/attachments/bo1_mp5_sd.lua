att.PrintName = "MP5SD Barrel"
att.Icon = Material("entities/acwatt_supp_bo1_supp.png", "mips smooth")
att.Description = "Integrated Suppressor for the MP5."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "bo1_mp5_barrel"

att.GivesFlags = {"mp5sd", "mp5sd2", "mp5sd3", "ubgls_on"}

att.SortOrder = 99

att.Model = "models/weapons/arccw/atts/bo1_suppressor.mdl"

att.Silencer = true
att.Override_MuzzleEffect = "muzzleflash_suppressed"
att.IsMuzzleDevice = true

att.Mult_ShootVol = 0.75
att.Mult_AccuracyMOA = 0.75

att.Mult_SightTime = 1.1
att.Mult_HipDispersion = 1.15

att.Add_BarrelLength = 4