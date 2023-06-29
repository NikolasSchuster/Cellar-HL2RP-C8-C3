att.PrintName = "Masterkey (BO1)"
att.Icon = Material("entities/acwatt_ubgl_aug_mk.png", "mips smooth")
att.Description = "Selectable shotgun equipped under the rifle's barrel. Double tap +ZOOM to equip/dequip."
att.Desc_Pros = {
	"+ Selectable Underbarrel Shotgun.",
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
	"info.toggleubgl"
}
att.AutoStats = true
att.Slot = "bo1_mk"
att.ExcludeFlags = {"kali_barrel_short", "mag_patriot"}
att.GivesFlags = {"ubanims"}
att.BO1_UBMK = true
att.HideIfBlocked = true

att.SortOrder = 99

att.MountPositionOverride = 0

att.UBGL = true
att.UBGL_BaseAnims = true

att.UBGL_PrintName = "UB (BUCK)"
att.UBGL_Automatic = false
att.UBGL_MuzzleEffect = "muzzleflash_m3"
att.UBGL_ClipSize = 4
att.UBGL_Ammo = "buckshot"
att.UBGL_RPM = 1200
att.UBGL_Recoil = 0.5
att.UBGL_Capacity = 4
att.UBGL_Icon = Material("entities/acwatt_ubgl_aug_mk.png")

att.Reloading = false
att.ReloadingTimer = 0
att.NeedPump = false

local function Ammo(wep)
	return wep.Owner:GetAmmoCount("buckshot")
end

att.Hook_ShouldNotSight = function(wep)
	if wep:GetInUBGL() then return true end
end

att.UBGL_NPCFire = function(wep, ubgl)
	if att.Reloading then
		Masterkey_ReloadFinish(wep)
		return
	end
	if att.NeedPump then return end
	if wep:Clip2() <= 0 then return end

	wep:PlayAnimation("fire_mksetup")

	--wep:FireRocket("arccw_gl_he_mw2", 30000)
	wep.Owner:FireBullets({
		Src = wep.Owner:EyePos(),
		Num = 6,
		Damage = 25,
		Force = 2,
		Attacker = wep.Owner,
		Dir = wep.Owner:EyeAngles():Forward(),
		Spread = Vector(0.1, 0.1, 0),
		Callback = function(_, tr, dmg)
			local dist = (tr.HitPos - tr.StartPos):Length() * ArcCW.HUToM

			local dmgmax = 25
			local dmgmin = 0

			local delta = dist / 1750 * 0.025

			delta = math.Clamp(delta, 0, 1)

			local amt = Lerp(delta, dmgmax, dmgmin)

			dmg:SetDamage(amt)
		end
	})

	wep:EmitSound("ArcCW_BO1.MK_Fire", 100)

	wep:SetClip2(wep:Clip2() - 1)

	wep:DoEffects()
	att.NeedPump = true
end

att.UBGL_Fire = function(wep, ubgl)
	if att.Reloading then
		Masterkey_ReloadFinish(wep)
		return
	end
	if att.NeedPump then return end
	if wep:Clip2() <= 0 then return end

	wep:PlayAnimation("fire_mksetup")

	--wep:FireRocket("arccw_gl_he_mw2", 30000)
	wep.Owner:FireBullets({
		Src = wep.Owner:EyePos(),
		Num = 6,
		Damage = 25,
		Force = 2,
		Attacker = wep.Owner,
		Dir = wep.Owner:EyeAngles():Forward(),
		Spread = Vector(0.1, 0.1, 0),
		Callback = function(_, tr, dmg)
			local dist = (tr.HitPos - tr.StartPos):Length() * ArcCW.HUToM

			local dmgmax = 25
			local dmgmin = 0

			local delta = dist / 1750 * 0.025

			delta = math.Clamp(delta, 0, 1)

			local amt = Lerp(delta, dmgmax, dmgmin)

			dmg:SetDamage(amt)
		end
	})

	wep:EmitSound("ArcCW_BO1.MK_Fire", 100)

	wep:SetClip2(wep:Clip2() - 1)

	wep:DoEffects()
	att.NeedPump = true
end

att.UBGL_Reload = function(wep, ubgl)
	if wep:Clip2() >= 4 then return end
	if Ammo(wep) <= 0 then return end
	if att.Reloading == true then return end

	Masterkey_ReloadStart(wep)
	att.Reloading = true
end

att.Hook_Think = function(wep)
	--print("lol")
	if att.NeedPump and wep:GetNextSecondaryFire() <= CurTime() and wep:Clip2() > 0 and !att.Reloading and !wep.Owner:KeyDown(IN_ATTACK) then
		wep:PlayAnimation("pump_mksetup")
		wep:SetNextSecondaryFire(CurTime() + 0.75)
		att.NeedPump = false
	end
	if att.Reloading and att.ReloadingTimer <= CurTime() and wep:Clip2() < 4 then
		Masterkey_ReloadLoop(wep)
	elseif att.Reloading and wep:Clip2() >= 4 then
		Masterkey_ReloadFinish(wep)
	end
end

-- i buffed the masterkey reloading because it's horrendously slow
-- i buffed the masterkey reloading because it's horrendously slow
-- i buffed the masterkey reloading because it's horrendously slow

function Masterkey_ReloadStart(wep)
	wep:PlayAnimation("reload_start_mksetup")
	att.ReloadingTimer = (CurTime() + 35 / 30)
	att.Reloading = true
end

function Masterkey_ReloadLoop(wep)
	wep:PlayAnimation("reload_loop_mksetup")
	att.ReloadingTimer = (CurTime() + 33 / 30)
	Masterkey_InsertShell(wep)
end

function Masterkey_ReloadFinish(wep)
	wep:PlayAnimation("reload_finish_mksetup")
	wep:SetNextSecondaryFire(CurTime() + 50 / 30)
	att.Reloading = false
	att.NeedPump = false
end

function Masterkey_InsertShell(wep)
	wep.Owner:RemoveAmmo(1, "buckshot")
	wep:SetClip2(wep:Clip2() + 1)
end

att.Mult_SightTime = 1.25
att.Mult_SightedSpeedMult = 0.85