att.PrintName = "Gen-2 Collapsible Stock"
att.Icon = Material("entities/acwatt_bo1_stock_icon.png", "mips smooth")
att.Description = "Gen-2 Carbine Stock. Used in most CAR-15 configurations. Toggleable between extended and collapsed."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true

att.SortOrder = 98
att.Slot = {"kali_stock"}

att.RandomWeight = 0.5

/*
att.Mult_Recoil = 0.75
att.Mult_RecoilSide = 0.75
att.Mult_MoveDispersion = 1.1
att.Mult_SightTime = 0.75
att.Mult_SightedSpeedMult = 1.2
*/

att.GivesFlags = {"gen2_stock", "not_patriot"}

att.ToggleStats = {
    {
        PrintName = "Collapsed",
        ActivateElements = {"gen2_collapsed"},
        Mult_Recoil = 0.75,
        Mult_RecoilSide = 0.75,
        Mult_MoveDispersion = 1.1,
        Mult_SightTime = 0.75,
        Mult_SightedSpeedMult = 1.2,
    },
    {
        PrintName = "Extended",
        ActivateElements = {"gen2_extended"},
        Mult_Recoil = 0.65,
        Mult_RecoilSide = 0.65,
        Mult_MoveDispersion = 1.1,
        Mult_SightTime = 1.1,
        Mult_SightedSpeedMult = 0.95,
    },
}