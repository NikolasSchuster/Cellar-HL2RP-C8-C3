att.PrintName = "PK-AV (4x)"
att.Icon = Material("entities/acwatt_optic_bo1_acog.png", "mips smooth")
att.Description = "Medium range optic with Soviet-style mount."
att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}

att.SortOrder = 4

att.AutoStats = true
att.Slot = "bo1_pso"

att.Model = "models/weapons/arccw/atts/bo1_pka.mdl"

att.DroppedModel = "models/weapons/arccw/atts/bo1_pka.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 10, -1.3),
        Ang = Angle(0, 0, 0),
        Magnification = 1,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 1,
        ZoomSound = "weapons/arccw/fiveseven/fiveseven_slideback.wav",
        IgnoreExtra = true
    }
}

att.ScopeGlint = false

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo1_acog_pka.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 7.25
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo1_pka_hsp.mdl"
att.Colorable = true

att.HolosightMagnification = 4
att.HolosightBlackbox = true

att.Mult_SightTime = 1.1