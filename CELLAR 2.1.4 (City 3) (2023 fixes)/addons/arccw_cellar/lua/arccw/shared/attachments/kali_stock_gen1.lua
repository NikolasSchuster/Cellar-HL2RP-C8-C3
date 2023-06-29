att.PrintName = "Gen-1 Collapsible Stock"
att.Icon = Material("entities/acwatt_bo1_stock_icon.png", "mips smooth")
att.Description = [[
    Gen-1 collapsible stock that provides better recoil control at the cost of maneuverability.
    Toggleable between extended and collapsed.

    Rare. Ever only found on the obscure CAR-15 SMG configuration, the Colt Models 607a and 607b.
]]
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true

att.SortOrder = 99
att.Slot = {"kali_stock"}

/*
att.Mult_Recoil = 0.625
att.Mult_RecoilSide = 0.625
att.Mult_MoveDispersion = 1.1
att.Mult_SightTime = 1.2
att.Mult_SightedSpeedMult = 0.95
*/

att.GivesFlags = {"gen1_stock", "not_patriot"}

att.RandomWeight = 0.1

att.ToggleStats = {
    {
        PrintName = "Collapsed",
        ActivateElements = {"gen1_collapsed"},
        Mult_Recoil = 0.7,
        Mult_RecoilSide = 0.7,
        Mult_MoveDispersion = 1.1,
        Mult_SightTime = 0.95,
        Mult_SightedSpeedMult = 1.05,
    },
    {
        PrintName = "Extended",
        ActivateElements = {"gen1_extended"},
        Mult_Recoil = 0.625,
        Mult_RecoilSide = 0.625,
        Mult_MoveDispersion = 1.1,
        Mult_SightTime = 1.2,
        Mult_SightedSpeedMult = 0.95,
    },
}