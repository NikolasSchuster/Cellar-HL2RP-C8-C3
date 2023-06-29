att.PrintName = "Colt 3x20 Carry Handle Scope (3x)"
att.AbbrevName = "Colt Scope [BO1](3x)"
att.Icon = Material("entities/acwatt_optic_bo1_acog.png", "mips smooth")
att.Description = "Medium range combat scope for improved precision at longer ranges."
att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}

att.SortOrder = 4

att.AutoStats = true
att.Slot = {"optic", "bo1_acog"}

att.Model = "models/weapons/arccw/atts/bo1_coltscope.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(-0, 8, -1.0325),
        Ang = Angle(0, 0, 0),
        Magnification = 1,
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo1_acog_cross.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 13.5
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo1_coltscope_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 3

att.Mult_SightTime = 1.1