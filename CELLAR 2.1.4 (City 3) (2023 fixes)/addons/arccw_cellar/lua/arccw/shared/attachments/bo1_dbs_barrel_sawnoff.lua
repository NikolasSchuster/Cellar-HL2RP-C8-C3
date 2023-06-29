att.PrintName = "Sawed-Off Barrel"
att.Icon = Material("entities/acwatt_bo1_dbs_barrel_sawnoff.png", "mips smooth")
att.Description = "Significantly reduced length barrel. Much less range, much higher spread, much more agile."

att.SortOrder = 105

att.AutoStats = true

att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Slot = {"waw_dbs_barrel", "bo1_olympia_sawn"}
att.GivesFlags = {"ssg_barrel"}

att.Mult_Range = 0.5

att.Mult_Recoil = 1.5
att.Mult_RecoilSide = 1.5
att.Mult_AccuracyMOA = 1.75

att.Mult_HipDispersion = 0.7
att.Mult_MoveDispersion = 0.5

att.Mult_SpeedMult = 1.05
att.Mult_SightedSpeedMult = 1.25
att.Mult_SightTime = 0.5

att.Override_MuzzleEffectAttachment = 2

att.Hook_GetShootSound = function(wep, sound)
    return "ArcCW_WAW.SawnOff_Fire"
end