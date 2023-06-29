att.PrintName = "StG-44SD Barrel"
att.Icon = Material("entities/acwatt_supp_bo1_supp.png", "mips smooth")
att.Description = "Integrated Suppressor Barrel for the STG-44."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "stg44_barrel"

att.GivesFlags = {"stg44sd", "sd_nomuzz"}

att.SortOrder = 98

att.Model = "models/weapons/arccw/atts/bo1_suppressor.mdl"

att.Silencer = true
att.Override_MuzzleEffect = "muzzleflash_suppressed"
att.IsMuzzleDevice = true

att.Mult_ShootVol = 0.75
att.Mult_AccuracyMOA = 0.9
att.Mult_Range = 1.05

att.Mult_SightTime = 1.05
att.Mult_HipDispersion = 1.05

att.Add_BarrelLength = 4