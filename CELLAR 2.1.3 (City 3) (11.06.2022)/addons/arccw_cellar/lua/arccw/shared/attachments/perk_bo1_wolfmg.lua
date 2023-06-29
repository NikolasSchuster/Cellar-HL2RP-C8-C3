att.PrintName = "You got the Machine Gun!"
att.Icon = Material("entities/acwatt_bo1_doom_ee.png", "mips smooth")
att.Description = "Commandeered Nazi Weapon."
att.Desc_Pros = {
}
att.Desc_Cons = {
    " -Blocks all other attachments",
}
att.AutoStats = true
att.Slot = {"bo1_perk_wolfmg"}
att.GivesFlags = {"wolf_ee"}

att.WOLF_EE = true

att.NoRandom = true

att.Mult_HipDispersion = 0
att.Mult_MoveDispersion = 0
att.Mult_Recoil = 0
att.Mult_SpeedMult = 3
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

att.AttachSound = "weapons/arccw/wolf_ee/mg_up.wav"

att.Hook_GetShootSound = function(wep, sound)
    return "^weapons/arccw/wolf_ee/mg_fire.wav"
end

att.Hook_GetDistantShootSound = function(wep, sound)
    return ""
end