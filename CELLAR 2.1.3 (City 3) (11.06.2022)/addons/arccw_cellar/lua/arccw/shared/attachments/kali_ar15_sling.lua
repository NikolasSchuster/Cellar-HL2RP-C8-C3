att.PrintName = "Commando Wrapped Sling"
att.Icon = Material("entities/acwatt_sling_wrap.png", "mips smooth")
att.Description = "Having no need for your sling, but not wanting to take it off, you wrap it around the body of your AR-15."

att.SortOrder = 100
att.Free = true
att.IgnorePickX = true

att.Desc_Pros = {
    "+ Looks cooler if you like it",
}
att.Desc_Cons = {
    "- Aesthetics provide no real performance upgrades."
}
att.Desc_Neutrals = {
    " Replicate the look of the the original Commando from Black Ops to access this attachment!"
}
att.Slot = "kali_ar15_sling"
att.RequireFlags = {"kali_barrel_xm"}
att.ExcludeFlags = {"solider_stock"}
att.ActivateElements = {"kali_bo1_sling"}

att.AttachSound = "weapons/arccw/bo1_m16/bo_spawn.wav"

att.Free = true
att.IgnorePickX = true