att.PrintName = "Gen-3 Carbine Stock"
att.Icon = Material("entities/acwatt_bo1_stock_icon.png", "mips smooth")
att.Description = "Extended gen-3 collapsible stock that provides better recoil control at the cost of maneuverability."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true

att.SortOrder = 97
att.Slot = {"kali_stock"}

att.RandomWeight = 0.5

/*
att.Mult_Recoil = 0.65
att.Mult_RecoilSide = 0.65
att.Mult_MoveDispersion = 1.1
att.Mult_SightTime = 1.1
att.Mult_SightedSpeedMult = 0.95
*/

att.GivesFlags = {"gen3_stock", "not_patriot"}

att.ToggleStats = {
    {
        PrintName = "Collapsed",
        ActivateElements = {"gen3_collapsed"},
        Mult_Recoil = 0.75,
        Mult_RecoilSide = 0.75,
        Mult_MoveDispersion = 1.1,
        Mult_SightTime = 0.75,
        Mult_SightedSpeedMult = 1.2,
    },
    {
        PrintName = "Extended",
        ActivateElements = {"gen3_extended"},
        Mult_Recoil = 0.65,
        Mult_RecoilSide = 0.65,
        Mult_MoveDispersion = 1.1,
        Mult_SightTime = 1.1,
        Mult_SightedSpeedMult = 0.95,
    },
}