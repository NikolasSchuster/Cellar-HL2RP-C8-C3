att.PrintName = "Sally's Blessing"
att.Icon = Material("entities/acwatt_ammo_papunch.png", "mips smooth")
att.Description = "The reward for keeping your starting weapon around until the very end. The M1911 now shoots Element 115 infused Grenades."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"ammo_1911_pap"}

att.MagReducer = true
att.ActivateElements = {"reducedmag", "pap_starting"}
att.AdminOnly = true
att.PackAPunch = true

att.SortOrder = 101
att.Mult_Damage = 2.5
att.Mult_DamageMin = 2.5
att.Mult_Penetration = 2.5

att.Mult_AccuracyMOA = 12.5
att.Mult_HipDispersion = 2
att.Override_MuzzleEffect = "pap_heavy_flame"
att.Override_ShootEntity = "arccw_bo1_mustangsally"
att.Mult_MuzzleVelocity = 100000

att.AttachSound = "weapons/arccw/pap/pap_jingle.wav"

att.Override_MuzzleEffect = "pap_muzzle_big"

att.Hook_FireBullets = function(wep, data)
  wep:EmitSound("PAP_Effect")
end