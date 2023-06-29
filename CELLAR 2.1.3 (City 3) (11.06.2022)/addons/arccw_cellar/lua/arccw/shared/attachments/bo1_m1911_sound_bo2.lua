att.PrintName = "M1911A1 Black Ops 2 Sound"
att.AbbrevName = "Black Ops 2"

att.Icon = Material("entities/acwatt_bo2_logo.png", "smooth mips")
att.Description = "M1911A1 sound from Black Ops 2"

att.Slot = "bo1_m1911_sound"
att.Free = true
att.IgnorePickX = true


att.Hook_GetShootSound = function(wep, sound)
    local sil = wep:GetBuff_Override("Silencer")
    if sil then
        return "ArcCW_BO2.Pistol_Sil"
    end
    return "ArcCW_BO2.M1911_Fire"
end

att.Hook_GetDistantShootSound = function(wep, distancesound)
    if distancesound == wep.DistantShootSound then
        return "ArcCW_BO2.Pistol_Ringoff"
    end
end