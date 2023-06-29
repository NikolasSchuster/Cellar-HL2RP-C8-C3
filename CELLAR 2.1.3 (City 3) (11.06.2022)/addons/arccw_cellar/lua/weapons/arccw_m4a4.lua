SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR" 
SWEP.AdminOnly = false

SWEP.PrintName = "M4A4"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = "A popular American assault rifle based on Eugene Stoner's AR-15 system. Well-balanced with good all-round characteristics."
SWEP.Trivia_Manufacturer = "FN USA"
SWEP.Trivia_Calibre = "5.56x45mm NATO"
SWEP.Trivia_Mechanism = "Gas-Operated"
SWEP.Trivia_Country = "USA"
SWEP.Trivia_Year = 1993

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw_go/v_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/arccw_go/v_rif_m4a1.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "010000100000"

SWEP.Damage = 45
SWEP.DamageMin = 22
SWEP.BloodDamage = 300
SWEP.ShockDamage = 350
SWEP.BleedChance = 50
SWEP.AmmoItem = "bullets_556x45"

SWEP.Range = 100 -- in METRES
SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.

SWEP.PhysBulletMuzzleVelocity = 900

SWEP.Recoil = 0.325
SWEP.RecoilSide = 0.215
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 2.5

SWEP.Delay = 60 / 725 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 4 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 400 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100

SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.MagID = "stanag" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.FirstShootSound = "arccw_go/m4a1/m4a1_03.wav"
SWEP.ShootSound = "arccw_go/m4a1/m4a1_02.wav"
SWEP.ShootSoundSilenced = "arccw_go/m4a1/m4a1_02.wav"
SWEP.DistantShootSound = "arccw_go/m4a1/m4a1-1-distant.wav"

SWEP.MeleeSwingSound = "arccw_go/m249/m249_draw.wav"
SWEP.MeleeMissSound = "weapons/iceaxe/iceaxe_swing1.wav"
SWEP.MeleeHitNPCSound = "physics/body/body_medium_break2.wav"

SWEP.MuzzleEffect = "muzzleflash_3"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1.25
SWEP.ShellRotateAngle = Angle(0, 180, 0)

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.97
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.30

SWEP.IronSightStruct = {
    Pos = Vector(-5.223, -8.573, 0.707),
    Ang = Angle(0.143, -0.267, -1.951),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(-1, 2, -1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -10)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {}

SWEP.ExtraSightDist = 10

SWEP.MirrorVMWM = true

SWEP.Attachments = {}

SWEP.WorldModelOffset = {
    pos = Vector(-11, 5.5, -5),
    ang = Angle(-10, 0, 180)
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["draw"] = {
        Source = "draw",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },
    ["ready"] = {
        Source = "ready",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },
    ["fire"] = {
        Source = {"shoot1", "shoot2", "shoot3"},
        Time = 0.5,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "idle",
        Time = 0.5,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {16, 30},
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.7,
        LHIKOut = 0.7,
        LHIKEaseOut = 0.6
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {16, 30, 55},
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.7,
        LHIKOut = 0.8,
        LHIKEaseOut = 0.6
    },
    ["reload_smallmag"] = {
        Source = "reload_smallmag",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {16, 30},
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.7,
        LHIKOut = 0.7,
        LHIKEaseOut = 0.6
    },
    ["reload_smallmag_empty"] = {
        Source = "reload_smallmag_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {16, 30, 55},
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.7,
        LHIKOut = 0.8,
        LHIKEaseOut = 0.6
    },
    ["enter_inspect"] = false,
    ["idle_inspect"] = false,
    ["exit_inspect"] = false,
}

sound.Add({
    name = "ARCCW_GO_M4A1.Draw",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/m4a1/m4a1_draw.wav"
})

sound.Add({
    name = "ARCCW_GO_M4A1.Clipout",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/m4a1/m4a1_clipout.wav"
})

sound.Add({
    name = "ARCCW_GO_M4A1.Clipin",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/m4a1/m4a1_clipin.wav"
})

sound.Add({
    name = "ARCCW_GO_M4A1.Cliphit",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/m4a1/m4a1_cliphit.wav"
})

sound.Add({
    name = "ARCCW_GO_M4A1.Boltforward",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/m4a1/m4a1_boltforward.wav"
})

sound.Add({
    name = "ARCCW_GO_M4A1.Boltback",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/m4a1/m4a1_boltback.wav"
})