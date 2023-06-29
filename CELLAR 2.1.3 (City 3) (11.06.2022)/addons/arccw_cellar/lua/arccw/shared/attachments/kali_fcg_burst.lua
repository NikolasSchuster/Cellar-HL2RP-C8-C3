att.PrintName = "Burst S-1-3 FCG"
att.AbbrevName = "Burst"
att.Icon = Material("entities/acwatt_fcg_s13.png", "mips smooth")
att.Description = "3-round burst fire control group originally designed for the M16A2."
att.Desc_Pros = {
    "+ Burst Fire mode allows for ammunition",
    "conservation"
}
att.Desc_Cons = {
    "- Burst Delay"
}
att.AutoStats = true
att.Slot = "fcg_kali"
att.SortOrder = 103
att.IgnorePickX = true
att.Free = true

att.RandomWeight = 0.5
att.Mult_Recoil = 0.9
att.Mult_HipDispersion = 0.95
att.Mult_AccuracyMOA = 0.95
att.Mult_Damage = 40 / 30
att.Mult_DamageMin = 30 / 20

att.Override_Firemodes = {
    {
        Mode = -3,
        PostBurstDelay = 0.2,
        RunawayBurst = true,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

att.Hook_Compatible = function(wep)
    local auto = false
    for i, v in pairs(wep.Firemodes) do
        if v.Mode and v.Mode == -3 then
            auto = true
            break
        end
    end
    if auto then return false end
end