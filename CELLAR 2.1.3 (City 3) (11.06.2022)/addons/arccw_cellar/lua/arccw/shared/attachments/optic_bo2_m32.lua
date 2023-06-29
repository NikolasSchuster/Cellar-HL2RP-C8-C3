att.PrintName = "M32 Rangefinder (HOLO)"
att.Icon = Material("entities/acwatt_optic_bo2_docter.png", "mips smooth")
att.Description = "Small red dot sight with a Soviet-style mount."

att.SortOrder = 1

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Neutrals = {"bo.desc"}

att.AutoStats = true
att.Slot = "bo2_m32_sight"

att.Model = "models/weapons/arccw/atts/bo2_m32_scope.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 2.5, -5.875),
        Ang = Angle(0, 0, 0),
        Magnification = 1.1,
        ScrollFunc = ArcCW.SCROLL_NONE,
        IgnoreExtra = false
    }
}

att.Holosight = true
att.HolosightReticle = Material("hud/reticles/bo2_m32_reticle.png", "mips smooth")
att.HolosightSize = 3
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo2_m32_hsp.mdl"

att.Mult_SightTime = 1.01

att.HolosightMagnification = 4

att.Colorable = true