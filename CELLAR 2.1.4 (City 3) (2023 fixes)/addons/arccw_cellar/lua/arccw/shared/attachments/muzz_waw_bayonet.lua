att.PrintName = "Bayonet (WAW)"
att.AbbrevName = "Bayonet"
att.Icon = Material("entities/acwatt_muzz_waw_bayonet.png", "mips smooth")
att.Description = "Bayonet fixed to the end of your weapon, allowing you to stab for massive damage."
att.Desc_Pros = {
    "bo1.bayonet.1",
    "bo1.bayonet.2",
}
att.Desc_Cons = {
}
att.AutoStats = true

att.Slot = {"waw_bayonet"}
att.SortOrder = 100

att.WAW_Bayonet = true

att.Mult_HipDispersion = 1.15
att.Mult_SightTime = 1.1

att.Override_MeleeDamage = 125
att.Add_MeleeRange = 16

att.Mult_MeleeTime = 1.5
att.Mult_MeleeTime_SkipAS = true
att.Mult_MeleeWaitTime = 1.5
att.Override_MeleeDamageType = DMG_SLASH

att.Mult_MeleeAttackTime = 0.5
att.Add_BarrelLength = 6

att.A_Hook_Add_LungeLength = function(wep, data)
    if wep:GetState() == ArcCW.STATE_SPRINT then data.add = data.add + 64 end
end

att.Override_ShootWhileSprint = true
att.Override_ShootWhileSprint_SkipAS = true
att.Override_HoldtypeSprintShoot = "shotgun"
att.Hook_ShouldNotFire = function(wep)
    if wep:GetState() == ArcCW.STATE_SPRINT or wep:GetSprintDelta() > 0 then return true end
end