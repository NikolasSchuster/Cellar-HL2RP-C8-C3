att.PrintName = "True Patriot Grip"
att.Icon = Material("entities/acwatt_bo2_longbarrel.png", "mips smooth")
att.Description = "Handle your FPW like a true patriot. With one hand."

att.SortOrder = 97

att.AutoStats = true

att.Desc_Pros = {
}
att.Desc_Cons = {
    "Disables all stocks.",
}
att.Slot = "kali_truepatriot"
att.HideIfBlocked = true

att.RequireFlags = {"kali_barrel_patriot", "mag_patriot"}
att.GivesFlags = {"true_patriot"}
att.ExcludeFlags = {"not_patriot"}
att.Override_ShootWhileSprint = true
att.Override_HoldtypeActive = "pistol"
att.Override_HoldtypeSights = "revolver"
att.Mult_Recoil = 2.25
att.Mult_RecoilSide = 2.25
att.Mult_VisualRecoilMult = 2.25
att.LHIK = true
att.LHIKHide = true