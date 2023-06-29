att.PrintName = "Integrated Bipod"
att.Icon = Material("entities/acwatt_bo1_awm_bipod.png", "mips smooth")
att.Description = "A bipod integrated onto the weapon. Deploying it allows for accurate and stable shooting."

att.Desc_Pros = {"bo.nosightsdisp"}

att.SortOrder = 1000

att.AutoStats = true
att.Slot = "bo1_bipod"
att.ActivateElements = {"bo1_bipod"}
att.ExcludeFlags = {"g36c", "g3k", "g3k_ris", "sd_barrel"}
att.BO1_Bipod = true
att.HideIfBlocked = true

att.Free = true

att.Bipod = true
att.Mult_BipodRecoil = 0.05
att.Mult_BipodDispersion = 0.15

att.Mult_HipDispersion = 1.1

att.M_Hook_Mult_SightsDispersion = function(wep, data)
    if wep:InBipod() then
        data.mult = 0
    end
end