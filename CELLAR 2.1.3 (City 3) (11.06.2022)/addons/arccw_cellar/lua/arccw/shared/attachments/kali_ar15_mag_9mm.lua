att.PrintName = "AR-15 9x19mm Magazine"
att.AbbrevName = "9x19mm Magazine"
att.Icon = Material("entities/acwatt_bo1_ext_mag.png", "mips smooth")
att.Description = "Your assault rifle has been converted to fire 9x19mm Parabellum rounds, effectively making it an SMG."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"kali_ar15_mag"}

att.ActivateElements = {"9mm_mag"}
att.GivesFlags = {"m635"}

att.RandomWeight = 0.1

att.SortOrder = 98

att.Override_Trivia_Calibre = "9x19mm Parabellum"
att.Mult_Damage = 0.80
att.Mult_DamageMin = 0.80
att.Mult_Penetration = 0.75
att.Mult_Recoil = 0.5
att.Mult_RecoilSide = 0.5
att.Mult_Range = 0.6
att.Mult_AccuracyMOA = 1.5
att.Mult_VisualRecoilMult = 0.5
att.Override_ClipSize = 32
att.Override_Ammo = "pistol"

att.Override_MuzzleEffect = "muzzleflash_smg"

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == wep.ShootSound or sound == wep.FirstShootSound then return "ArcCW_CDE.M16_9mm" end
    if fsound == wep.ShootSoundSilenced then return "ArcCW_CDE.M16_9mmSil" end
end

att.Hook_GetDistantShootSound = function(wep, distancesound)
    if distancesound == wep.DistantShootSound then return "ArcCW_CDE.M16_9mmDist" end
end

-- now that's more like it