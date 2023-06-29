att.PrintName = "Group 935 Experimental Rapid Fire"
att.AbbrevName = "G935 Rapid Fire"
att.Icon = Material("entities/acwatt_bo1_fcg_rapid.png", "mips smooth")
att.Description = "Experimental rapid fire modification increases fire rate greatly.\nThe high rate of fire strains the cooling system, and sustained fire will decrease fire rate and accuracy greatly."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "bo1.g935.con.1",
    "bo1.g935.con.2"
}
att.AutoStats = true
att.Slot = "bo2_fcg_mg08"
att.GivesFlags = {"enables_cooling"}
att.SortOrder = 99
att.IgnorePickX = true

att.Mult_RPM = 1.5
att.Mult_Range = 0.75

att.Override_Jamming = true
att.Override_HeatLockout = false
att.Override_HeatCapacity = 180
att.Override_HeatDissipation = 6

att.Hook_ModifyRPM = function(wep, delay)
    local heat = math.Clamp(wep:GetHeat() / wep:GetMaxHeat(), 0, 1)
    if heat > 0.5 then
        return delay * (1 + ((heat - 0.2) / 0.8))
    end
end

att.M_Hook_Mult_AccuracyMOA = function(wep, data)
    local heat = math.Clamp(wep:GetHeat() / wep:GetMaxHeat(), 0, 1)
    if heat > 0.5 then
        data.mult = data.mult * (1 + ((heat - 0.2) / 0.8))
    end
end
