att.PrintName = "M203 (BO1)[LHIK]"
att.Icon = Material("entities/acwatt_ubgl_bo1_m203.png", "mips smooth")
att.Description = "Selectable Grenade Launcher equipped under the rifle's handguard. Double tap +ZOOM to equip/dequip."
att.Desc_Pros = {
    "pro.ubgl",
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
    "info.toggleubgl"
}
att.AutoStats = true
att.Slot = "ubgl_bo1"
att.BO1_UBGL = true
att.HideIfBlocked = true

att.SortOrder = 90

att.LHIK = true
att.LHIK_Animation = true

att.ModelOffset = Vector(0, 0, 0)

att.MountPositionOverride = 0

att.Model = "models/weapons/arccw/atts/c_bo1_ub_m203.mdl"

att.UBGL = true

att.UBGL_PrintName = "UB (HE)"
att.UBGL_Automatic = false
att.UBGL_MuzzleEffect = "muzzleflash_m79"
att.UBGL_ClipSize = 1
att.UBGL_Ammo = "smg1_grenade"
att.UBGL_RPM = 300
att.UBGL_Recoil = 2.5
att.UBGL_Capacity = 1

local function Ammo(wep)
    return wep.Owner:GetAmmoCount("smg1_grenade")
end

/*att.Hook_LHIK_TranslateAnimation = function(wep, key)
    if key == "idle" then
        if wep:GetInUBGL() then
            return "idle_ready"
        else
            return "idle"
        end
    end
end*/

att.UBGL_Fire = function(wep, ubgl)
    if wep:Clip2() <= 0 then return end

    wep:DoLHIKAnimation("fire", 0.5)

    wep:FireRocket("arccw_bo1_m203_he", 4000)

    wep:EmitSound("ArcCW_BO1.M203_Fire", 100)

    wep:SetClip2(wep:Clip2() - 1)

    wep:DoEffects()
end

att.UBGL_Reload = function(wep, ubgl)
    if wep:Clip2() >= 1 then return end

    if Ammo(wep) <= 0 then return end

    wep:SetNextSecondaryFire(CurTime() + 2.5)

    wep:DoLHIKAnimation("reload", 3)

    wep:PlaySoundTable({
        {s = "ArcCW_BO1.M203_Open", t = 0.125},
        {s = "ArcCW_BO1.M203_40mmOut", t = 0.175},
        {s = "ArcCW_BO1.M203_40mmIn", t = 1.5},
        {s = "ArcCW_BO1.M203_Close", t = 2.25},
    })

    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local clip = 1

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "smg1_grenade")

    wep:SetClip2(load)
end

att.Mult_SightTime = 1.25
att.Mult_SightedSpeedMult = 0.85