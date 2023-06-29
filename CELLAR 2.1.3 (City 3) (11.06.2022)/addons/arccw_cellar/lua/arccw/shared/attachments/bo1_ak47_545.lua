att.PrintName = "AK-47 5.45x39mm Conversion"
att.AbbrevName = "5.45x39mm Conversion"
att.Icon = Material("entities/acwatt_bo1_ext_mag.png", "mips smooth")
att.Description = "Converts your weapon to load 5.45x39mm rounds, used by the AK-74 and its derivatives."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"ammo_bo1_74"}

att.ActivateElements = {"74"}
att.GivesFlags = {"74ammo"}

att.SortOrder = 97

att.Mult_Damage = 0.85
att.Mult_DamageMin = 0.85
att.Mult_Penetration = 1.1

att.Mult_Recoil = 0.75
att.Mult_RecoilSide = 0.75
att.Mult_AccuracyMOA = 0.75
att.Mult_VisualRecoilMult = 0.75

att.Override_Ammo = "smg1"
att.Override_Trivia_Calibre = "5.45x39mm"

att.Override_MuzzleEffect = "muzzleflash_4"

/*
att.Hook_GetShootSound = function(wep, sound)
  return "ArcCW_BO1.AK74u_Fire"
end
*/