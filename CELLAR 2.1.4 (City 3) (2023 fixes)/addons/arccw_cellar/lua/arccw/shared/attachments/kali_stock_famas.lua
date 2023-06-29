att.PrintName = "FAMAS Stock"
att.Icon = Material("entities/acwatt_bo1_stock_icon.png", "mips smooth")
att.Description = [[
    The rear of the FAMAS receiver has been turned into a stock that performs equally as well as a standard M16 full stock.
    
    None of the previous functionality of this part of the FAMAS has carried over to its life as a stock, with most of its internals being stripped to keep it in line with the weight of a standard full stock.
]]

att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true

att.SortOrder = 93
att.Slot = {"kali_stock"}

att.Mult_Recoil = 0.50
att.Mult_RecoilSide = 0.50
att.Mult_MoveDispersion = 1.25
att.Mult_SightTime = 1.25
att.Mult_SightedSpeedMult = 0.85

att.GivesFlags = {"famas_stock", "not_patriot"}
--att.RequireFlags = {"kali_barrel_famas"}
att.HideIfBlocked = true

att.RandomWeight = 0.01