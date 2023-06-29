att.PrintName = "You got the Chaingun!"
att.Icon = Material("entities/acwatt_bo1_doom_ee.png", "mips smooth")
att.Description = "Rip and Tear until it is done."
att.Desc_Pros = {
}
att.Desc_Cons = {
    " -Blocks all other attachments",
}
att.AutoStats = true
att.Slot = {"bo1_perk_minigun"}
att.GivesFlags = {"doom_ee"}

att.DOOM_EE = true

att.NoRandom = true

att.Mult_HipDispersion = 0
att.Mult_MoveDispersion = 0
att.Mult_Recoil = 0
att.Mult_SpeedMult = 3
att.Mult_ShootSpeedMult = 5
att.Mult_SightedSpeedMult = 3
att.Mult_AccuracyMOA = 1.75
att.Override_CanBash = false
att.Override_ShootWhileSprint = true
att.Override_BottomlessClip = true

att.Hook_ShouldNotSight = function(wep)
    return true
end

att.Hook_ModifyRPM = function(wep, delay)
    return 60 / 525
end

att.AttachSound = "weapons/arccw/doom_ee/doom_ee_on.wav"
att.DetachSound = "weapons/arccw/doom_ee/doom_ee_off.wav"

att.Hook_GetShootSound = function(wep, sound)
    return "ArcCW_BO1.Chaingun_Fire"
end

att.Hook_GetDistantShootSound = function(wep, sound)
    return ""
end