att.PrintName = "Redfield Scope (16x)"
att.Icon = Material("entities/acwatt_optic_bo1_l96.png", "mips smooth")
att.Description = "BO1 Variable Zoom scope. Provides imroved sight picture of targets much father than any other scope."

att.SortOrder = 7

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}

att.AutoStats = true
att.Slot = {"optic" , "bo1_longscope"}

att.Model = "models/weapons/arccw/atts/bo1_longscope.mdl"

att.DroppedModel = "models/weapons/arccw/atts/bo1_longscope.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 10, -1.125),
        Ang = Angle(0, 0, 0),
        Magnification = 1.5,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 8,
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo1_l96.png")
att.HolosightNoFlare = true
att.HolosightSize = 10
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo1_longscope_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true
att.HolosightMagnification = 2
att.HolosightMagnificationMin = 2
att.HolosightMagnificationMax = 16

att.Mult_SightTime = 1.125