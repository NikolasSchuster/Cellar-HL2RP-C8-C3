att.PrintName = "Stinger Modification"
att.Icon = Material("entities/acwatt_bo1_fcg_rapid.png", "mips smooth")
att.Description = "Built from the remains of an aircraft machine gun, an M1 Garand and a BAR. Storm the beaches of Iwo Jima in style. However now that it isn't airborne, sustained fire may heat up the weapon too much."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "bo1.g935.con.1",
    "bo1.g935.con.2"
}
att.AutoStats = true
att.Slot = "waw_fcg_stinger"
att.GivesFlags = {"enables_cooling"}
att.SortOrder = 100
att.Mult_RPM = 14 / 5 -- AN/M2 ROF is 1400 RPM
att.Mult_AccuracyMOA = 2
att.Mult_RecoilSide = 1.5

att.Override_Jamming = true
att.Override_HeatLockout = false
att.Override_HeatCapacity = 300
att.Override_HeatDissipation = 8
att.Override_HeatDelayTime = 4

att.Hook_ModifyRPM = function(wep, delay)
    local heat = math.Clamp(wep:GetHeat() / wep:GetMaxHeat(), 0, 1)
    if heat > 0.6 then
        return delay * (1 + ((heat - 0.5) / 0.5) * 3)
    end
end

att.M_Hook_Mult_AccuracyMOA = function(wep, data)
    local heat = math.Clamp(wep:GetHeat() / wep:GetMaxHeat(), 0, 1)
    if heat > 0.2 then
        data.mult = data.mult * (1 + ((heat - 0.2) / 0.8))
    end
end
