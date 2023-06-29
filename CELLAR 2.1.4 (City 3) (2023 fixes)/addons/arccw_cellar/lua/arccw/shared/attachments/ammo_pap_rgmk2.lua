att.PrintName = "Pack-A-Punched"
att.Icon = Material("entities/acwatt_ammo_papunch.png", "mips smooth")
att.Description = "Ray Gun now fires even more powerful balls of plasma.."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"ammo_rgmk2_pap"}
att.GivesFlags = {"papraygun"}

att.PackAPunch = true
att.AdminOnly = true

att.MagExtender = true

att.SortOrder = 100
att.Override_ShootEntity = "arccw_bo2_rgmk2_pap"
att.Override_MuzzleEffect = "rgmk2_pap_flash"
--att.Override_Tracer = "bo1_raygun_tracer_pap"

att.AttachSound = "weapons/arccw/pap/pap_jingle.wav"

att.Hook_FireBullets = function(wep, data)
  wep:EmitSound("PAP_Effect")
end