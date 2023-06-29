att.PrintName = "Trijicon ACOG 6x48 (6x)"
att.AbbrevName = "ACOG [BO2](6x)"
att.Icon = Material("entities/acwatt_optic_bo2_acog.png", "mips smooth")
att.Description = "Black Ops 2 ACOG Scope. Medium range combat scope for improved precision at longer ranges."

att.SortOrder = 6

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}

att.AutoStats = true
att.Slot = {"optic", "bo1_acog"}

att.Model = "models/weapons/arccw/atts/bo2_acog.mdl"
att.ModelOffset = Vector(0, 0, -0.125)
att.OffsetAng = Angle(0, 0, 0)

att.AdditionalSights = {
    {
        Pos = Vector(0, 8, -1.025),
        Ang = Angle(0, 0, 0),
        Magnification = 1,
        IgnoreExtra = true,
        CrosshairInSights = false,
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo2_acog.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 8.9
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo2_acog_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 6

att.Mult_SightTime = 1.1