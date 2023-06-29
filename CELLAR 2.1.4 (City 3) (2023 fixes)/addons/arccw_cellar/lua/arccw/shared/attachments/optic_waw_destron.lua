att.PrintName = "Destron (1.5x)"
att.Icon = Material("entities/acwatt_optic_bo1_acog.png", "mips smooth")
att.Description = "Custom mid-range scope originally for the Walther P38."

att.SortOrder = 1.5

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom"
}
att.Desc_Neutrals = {"bo.desc"}


att.AutoStats = true
att.Slot = {"bo1_lp_optic"}

att.Model = "models/weapons/arccw/atts/waw_destron.mdl"
att.ModelOffset = Vector(0, 0, 0)
att.OffsetAng = Angle(0, 0, 0)

att.AdditionalSights = {
    {
        Pos = Vector(-0.025, 10, -0.775),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo1_acog_cross.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 12
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/waw_destron_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 1.5

att.Mult_SightTime = 1.1