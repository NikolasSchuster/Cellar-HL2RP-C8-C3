att.PrintName = "Pack-A-Punched"
att.Icon = Material("entities/acwatt_ammo_papunch.png", "mips smooth")
att.Description = "High Explosive Ordinance infused with Element 115. The magazine capacity is altered."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"ammo_pap_xbow"}

att.PackAPunch = true
att.AdminOnly = true

att.GivesFlags = {"pap_xbow", "papname1", "papname2", "papname3"}

att.SortOrder = 100
att.Mult_Damage = 2.5
att.Mult_DamageMin = 2.5

att.AttachSound = "weapons/arccw/pap/pap_jingle.wav"

att.Override_ShootEntity = "arccw_bo1_xbow_bolt_exp_pap"

att.Hook_FireBullets = function(wep, data)
  wep:EmitSound("PAP_Effect")
end