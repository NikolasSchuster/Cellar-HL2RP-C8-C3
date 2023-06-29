att.PrintName = "PDW Foregrip (BO2)"
att.Icon = Material("entities/acwatt_bo2_foregrip.png", "mips smooth")
att.Description = "Vertical foregrip that goes under the weapon's handguard. Improves hip fire handling and recoil."

att.SortOrder = 97

att.Desc_Pros = {
}
att.Desc_Cons = {
}
--att.BO1_UBFG = true

att.AutoStats = true

att.Mult_HipDispersion = 0.9
att.Mult_Recoil = 0.9

att.Mult_SightTime = 1.15
att.Mult_SpeedMult = 0.98

att.GivesFlags = {"bo2_foregrip"}
att.Slot = {"foregrip", "bo1_uniforegrip"}
att.ModelOffset = Vector(-16, -2.825, 3.75)

att.LHIK = true

att.Override_HoldtypeActive = "smg"
att.Override_HoldtypeSights = "smg"

att.Model = "models/weapons/arccw/atts/bo2_verticalpk.mdl"