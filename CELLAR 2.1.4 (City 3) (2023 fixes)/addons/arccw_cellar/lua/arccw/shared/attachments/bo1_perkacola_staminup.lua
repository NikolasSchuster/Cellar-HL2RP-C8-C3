att.PrintName = "Stamin-Up"
att.Icon = Material("entities/acwatt_perk_staminup.png", "mips smooth")
att.Description = "Babe, you know you want me! Let's run the extra mile!\nI'll open your eyes and I'll make you see! I'll make it worth your while!\n\nSounds like it's Staaaaamin-Up time!"
att.Desc_Pros = {
    "bo1.perkacola.active",
    "bo1.perkacola.staminup",
    "+Full ADS Movement Speed",
}
att.Desc_Cons = {
}
att.Slot = {"bo1_perk"}
att.NoRandom = true
att.NotForNPCS = true
att.Mult_SightedSpeedMult = 10

att.BO1_StaminUp = true

att.AttachSound = "weapons/arccw/bo1_perks/perk_stamina.wav"

hook.Add("Move", "ArcCW_BO1_StaminUp", function(ply, mv)
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) or not wep.ArcCW or not wep:GetBuff_Override("BO1_StaminUp") then return end

    local max = ply:GetMaxSpeed()
    local s = ply.ArcCW_LastTickSpeedMult or 1

    if ply:Crouching() then s = s * ply:GetCrouchedWalkSpeed() end

    mv:SetMaxSpeed(max * s * 1.15)
    mv:SetMaxClientSpeed(max * s * 1.15)
end)