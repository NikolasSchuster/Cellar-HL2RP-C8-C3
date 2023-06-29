att.PrintName = "DSR Scope (12x)"
att.Icon = Material("entities/acwatt_optic_bo1_l96.png", "mips smooth")
att.Description = "German high powered scope for the DSR=50."

att.SortOrder = 12

att.Desc_Pros = {
    "+ Precision sight picture",
}
att.Desc_Cons = {
    "- Visible glint"
}
att.AutoStats = true
att.Slot = "bo2_dsr50_scope"

att.Model = "models/weapons/arccw/atts/bo2_dsr50_scope.mdl"
att.ModelOffset = Vector(0, 0, 0)
att.OffsetAng = Angle(0, 0, 0)

att.GivesFlags = {"dsr_scope"}

att.DroppedModel = "models/weapons/arccw/atts/bo2_dsr50_scope.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 5, 0.015),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 4,
        IgnoreExtra = true
    }
}

att.ScopeGlint = false

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/psg1_scope.png")
att.HolosightNoFlare = true
att.HolosightSize = 11
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo2_dsr50_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true
att.HolosightMagnification = 6
att.HolosightMagnificationMin = 2
att.HolosightMagnificationMax = 12

att.Mult_SightTime = 1.125