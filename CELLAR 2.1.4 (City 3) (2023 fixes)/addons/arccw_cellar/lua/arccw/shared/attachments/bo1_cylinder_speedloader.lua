att.PrintName = "Speedloader"
att.Icon = Material("entities/acwatt_bo1_ammo_phyton_speed.png", "mips smooth")
att.Description = "A clip that can insert all rounds of a cylinder at once, speeding up reload. The remaining rounds in the cylinder are ejected and lost."
att.Desc_Pros = {
    "bo1.speedloader.pro"
}
att.Desc_Cons = {
    "bo1.speedloader.con"
}
att.AutoStats = true
att.Slot = {"bo1_cylinder"}
att.GivesFlags = {"bo1_speedloader"}

att.BO1_SpeedLoader = true
att.Override_ShotgunReload = false

att.Hook_ReloadDumpClip = function(wep)
    return true
end