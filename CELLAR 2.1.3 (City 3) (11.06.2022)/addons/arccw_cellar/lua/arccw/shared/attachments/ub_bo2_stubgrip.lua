att.PrintName = "Stub Foregrip (BO2)"
att.Icon = Material("entities/acwatt_bo2_foregrip.png", "mips smooth")
att.Description = "Stubbier vertical foregrip that goes under the weapon's handguard. Improves overall handling."

att.SortOrder = 97

att.Desc_Pros = {
}
att.Desc_Cons = {
}
--att.BO1_UBFG = true

att.AutoStats = true

att.Mult_Recoil = 0.95
att.Mult_SightTime = 0.95
att.Mult_HipDispersion = 0.95

att.Mult_SpeedMult = 0.97

att.GivesFlags = {"bo2_foregrip"}
att.Slot = {"foregrip", "bo1_uniforegrip"}
att.ModelOffset = Vector(-18, -2.5, 5.25)

att.LHIK = true

att.Override_HoldtypeActive = "smg"
att.Override_HoldtypeSights = "smg"

att.Model = "models/weapons/arccw/atts/bo2_grip.mdl"