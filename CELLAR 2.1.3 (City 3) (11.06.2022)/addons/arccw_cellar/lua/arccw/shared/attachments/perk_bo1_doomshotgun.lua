att.PrintName = "You got the Shotgun!"
att.Icon = Material("entities/acwatt_bo1_doom_ee.png", "mips smooth")
att.Description = "Rip and Tear until it is done."
att.Desc_Pros = {
}
att.Desc_Cons = {
    " -Blocks all other attachments",
}
att.AutoStats = true
att.Slot = {"bo1_perk_doomshotgun"}
att.GivesFlags = {"doom_ee"}

att.NoRandom = true

att.DOOM_EE = true

att.Mult_HipDispersion = 0
att.Mult_MoveDispersion = 0
att.Mult_Recoil = 0
att.Mult_SpeedMult = 3
att.Mult_SightedSpeedMult = 3
att.Override_Num = 8

att.Override_CanBash = false
att.Override_ShootWhileSprint = true
att.Override_BottomlessClip = true

att.Override_ShotgunSpreadPattern = true
att.Override_ShotgunSpreadDispersion = false

att.Hook_ShotgunSpreadOffset = function(wep, data)
    data.ang = Angle(0, math.Rand(-4, 4), 0)

    return data
end

att.Hook_ShouldNotSight = function(wep)
    return true
end

att.Hook_ModifyRPM = function(wep, delay)
    return 60 / 150
end

att.AttachSound = "weapons/arccw/doom_ee/doom_ee_on.wav"
att.DetachSound = "weapons/arccw/doom_ee/doom_ee_off.wav"

att.Hook_GetShootSound = function(wep, sound)
    return "ArcCW_BO1.DOOMSG_Fire"
end

att.Hook_GetDistantShootSound = function(wep, sound)
    return ""
end