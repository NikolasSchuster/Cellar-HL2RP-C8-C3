att.PrintName = "PPSh-41 Polymer Stock."
att.Icon = Material("entities/acwatt_spas12_nostock.png", "mips smooth")
att.Description = "A polymer replacement for the PPSh's original wood stock and grip. Makes maneuvering the weapon is easier but recoil is increased due to the lost weight."
att.Desc_Pros = {
    "Allows the Optic attachment slot."
}
att.Desc_Cons = {
}
att.AutoStats = true

att.SortOrder = 99
att.Slot = "ppsh_stock"

att.Mult_Recoil = 1.2
att.Mult_RecoilSide = 1.2
att.Mult_MoveDispersion = 0.9
att.Mult_SpeedMult = 1.1
att.Mult_SightedSpeedMult = 1.1
att.Mult_DrawTime = 0.9

att.GivesFlags = {"stock_light"}