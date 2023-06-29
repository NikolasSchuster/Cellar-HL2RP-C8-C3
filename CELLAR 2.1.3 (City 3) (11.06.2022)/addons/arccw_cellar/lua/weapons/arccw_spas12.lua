SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "CELLAR"
SWEP.AdminOnly = false

SWEP.PrintName = "SPAS-12"

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/cellar/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/cellar/weapons/w_shotgun.mdl"
SWEP.ViewModelFOV = 75

SWEP.Damage = 35
SWEP.DamageMin = 10
SWEP.BloodDamage = 1500 / 8
SWEP.ShockDamage = 5000 / 8
SWEP.BleedChance = 99
SWEP.IsBuckshot = true

SWEP.Range = 25
SWEP.Penetration = 1
SWEP.DamageType = DMG_BUCKSHOT

SWEP.AmmoItem = "bullets_buckshot"
SWEP.Primary.Ammo = "buckshot"

SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 150

SWEP.TracerNum = 1
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 6
SWEP.ExtendedClipSize = 8
SWEP.ReducedClipSize = 4

SWEP.Recoil = 10
SWEP.RecoilSide = 3
SWEP.MaxRecoilBlowback = 2
SWEP.RecoilPunch = 0.5

SWEP.ShotgunReload = true
SWEP.ManualAction = true

SWEP.Delay = 60 / 80
SWEP.Num = 8
SWEP.RunawayBurst = false
SWEP.Firemodes = {
    {
        PrintName = "PUMP",
        Mode = 1,
    },
}

SWEP.AccuracyMOA = 80
SWEP.SightsDispersion = 100
SWEP.HipDispersion = 200
SWEP.MoveDispersion = 75

SWEP.ShootVol = 120
SWEP.ShootPitch = 100

SWEP.ShootSound = Sound("Weapon_Shotgun.Single")
SWEP.DistantShootSound = Sound("Weapon_Shotgun.Single")

SWEP.MuzzleEffect = "muzzleflash_shotgun"
SWEP.ShellModel = "models/shells/shell_12gauge.mdl"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.ShotgunShellSoundsTable
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.95
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.27

SWEP.BulletBones = {}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-4.85, -5, 2.05),
    Ang = Angle(-0.2, 0.1, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "ar2"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.ActivePos = Vector(-2.5, -6, 1)
SWEP.ActiveAng = Angle(0, 1, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 5

SWEP.Attachments = {}

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
        Time = 1,
    },
    ["fire"] = {
        Source = "fire01",
        Time = 0.5,
    },
    ["fire_iron"] = {
        Source = "fire_ironsights",
        Time = 1,
        ShellEjectAt = 0,
    },
    ["cycle"] = {
        Source = "pump",
        Time = 0.75,
        ShellEjectAt = 0.3,
		SoundTable = {
			{s = "weapons/shotgun/shotgun_cock_back.wav", t = 0},
			{s = "weapons/shotgun/shotgun_cock_forward.wav", t = 0.3},
			},
    },
    ["cycle_iron"] = {
        Source = "pump2_sighted",
        Time = 0.75,
        ShellEjectAt = 0.3,
		SoundTable = {
			{s = "weapons/shotgun/shotgun_cock_back.wav", t = 0},
			{s = "weapons/shotgun/shotgun_cock_forward.wav", t = 0.3},
			},
    },
    ["sgreload_start"] = {
        Source = "reload1",
        Time = 0.25,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        SoundTable = {
            {s = "weapons/tfa_ins2/m590/m590_shell.wav", t = 0.35},
        },
    },
    ["sgreload_insert"] = {
        Source = "reload2",
        Time = 0.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        TPAnimStartTime = 0.3,
        SoundTable = {
            {s = "weapons/tfa_ins2/m590/m590_shell.wav", t = 0.35},
        },
    },
    ["sgreload_finish"] = {
        Source = "reload3",
        Time = 0.5,
    },
    ["sgreload_start_empty"] = {
        Source = "reload1",
        Time = 0.25,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        SoundTable = {
            {s = "weapons/tfa_ins2/m590/m590_shell.wav", t = 0.35},
        },
    },
    ["sgreload_insert_empty"] = {
        Source = "reload2",
        Time = 0.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        TPAnimStartTime = 0.3,
        SoundTable = {
            {s = "weapons/tfa_ins2/m590/m590_shell.wav", t = 0.35},
        },
    },
    ["sgreload_finish_empty"] = {
        Source = "reload3",
        Time = 0.5,
    }
}