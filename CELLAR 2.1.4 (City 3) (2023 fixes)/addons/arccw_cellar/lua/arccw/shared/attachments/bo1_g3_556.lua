att.PrintName = "G3A4 5.56x45mm Conversion"
att.AbbrevName = "5.56x45mm Conversion"
att.Icon = Material("entities/acwatt_bo1_ext_mag.png", "mips smooth")
att.Description = "Your battle rifle has been converted to fire standard 5.56mm NATO rounds. The lighter ammunition improves reload times slightly. The lower power of the ammunition means it doesn't go as far and does less damage to targets but improves recoil control."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo1_g3_ammo"}

att.ActivateElements = {"556_mag"}
att.GivesFlags = {"556mag"}

att.SortOrder = 98

att.Override_Trivia_Calibre = "5.56x45mm NATO"
att.Mult_Damage = 30 / 62
att.Mult_DamageMin = 25 / 37
att.Mult_Penetration = 1.1
att.Mult_Recoil = 0.35
att.Mult_RecoilSide = 0.35
att.Mult_Range = 0.65
att.Mult_VisualRecoilMult = 0.5
att.Override_ClipSize = 30
att.Mult_ReloadTime = 0.9
att.Override_Ammo = "smg1"

att.Override_Firemodes = {
  {
    Printname = "AUTO",
    Mode = 2,
  },
  {
    Printname = "SEMI-AUTO",
    Mode = 1,
  },
  {
    Mode = 0
  },
}

att.Override_MuzzleEffect = "muzzleflash_4"

att.Hook_GetShootSound = function(wep, fsound)
  if fsound == wep.ShootSound or sound == wep.FirstShootSound then return "ArcCW_BO1.AUG_Fire" end
end

att.Hook_GetDistantShootSound = function(wep, distancesound)
  if distancesound == wep.DistantShootSound then
    return {
      "weapons/arccw/bo1_aug/ringoff_f.wav",
      "weapons/arccw/bo1_aug/ringoff_r.wav"
    }
  end
end