att.PrintName = "PE PEM Scope (WAW)"
att.Icon = Material("entities/acwatt_optic_waw_telescopic.png", "mips smooth")
att.Description = "Soviet Scope that has gone through some modifications for use on the PTRS-41"

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}

att.SortOrder = 1000

att.AutoStats = true
att.Slot = "waw_pem_scope"

att.Model = "models/weapons/arccw/atts/waw_pemscope.mdl"
att.GivesFlags = {"waw_pemscope"}

att.AdditionalSights = {
    {
        Pos = Vector(0, 9, -3.525),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 2,
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/waw_telescopic.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 10.5
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/waw_pemscope_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 4

att.Mult_SightTime = 1.1