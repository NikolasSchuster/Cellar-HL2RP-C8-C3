att.PrintName = "Farview (12x)"
att.Icon = Material("entities/acwatt_optic_bo1_l96.png", "mips smooth")
att.Description = "High-power scope for the L115A1 AWM."

att.SortOrder = 1000

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}

att.AutoStats = true
att.Slot = "bo1_awm"

att.Model = "models/weapons/arccw/atts/bo1_farview.mdl"
att.ModelOffset = Vector(0, 0, -0.15)
att.OffsetAng = Angle(0, 0, 0)

att.DroppedModel = "models/weapons/arccw/atts/bo1_farview.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 10, -5.0525),
        Ang = Angle(0, 0, 0),
        Magnification = 1.5,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 4,
        IgnoreExtra = true
    }
}

att.ScopeGlint = false

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo1_l96.png")
att.HolosightNoFlare = true
att.HolosightSize = 11.5
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo1_farview_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true
att.HolosightMagnification = 6
att.HolosightMagnificationMin = 2
att.HolosightMagnificationMax = 12

att.Mult_SightTime = 1.125