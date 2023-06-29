att.PrintName = "ADCO SOLO (RDS)"
att.Icon = Material("entities/acwatt_optic_bo2_docter.png", "mips smooth")
att.Description = "Relatively compact holographic sight. Provides a small electronic dot reticle which speeds up target acquisition by eliminating the need to line up irons."

att.SortOrder = 1

att.SortOrder = 1

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Neutrals = {"bo.desc"}

att.AutoStats = true
att.Slot = {"optic", "bo1_reddots", "optic_lp"}

att.Model = "models/weapons/arccw/atts/bo2_solo.mdl"
att.ModelOffset = Vector(0, 0, -0.01)
att.OffsetAng = Angle(0, 0, 0)

att.AdditionalSights = {
    {
        Pos = Vector(-0.0125, 10, -1.125),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        ScrollFunc = ArcCW.SCROLL_NONE,
        IgnoreExtra = false
    }
}

att.Holosight = true
att.HolosightReticle = Material("hud/reticles/reddot.png", "mips smooth")
att.HolosightSize = 0.25
att.HolosightBone = "holosight"
att.HolosightNoFlare = false

att.Mult_SightTime = 1.01

att.Colorable = true