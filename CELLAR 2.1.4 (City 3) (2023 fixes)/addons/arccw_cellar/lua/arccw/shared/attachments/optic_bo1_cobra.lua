att.PrintName = "Kobra EKP-1S-03 (RDS)"
att.AbbrevName = "Kobra [BO1](RDS)"
att.Icon = Material("entities/acwatt_optic_bo1_reddot.png", "mips smooth")
att.Description = "Small red dot sight with a Soviet-style mount."

att.SortOrder = 1

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Neutrals = {"bo.desc"}

att.AutoStats = true
att.Slot = "bo1_cobra"

att.Model = "models/weapons/arccw/atts/bo1_cobra.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 10, -1.4),
        Ang = Angle(0, 0, 0),
        Magnification = 1.1,
        ScrollFunc = ArcCW.SCROLL_NONE,
        IgnoreExtra = false,
    }
}

att.Holosight = true
att.HolosightReticle = Material("hud/reticles/reddot.png", "mips smooth")
att.HolosightSize = 0.25
att.HolosightBone = "holosight"
att.HolosightNoFlare = false

att.Mult_SightTime = 1.01

att.Colorable = true