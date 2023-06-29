SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "SMG1"

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/cellar/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/cellar/weapons/w_smg1.mdl"
SWEP.ViewModelFOV = 75

SWEP.DefaultBodygroups = "000000"

SWEP.Damage = 42
SWEP.DamageMin = 20
SWEP.BloodDamage = 200
SWEP.ShockDamage = 700
SWEP.BleedChance = 50

SWEP.AmmoItem = "bullets_smg"
SWEP.Primary.Ammo = "AR2" -- what ammo type the gun uses

SWEP.Range = 50
SWEP.Penetration = 8
SWEP.DamageType = DMG_BULLET

SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 900

SWEP.TracerNum = 1
SWEP.TracerCol = Color(21, 37, 64)
SWEP.TracerWidth = 10

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 45 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 60
SWEP.ReducedClipSize = 15

SWEP.Recoil = 0.8
SWEP.RecoilSide = 0.75
SWEP.RecoilRise = 1.35
SWEP.VisualRecoilMult = 1

SWEP.Delay = 60 / 800 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
}

SWEP.AccuracyMOA = 5
SWEP.SightsDispersion = 25
SWEP.HipDispersion = 300
SWEP.MoveDispersion = 200

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.FirstShootSound = Sound("Weapon_SMG1.Single")
SWEP.ShootSound = Sound("Weapon_SMG1.Single")
SWEP.DistantShootSound = Sound("Weapon_SMG1.Single")

SWEP.MuzzleEffect = "muzzleflash_m14"
SWEP.ShellModel = "models/weapons/shell.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.96
SWEP.SightedSpeedMult = 0.70
SWEP.SightTime = 0.3

SWEP.BulletBones = {}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-4.7, -6, 1.8),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "weapons/tnweapons/osipr/sightlower1.wav", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "smg"
SWEP.HoldtypeSights = "smg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(-2.5, -7, 2)
SWEP.ActiveAng = Angle(-2, -1, 0)

SWEP.HolsterPos = Vector(-2, -7, 2)
SWEP.HolsterAng = Angle(-2, -1, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 27

SWEP.ExtraSightDist = 5

SWEP.Animations = {
    ["idle"] = {
        Source = "idle01",
        Time = 0
    },
    ["idle_sight"] = {
        Source = "idle01",
        Time = 0
    },
    ["draw"] = {
        Source = "draw",
        Time = 1,
        SoundTable = {{s = "weapons/smg1/smg1_deploy.wav", t = 0.01}},
    },
    ["holster"] = {
        Source = "holster",
        Time = 1,
    },
    ["ready"] = {
        Source = "draw",
        Time = 1,
		SoundTable = {{s = "weapons/smg1/smg1_deploy.wav", t = 0.01}},
    },
    ["fire"] = {
        Source = {"fire01", "fire02", "fire03", "fire04"},
        Time = 1,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = {"fire1_is", "fire2_is", "fire3_is"},
        Time = 1,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 2,
        TPAnim = ACT_GESTURE_RELOAD_SMG1,
		TPAnimStartTime = 0,
        SoundTable = {
            {s = "weapons/smg1/smg1_clipout.wav", t = 0.25},
            {s = "weapons/smg1/smg1_clipin.wav", t = 0.8},
			{s = "weapons/smg1/smg1_boltforward.wav", t = 1.1}
        },
    },
    ["reload_empty"] = {
        Source = "reload",
        Time = 2,
        TPAnim = ACT_GESTURE_RELOAD_SMG1,
		TPAnimStartTime = 0,
        SoundTable = {
            {s = "weapons/smg1/smg1_clipout.wav", t = 0.25},
            {s = "weapons/smg1/smg1_clipin.wav", t = 0.8},
			{s = "weapons/smg1/smg1_boltforward.wav", t = 1.1}
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
        Source = "sprint",
        Time = 1
    },
}
