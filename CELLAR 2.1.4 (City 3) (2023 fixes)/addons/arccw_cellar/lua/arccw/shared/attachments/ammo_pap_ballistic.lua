att.PrintName = "Pack-A-Punched"
att.Icon = Material("entities/acwatt_ammo_papunch.png", "mips smooth")
att.Description = "Lethal Spring-Propelled Blades infused with Element 115. The magazine capacity is altered."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"ammo_pap_bknife"}

att.PackAPunch = true
att.AdminOnly = true

att.GivesFlags = {"pap_bknife", "papname1", "papname2", "papname3"}

att.SortOrder = 100
att.Mult_Damage = 2.5
att.Mult_DamageMin = 2.5
att.Mult_MeleeDamage = 2.5
att.Mult_MuzzleVelocity = 1.5

att.AttachSound = "weapons/arccw/pap/pap_jingle.wav"

att.Override_ShootEntity = "arccw_bo1_bknife_pap"

att.Hook_FireBullets = function(wep, data)
  wep:EmitSound("PAP_Effect")
end