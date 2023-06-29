att.PrintName = "Wood Furniture"
att.Icon = Material("entities/acwatt_m16_stock.png", "mips smooth")
att.Description = "Patrolling the Mojave makes you wish for a nuclear winter."

att.Desc_Neutrals = {
    " Replicate the look of the the original Service Rifle from Fallout: New Vegas to access this attachment!"
}
att.AutoStats = true
att.Free = true
att.IgnorePickX = true

att.SortOrder = 100
att.Slot = {"kali_wood"}
att.ExcludeFlags = {
    "notwood",
}
att.GiveFlags = {"FNV_Unique"}

att.FNV_Unique = true
att.AttachSound = "weapons/arccw/fnv_ee/fnv_ww.ogg"

att.NoRandom = true