att.PrintName = "MTAR Laser Pointer (BO2)"
att.Icon = Material("entities/acwatt_tac_bo2_anpeq.png", "mips smooth")
att.Description = "Tacical laser pointer. Tighter aim when firing from hip, less dispersion when moving."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "- Visible Laser Sight",
    "- Visible Light Beam"
}
att.AutoStats = true
att.Slot = {"bo1_tac_mtar"}
att.GivesFlags = {"bo1_laser"}

att.Model = "models/weapons/arccw/atts/bo2_mtar_laser.mdl"

att.KeepBaseIrons = true

att.Laser = false
att.LaserStrength = 5 / 5
att.LaserBone = "light"

att.ColorOptionsTable = {Color(0, 255, 0)}

att.ToggleStats = {
    {
        PrintName = "Laser",
        Laser = true,
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75
    },
    {
        PrintName = "Off",
    }
}