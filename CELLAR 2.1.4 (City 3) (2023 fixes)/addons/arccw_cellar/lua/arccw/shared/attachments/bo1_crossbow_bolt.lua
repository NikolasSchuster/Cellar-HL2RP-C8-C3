att.PrintName = "Impact Bolts"
att.Icon = Material("entities/acwatt_ammo_bo1_hp.png", "mips smooth")
att.Description = "Switch to non-explosive crossbow bolts, which are lethal on a direct hit and easier to handle."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo1_xbow_ammo"}

att.Override_ShootEntity = "arccw_bo1_xbow_bolt"
att.Mult_ReloadTime = 0.8
att.Mult_AccuracyMOA = 0.25
att.Mult_MuzzleVelocity = 1.5
att.Mult_HipDispersion = 0.5

att.ActivateElements = {"xbow_bolt_impact"}