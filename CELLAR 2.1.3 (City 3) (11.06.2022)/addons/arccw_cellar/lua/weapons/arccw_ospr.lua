SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR [DEV]" 
SWEP.AdminOnly = false

SWEP.PrintName = "OSPR Mk. 3"

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/schwarzkruppzo/c_ospr.mdl"
SWEP.WorldModel = "models/weapons/schwarzkruppzo/w_ospr.mdl"
SWEP.ViewModelFOV = 65

SWEP.Damage = 100
SWEP.DamageMin = 70
SWEP.BloodDamage = 1000
SWEP.ShockDamage = 6000
SWEP.BleedChance = 100
SWEP.AmmoItem = "bullets_ar2"
SWEP.ImpulseSkill = true

SWEP.DefaultBodygroups = "000000"

SWEP.Range = 2000 -- in METRES
SWEP.Penetration = 30
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 900 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.ImpactEffect = "AR2Impact"
SWEP.Tracer = "AR2Tracer"
SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(21, 37, 64)
SWEP.TracerWidth = 10

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 60
SWEP.ReducedClipSize = 15

SWEP.Recoil = 0.1
SWEP.RecoilSide = 0
SWEP.RecoilRise = 0.75
SWEP.VisualRecoilMult = 1
SWEP.RecoilPunch = 2

SWEP.RecoilDirection = Angle(1, 0, 0)
SWEP.RecoilDirectionSide = Angle(0, 1, 0)

SWEP.Delay = 500 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
	{
		Mode = 1,
	},
}

SWEP.NPCWeaponType = {"weapon_ar2", "weapon_smg1"}
SWEP.NPCWeight = 150

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 512 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 2048

SWEP.Primary.Ammo = "AR2" -- what ammo type the gun uses

SWEP.ShootVol = 155 -- volume of shoot sound
SWEP.ShootPitch = 120 -- pitch of shoot sound

sound.Add({
    name = "OSPR.Single",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 155,
    pitch = {85, 130},
    sound = "weapons/ospr/fire1.ogg"
})

SWEP.FirstShootSound = Sound("OSPR.Single")
SWEP.ShootSound = Sound("OSPR.Single")
SWEP.DistantShootSound = Sound("OSPR.Single")

SWEP.MuzzleEffect = "muzzleflash_ar2"
SWEP.ShellModel = "models/weapons/shell.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 0 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.96
SWEP.SightedSpeedMult = 0.70
SWEP.SightTime = 1

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
	-- [0] = "bulletchamber",
	-- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
	Pos = Vector(-6, -10, 0.5),
	Ang = Angle(0, 0, 0),
	Magnification = 2,
	ScopeMagnification = 0,
	ScopeMagnificationMin = 0,
	ScopeMagnificationMax = 20,
	BlackBox = false,
	ScopeTexture = nil,
	SwitchToSound = "", -- sound that plays when switching to this sight
	SwitchFromSound = "",
	ScrollFunc = ArcCW.SCROLL_ZOOM,
	FlatScope = true,
	ZoomLevels = 30,
	MagnifiedOptic = true,
	CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "passive"
SWEP.HoldtypeSights = "passive"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0, 0, 0)
SWEP.HolsterAng = Angle(0, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 27

SWEP.ExtraSightDist = 5

SWEP.Attachments = {}
SWEP.Animations = {
	["idle"] = {
		Source = "idle",
		Time = 5
	},
	["reload"] = {
		Source = "fire",
		Time = 1,
	},
	["draw"] = {
		Source = "draw",
		Time = 1,
	},
	["fire"] = {
		Source = "fire",
		Time = 1,
	},
	["enter_sprint"] = {
		Source = "sprint_in",
		Time = 0.7
	},
	["exit_sprint"] = {
		Source = "sprint_out",
		Time = 0.7
	},
	["idle_sprint"] = {
		Source = "sprint",
		Time = 0.7
	},
	["bash"] = {
		Source = "melee",
		Time = 1
	},
	
}
SWEP.OSPR = true
SWEP.Stat_Attack = 40
SWEP.Stat_DistanceSkillMod = {
	[1] = 10,
	[2] = 10,
	[3] = 10,
	[4] = 10
}

if CLIENT then
	local rt_Store		= render.GetScreenEffectTexture(0)
	local rt_Blur		= render.GetScreenEffectTexture(1)
	local wireframe = Material("models/wireframe")
	local debugwhite = Material("models/debug/debugwhite")
	local thermalrt = CreateMaterial("visorThermalRT", "UnlitGeneric", {
		["$basetexture"] = "_rt_FullFrameFB",
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1,
		["$ignorez"] = 0,
		["$additive"] = 0,
	})
	local copy = Material("pp/copy")

	local function ArcCW_TranslateBindToEffect(bind)
	    local alt = GetConVar("arccw_altbindsonly"):GetBool()

	    return alt and ArcCW.BindToEffect_Unique[bind] or ArcCW.BindToEffect[bind] or bind
	end

	local function OSPR_PlayerBindPress(ply, bind, pressed)
		if not (ply:IsValid()) then return end

		local wep = ply:GetActiveWeapon()

		if not wep.ArcCW then return end
		if not wep.OSPR then return end
		
		local block = false

		bind = ArcCW_TranslateBindToEffect(bind)

		if wep:GetState() == ArcCW.STATE_SIGHTS then
			if bind == "zoomin" then
				wep:Scroll(1)
				return true
			elseif bind == "zoomout" then
				wep:Scroll(-1)
				return true
			end
		end
	end

	hook.Add("PlayerBindPress", "OSPR_PlayerBindPress", OSPR_PlayerBindPress)

	function SWEP:PostDrawViewModel()
		render.SetBlend(1)

		if ArcCW.Overdraw then
			ArcCW.Overdraw = false
		else
			self:DoScope()
		end
	end

	local scope_bg = Material("ospr/scope_bg")
	local scope_bg_overlay = Material("ospr/scope_bg_overlay")

	if IsValid(visor_ui_model) then
		visor_ui_model:Remove()
		visor_ui_model = nil
	end

	visor_ui_model = ClientsideModel("models/sniper_ui.mdl", RENDERGROUP_OPAQUE)
	visor_ui_model:SetNoDraw(true)

	local pos, ang, ui_ang = Vector(0, 0, 0), Angle(), Angle(0, -90, 90)
	local mdlang = Angle(ang)
	mdlang:RotateAroundAxis(ang:Right(), 0)
	mdlang:RotateAroundAxis(ang:Forward(), 0)
	mdlang:RotateAroundAxis(ang:Up(), 90)

	local drawThermal = false
	function OSPR_TestThermal()
		local rt_Scene = render.GetRenderTarget()
		render.CopyRenderTargetToTexture(rt_Store)

		render.OverrideAlphaWriteEnable(true, true)
		render.Clear(0, 0, 0, 0, false, true)

		cam.Start3D()
			render.SuppressEngineLighting(true)

			for _, ent in ipairs(ents.FindByClass("player")) do
				local doll = ent:GetNetVar("doll")
				local ragdoll = doll and Entity(doll)

				render.SetColorModulation(1, 0, 0.25)
				render.MaterialOverride(wireframe)

				ent = IsValid(ragdoll) and ragdoll or ent
				ent:DrawModel()
		    end

		    render.SuppressEngineLighting(false)
		    render.SetColorModulation(1, 1, 1)
		    render.MaterialOverride(nil)
		cam.End3D()
			
		render.CopyRenderTargetToTexture(rt_Blur)
		render.BlurRenderTarget(rt_Blur, 0.025, 0.025, 1)

		thermalrt:SetTexture("$basetexture", rt_Blur)

		render.SetRenderTarget(rt_Scene)
		
		copy:SetTexture("$basetexture", rt_Store)
		render.SetMaterial(copy)
		render.DrawScreenQuad()
		
		render.SetMaterial(thermalrt)
		render.DrawScreenQuad()
	end

	function SWEP:DoScope()
		if self:GetState() != ArcCW.STATE_SIGHTS then
			if drawThermal then
				hook.Remove("PostDrawEffects", "VISOR.UI")
				drawThermal = false
			end

			return
		end
		
		if self:GetSightDelta() > 0.75 then
			if drawThermal then
				hook.Remove("PostDrawEffects", "VISOR.UI")
				drawThermal = false
			end
			
			return
		end

		if !drawThermal then
			hook.Add("PostDrawEffects", "VISOR.UI", OSPR_TestThermal)
			drawThermal = true
		end
		
		if !scope_bg:IsError() then
			render.SetMaterial(scope_bg)
	        render.DrawScreenQuad()

	        render.SetMaterial(scope_bg_overlay)
	        render.DrawScreenQuad()
	    end
	end

	surface.CreateFont("ospr_ui", {
		font = "Blender Pro Bold",
		extended = false,
		size = 26,
		weight = 1000,
		antialias = true,
	})

	surface.CreateFont("ospr_ui.value", {
		font = "Blender Pro Bold",
		extended = false,
		size = 35,
		weight = 500,
		antialias = true,
	})

	ospr_setup_materials = false
	ospr_anim_circles = ospr_anim_circles or nil
	ospr_anim_energy = ospr_anim_energy or nil

	local function OSPR_SetupMaterials()
		local materials = {
			["static_color"] = Color(0, 255, 255, 255),
			["strikes"] = Color(0, 255, 255, 76),
			["inner_circle"] = Color(255, 255, 255, 51),
			["inner_circle"] = Color(255, 255, 255, 51),
			["guides_minor"] = Color(255, 255, 255, 25.5),
			["guides_major"] = Color(255, 255, 255, 64),
			["horizontal_corners"] = Color(255, 255, 255, 102),
			["left_slider"] = Color(0, 255, 255, 76),
			["outer_circle_minor"] = Color(0, 255, 255, 25.5),
			["outer_circle_major"] = Color(255, 255, 255, 25.5),
			["white_circles"] = Color(255, 255, 255, 128),
			["anim_circles"] = Color(0, 255, 255, 25.5),
			["anim_energy"] = Color(255, 255, 255, 255),
		}

		for k, v in pairs(materials) do
			local mat = Material("ospr/"..k)

			if mat:IsError() then continue end

			local tex

			if k == "anim_circles" then
				tex = GetRenderTargetEx("ospr_x2"..k, 128, 4, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SHARED, 0, 0, IMAGE_FORMAT_RGBA8888)
				ospr_anim_circles = tex
			elseif k == "anim_energy" then
				tex = GetRenderTargetEx("ospr_y2"..k, 128, 128, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SHARED, 0, 0, IMAGE_FORMAT_RGBA8888)
				ospr_anim_energy = tex
			else
				tex = GetRenderTargetEx("ospr_"..k, 16, 16, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SHARED, 0, 0, IMAGE_FORMAT_RGBA8888)
			end
			
			render.PushRenderTarget(tex)
				render.Clear(v.r, v.g, v.b, v.a)
			render.PopRenderTarget()

			mat:SetTexture("$basetexture", tex)
		end
	end

	function SWEP:DrawHUD()
		if !ospr_setup_materials then
			OSPR_SetupMaterials()

			ospr_setup_materials = true
		end
		
		if self:GetState() != ArcCW.STATE_SIGHTS then
			return
		end
		
		if self:GetSightDelta() > 0.75 then
			return
		end

		if ospr_anim_circles then
			local reloading = math.Clamp((self:GetNextArcCWPrimaryFire() - CurTime()) / self.Delay, 0, 1)
			render.PushRenderTarget(ospr_anim_circles)
				render.Clear(0, 255, 255, 25.5)
				cam.Start2D()
					surface.SetDrawColor(0, 255, 255, 255)
					surface.DrawRect(0, 0, 4 * math.Round(28 * reloading), 4)
				cam.End2D()
			render.PopRenderTarget()
		end

		if ospr_anim_energy then
			local delta = self:GetChargeDelta()

			render.PushRenderTarget(ospr_anim_energy)
				render.Clear(255, 255, 255, 255)
				cam.Start2D()
					surface.SetDrawColor(0, 255, 255, 255)

					if delta > 0 and delta < 1 then
						surface.DrawRect(0, 32, 32, 32)
					end

					if delta > 0.25 then
						surface.DrawRect(0, 0, 64, 32)
					end

					if delta > 0.5 then
						surface.DrawRect(64, 0, 64, 32)
					end

					if delta > 0.75 then
						surface.DrawRect(32, 32, 32, 32)
					end

					if delta >= 1 then
						surface.DrawRect(0, 64, 128, 64)
					end
				cam.End2D()
			render.PopRenderTarget()
		end

		local proc = string.format("%i%%", 100 * self:GetChargeDelta())
		cam.Start3D(pos, ang, 75, 0, 0, nil, nil, 0.1, 1280)
			cam.IgnoreZ(true)
				render.SuppressEngineLighting(true)
				visor_ui_model:SetPos(pos)
				visor_ui_model:SetAngles(mdlang)
				visor_ui_model:FrameAdvance(FrameTime())
				visor_ui_model:DrawModel()

				render.SuppressEngineLighting(false)

				local ui = visor_ui_model:GetAttachment(1)

				if ui then
					cam.Start3D2D(ui.Pos, ui_ang, 0.05)
						local old = DisableClipping(true)
						surface.SetFont("ospr_ui")

						local w, h = surface.GetTextSize("CHARGE")
						local y = -5 + -h/2

						surface.SetTextColor(color_black)
						surface.SetTextPos(-w/2, y) 
						surface.DrawText("CHARGE")


						surface.SetFont("ospr_ui.value")

						w, h = surface.GetTextSize(proc)
						y = y - h

						surface.SetTextColor(color_white)
						surface.SetTextPos(-w/2, y - 3) 
						surface.DrawText(proc)

						DisableClipping(old)
					cam.End3D2D()
				end
			cam.IgnoreZ(false)
		cam.End3D()
	end

	function SWEP:Hook_SelectFireAnimation()
		visor_ui_model:ResetSequenceInfo()
		visor_ui_model:SetCycle(0)
		visor_ui_model:ResetSequence("fire")
	end

	local EFFECT = {}
	local laser2 = CreateMaterial("ospr_laser3", "UnlitGeneric", {
		["$basetexture"] = "effects/bluelaser1",
		["$nocull"] = 1,
		["$nodecal"] = 1,
		["$additive"] = 1,
		["$no_fullbright"] = 1,
		["$model"] = 1,
		["$nofog"] = 1,
		["$vertexalpha"] = 1,
		["$vertexcolor"] = 1
	})
	function EFFECT:Init(data)
		self.EndPos = data:GetOrigin()
		self.WeaponEnt = data:GetEntity()
		self.Position = self:GetTracerShootPos(self.EndPos, self.WeaponEnt, 1)
		self.Color = Color(32, 255, 255, 255)
		self.Size = 32
		
		self.alpha = 200
		self:SetRenderBoundsWS(self.Position, self.EndPos)
	end

	function EFFECT:Think()
		local ft = FrameTime()

		self.Size = Lerp(10 * ft, self.Size, 0)
		self.alpha = Lerp(5 * ft, self.alpha, 0)
		local delta = self.alpha / 255

		self.Color.r = 32 * delta
		self.Color.g = 255 * delta
		self.Color.b = 255 * delta
		self.Color.a = self.alpha

		if self.alpha <= 0 then 
			return false 
		end	

		return true
	end

	function EFFECT:Render()
		render.SetMaterial(laser2)
		render.DrawBeam(self.Position, self.EndPos, self.Size, 0, 0, self.Color)
	end

	effects.Register(EFFECT, "ospr.laser")
end

function SWEP:StartCharge()
	self.LastChargeUpTime = CurTime()
end

function SWEP:StopCharge()
	self.LastChargeUpTime = nil
end

function SWEP:GetChargeDelta()
	if !self.LastChargeUpTime then
		return 0
	end
	
	local delta = math.Clamp((CurTime() - self.LastChargeUpTime) / 3, 0, 1)

	delta = math.abs(delta)

	return delta
end

local function SuppressSelection()
	return true
end

function SWEP:Hook_Think()
	if SERVER then
		if self:GetState() == ArcCW.STATE_SIGHTS and !self.LastChargeUpTime then
			if self:GetNextArcCWPrimaryFire() <= CurTime() then
				self:StartCharge()
				self:CallOnClient("StartCharge")
			end
		elseif self:GetState() != ArcCW.STATE_SIGHTS and self.LastChargeUpTime then
			self:StopCharge()
			self:CallOnClient("StopCharge")
		end
	else
		if self:GetState() == ArcCW.STATE_SIGHTS and !self.PlaySightAnim then
			hook.Add("SuppressWeaponSelection", "OSPR", SuppressSelection)

			self.PlaySightAnim = true

			visor_ui_model:ResetSequenceInfo()
			visor_ui_model:SetCycle(0)
			visor_ui_model:ResetSequence("draw")
		elseif self:GetState() != ArcCW.STATE_SIGHTS and self.PlaySightAnim then
			hook.Remove("SuppressWeaponSelection", "OSPR")

			self.PlaySightAnim = false
		end
	end
end

function SWEP:Hook_PostFireBullets()
	if SERVER then
		self:StopCharge()
		self:CallOnClient("StopCharge")
	end
end

function SWEP:DoShellEject()

end

function SWEP:DoEffects()
	
end

function SWEP:Hook_BulletHit(hit)
	local pos = hit.tr.HitPos

	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetEntity(self)

	util.Effect("ospr.laser", effectdata)

	return hit
end

function SWEP:GetBloodDamageInfo()
	local delta = math.max(self:GetChargeDelta(), 0.1)

	return self.ShockDamage * delta, self.BloodDamage * delta, self.BleedChance * delta
end

function SWEP:GetDamage(range, pellet)
	local charge = math.max(self:GetChargeDelta(), 0.1)
    local dmgmax = self.Damage * charge
    local dmgmin = self.DamageMin * charge
    local delta = 1

    local sran = self.Range

    delta = (range / sran)
    delta = math.Clamp(delta, 0, 1)

    local lerped = Lerp(delta, dmgmax, dmgmin)
    print(lerped)
    return lerped
end