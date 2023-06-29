att.PrintName = "WLP (BO2)"
att.Icon = Material("entities/acwatt_tac_bo2_anpeq.png", "mips smooth")
att.Description = "Tacical laser and weapon light. Tighter aim when firing from hip, less dispersion when moving."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "Visible Laser Sight",
    "Visible Light Beam"
}
att.AutoStats = true
att.Slot = {"tac_pistol", "bo2_wlp", "bo1_tacall", "bo1_tacpistol"}
att.GivesFlags = {"bo1_laser"}

att.Mult_SpeedMult = 0.99
att.Mult_SightTime = 1.1

att.Model = "models/weapons/arccw/atts/bo2_wlp.mdl"
att.ModelOffset = Vector(0, 0, -1)

att.KeepBaseIrons = true

att.Laser = false
att.LaserStrength = 5 / 5
att.LaserBone = "laser"

att.ColorOptionsTable = {Color(255, 0, 0)}

att.Flashlight = false
att.FlashlightFOV = 50
att.FlashlightFarZ = 1024 -- how far it goes
att.FlashlightNearZ = 32 -- how far away it starts
att.FlashlightAttenuationType = ArcCW.FLASH_ATT_LINEAR -- LINEAR, CONSTANT, QUADRATIC are available
att.FlashlightColor = Color(255, 255, 255)
att.FlashlightTexture = "effects/flashlight001"
att.FlashlightBrightness = 2
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