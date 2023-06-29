att.PrintName = "PSG-1 Barrel"
att.Icon = Material("entities/acwatt_bo2_longbarrel.png", "mips smooth")
att.Description = [[
  Longer, heavier barel and extended handguard increase range and reduce imprecision as well as recoil, at the cost of sight time.
  A modification was also made to the receiver to remove full auto from this marksman's rifle.
]]

att.SortOrder = 109
att.AutoStats = true

att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Slot = "bo1_g3_barrel"
att.GivesFlags = {"psg1_barrel"}

att.Mult_Range = 1.75
att.Mult_Recoil = 0.9
att.Mult_RecoilSide = 0.9
att.Mult_SightTime = 1.25
att.Mult_AccuracyMOA = 0.5


att.Override_Firemodes = {
  {
    Mode = 1,
  },
  {
    Mode = 0
  }
}

att.Hook_GetShootSound = function(wep, sound)
  return "ArcCW_BO1.G3_Fire"
end

att.Hook_GetDistantShootSound = function(wep, distancesound)
  if distancesound == wep.DistantShootSound then
      return {
        "weapons/arccw/bo1_generic_sniper/ringoff/1/ring_00.wav",
        "weapons/arccw/bo1_generic_sniper/ringoff/1/ring_01.wav",
        "weapons/arccw/bo1_generic_sniper/ringoff/1/ring_02.wav"
      }
  end
end