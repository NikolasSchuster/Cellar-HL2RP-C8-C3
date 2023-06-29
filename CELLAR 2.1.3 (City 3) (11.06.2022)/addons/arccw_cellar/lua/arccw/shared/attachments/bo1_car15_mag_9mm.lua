att.PrintName = "CAR-15 9x19mm Magazine"
att.AbbrevName = "9x19mm Magazine"
att.Icon = Material("entities/acwatt_bo1_ext_mag.png", "mips smooth")
att.Description = "Your assault rifle has been converted to fire 9x19mm Parabellum rounds, effectively making it an SMG."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"car15_9mm_ammo"}

att.ActivateElements = {"9mm_mag"}
att.GivesFlags = {"m635"}

att.SortOrder = 98

att.Override_Trivia_Calibre = "9x19mm Parabellum"
att.Mult_Damage = 0.75
att.Mult_DamageMin = 0.75
att.Mult_Penetration = 0.75
att.Mult_Recoil = 0.5
att.Mult_RecoilSide = 0.5
att.Mult_Range = 0.6
att.Mult_AccuracyMOA = 1.5
att.Mult_VisualRecoilMult = 0.5
att.Override_ClipSize = 32
att.Override_Ammo = "pistol"

att.Override_MuzzleEffect = "muzzleflash_smg"