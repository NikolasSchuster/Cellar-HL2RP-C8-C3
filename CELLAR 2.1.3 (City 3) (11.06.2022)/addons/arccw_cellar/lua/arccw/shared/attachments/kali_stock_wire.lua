att.PrintName = "Wire Stock"
att.Icon = Material("entities/acwatt_bo1_stock_icon.png", "mips smooth")
att.Description = [[
    Wire stock which provides better handling and a small bonus to recoil control.
    Toggleable between extended and collapsed
    
    Rare. Ever only found present in obscure "SMG" configurations and FPWs.
]]
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true

att.SortOrder = 94
att.Slot = {"kali_stock"}

/*
att.Mult_Recoil = 0.9
att.Mult_RecoilSide = 0.9
att.Mult_MoveDispersion = 1.05
att.Mult_SightTime = 0.65
att.Mult_SightedSpeedMult = 1.4
*/

att.GivesFlags = {"wire_stock", "not_patriot"}

att.RandomWeight = 0.05

att.ToggleStats = {
    {
        PrintName = "Collapsed",
        ActivateElements = {"wire_collapsed"},
        Mult_Recoil = 0.975,
        Mult_RecoilSide = 0.975,
        Mult_SightTime = 0.75,
        Mult_SightedSpeedMult = 1.35,
    },
    {
        PrintName = "Extended",
        ActivateElements = {"wire_extended"},
        Mult_Recoil = 0.9,
        Mult_RecoilSide = 0.9,
        Mult_MoveDispersion = 1.05,
        Mult_SightTime = 0.75,
        Mult_SightedSpeedMult = 1.25,
    },
}