SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true
SWEP.Category = "CELLAR"
SWEP.AdminOnly = false

SWEP.PrintName = "Crowbar"
SWEP.Slot = 0

SWEP.NotForNPCs = true
SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_mmod/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ViewModelFOV = 60

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.MeleeRange = 35
SWEP.MeleeDamageType = DMG_CLUB
SWEP.MeleeTime = 0.45
SWEP.MeleeDamage = 33
SWEP.BloodDamage = 100
SWEP.ShockDamage = 100
SWEP.BleedChance = 75
SWEP.HeadDamageMultiply = 20

SWEP.MeleeMissSound = {
    Sound("weapons/tfa_mmod/crowbar/crowbar_swing1.wav"),
    Sound("weapons/tfa_mmod/crowbar/crowbar_swing2.wav"),
    Sound("weapons/tfa_mmod/crowbar/crowbar_swing3.wav"),
}
SWEP.MeleeHitNPCSound = {
    Sound("physics/flesh/flesh_impact_bullet1.wav"),
    Sound("physics/flesh/flesh_impact_bullet2.wav"),
    Sound("physics/flesh/flesh_impact_bullet3.wav"),
    Sound("physics/flesh/flesh_impact_bullet4.wav"),
    Sound("physics/flesh/flesh_impact_bullet5.wav"),
}

SWEP.MeleeGesture = 0
SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "MELEE"
    }
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "melee"

SWEP.Primary.ClipSize = -1

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
        Time = 1,
        SoundTable = {{s = "weapons/tfa_mmod/crowbar/crowbar_deploy.wav", t = 0.1}}
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
    local reach = 32 + self:GetBuff_Add("Add_MeleeRange") + self.MeleeRange
    local dmg = self:GetBuff_Override("Override_MeleeDamage") or self.MeleeDamage or 20

    if melee2 then
        reach = 32 + self:GetBuff_Add("Add_MeleeRange") + self.Melee2Range
        dmg = self:GetBuff_Override("Override_MeleeDamage") or self.Melee2Damage or 20
    end

    dmg = dmg * self:GetBuff_Mult("Mult_MeleeDamage")

    self:GetOwner():LagCompensation(true)

    local tr = util.TraceLine({
        start = self:GetOwner():GetShootPos(),
        endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * reach,
        filter = self:GetOwner(),
        mask = MASK_SHOT_HULL
    })

    if !(game.SinglePlayer() and CLIENT) then
        if tr.Hit then
            self:PlayAnimation("hit", 1, true, 0, false)

            if tr.Entity:IsNPC() or tr.Entity:IsNextBot() or tr.Entity:IsPlayer() then
                self:MyEmitSound(self.MeleeHitNPCSound, 75, 100, 1, CHAN_WEAPON)
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

    local target = tr.Entity

    if SERVER and IsValid(target) then --and (target.ixPlayer or target:IsNPC() or target:IsPlayer() or target:Health() > 0) then
        local dmginfo = DamageInfo()

        local attacker = self:GetOwner()
        if !IsValid(attacker) then attacker = self end

        dmginfo:SetAttacker(attacker)
        dmginfo:SetInflictor(self)
        dmginfo:SetDamage(dmg)
        dmginfo:SetDamageType(self:GetBuff_Override("Override_MeleeDamageType") or self.MeleeDamageType or DMG_CLUB)
        dmginfo:SetDamagePosition(tr.HitPos)
        dmginfo:SetDamageForce(self:GetOwner():GetAimVector() * (dmg * 0.25))

        SuppressHostEvents(NULL)
        target:DispatchTraceAttack(dmginfo, tr)
        SuppressHostEvents(self:GetOwner())

        if tr.Entity:GetClass() == "func_breakable_surf" then
            tr.Entity:Fire("Shatter", "0.5 0.5 256")
        end
    end

    self:GetBuff_Hook("Hook_PostBash", {tr = tr, dmg = dmg})

    self:GetOwner():LagCompensation(false)
end