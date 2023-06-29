att.PrintName = "PSO-1 (6x)"
att.Icon = Material("entities/acwatt_optic_bo1_l96.png", "mips smooth")
att.Description = "Scope designed for the Dragunov SVD-63."

att.SortOrder = 6

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}

att.AutoStats = true
att.Slot = "bo1_pso"

att.Model = "models/weapons/arccw/atts/bo1_pso.mdl"

att.DroppedModel = "models/weapons/arccw/atts/bo1_pso.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(-0.02, 11, -1.28),
        Ang = Angle(0, 0, 0),
        Magnification = 1.5,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 2,
        IgnoreExtra = true,
        CrosshairInSights = false,
    }
}

att.ScopeGlint = false

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo1_dragunov.png")
att.HolosightNoFlare = true
att.HolosightSize = 12.5
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo1_pso_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true
att.HolosightMagnification = 6
att.HolosightMagnificationMin = 4
att.HolosightMagnificationMax = 6

att.Mult_SightTime = 1.1