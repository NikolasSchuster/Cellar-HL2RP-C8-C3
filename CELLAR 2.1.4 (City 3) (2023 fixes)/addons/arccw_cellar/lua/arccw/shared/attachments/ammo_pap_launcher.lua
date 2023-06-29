att.PrintName = "Pack-A-Punched"
att.Icon = Material("entities/acwatt_ammo_papunch.png", "mips smooth")
att.Description = "High Explosive Ordinance infused with Element 115. The magazine capacity is altered."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"ammo_pap_launchers"}

att.PackAPunch = true
att.AdminOnly = true

att.MagExtender = true
att.ActivateElements = {"extendedmag"}
att.GivesFlags = {"pap_launcher", "papname1", "papname2", "papname3"}

att.SortOrder = 100
att.Override_ShotgunReload = false
att.Mult_Damage = 2.5
att.Mult_DamageMin = 2.5
att.Mult_Penetration = 2.5

att.AttachSound = "weapons/arccw/pap/pap_jingle.wav"

att.Hook_FireBullets = function(wep, data)
  wep:EmitSound("PAP_Effect")
end