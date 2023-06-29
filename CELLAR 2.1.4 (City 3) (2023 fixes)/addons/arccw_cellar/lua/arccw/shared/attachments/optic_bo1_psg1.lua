att.PrintName = "Hensoldt ZF 6×42 (2-8x)"
att.AbbrevName = "Hensoldt [BO1](8x)"
att.Icon = Material("entities/acwatt_optic_bo1_l96.png", "mips smooth")
att.Description = "German high power scope originally for the HK PSG-1. Magnification between 4x and 8x."

att.SortOrder = 150

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}

att.AutoStats = true
att.Slot = {"bo1_sniper_scope", "bo1_hendsoldt"}

att.Model = "models/weapons/arccw/atts/bo1_hensoldt.mdl"
att.ModelOffset = Vector(0, -0.1, 0)
att.OffsetAng = Angle(0, 0, 0)

att.GivesFlags = {"psg1_scope", "no_rail"}

att.DroppedModel = "models/weapons/arccw/atts/bo1_hensoldt.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(-0.025, 11, -1.185),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 4,
        IgnoreExtra = true
    }
}

att.ScopeGlint = false

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/psg1_scope.png")
att.HolosightNoFlare = true
att.HolosightSize = 10.25
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo1_hensoldt_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true
att.HolosightMagnification = 6
att.HolosightMagnificationMin = 2
att.HolosightMagnificationMax = 8

att.Mult_SightTime = 1.125