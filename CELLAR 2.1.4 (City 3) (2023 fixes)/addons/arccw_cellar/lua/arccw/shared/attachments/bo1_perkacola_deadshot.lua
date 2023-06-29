att.PrintName = "Deadshot Daquiri"
att.Icon = Material("entities/acwatt_perk_deadshot.png", "mips smooth")
att.Description = "Zero in baby, zero on that spot. The hot spot baby, give it all you got!\nSo quit complaining, about your bad aiming! Just try, try again for me!\n\nWith the headshot power of a Deadshot Daiquiri!"
att.Desc_Pros = {
    "bo1.perkacola.deadshot"
}
att.Slot = {"bo1_perk"}
att.NoRandom = true
att.NotForNPCS = true

att.AutoStats = true
att.Mult_HipDispersion = 0.5
att.Mult_MoveDispersion = 0.5
att.Mult_Recoil = 0.75
att.Mult_Sway = 0.1

att.Hook_BulletHit = function(wep, data)
    if data.tr.HitGroup == HITGROUP_HEAD then
        data.damage = data.damage * 2
    end
end

att.AttachSound = "weapons/arccw/bo1_perks/perk_deadshot.wav"