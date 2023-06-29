att.PrintName = "Water Cooler"
att.Icon = Material("entities/acwatt_waw_perk_cooling.png", "mips smooth")
att.Description = "Decreases overheat and increases dissipation by 30%."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"waw_perk_cooling"}

att.HideIfBlocked = true
att.RequireFlags = {"enables_cooling"}

att.Mult_HeatCapacity = 1.3
att.Mult_HeatDissipation = 1.3
