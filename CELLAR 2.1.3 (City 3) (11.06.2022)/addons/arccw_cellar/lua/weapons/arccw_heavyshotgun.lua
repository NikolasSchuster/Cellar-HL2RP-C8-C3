SWEP.Base = "arccw_base"

SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Heavy Shotgun"

SWEP.Slot = 2


SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_heavyshotgun.mdl"
SWEP.WorldModel = "models/weapons/w_heavyshotgun.mdl"
SWEP.ViewModelFOV = 60
SWEP.DefaultBodygroups = "0000000"
SWEP.ImpulseSkill = true

SWEP.Damage = 40
SWEP.DamageMin = 10
SWEP.BloodDamage = 2200 / 8
SWEP.ShockDamage = 6100 / 8
SWEP.BleedChance = 5
SWEP.IsBuckshot = true
SWEP.Range = 10
SWEP.AmmoItem = "bullets_heavyshotgun"

SWEP.Penetration = 2
SWEP.DamageType = DMG_BUCKSHOT
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 150 -- projectile or phys bullet muzzle velocity

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 6

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 12 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 20
SWEP.ReducedClipSize = 5


SWEP.Recoil = 8
SWEP.RecoilSide = 1
SWEP.RecoilRise = 2

SWEP.Delay = 60 / 200 -- 60 / RPM.
SWEP.Num = 5 -- number of shots per trigger pull.
SWEP.RunawayBurst = false
SWEP.Firemodes = {
    {
        Mode = 1
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

SWEP.Primary.Ammo = "buckshot" -- what ammo type the gun uses
SWEP.MagID = "HShotgun" -- the magazine pool this gun draws from
SWEP.ShootVol = 200 -- volume of shoot sound
SWEP.ShootPitch = 90 -- pitch of shoot sound

SWEP.ShootSound = "shotgun_dbl_fire7.wav"
SWEP.ShootSoundSilenced = "weapons/arccw/m4a1/m4a1_silencer_01.wav"
SWEP.DistantShootSound = "weapons/arccw/ak47/ak47-1-distant.wav"

SWEP.MuzzleEffect = "muzzleflash_minimi"
SWEP.ShellModel = ""
SWEP.ShellScale = 0
SWEP.ShellMaterial = ""

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.75
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

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 20


SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 5

SWEP.Attachments = {
    {
        PrintName = "Choke",
        DefaultAttName = "Standard Choke",
        Slot = "choke",
    },
    {
        PrintName = "Ammo Type",
        Slot = "ammo_shotgun",
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
        Source = "fire1",
        Time = 0.5,
    },
    ["fire_iron"] = {
        Source = "fire1",
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
        Framerate = 30,
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

local soundData = {
    name                = "Cock" ,
    channel     = CHAN_WEAPON,
    volume              = 0.5,
    soundlevel  = 80,
    pitchstart  = 100,
    pitchend    = 100,
    sound               = "shotgun_cock.wav"
}
sound.Add(soundData)