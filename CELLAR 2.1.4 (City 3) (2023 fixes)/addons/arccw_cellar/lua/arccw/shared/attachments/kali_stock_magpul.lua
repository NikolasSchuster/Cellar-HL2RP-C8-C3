att.PrintName = "Magpul Carbine Stock"
att.Icon = Material("entities/acwatt_bo1_stock_icon.png", "mips smooth")
att.Description = "Magupul collapsible stock. Popular in the civilian aftermarket. Toggleable between extended and colllapsed."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true

att.SortOrder = 96
att.Slot = {"kali_stock"}
att.Ingore = true
att.Hidden = true

/*
att.Mult_Recoil = 0.70
att.Mult_RecoilSide = 0.70
att.Mult_MoveDispersion = 1.05
att.Mult_SightTime = 1.05
att.Mult_SightedSpeedMult = 0.975
*/

att.GivesFlags = {"magpul_stock", "not_patriot"}

att.ToggleStats = {
    {
        PrintName = "Collapsed",
        ActivateElements = {"magpul_collapsed"},
        Mult_Recoil = 0.75,
        Mult_RecoilSide = 0.75,
        Mult_MoveDispersion = 1.1,
        Mult_SightTime = 0.75,
        Mult_SightedSpeedMult = 1.2,
    },
    {
        PrintName = "Extended",
        ActivateElements = {"magpul_extended"},
        Mult_Recoil = 0.65,
        Mult_RecoilSide = 0.65,
        Mult_MoveDispersion = 1.1,
        Mult_SightTime = 1.1,
        Mult_SightedSpeedMult = 0.95,
    },
}