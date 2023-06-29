att.PrintName = "Fast Mags"
att.Icon = Material("entities/acwatt_bo1_dualmag.png", "mips smooth")
att.Description = "A mechanism for reloading your weapon more effectively."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"bo1_mag", "bo1_dualmag", "bo3_mags", "bo2_fastmag"}

att.ExcludeFlags = {"mp5k", "ubanims"}
att.GivesFlags = {"bo1_mag_fast"}
att.BO1_FastMag = true

att.Mult_ReloadTime = 0.75
att.Mult_MoveDispersion = 1.25
att.Mult_SightTime = 1.15
att.Mult_DrawTime = 1.25
att.Mult_HolsterTime = 1.25