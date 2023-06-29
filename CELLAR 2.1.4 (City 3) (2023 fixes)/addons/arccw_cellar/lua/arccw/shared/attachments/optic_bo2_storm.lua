att.PrintName = "Storm PSR Scope (12x)"
att.Icon = Material("entities/acwatt_optic_bo1_l96.png", "mips smooth")
att.Description = "High powered scope for the XPR-50."

att.SortOrder = 120

att.Desc_Pros = {
    "+ Precision sight picture",
}
att.Desc_Cons = {
    "- Visible glint"
}
att.AutoStats = true
att.Slot = "bo2_storm_scope"

att.Model = "models/weapons/arccw/atts/bo2_storm_scope.mdl"
att.ModelOffset = Vector(0, 0, 0)
att.OffsetAng = Angle(0, 0, 0)

att.GivesFlags = {"storm_scope"}

att.DroppedModel = "models/weapons/arccw/atts/bo2_storm_scope.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 5, -5.425),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 4,
        IgnoreExtra = true,
        Thermal = true,
        ThermalScopeColor = Color(100, 255, 255),
        ThermalHighlightColor = Color(255, 0, 0),
        Contrast = 0.9, -- allows you to adjust the values for contrast and brightness when either NVScope or Thermal is enabled.
    }
}

att.ScopeGlint = false

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo2_storm.png")
att.HolosightNoFlare = true
att.HolosightSize = 8.5
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo2_storm_hsp.mdl"
att.Colorable = false

att.HolosightBlackbox = true
att.HolosightMagnification = 6
att.HolosightMagnificationMin = 2
att.HolosightMagnificationMax = 12

att.Mult_SightTime = 1.125