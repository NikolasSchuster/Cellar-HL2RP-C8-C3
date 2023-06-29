att.PrintName = "Swarovski (1.5x)"
att.Icon = Material("entities/acwatt_optic_bo1_acog.png", "mips smooth")
att.Description = "Medium range scope made specifically for the AUG A1."

att.SortOrder = 1000

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}

att.AutoStats = true
att.Slot = "bo1_aug_sight"

att.Model = "models/weapons/arccw/atts/bo1_swarovski.mdl"

att.DroppedModel = "models/weapons/arccw/atts/bo1_swarovski.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0.025, 8, -5.65),
        Ang = Angle(0, 0, 0),
        Magnification = 1,
        IgnoreExtra = true,
        HolosightBone = "holosight",
        HolosightData = {
            Holosight = true,
            HolosightBlackbox = true,
            HolosightNoFlare = true,
            HolosightSize = 10,
            HolosightMagnification = 1.5,
            HolosightReticle = Material("hud/scopes/bo1_aug_crosshair.png", "mips smooth"),
            HolosightPiece = "models/weapons/arccw/atts/bo1_swarovski_hsp.mdl",
        }
    },
    {
        Pos = Vector(0.025, 8, -6.3),
        Ang = Angle(0.3, 0, 0),
        Magnification = 1.25,
        CrosshairInSights = false,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        IgnoreExtra = true,
        HolosightData = {
            Holosight = false,
        },
    },
}

att.HolosightPiece = "models/weapons/arccw/atts/bo1_swarovski_hsp.mdl"

att.Mult_SightTime = 1.05