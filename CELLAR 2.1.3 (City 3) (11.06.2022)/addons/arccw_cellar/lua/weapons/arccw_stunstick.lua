SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true
SWEP.Category = "CELLAR"
SWEP.AdminOnly = false

SWEP.PrintName = "Stunstick"
SWEP.Slot = 0

SWEP.NotForNPCs = true
SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_mmod/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.ViewModelFOV = 60

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.MeleeDamage = 12
SWEP.MeleeRange = 40
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeTime = 0.6

SWEP.MeleeMissSound = {
	Sound("weapons/tfa_mmod/stunstick/stunstick_swing1.wav"),
	Sound("weapons/tfa_mmod/stunstick/stunstick_swing2.wav"),
	Sound("weapons/tfa_mmod/stunstick/stunstick_swing3.wav"),
}
SWEP.MeleeHitSound = {
	Sound("weapons/tfa_mmod/stunstick/stunstick_impact1.wav"),
	Sound("weapons/tfa_mmod/stunstick/stunstick_impact2.wav"),
	Sound("weapons/tfa_mmod/stunstick/stunstick_impact3.wav"),
}
SWEP.MeleeHitNPCSound = {
	Sound("weapons/tfa_mmod/stunstick/stunstick_fleshhit1.wav"),
	Sound("weapons/tfa_mmod/stunstick/stunstick_fleshhit2.wav"),
}
SWEP.SparkSound = {
	Sound("weapons/tfa_mmod/stunstick/spark1.wav"),
	Sound("weapons/tfa_mmod/stunstick/spark2.wav"),
	Sound("weapons/tfa_mmod/stunstick/spark3.wav"),
}

SWEP.MeleeGesture = 0
SWEP.NotForNPCs = true

SWEP.Firemodes = {
	{
		Mode = 1,
		PrintName = "NOTACTIVATED"
	},
	{
		Mode = 2,
		PrintName = "ACTIVATED"
	},
}


SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "melee"
SWEP.IsStun = true
SWEP.Primary.ClipSize = -1

SWEP.Animations = {
	["draw"] = {
		Source = "draw",
		Time = 1,
		SoundTable = {{s = "weapons/universal/uni_ads_in_03.wav", t = 0.1}}
	},
	["idle"] = {
		Source = "idle01",
		Time = 2,
	},
	["miss"] = {
		Source = {"misscenter1", "misscenter2", "misscenter3"},
		Time = 1,
	},
	["hit"] = {
		Source = {"hitcenter1", "hitcenter2", "hitcenter3"},
		Time = 1,
	},
}

SWEP.IronSightStruct = false

SWEP.BashPreparePos = Vector(0, 0, 0)
SWEP.BashPrepareAng = Angle(0, 5, 0)

SWEP.BashPos = Vector(0, 0, 0)
SWEP.BashAng = Angle(10, -10, 0)

SWEP.HolsterPos = Vector(0, -1, 2)
SWEP.HolsterAng = Angle(-15, 0, 0)

function SWEP:StunEffect(tr)
	local vSrc = tr.StartPos
	local bFirstTimePredicted = IsFirstTimePredicted()
	local bHitWater = bit.band(util.PointContents(vSrc), MASK_WATER) ~= 0
	local bEndNotWater = bit.band(util.PointContents(tr.HitPos), MASK_WATER) == 0

	local trSplash = bHitWater and bEndNotWater and util.TraceLine({
		start = tr.HitPos,
		endpos = vSrc,
		mask = MASK_WATER
	}) or not (bHitWater or bEndNotWater) and util.TraceLine({
		start = vSrc,
		endpos = tr.HitPos,
		mask = MASK_WATER
	})

	if trSplash and bFirstTimePredicted then
		local data = EffectData()
		data:SetOrigin(trSplash.HitPos)
		data:SetScale(1)

		if bit.band(util.PointContents(trSplash.HitPos), CONTENTS_SLIME) != 0 then
			data:SetFlags(1)
		end

		util.Effect("watersplash", data)
	end

	if tr.Hit and bFirstTimePredicted and not trSplash then
		local data = EffectData()
		data:SetOrigin(tr.HitPos)
		data:SetStart(tr.HitPos + tr.HitNormal * 100)
		data:SetEntity(tr.Entity)

		data:SetSurfaceProp(tr.SurfaceProps)

		util.Effect("Impact", data)

		if self:IsActivated() then
			data:SetNormal(tr.HitNormal)

			util.Effect("StunstickImpact", data)
		end
	end
end

function SWEP:GetBloodDamageInfo()
	if self:IsActivated() then
		return 100, 25, 5
	else
		return 25, 25, 10
	end
end

function SWEP:Bash(melee2)
	melee2 = melee2 or false
	if self:GetState() == ArcCW.STATE_SIGHTS then return end
	if self:GetNextArcCWPrimaryFire() > CurTime() then return end

	if !self.CanBash and !self:GetBuff_Override("Override_CanBash") then return end

	self.Primary.Automatic = true

	local mult = self:GetBuff_Mult("Mult_MeleeTime")
	local mt = self.MeleeTime * mult

	if melee2 then
		mt = self.Melee2Time * mult
	end

	self:SetNextArcCWPrimaryFire(CurTime() + mt)

	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	if CLIENT then
		self:OurViewPunch(-self.BashAng * 0.05)
	end

	self:MeleeAttack(melee2)
end

function SWEP:MeleeAttack(melee2)
	local reach = 32 + self.MeleeRange

	self:GetOwner():LagCompensation(true)

	local tr = util.TraceHull({
		start = self:GetOwner():GetShootPos(),
		endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * reach,
		filter = self:GetOwner(),
		mins = Vector(-5, -5, -5),
		maxs = Vector(5, 5, 5),
		mask = MASK_SHOT_HULL
	})

	if !(game.SinglePlayer() and CLIENT) then
		if tr.Hit then
			self:PlayAnimation("hit", 1, true, 0, false)

			if tr.Entity:IsNPC() or tr.Entity:IsNextBot() or tr.Entity:IsPlayer() then
				self:MyEmitSound(self.MeleeHitNPCSound, 75, 100, 1, CHAN_WEAPON)
			else
				self:MyEmitSound(self.MeleeHitSound, 75, 100, 1, CHAN_WEAPON)
			end

			if tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_BLOODYFLESH then
				local fx = EffectData()
				fx:SetOrigin(tr.HitPos)

				util.Effect("BloodImpact", fx)
			else
				self:StunEffect(tr)
			end
		else
			self:PlayAnimation("miss", 1, true, 0, false)

			self:MyEmitSound(self.MeleeMissSound or "weapons/iceaxe/iceaxe_swing1.wav", 75, 100, 1, CHAN_WEAPON)
		end
	end

	if SERVER then
		local entity = tr.Entity

		if IsValid(entity) then
			local dmg = 10

			local dmginfo = DamageInfo()

			local attacker = self:GetOwner()
			if !IsValid(attacker) then attacker = self end

			dmginfo:SetAttacker(attacker)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(dmg)
			dmginfo:SetDamageType(DMG_CLUB)
			dmginfo:SetDamagePosition(tr.HitPos)
			dmginfo:SetDamageForce(self:GetOwner():GetAimVector() * (dmg * 0.25))

		   	SuppressHostEvents(NULL)
			entity:DispatchTraceAttack(dmginfo, tr)
			SuppressHostEvents(self:GetOwner())

			if tr.Entity:GetClass() == "func_breakable_surf" then
				tr.Entity:Fire("Shatter", "0.5 0.5 256")
			end
		end
	end

	self:GetOwner():LagCompensation(false)
end

function SWEP:ChangeFiremode(pred)
	if !self:GetOwner():IsWepRaised() then
		return
	end

    pred = pred or true
    local fmt = self:GetBuff_Override("Override_Firemodes") or self.Firemodes

    fmt["BaseClass"] = nil

    if table.Count(fmt) == 1 then return end

    local fmi = self:GetNWInt("firemode", 1)
    local lastfmi = fmi

    fmi = fmi + 1

    if fmi > table.Count(fmt) then
       fmi = 1
    end

    local altsafety = SERVER and (self:GetOwner():GetInfo("arccw_altsafety") == "1") or CLIENT and (GetConVar("arccw_altsafety"):GetBool())
    if altsafety and !self:GetOwner():KeyDown(IN_WALK) and fmt[fmi] and fmt[fmi].Mode == 0 then
        -- Skip safety when walk key is not down
        fmi = (fmi + 1 > table.Count(fmt)) and 1 or (fmi + 1)
    elseif altsafety and self:GetOwner():KeyDown(IN_WALK) then
        if fmt[lastfmi] and fmt[lastfmi].Mode == 0 then
            -- Find the first non-safety firemode
            local nonsafe_fmi = nil
            for i, fm in pairs(fmt) do
                if fm.Mode != 0 then nonsafe_fmi = i break end
            end
            fmi = nonsafe_fmi or fmi
        else
            -- Find the safety firemode
            local safety_fmi = nil
            for i, fm in pairs(fmt) do
                if fm.Mode == 0 then safety_fmi = i break end
            end
            fmi = safety_fmi or fmi
        end
    end

    if !fmt[fmi] then fmi = 1 end

    self:SetNWInt("firemode", fmi)

    if SERVER then
        if pred then
            SuppressHostEvents(self:GetOwner())
        end
        
        --timer.Simple(0.1, function()
        --	self:GetOwner():DoCustomAnimEvent(401, fmi == 2 and 1 or 0)
        --end)
        self:MyEmitSound(self.SparkSound, 75, 100, 1, CHAN_WEAPON)

        if pred then
            SuppressHostEvents(NULL)
        end
    else
    	self:MyEmitSound(self.SparkSound, 75, 100, 1, CHAN_WEAPON)
    end


    self:SetShouldHoldType()
end

function SWEP:IsActivated()
	return self:GetNWInt("firemode") == 2
end

function SWEP:OnRaised()
end

function SWEP:OnLowered()
	if self:IsActivated() then
		self:MyEmitSound(self.SparkSound, 75, 100, 1, CHAN_WEAPON)
	end

	self:SetNWInt("firemode", 1)
end

function SWEP:Holster(wep)
    if self:GetOwner():IsNPC() then return end
    if self:GetBurstCount() > 0 and self:Clip1() > 0 then return false end

    local skip = GetConVar("arccw_holstering"):GetBool()

    if CLIENT then
        if LocalPlayer() != self:GetOwner() then return end
    end

    if game.SinglePlayer() and self:GetOwner():IsValid() and SERVER then
        self:CallOnClient("Holster")
    end

    if self:GetNWBool("grenadeprimed") then
        self:Throw()
    end

    self.Sighted = false
    self.Sprinted = false

    if CLIENT and LocalPlayer() == self:GetOwner() then
        self:ToggleCustomizeHUD(false)
    end

    self.HolsterSwitchTo = wep

    local time = 0.25
    local anim = self:SelectAnimation("holster")
    if anim then
        self:PlayAnimation(anim, self:GetBuff_Mult("Mult_DrawTime"), true, nil, nil, nil, true)
        time = self:GetAnimKeyTime(anim)
    else
        if CLIENT then
            self:ProceduralHolster()
        end
    end

    time = time * self:GetBuff_Mult("Mult_DrawTime")

    if !skip then time = 0 end

    if !self.FullyHolstered then

        self:SetTimer(time, function()
            self.ReqEnd = true
            self:KillTimers()

            self.FullyHolstered = true

            self:Holster(self.HolsterSwitchTo)

            if CLIENT then
                input.SelectWeapon(self.HolsterSwitchTo)
            else
                if SERVER then
                    if self:GetBuff_Override("UBGL_UnloadOnDequip") then
                        local clip = self:Clip2()

                        local ammo = self:GetBuff_Override("UBGL_Ammo") or "smg1_grenade"

                        if SERVER and IsValid(self:GetOwner()) then
                            self:GetOwner():GiveAmmo(clip, ammo, true)
                        end

                        self:SetClip2(0)
                    end

                    self:KillShields()

                    if IsValid(self:GetOwner()) and IsValid(self.HolsterSwitchTo) then
                        self:GetOwner():SelectWeapon(self.HolsterSwitchTo:GetClass())
                    end

                    local vm = self:GetOwner():GetViewModel()

                    if IsValid(vm) then
                        for i = 0, vm:GetNumBodyGroups() do
                            vm:SetBodygroup(i, 0)
                        end
                        vm:SetSkin(0)
                    end

                    if self.Disposable and self:Clip1() == 0 and self:Ammo1() == 0 then
                        self:GetOwner():StripWeapon(self:GetClass())
                    end
                end
            end
        end)
    end

    self:OnLowered()

    if !skip then return true end

    local vm = self:GetOwner():GetViewModel()

    vm:SetPlaybackRate(1)

    return self.FullyHolstered
end

function SWEP:SecondaryAttack()
	if (!IsFirstTimePredicted()) then
		return
	end

	local data = {}
		data.start = self:GetOwner():GetShootPos()
		data.endpos = data.start + self:GetOwner():GetAimVector() * 84
		data.filter = {self, self:GetOwner()}
	local trace = util.TraceLine(data)
	local entity = trace.Entity

	if SERVER and IsValid(entity) then
		if (entity:IsPlayer() and ix.config.Get("allowPush", true)) then
			local direction = self:GetOwner():GetAimVector() * (300 + (self:GetOwner():GetCharacter():GetAttribute("str", 0) * 3))
				direction.z = 0
			entity:SetVelocity(direction)

			self:GetOwner():EmitSound("Weapon_Crossbow.BoltHitBody")
			self:SetNextPrimaryFire(CurTime() + 1.5)
			self:SetNextSecondaryFire(CurTime() + 1.5)
		end
	end
end

if CLIENT then
	SWEP.FirstPersonGlowSprite = Material("sprites/light_glow02_add_noz")
	SWEP.ThirdPersonGlowSprite = Material("sprites/light_glow02_add")
	function SWEP:ViewModelDrawn(vm)
		if !self:IsActivated() then return end

		local attachment = vm:GetAttachment(vm:LookupAttachment("sparkrear"))
		local curTime = CurTime()
		local scale = math.abs(math.sin(curTime * 5) * 2)
		local alpha = math.abs(math.sin(curTime) / 4)

		self.FirstPersonGlowSprite:SetFloat("$alpha", 0.7 + alpha)
		self.ThirdPersonGlowSprite:SetFloat("$alpha", 0.5 + alpha)
							
		if !attachment or (attachment and !attachment.Pos) then return end

		cam.Start3D(EyePos(), EyeAngles())
			cam.IgnoreZ(true)
				render.SetMaterial(self.ThirdPersonGlowSprite)
				render.DrawSprite(attachment.Pos, 16 + scale, 16 + scale, Color(255, 255, 255, 255 ))
						
				self.FirstPersonGlowSprite:SetFloat("$alpha", 0.5 + alpha)
						
				for i = 1, 9 do
					local attachment = vm:GetAttachment(vm:LookupAttachment("spark"..i.."a"))
					
					if attachment.Pos then
						if i == 1 or i == 2 or i == 9 then
							render.SetMaterial(self.ThirdPersonGlowSprite)
						else
							render.SetMaterial(self.FirstPersonGlowSprite)
						end
						
						render.DrawSprite(attachment.Pos, 1, 1, Color(255, 255, 255, 255))
					end
				end
						
				for i = 1, 9 do
					local attachment = vm:GetAttachment(vm:LookupAttachment("spark"..i.."b"))
					
					if attachment.Pos then
						if i == 1 or i == 2 or i == 9 then
							render.SetMaterial(self.ThirdPersonGlowSprite)
						else
							render.SetMaterial(self.FirstPersonGlowSprite)
						end
								
						render.DrawSprite(attachment.Pos, 1, 1, Color(255, 255, 255, 255))
					end
				end
			cam.IgnoreZ(true)
		cam.End3D()
	end

	function SWEP:DrawWorldModel()
		self.BaseClass.DrawWorldModel(self)

		if !self:IsActivated() then return end

		local attachment = self:GetAttachment(1)
		local curTime = CurTime()
		local scale = math.abs(math.sin(curTime) * 4)
		local alpha = math.abs(math.sin(curTime) / 4)
		
		self.ThirdPersonGlowSprite:SetFloat("$alpha", 0.7 + alpha)
		
		if attachment and attachment.Pos then
			cam.Start3D(EyePos(), EyeAngles())
				render.SetMaterial(self.ThirdPersonGlowSprite)
				render.DrawSprite(attachment.Pos, 8 + scale, 8 + scale, Color(255, 255, 255, 255 ))
			cam.End3D()
		end
	end
end