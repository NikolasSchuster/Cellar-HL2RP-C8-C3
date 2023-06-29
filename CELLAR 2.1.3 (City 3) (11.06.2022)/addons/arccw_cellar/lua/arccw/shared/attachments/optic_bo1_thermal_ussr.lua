att.PrintName = "NSPU 1PN34 Thermal Scope"
att.AbbrevName = "Infrared Scope (USSR)"
att.Icon = Material("entities/acwatt_optic_bo1_thermal_us.png", "mips smooth")
att.Description = "Black Ops 1 Thermal Sight. Low magnification optical sight that highlights enemies in white. Exclusive to AK platoform weapons."

att.SortOrder = 5

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Neutrals = {"bo.desc"}

att.AutoStats = true
att.Slot = {"bo1_irscope_ussr"}

att.Model = "models/weapons/arccw/atts/bo1_thermal_ussr.mdl"
att.ModelOffset = Vector(0, 0, 0)
att.OffsetAng = Angle(0, 0, 0)

att.AdditionalSights = {
    {
        Pos = Vector(0, 6, -4.51),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        ScrollFunc = ArcCW.SCROLL_NONE,
        IgnoreExtra = false,
        Thermal = true,
        ThermalScopeColor = Color(100, 255, 255),
        ThermalHighlightColor = Color(255, 255, 255),
        Contrast = 0.9, -- allows you to adjust the values for contrast and brightness when either NVScope or Thermal is enabled.
    }
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo1_thermal_ussr.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 6.9
att.HolosightBone = "holosight"
att.HolosightBlackbox = true
att.HolosightPiece = "models/weapons/arccw/atts/bo1_thermal_ussr_hsp.mdl"

att.Mult_SightTime = 1.01

att.HolosightMagnification = 2

att.Colorable = false