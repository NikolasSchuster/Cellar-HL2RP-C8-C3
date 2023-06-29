att.PrintName = "AN/PEQ-15 (BO2)"
att.Icon = Material("entities/acwatt_tac_bo2_anpeq.png", "mips smooth")
att.Description = "Tacical laser and weapon light. Tighter aim when firing from hip, less dispersion when moving."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "- Visible Laser Sight",
    "- Visible Light Beam"
}
att.AutoStats = true
att.Slot = {"tac", "bo2_anpeq", "bo1_tacall", "bo1_tacprimary"}
att.GivesFlags = {"bo1_laser"}

att.Model = "models/weapons/arccw/atts/bo2_anpeq.mdl"

att.KeepBaseIrons = true

att.Laser = false
att.LaserStrength = 5 / 5
att.LaserBone = "laser"

att.ColorOptionsTable = {Color(255, 0, 0)}

att.Flashlight = false
att.FlashlightFOV = 50
att.FlashlightFarZ = 512 -- how far it goes
att.FlashlightNearZ = 1 -- how far away it starts
att.FlashlightAttenuationType = ArcCW.FLASH_ATT_LINEAR -- LINEAR, CONSTANT, QUADRATIC are available
att.FlashlightColor = Color(255, 255, 255)
att.FlashlightTexture = "effects/flashlight001"
att.FlashlightBrightness = 4
att.FlashlightBone = "light"

att.ToggleStats = {
    {
        PrintName = "Laser",
        Laser = true,
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75
    },
    {
        PrintName = "Light",
        Flashlight = true,
    },
    {
        PrintName = "Both",
        Laser = true,
        Flashlight = true,
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75
    },
    {
        PrintName = "Off",
    }
}