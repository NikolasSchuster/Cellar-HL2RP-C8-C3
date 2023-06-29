att.PrintName = "Buckshot Shells"
att.Icon = Material("entities/acwatt_ammo_bo1_hp.png", "mips smooth")
att.Description = "Load multiple pellets that do more damage close-up."
att.Desc_Pros = {
    "bo1.ksg.buck"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo2_ksg_buckshot"}

att.Override_Num = 8
att.Override_AccuracyMOA = 40
att.Override_AccuracyMOA_Priority = 0

att.Override_HullSize = 1
att.Override_HullSize_Priority = 0

att.Override_BodyDamageMults = {[HITGROUP_HEAD] = 1,}
att.Override_BodyDamageMults_Priority = 0

att.Mult_Damage = 1.2
att.Mult_HipDispersion = 1.25
att.Mult_Range = 0.75