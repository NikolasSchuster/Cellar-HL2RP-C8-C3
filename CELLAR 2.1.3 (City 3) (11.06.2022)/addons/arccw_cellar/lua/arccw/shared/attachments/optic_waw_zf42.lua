att.PrintName = "ZF42 (WAW)"
att.Icon = Material("entities/acwatt_optic_waw_mosin.png", "mips smooth")
att.Description = "Sniper scope for the Mauser Karabiner 98k."
att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
    "bo1.sgreload",
}
att.Desc_Neutrals = {"bo.desc"}

att.SortOrder = 1000

att.AutoStats = true
att.Slot = "waw_ger_scope"

att.Mult_AccuracyMOA = 0.5

att.Model = "models/weapons/arccw/atts/waw_zf42.mdl"
att.GivesFlags = {"waw_zf42"}

att.AdditionalSights = {
    {
        Pos = Vector(0, 14, -2.87),
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
att.HolosightSize = 8.5
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/waw_zf42_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 4

att.Override_ShotgunReload = true

att.Hook_GetDistantShootSound = function(wep, distancesound)
    if distancesound == wep.DistantShootSound then
        return "ArcCW_WAW.Sniper_RingSt"
    end
end