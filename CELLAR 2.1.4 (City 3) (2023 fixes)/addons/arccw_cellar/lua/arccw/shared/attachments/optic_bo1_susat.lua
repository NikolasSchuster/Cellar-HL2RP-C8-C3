att.PrintName = "SUSAT (4x)"
att.Icon = Material("entities/acwatt_optic_bo1_acog.png", "mips smooth")
att.Description = "Medium range combat scope produced in the UK for improved precision at medium ranges."
att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}

att.SortOrder = 4

att.AutoStats = true
att.Slot = {"optic", "bo1_acog", "bo1_susat"}

att.Model = "models/weapons/arccw/atts/bo1_susat.mdl"
att.ModelOffset = Vector(1, 0, -0.125)

att.GivesFlags = {"susat_norail"}

att.AdditionalSights = {
    {
        Pos = Vector(0, 8, -1.785),
        Ang = Angle(0, 0, 0),
        Magnification = 1,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 2,
        IgnoreExtra = true,
        HolosightBone = "holosight",
        HolosightData = {
            Holosight = true,
            HolosightMagnification = 4,
            HolosightMagnificationMin = 2,
            HolosightMagnificationMax = 4,
            HolosightNoFlare = true,
            HolosightSize = 9,
            HolosightBlackbox = true,
            HolosightReticle = Material("hud/scopes/bo1_susat.png", "mips smooth"),
            HolosightPiece = "models/weapons/arccw/atts/bo1_susat_hsp.mdl",
        },
        CrosshairInSights = false,
    },
    {
        Pos = Vector(-0.005, 8, -2.675),
        Ang = Angle(-0.55, 0, 0),
        Magnification = 1.25,
        CrosshairInSights = false,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        IgnoreExtra = true,
        HolosightData = {
            Holosight = false,
        },
    },
}

att.HolosightPiece = "models/weapons/arccw/atts/bo1_susat_hsp.mdl"
att.Colorable = true

att.Mult_SightTime = 1.1