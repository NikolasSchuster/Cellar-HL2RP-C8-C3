att.PrintName = "Slug Rounds"
att.Icon = Material("entities/acwatt_ammo_bo1_fmj.png", "mips smooth")
att.Description = "Load one large projectile instead of pellets, allowing for more accurate shooting."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"ammo_pap_sg", "ammo_pap_pumpsg"}

att.Mult_Damage = 0.9
att.Mult_DamageMin = 1.2
att.Mult_RangeMin = 0
att.Mult_Range = 2
att.Mult_AccuracyMOA = 0.25
att.Override_Num = 1

att.Override_HullSize = 0
att.Override_BodyDamageMults = {}

att.Hook_Compatible = function(wep)
    return wep.Num > 1
end