SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Impulse Rifle (CCA)"

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_ordinalriflearccw.mdl"
SWEP.WorldModel = "models/weapons/w_ordinalrifle.mdl"
SWEP.ViewModelFOV = 65
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(-10, 4.2, -6),
    ang = Angle(-10, 0, 180)
}

SWEP.DefaultBodygroups = "00000000000"
SWEP.ImpulseSkill = true

SWEP.Damage = 42
SWEP.DamageMin = 30
SWEP.BloodDamage = 180
SWEP.ShockDamage = 950
SWEP.BleedChance = 5


SWEP.Range = 100 -- in METRES
SWEP.Penetration = 8
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 40 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 50
SWEP.ReducedClipSize = 10
SWEP.AmmoItem = "bullets_rifle"

SWEP.PhysBulletMuzzleVelocity = 700

SWEP.Recoil = 0.3
SWEP.RecoilSide = 0.670
SWEP.RecoilRise = 0.1

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 100 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 175

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "ar2" -- the magazine pool this gun draws from

SWEP.ShootVol = 60 -- volume of shoot sound
SWEP.ShootPitch = 140 -- pitch of shoot sound

SWEP.ShootSound = "weapons/ar2/fire1.wav"
SWEP.ShootSoundSilenced = "weapons/ar2/fire1.wav"
SWEP.DistantShootSound = "weapons/ar2/fire1.wav"

SWEP.MuzzleEffect = "muzzleflash_minimi"
SWEP.ShellModel = ""
SWEP.ShellScale = 0
SWEP.ShellMaterial = ""

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 1
SWEP.SightTime = 0.2

SWEP.IronSightStruct = {
    Pos = Vector(-3.2, -1, 0.3),
    Ang = Angle(0, 0, -30),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = true
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(2,2,-0.6)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(0, -3, 1)
SWEP.CrouchAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10

SWEP.Attachments = {
    {
        PrintName = "Optic",
        Slot = "optic_lp",
        Bone = "pulserifle",
        DefaultAttName = "Iron Sights",
        Offset = {
            vpos = Vector(-0, -5, 4.25),
            vang = Angle(0, 90, 0),
        },
        VMScale = Vector(1.15, 1.15, 1.15),
        CorrectivePos = Vector(0, -10, 0),
        CorrectiveAng = Angle(0, 0, 0),
    },
    {
        PrintName = "Underbarrel",
        Slot = "foregrip",
        Bone = "pulserifle",
        Offset = {
            vpos = Vector(0, 10, -1.1),
            vang = Angle(0, -90, 0),
        },
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "pulserifle",
        Offset = {
            vpos = Vector(-0, 12, 1.2),
            vang = Angle(0, -90, 0),
        },
    },
    {
        PrintName = "Hammer",
        Slot = "ar2_hammer",
        DefaultAttName = "Standard Pulse-Action",
    },
    {
        PrintName = "Plug Type",
        Slot = "ar2_ammo",
        DefaultAttName = "Standard Plug"
    },
    {
        PrintName = "Perk",
        Slot = "perk"
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "pulserifle", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0.5, -1, 4), -- offset that the attachment will be relative to the bone
            vang = Angle(0, -90, 0),
        },
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["draw"] = {
        Source = "draw",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },
    ["fire"] = {
        Source = {"fire1","fire2"},
        Time = 0.5,
    },
    ["fire_iron"] = {
        Source = "fire3",
        Time = 0.5,
    },
    ["enter_sights"] = {
        Source = "idle",
        Time = 0,
    },
    ["idle_sights"] = {
        Source = "idle",
        Time = 0,
    },
    ["exit_sights"] = {
        Source = "idle",
        Time = 0,
    },
    ["enter_inspect"] = {
        Source = "inspect",
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    },
}