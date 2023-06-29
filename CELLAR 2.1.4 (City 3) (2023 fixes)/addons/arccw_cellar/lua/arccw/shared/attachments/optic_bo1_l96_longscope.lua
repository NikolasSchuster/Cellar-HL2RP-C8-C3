att.PrintName = "Redfield (16x)"
att.Icon = Material("entities/acwatt_optic_bo1_l96.png", "mips smooth")
att.Description = "Variable zoom scope for the L115A1 AWM."

att.SortOrder = 999

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}

att.AutoStats = true
att.Slot = "bo1_awm"

att.Model = "models/weapons/arccw/atts/bo1_redfield.mdl"

att.DroppedModel = "models/weapons/arccw/atts/bo1_redfield.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 6, -4.6),
        Ang = Angle(0, 0, 0),
        Magnification = 1.6,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 3,
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo1_l96.png")
att.HolosightNoFlare = true
att.HolosightSize = 12
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo1_redfield_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true
att.HolosightMagnification = 6
att.HolosightMagnificationMin = 2
att.HolosightMagnificationMax = 16

att.Mult_SightTime = 1.125