SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "CELLAR"
SWEP.AdminOnly = false

SWEP.PrintName = "OSIPR Mk. I"

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_mmod/c_irifle_hd.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.ViewModelFOV = 60

SWEP.Damage = 50
SWEP.DamageMin = 40
SWEP.BloodDamage = 550
SWEP.ShockDamage = 850
SWEP.BleedChance = 2
SWEP.AmmoItem = "bullets_ar2"
SWEP.ImpulseSkill = true

SWEP.DefaultBodygroups = "000000"

SWEP.Range = 110 -- in METRES
SWEP.Penetration = 7
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

SWEP.Recoil = 1
SWEP.RecoilSide = 0.35
SWEP.RecoilRise = 0.75

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
}

SWEP.NPCWeaponType = {"weapon_ar2", "weapon_smg1"}
SWEP.NPCWeight = 150

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 225 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

SWEP.Primary.Ammo = "AR2" -- what ammo type the gun uses

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

sound.Add({
    name = "OSIPR.Single",
    channel = CHAN_WEAPON,
    volume = 0.8,
    level = 140,
    pitch = {85, 100},
    sound = {"weapons/tfa_mmod/ar2/fire1.wav", "weapons/tfa_mmod/ar2/fire2.wav", "weapons/tfa_mmod/ar2/fire3.wav"}
})

SWEP.FirstShootSound = Sound("OSIPR.Single")
SWEP.ShootSound = Sound("OSIPR.Single")
SWEP.DistantShootSound = Sound("OSIPR.Single")

SWEP.MuzzleEffect = "muzzleflash_ar2"
SWEP.ShellModel = "models/weapons/shell.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 0 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.96
SWEP.SightedSpeedMult = 0.70
SWEP.SightTime = 0.75

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-4.24, -5.829, 1.76),
    Ang = Angle(0, 0, -8.443),
    Magnification = 1.1,
    SwitchToSound = "weapons/tnweapons/osipr/sightlower1.wav", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "ar2"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 27

SWEP.ExtraSightDist = 5

SWEP.Attachments = {}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 100
    },
    ["draw"] = {
        Source = "draw",
        Time = 0.5,
        SoundTable = {{s = "weapons/tfa_mmod/ar2/ar2_deploy.wav", t = 0}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 0.5,
        SoundTable = {{s = "weapons/tfa_mmod/ar2/ar2_deploy.wav", t = 0}},
    },
    ["ready"] = {
        Source = "ready",
        Time = 1,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["fire"] = {
        Source = {"fire1", "fire2", "fire3", "fire4"},
        Time = 0.4,
        ShellEjectAt = 0,
    },
    ["fire_last"] = {
        Source = "fire_midempty",
        Time = 0.4,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = {"fire1_is", "fire2_is", "fire3_is", "fire4_is"},
        Time = 0.4,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 2.5,
        TPAnim = ACT_GESTURE_RELOAD,
		TPAnimStartTime = 0,
        SoundTable = {
            {s = "weapons/tfa_mmod/ar2/ar2_magout.wav", t = 0.25},
			{s = "weapons/tfa_mmod/ar2/ar2_rotate.wav", t = 0.35},
            {s = "weapons/tfa_mmod/ar2/ar2_magin.wav", t = 1.25},
			{s = "weapons/tfa_mmod/ar2/ar2_reload_push.wav", t = 1.35}
        },
    },
    ["reload_empty"] = {
        Source = "reloadempty",
        Time = 2.5,
        TPAnim = ACT_GESTURE_RELOAD,
		TPAnimStartTime = 0,
        SoundTable = {
            {s = "weapons/tfa_mmod/ar2/ar2_magout.wav", t = 0.25},
			{s = "weapons/tfa_mmod/ar2/ar2_rotate.wav", t = 0.35},
            {s = "weapons/tfa_mmod/ar2/ar2_magin.wav", t = 1.25},
			{s = "weapons/tfa_mmod/ar2/ar2_reload_push.wav", t = 1.35}
        },
    },
}

function SWEP:DoEffects()
    if not game.SinglePlayer() and not IsFirstTimePredicted() then return end

    local self = self

    if CLIENT and !self:GetOwner():ShouldDrawLocalPlayer() then
        self = self:GetOwner():GetViewModel()
    end

    local muz = self:GetAttachment(1)
    if muz then
        local data = EffectData()
        data:SetEntity(self) 
        data:SetOrigin(muz.Pos + muz.Ang:Forward() * 20) 
        data:SetAngles(muz.Ang)
        data:SetScale(1)
        data:SetAttachment(1)
        data:SetFlags(5)
        util.Effect("MuzzleFlash", data)
    end
end