att.PrintName = "Soviet Suppressor (BO1)"
att.Icon = Material("entities/acwatt_supp_bo1_supp.png", "mips smooth")
att.Description = "Soviet Suppressor that fits every weapon. Lightweight can cools and disperses gases leaving the barrel, muffling the firearm's audible report but slowing down muzzle velocity."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.AutoStats = true
att.Slot = {"muzzle", "muzzle_shotgun", "bo1_muzzle"}

att.SortOrder = 150

att.Model = "models/weapons/arccw/atts/bo1_soviet_supp.mdl"

att.Silencer = true
att.Override_MuzzleEffect = "muzzleflash_suppressed"
att.IsMuzzleDevice = true

att.Mult_ShootPitch = 1.1
att.Mult_ShootVol = 0.75
att.Mult_Range = 0.9

att.Add_BarrelLength = 5