att.PrintName = "Ludicrous Gibs!"
att.Icon = Material("entities/acwatt_bo1_doom_ee.png", "mips smooth")
att.Description = "Rip and Tear until it is done."
att.Desc_Pros = {
    "bo1.doom",
    "bo1.doom.rpg.pro",
}
att.Desc_Cons = {
    "bo1.doom.rpg.con.1",
    "bo1.doom.rpg.con.2",
}
att.AutoStats = false
att.Slot = {"bo1_perk_doomrpg"}
att.GivesFlags = {"doom_ee"}

att.NoRandom = true

att.DOOM_EE = true

att.Override_Damage = 150
att.Override_DamageMin = 150
att.Override_HipDispersion = 0
att.Override_MoveDispersion = 0
att.Override_JumpDispersion = 0
att.Mult_Recoil = 0
att.Override_SpeedMult = 1
att.Override_SightedSpeedMult = 1
att.Override_MuzzleVelocity = 500

att.Add_BarrelLength = -100

att.Override_CanBash = false
att.Override_ShootWhileSprint = true
att.Override_BottomlessClip = true

att.Override_ShootEntity = "arccw_bo1_doomrocket"

att.Override_Firemodes = {
    {
      Mode = 2,
    },
}

att.Hook_ShouldNotSight = function(wep)
    return true
end

att.Hook_ModifyRPM = function(wep, delay)
    return 60 / 56.8
end

att.AttachSound = "weapons/arccw/doom_ee/doom_ee_on.wav"
att.DetachSound = "weapons/arccw/doom_ee/doom_ee_off.wav"

att.Hook_GetShootSound = function(wep, sound)
    return "ArcCW_BO1.DOOMRPG_Fire"
end

att.Hook_GetDistantShootSound = function(wep, sound)
    return ""
end