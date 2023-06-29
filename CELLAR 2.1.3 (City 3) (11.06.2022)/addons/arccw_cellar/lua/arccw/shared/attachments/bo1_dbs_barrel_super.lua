att.PrintName = "You got the Super Shotgun!"
att.Icon = Material("entities/acwatt_bo1_doom_ee.png", "mips smooth")
att.Description = "Rip and Tear until it is done."

att.SortOrder = 105

att.AutoStats = true

att.Desc_Pros = {
}
att.Desc_Cons = {
    " -Blocks all other attachments",
}
att.Slot = {"perk_bo1_ssg"}
att.GivesFlags = {"ssg_barrel", "doom_ee"}

att.DOOM_EE = true

att.Mult_Range = 0.25
att.Mult_Recoil = 0
att.Mult_RecoilSide = 0
att.Mult_SpeedMult = 1.5
att.Mult_SightedSpeedMult = 1.5
att.Mult_SightTime = 0.75
att.Mult_AccuracyMOA = 1.75
att.Override_Num = 26
att.Mult_Damage = 3
att.Mult_DamageMin = 3
att.Override_AmmoPerShot = 2
att.Override_MuzzleEffectAttachment = 2

att.Override_ShootWhileSprint = true
att.Override_CanBash = false

att.Override_Firemodes = {
    {
        PrintName = "BOTH",
        Mode = 1,
    },
}

att.Hook_ShouldNotSight = function(wep)
    return true
end

att.Hook_GetShootSound = function(wep, sound)
    return "ArcCW_WAW.SSG_Fire"
end

att.Hook_GetDistantShootSound = function(wep, sound)
    return ""
end

att.Mult_ReloadTime = 1 / 2.25

att.AttachSound = "weapons/arccw/bo1_olympia/waw_e1m1.wav"