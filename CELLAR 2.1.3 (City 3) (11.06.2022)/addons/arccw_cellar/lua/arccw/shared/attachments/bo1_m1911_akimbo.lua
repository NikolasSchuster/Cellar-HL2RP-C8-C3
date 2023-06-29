att.PrintName = "M1911 Dual Wield"
att.Icon = Material("entities/acwatt_1911_meu2.png", "smooth mips")
att.Description = "A second M1911A1 for your left hand."
att.Spawnable = false
att.Ignore = true
att.Desc_Pros = {
    "+100% more gun",
}
att.Desc_Cons = {
    "- Cannot use ironsights"
}
att.Desc_Neutrals = {
    "Don't toggle the UBGL"
}
att.AutoStats = true
att.Mult_HipDispersion = 3
att.Slot = "1911akimbo"

att.GivesFlags = {"akimboflag", "akimbo_pap", "akimbo_pap2"}

att.SortOrder = 1738

att.AddSuffix = " DW"

att.MountPositionOverride = 0

--att.Model = "models/weapons/arccw/c_bo1_1911_left.mdl"

/*
att.LHIK = true
att.LHIK_Animation = true
att.LHIK_MovementMult = 0
*/

att.UBGL = true

att.UBGL_PrintName = "LEFT"
att.UBGL_Automatic = false
att.UBGL_MuzzleEffect = "muzzleflash_4"
att.UBGL_ClipSize = 8
att.UBGL_Ammo = "pistol"
att.UBGL_RPM = 60 / 600
att.UBGL_Recoil = 0.5
att.UBGL_RecoilSide = 0.3
att.UBGL_RecoilRise = 1
att.UBGL_Capacity = 8

att.Hook_ShouldNotSight = function(wep)
    return true
end

att.Hook_Think = function(wep)
    if !IsFirstTimePredicted() then return end
    if wep:GetOwner():KeyPressed(IN_RELOAD) then
        wep:SetNWBool("ubgl", false)
        wep:ReloadUBGL()
        wep:Reload()
    elseif wep:GetOwner():KeyPressed(IN_ATTACK) then
        wep:SetNWBool("ubgl", true)
        wep:ShootUBGL()
    elseif wep:GetOwner():KeyPressed(IN_ATTACK2) then
        wep:SetNWBool("ubgl", false)
        wep:PrimaryAttack()
    end
end

/*att.Hook_TranslateSequence = function(wep, anim)
    local awesome-- = wep:GetAnimKeyTime(anim)
    local playanim = nil

    -- i fucking hate it! i really do why the fuck it so nastyy
    -- need to find a way to fix this disaster

    if anim == "sprint_in_dw_both" then
        awesome = 11 / 30
        playanim = "sprint_in"
    elseif anim == "sprint_out_dw_both" then
        awesome = 11 / 30
        playanim = "sprint_out"
    elseif anim == "sprint_loop_dw_both" then
        awesome = 31 / 40
        playanim = "sprint_loop"
    elseif anim == "draw_dw_both" then
        awesome = 26 / 30 / 4
        playanim = "pullout"
    elseif anim == "holster_dw_both" then
        awesome = 26 / 30 / 4
        playanim = "holster"
    end

    if playanim then
        wep:PlayAnimation(playanim, awesome)
    end
end*/

/*att.Hook_LHIK_TranslateAnimation = function(wep, anim)
    if anim == "idle" and wep:Clip2() <= 0 then
        return "idle_empty"
    end
end*/

local function Ammo(wep)
    return wep.Owner:GetAmmoCount("pistol") -- att.UBGL_Ammo
end

att.UBGL_Fire = function(wep, ubgl)
    if wep:Clip2() <= 0 then return end

    -- this bitch
    local fixedcone = wep:GetDispersion() / 360 / 60

    wep.Owner:FireBullets({
        Src = wep.Owner:EyePos(),
        Num = 1,
        Damage = 32,
        Force = 1,
        Attacker = wep.Owner,
        Dir = wep.Owner:EyeAngles():Forward(),
        Spread = Vector(fixedcone, fixedcone, 0),
        Callback = function(_, tr, dmg)
            local dist = (tr.HitPos - tr.StartPos):Length() * ArcCW.HUToM

            local dmgmax = 32
            local dmgmin = 17

            local delta = dist / 800 * 0.025

            delta = math.Clamp(delta, 0, 1)

            local amt = Lerp(delta, dmgmax, dmgmin)

            dmg:SetDamage(amt)
        end
    })
    wep:EmitSound("ArcCW_BO1.M1911_Fire", 130, 115 * math.Rand(1 - 0.05, 1 + 0.05))
                            -- This is kinda important
                                            -- Wep volume
                                                    -- Weapon pitch (along with the pitch randomizer)




    wep:SetClip2(wep:Clip2() - 1)

    if wep:Clip2() > 0 then
        wep:PlayAnimation("fire_empty_both", 16 / 30)
    /*else
        wep:PlayAnimation("fire_last_left", 16 / 30)*/
    end

    wep:DoEffects()
end

att.UBGL_Reload = function(wep, ubgl)
    wep:Reload()

    local clip = 8 + (0 * GetConVar("arccw_mw2_chambering"):GetInt())

    if wep:Clip2() >= clip then return end -- att.UBGL_Capacity

    if Ammo(wep) <= 0 then return end

    if wep:Clip2() <= 0 then
        wep:PlayAnimation("reload_empty_both", 63 / 24)
        wep:SetNextSecondaryFire(CurTime() + 63 / 24)
        wep:PlaySoundTable({
            {s = "ArcCW_BO1.M1911_MagOut", 	t = 10 / 24},
            {s = "ArcCW_BO1.M1911_MagIn",  	t = 39 / 24},
            {s = "ArcCW_BO1.M1911_Slide_Fwd", 	t = 48 / 24},
        })
    else
        wep:PlayAnimation("reload_both", 59 / 24)
        wep:SetNextSecondaryFire(CurTime() + 59 / 24)
        wep:PlaySoundTable({
            {s = "ArcCW_BO1.M1911_MagOut", 	t = 10 / 24},
            {s = "ArcCW_BO1.M1911_MagIn",  	t = 39 / 24},
        })
    end

    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "pistol") -- att.UBGL_Ammo

    wep:SetClip2(load)
end