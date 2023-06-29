SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "CELLAR" 
SWEP.AdminOnly = false

SWEP.PrintName = "357"
SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_mmod/c_357.mdl"
SWEP.WorldModel = "models/weapons/tfa_mmod/w_357.mdl"
SWEP.ViewModelFOV = 50

SWEP.Damage = 120
SWEP.DamageMin = 75 -- damage done at maximum range
SWEP.BloodDamage = 750
SWEP.ShockDamage = 1000
SWEP.BleedChance = 95
SWEP.AmmoItem = "bullets_357"

SWEP.Range = 40 -- in METRES
SWEP.Penetration = 3
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 500

SWEP.CanFireUnderwater = false

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 6 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 6
SWEP.ReducedClipSize = 4

SWEP.Recoil = 8
SWEP.RecoilSide = 0.5
SWEP.RecoilRise = 3
//SWEP.VisualRecoilMult = 2
SWEP.MaxRecoilBlowback = 1.2
//SWEP.VisualRecoilMult = 1.25
SWEP.RecoilPunch = 0

SWEP.Delay = 60 / 180 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
}

SWEP.AccuracyMOA = 7 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 150 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 50

SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses
SWEP.MagID = "sp40" -- the magazine pool this gun draws from

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 95 -- pitch of shoot sound

SWEP.ShootSound = "weapons/tfa_mmod/357/357_fire1.wav"
SWEP.DistantShootSound = "weapons/tfa_mmod/357/357_fire2.wav"

SWEP.MuzzleEffect = "muzzleflash_pistol_deagle"

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 0 -- which attachment to put the case effect on

SWEP.RevolverReload = true

SWEP.SightTime = 0.28

SWEP.SpeedMult = 0.975
SWEP.SightedSpeedMult = 0.75

SWEP.BarrelLength = 18

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false


SWEP.IronSightStruct = {
    Pos = Vector(-3.16, 0, 1.2),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER

SWEP.ActivePos = Vector(1, 4, -1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(10, 3, -5)

SWEP.HolsterPos = Vector(2.96, -9.849, -14.16)
SWEP.HolsterAng = Angle(51, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 10

SWEP.Animations = {
    ["idle"] = {
        Source = "idle01",
        Time = 5,
    },
    ["idle_sight"] = {
        Source = "idle01",
        Time = 0
    },
    ["draw"] = {
        Source = "draw",
        Time = 0.75,
        SoundTable = {
            {
            s = "weapons/tfa_mmod/357/357_deploy.wav",
            t = 0
            }
        }
    },
    ["holster"] = {
        Source = "holster",
        Time = 1,
    },
    ["fire"] = {
        Source = "fire",
        Time = 0.75,
    },
    ["fire_iron"] = {
        Source = "fire_is",
        Time = 0.5,
    },
    ["reload"] = {
        Source = "reload",
        Time = 3,
        TPAnim = ACT_GESTURE_RELOAD_PISTOL,
        TPAnimStartTime = 0,
        SoundTable = {
            {s = "weapons/tfa_mmod/357/357_reload1.wav", t = 0.2},
            {s = "weapons/tfa_mmod/357/357_reload2.wav", t = 1},
            {s = "weapons/tfa_mmod/357/357_reload3.wav", t = 2},
            {s = "weapons/tfa_mmod/357/357_reload4.wav", t = 2.5}
            },
    },
    ["enter_sprint"] = {
        Source = "idle01_is",
        Time = 0
    },
    ["exit_sprint"] = {
        Source = "idle01_is",
        Time = 0
    },
    ["idle_sprint"] = {
        Source = "idle01_is",
        Time = 1
    },
}
