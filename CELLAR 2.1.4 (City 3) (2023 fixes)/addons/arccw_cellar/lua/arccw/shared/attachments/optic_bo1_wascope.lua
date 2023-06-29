att.PrintName = "WA2000 Scope (12x)"
att.Icon = Material("entities/acwatt_optic_bo1_l96.png", "mips smooth")
att.Description = "High Power Scope for the WA2000."

att.SortOrder = 6

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}


att.AutoStats = true
att.Slot = "bo1_wascope"

att.Model = "models/weapons/arccw/atts/bo1_wascope.mdl"

att.DroppedModel = "models/weapons/arccw/atts/bo1_redfield.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(-0.15, 12.5, -0.9),
        Ang = Angle(0, 0, 0),
        Magnification = 1.6,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 4,
        IgnoreExtra = true
    },
}

att.ScopeGlint = false

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo1_wa2000.png")
att.HolosightNoFlare = true
att.HolosightSize = 9.5
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo1_wascope_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true
att.HolosightMagnification = 6
att.HolosightMagnificationMin = 2
att.HolosightMagnificationMax = 12

att.Mult_SightTime = 1.125