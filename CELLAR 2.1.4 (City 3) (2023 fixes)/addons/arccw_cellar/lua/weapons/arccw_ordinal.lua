SWEP.Base = "arccw_base"

SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Suppressor LMG"

SWEP.Slot = 2


SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_suppressor.mdl"
SWEP.WorldModel = "models/weapons/w_suppressor.mdl"
SWEP.ViewModelFOV = 60
SWEP.DefaultBodygroups = "0000000"
SWEP.ImpulseSkill = true

SWEP.Damage = 30
SWEP.BloodDamage = 380
SWEP.ShockDamage = 1000
SWEP.BleedChance = 5
SWEP.DamageMin = 12.5 -- damage done at maximum range
SWEP.Range = 50 -- in METRES
SWEP.Penetration = 22
SWEP.DamageType = DMG_AIRBOAT
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1800 -- projectile or phys bullet muzzle velocity
SWEP.AmmoItem = "bullets_ordinal"
-- IN M/S

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 6

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 150 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 200
SWEP.ReducedClipSize = 75


SWEP.Recoil = 0.8
SWEP.RecoilSide = 0.75
SWEP.RecoilRise = 1

SWEP.Delay = 60 / 700 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2
    },
    {
        Mode = 0
    }
}

SWEP.NotForNPCS = true
SWEP.NPCWeaponType = {"weapon_shotgun"}
SWEP.NPCWeight = 50

SWEP.AccuracyMOA = 60 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 200

SWEP.ShootWhileSprint = false

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "Pulse LMG" -- the magazine pool this gun draws from
SWEP.ShootVol = 120 -- volume of shoot sound
SWEP.ShootPitch = 90 -- pitch of shoot sound

SWEP.ShootSound = "fire2.wav"
SWEP.ShootSoundSilenced = "weapons/arccw/m4a1/m4a1_silencer_01.wav"
SWEP.DistantShootSound = "weapons/arccw/ak47/ak47-1-distant.wav"

SWEP.MuzzleEffect = "muzzleflash_minimi"
SWEP.ShellModel = ""
SWEP.ShellScale = 0
SWEP.ShellMaterial = ""

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.65
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.33
SWEP.VisualRecoilMult = 1
SWEP.RecoilRise = 1

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-4, -4, 0),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "ar2"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 3, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 34


SWEP.AttachmentElements = {
    ["extendedmag"] = {
        VMBodygroups = {{ind = 1, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["reducedmag"] = {
        VMBodygroups = {{ind = 1, bg = 2}},
        WMBodygroups = {{ind = 1, bg = 2}},
    },
    ["nors"] = {
        VMBodygroups = {
            {ind = 2, bg = 1},
            {ind = 3, bg = 1},
        },
    },
    ["nobrake"] = {
        VMBodygroups = {
            {ind = 6, bg = 1},
        },
    },
    ["pwraith"] = {
        VMBodygroups = {},
        WMBodygroups = {},
        TrueNameChange = "Suppressor LMG",
        NameChange = "Hell's Wraith"
    },
    ["mount"] = {
        VMElements = {
        },
    }
}

SWEP.ExtraSightDist = 5

SWEP.Attachments = {
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "suppressor",
        Offset = {
            vpos = Vector(-1.5, -20, 0),
            vang = Angle(0, 80, 90),
            wpos = Vector(0, 0, 0),
            wang = Angle(0, 0, 0)
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"ubgl", "bipod"},
        Bone = "suppressor",
        Offset = {
            vpos = Vector(-4, -10, 1),
            vang = Angle(0, 80, 90),
            wpos = Vector(0, 0, 0),
            wang = Angle(0, 0, 0)
        },
    },
    {
        PrintName = "Ammo Type",
        Slot = "ammo_bullet"
    },
    {
        PrintName = "Perk",
        Slot = "perk"
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 1
    },
    ["draw"] = {
        Source = "draw",
        Time = 1,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["holster"] = {
        Source = "holster",
        Time = 0.4,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["ready"] = {
        Source = "idle",
        Time = 1,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["fire"] = {
        Source = {"fire"},
        Time = 0.5,
    },
    ["fire_iron"] = {
        Source = "fire",
        Time = 0.5,
    },
    ["reload"] = {
        Source = "reload",
        Time = 4,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Framerate = 37,
        Checkpoints = {28, 38, 69},
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.5,
    },
    ["reload_empty"] = {
        Source = "reload",
        Time = 4,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Framerate = 37,
        Checkpoints = {28, 38, 69},
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.5,
    },
}

local soundData = {
    name                = "Weapon_Swing" ,
    channel     = CHAN_WEAPON,
    volume              = 0.5,
    soundlevel  = 80,
    pitchstart  = 100,
    pitchend    = 100,
    sound               = "draw_minigun_heavy.wav"
}
sound.Add(soundData)

local soundData = {
    name                = "Weapon_Swing2" ,
    channel     = CHAN_WEAPON,
    volume              = 0.5,
    soundlevel  = 80,
    pitchstart  = 100,
    pitchend    = 100,
    sound               = "draw_default.wav"
}
sound.Add(soundData)

local soundData = {
    name                = "Magazine.Out" ,
    channel     = CHAN_WEAPON,
    volume              = 0.5,
    soundlevel  = 80,
    pitchstart  = 100,
    pitchend    = 100,
    sound               = "sniper_military_slideback_1.wav"
}
sound.Add(soundData)

local soundData = {
    name                = "Magazine.In" ,
    channel     = CHAN_WEAPON,
    volume              = 0.5,
    soundlevel  = 80,
    pitchstart  = 100,
    pitchend    = 100,
    sound               = "sniper_military_slideforward_1.wav"
}
sound.Add(soundData)