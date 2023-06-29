att.PrintName = "Leupold Mk 4 HAMR (3.5x)"
att.AbbrevName = "HAMR [BO2](3.5x)"
att.Icon = Material("entities/acwatt_optic_bo2_hamr.png", "mips smooth")
att.Description = "Black Ops 2 Hybrid Scope. Medium range combat scope for improved precision at longer ranges."

att.SortOrder = 6

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}

att.AutoStats = true
att.Slot = {"optic", "bo1_acog"}

att.Model = "models/weapons/arccw/atts/bo2_hamr.mdl"
att.ModelOffset = Vector(0, 0, 0)
att.OffsetAng = Angle(0, 0, 0)

att.AdditionalSights = {
    {
        Pos = Vector(0, 8.5, -1.025),
        Ang = Angle(0, 0, 0),
        Magnification = 1,
        CrosshairInSights = false,
        IgnoreExtra = true,
        HolosightBone = "bottom",
        HolosightData = {
            Holosight = true,
            HolosightReticle = Material("hud/scopes/bo2_hamr.png", "mips smooth"),
            HolosightNoFlare = true,
            HolosightSize = 9,
            HolosightPiece = "models/weapons/arccw/atts/bo2_hamr_hsp.mdl",
            Colorable = true,
            HolosightBlackbox = true,
            HolosightMagnification = 3.5,
        },
    },
    {
        Pos = Vector(0, 8, -2.125),
        Ang = Angle(-0, 0, 0),
        Magnification = 1.25,
        IgnoreExtra = true,
        HolosightBone = "top",
        HolosightData = {
            Holosight = true,
            HolosightReticle = Material("hud/reticles/reddot.png", "mips smooth"),
            HolosightNoFlare = true,
            HolosightSize = 0.5,
            HolosightPiece = "models/weapons/arccw/atts/bo2_hamr_hsp.mdl",
            Colorable = true,
        },
    },
}

att.Holosight = true
att.HolosightPiece = "models/weapons/arccw/atts/bo2_hamr_hsp.mdl"
att.Mult_SightTime = 1.1