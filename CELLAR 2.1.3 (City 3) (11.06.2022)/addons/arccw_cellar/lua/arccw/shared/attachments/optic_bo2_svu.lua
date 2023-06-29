att.PrintName = "SVU Scope (12x)"
att.Icon = Material("entities/acwatt_optic_bo1_l96.png", "mips smooth")
att.Description = "Russian high powered scope for the SVU-AS."

att.SortOrder = 120

att.Desc_Pros = {
    "+ Precision sight picture",
}
att.Desc_Cons = {
    "- Visible glint"
}
att.AutoStats = true
att.Slot = "bo2_svu_scope"

att.Model = "models/weapons/arccw/atts/bo2_svu_scope.mdl"
att.ModelOffset = Vector(0, 0, 0)
att.OffsetAng = Angle(0, 0, 0)

att.GivesFlags = {"svu_scope"}

att.DroppedModel = "models/weapons/arccw/atts/bo2_svu_scope.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(-0.01, 12, 1.08),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 4,
        IgnoreExtra = true
    }
}

att.ScopeGlint = false

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo1_dragunov.png")
att.HolosightNoFlare = true
att.HolosightSize = 10.75
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo2_svu_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true
att.HolosightMagnification = 6
att.HolosightMagnificationMin = 2
att.HolosightMagnificationMax = 12

att.Mult_SightTime = 1.1