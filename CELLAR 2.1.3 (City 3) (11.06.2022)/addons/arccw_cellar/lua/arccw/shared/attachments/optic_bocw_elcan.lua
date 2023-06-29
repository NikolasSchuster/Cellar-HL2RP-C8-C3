att.PrintName = "ELCAN C79 (2x)"
att.Icon = Material("entities/acwatt_optic_bocw_elcan.png", "mips smooth")
att.Description = "Short range combat scope for improved precision at slightly longer ranges."
att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}

att.SortOrder = 4

att.AutoStats = true
att.Slot = {"optic", "bo1_acog"}

att.Model = "models/weapons/arccw/atts/bocw_elcan.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 9, -1.285),
        Ang = Angle(0, 0, 0),
        Magnification = 1,
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bocw_elcan_cross.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 9.6
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bocw_elcan_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 2

att.Mult_SightTime = 1.1