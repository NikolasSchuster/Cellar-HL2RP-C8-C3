att.PrintName = "Heavy Foregrip (BO2)"
att.Icon = Material("entities/acwatt_bo2_foregrip.png", "mips smooth")
att.Description = "Heavy vertical foregrip that goes under the weapon's handguard made to support the heft and recoil of a light machine gun. It can be folded down and held horizontally."

att.SortOrder = 97

att.Desc_Pros = {
}
att.Desc_Cons = {
}
--att.BO1_UBFG = true

att.AutoStats = true

att.Mult_Recoil = 0.9
att.Mult_HipDispersion = 0.75

att.Mult_SightTime = 1.25
att.Mult_MoveDispersion = 1.25

att.Mult_SpeedMult = 0.95

att.GivesFlags = {"bo2_foregrip"}
att.Slot = {"foregrip", "bo1_uniforegrip"}
att.ModelOffset = Vector(-22, -3.25, 5.15)

att.LHIK = true

att.Override_HoldtypeActive = "smg"
att.Override_HoldtypeSights = "smg"

att.Model = "models/weapons/arccw/atts/bo2_heavygrip.mdl"