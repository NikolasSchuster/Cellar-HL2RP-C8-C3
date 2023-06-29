att.PrintName = "FAMAS F1"
att.Icon = Material("entities/acwatt_fcg_s13.png", "mips smooth")
att.Description = "Added weight from the carry handle improves recoil control."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "bo1_famas_frame"
att.GivesFlags = {"f1_top", "famas_f1"}
att.SortOrder = 100

att.Mult_Recoil = 0.9
att.Mult_SightTime = 1.1
att.Mult_SightedSpeedMult = 0.95

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