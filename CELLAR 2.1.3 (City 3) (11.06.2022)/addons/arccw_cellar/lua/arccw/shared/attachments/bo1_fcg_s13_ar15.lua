att.PrintName = "A2 S-1-3 FCG"
att.Icon = Material("entities/acwatt_fcg_s13.png", "mips smooth")
att.Description = "Firemode conversion allowing for 3-round burst and semi-auto fire modes."
att.Desc_Pros = {
    "bo1.burst"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.IgnorePickX = true
att.Free = true
att.Slot = "fcg_m16a2"
att.GivesFlags = {"a2top"}
att.SortOrder = 101

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
att.Mult_Recoil = 0.85
att.Mult_HipDispersion = 0.9
att.Mult_Damage = 40 / 30
att.Mult_DamageMin = 30 / 20

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