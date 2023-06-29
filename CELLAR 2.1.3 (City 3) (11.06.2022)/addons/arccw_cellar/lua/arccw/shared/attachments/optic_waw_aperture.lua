att.PrintName = "Aperture Sight (WAW)"
att.Icon = Material("entities/acwatt_optic_waw_aperture.png", "mips smooth")
att.Description = "There is a black crosshair with a fairly large black dot center. Ideally it should improve your aim."

att.SortOrder = 100
att.Free = true

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Neutrals = {"bo.desc"}

att.Slot = "waw_aperture"
att.GivesFlags = {"waw_aperture", "waw_crosshair"}

att.Mult_SightTime = 1.05
att.WAW_Aperture = true
