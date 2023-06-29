att.PrintName = "Hybrid Speedloader"
att.Icon = Material("entities/acwatt_bo1_ammo_phyton_speed.png", "mips smooth")
att.Description = "A clip that can insert all rounds of a cylinder at once. This variant conserves ammo by only using the speedloader while empty."
att.Desc_Pros = {
    "bo1.speedloader2"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo1_cylinder"}
att.GivesFlags = {"bo1_speedloader"}
att.InvAtt = "bo1_cylinder_speedloader"

att.BO1_SpeedLoader = true
att.Override_ShotgunReload = false
att.Override_HybridReload = true