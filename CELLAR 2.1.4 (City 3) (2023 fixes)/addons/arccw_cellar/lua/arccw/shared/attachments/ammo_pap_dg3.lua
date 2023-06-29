att.PrintName = "Pack-A-Punched"
att.Icon = Material("entities/acwatt_ammo_papunch.png", "mips smooth")
att.Description = "Even more powerful bolts of electricity."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"ammo_dg2_pap"}
att.GivesFlags = {"dg2pap"}

att.AdminOnly = true
att.PackAPunch = true

att.MagExtender = true

att.SortOrder = 100
att.Override_ShootEntity = "arccw_bo1_dg2_bolt_pap"
att.Override_MuzzleEffect = "dg3_flash"
--att.Override_Tracer = "bo1_raygun_tracer_pap"

att.AttachSound = "weapons/arccw/pap/pap_jingle.wav"

att.Hook_FireBullets = function(wep, data)
  wep:EmitSound("PAP_Effect")
end