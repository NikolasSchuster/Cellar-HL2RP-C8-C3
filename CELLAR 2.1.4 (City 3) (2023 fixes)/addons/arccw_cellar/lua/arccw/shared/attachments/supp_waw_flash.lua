att.PrintName = "Flash Suppressor (WAW)"
att.Icon = Material("entities/acwatt_supp_bo1_supp.png", "mips smooth")
att.Description = "Oldschool flash and sound moderator."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.AutoStats = true
att.Slot = {"waw_muzzle"}
att.GivesFlags = {"waw_flashhider"}

att.SortOrder = 150

att.Override_MuzzleEffect = "muzzleflash_suppressed"
att.Silencer = true
att.Override_MuzzleEffectAttachment = 3
att.IsMuzzleDevice = true

att.Mult_ShootPitch = 1.1
att.Mult_ShootVol = 0.75
att.Mult_Range = 0.9

att.Add_BarrelLength = 5