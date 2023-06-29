att.PrintName = "Maria"
att.Icon = Material("entities/acwatt_bo2_cosmetic_bhp_maria.png", "smooth mips")
att.Description = "Special engraved High-Power that once belonged to a man with a checkered suit."

att.Desc_Neutrals = {"bo.cosmetic"}

att.SortOrder = 100
att.Slot = "bo2_bhp_cosmetic"

att.Free = true

att.ActivateElements = {"maria"}

att.FNV_Unique = true
att.AttachSound = "weapons/arccw/fnv_ee/fnv_ww.ogg"
/*
att.Hook_GetShootSound = function(wep, sound)
    return "ArcCW_BO2.FNV_9mm_Fire"
end
*/

att.NoRandom = true