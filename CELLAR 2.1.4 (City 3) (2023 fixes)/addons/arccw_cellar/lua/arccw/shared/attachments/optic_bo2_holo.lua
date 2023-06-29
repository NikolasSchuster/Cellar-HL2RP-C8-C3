att.PrintName = "EOTech EXPS3 (HOLO)"
att.Icon = Material("entities/acwatt_optic_bo2_holo.png", "mips smooth")
att.Description = "Black Ops 2 Holographic Sight. Standard holographic sight. Provides a small electronic dot reticle which speeds up target acquisition by eliminating the need to line up irons."

att.SortOrder = 1

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Neutrals = {"bo.desc"}

att.AutoStats = true
att.Slot = {"optic", "bo1_reddots"}

att.Model = "models/weapons/arccw/atts/bo2_holo.mdl"
att.ModelOffset = Vector(0, 0, -0.1)
att.OffsetAng = Angle(0, 0, 0)

att.AdditionalSights = {
    {
        Pos = Vector(-0.0125, 10, -1.25),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        ScrollFunc = ArcCW.SCROLL_NONE,
        IgnoreExtra = false
    }
}

att.Holosight = true
att.HolosightReticle = Material("hud/reticles/bo2_holo.png", "mips smooth")
att.HolosightSize = 1.1
att.HolosightBone = "holosight"
att.HolosightNoFlare = true

att.Mult_SightTime = 1.01

att.Colorable = true