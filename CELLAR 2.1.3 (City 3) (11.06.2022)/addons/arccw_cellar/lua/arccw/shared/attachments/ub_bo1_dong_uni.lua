att.PrintName = "Dong Foregrip (BO1)"
att.Icon = Material("entities/acwatt_bo1_foregrip.png", "mips smooth")
att.Description = "Wooden vertical dong foregrip that goes under the weapon's handguard. Exclusive to soviet weapons"

att.SortOrder = 105

att.Desc_Pros = {
}
att.Desc_Cons = {
}

att.AutoStats = true

att.Slot = "bo2_dong"
att.ModelOffset = Vector(-17.5, -2.5, 4.25)

att.LHIK = true

att.Model = "models/weapons/arccw/atts/bo2_ub_dong.mdl"

att.Mult_Recoil = 0.85

att.Mult_SightTime = 0.75
att.Mult_HipDispersion = 1.2
att.Mult_SpeedMult = 0.95

att.DrawFunc = function(wep, element)
    if table.HasValue(wep:GetWeaponFlags(), "donggrip") then
        element.Model:SetBodygroup(0,0)
    else
        element.Model:SetBodygroup(0,1)
    end
end