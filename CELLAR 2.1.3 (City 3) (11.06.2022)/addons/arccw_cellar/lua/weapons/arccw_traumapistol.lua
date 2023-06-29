SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR"
SWEP.AdminOnly = false
-- This is a "fake name". While it is optional, you are encouraged to be creative.
SWEP.PrintName = "Травматический пистолет" 

-- This starts from 0. When set to 1, it will actually appear in slot 2.
SWEP.Slot = 1

-- This should be obvious.
SWEP.ViewModel = "models/weapons/bordelzio/arccw/hkvp70/c_hk_vp70.mdl"
SWEP.WorldModel = "models/weapons/bordelzio/arccw/hkvp70/wmodel/w_hk_vp70.mdl"
SWEP.ViewModelFOV = 57

SWEP.Damage = 1
SWEP.DamageMin = 1
SWEP.BloodDamage = 1
SWEP.ShockDamage = 1500
SWEP.BleedChance = 0

SWEP.AmmoItem = "bullets_trauma"
SWEP.Damage = 1 -- damage done at point blank

SWEP.Range = 65 -- in METRES
SWEP.Penetration = 0

SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 350 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 18 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 24
SWEP.ReducedClipSize = 12

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "Weapon_HKVP70.Fire"
SWEP.ShootSoundSilenced = "Weapon_HKVP70.FireSilenced"
SWEP.DistantShootSound = "Weapon_HKVP70.Fire"

SWEP.SightTime = 0.175

SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1

SWEP.Recoil = 0.5
SWEP.RecoilSide = 0.3
SWEP.RecoilRise = 2

-- These can be omitted to use default values
SWEP.MaxRecoilBlowback = -1
SWEP.VisualRecoilMult = 1.25
SWEP.RecoilPunch = 1.5

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = -3,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol" -- What NPC weapons will be replaced with this. Can be a table.
SWEP.NPCWeight = 80

SWEP.AccuracyMOA = 13 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 200 -- inaccuracy added by moving around.

SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses
SWEP.MagID = "sviinfinity" -- not used, but set it anyways

-- A number from 0 to 1
SWEP.SpeedMult = 0.90
SWEP.SightedSpeedMult = 0.5 -- Set this low for snipers! It is on top of speedmult

-- Barrel length determines how close to a wall will block your gun
SWEP.BarrelLength = 15
-- Used for optics, adjust as needed
SWEP.ExtraSightDist = 10


SWEP.Animations = {
	["idle"] = {
	Source = "idle",
	Time = 1,
    },
    ["draw"] = {
        Source = "draw",
        Time = 0.4,
        LHIK = true,
        LHIKIn = 1,
        LHIKOut = 1,
    },
    ["ready"] = {
        Source = "first_draw",
        Time = 1,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
	},
    ["bash"] = {
        Source = "melee",
        Time = 0.5,
	},
    ["fire"] = {
        Source = "fire",
        Time = 0.5,
        ShellEjectAt = 0,
	},
    ["fire_iron"] = {
        Source = "iron_fire",
        Time = 8 / 30,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 2.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Framerate = 37,
        Checkpoints = {28, 38, 69},
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.5,
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 2.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Framerate = 37,
        Checkpoints = {28, 38, 69},
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.5,
    },
}

SWEP.IronSightStruct = {
    Pos = Vector(-4.20, 0, 0.56),
    Ang = Angle(1, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.ActivePos = Vector(0, -2, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(0, -10, -2)
SWEP.SprintAng = Angle(20, 0, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.Attachments = {}