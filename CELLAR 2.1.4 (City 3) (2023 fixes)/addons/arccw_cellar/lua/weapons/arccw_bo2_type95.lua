SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Black Ops II" -- edit this if you like
SWEP.AdminOnly = false


-- This one is so yall are aware.
SWEP.PrintName = "QBZ-95-1"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = [[
    Chinese bullpup rifle standard for the People's Liberation Army.
]]
SWEP.Trivia_Manufacturer = "Norinco"
SWEP.Trivia_Calibre = "5.8x42mm DBP10"
SWEP.Trivia_Mechanism = "Gas-Operated"
SWEP.Trivia_Country = "China"
SWEP.Trivia_Year = 1995

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/c_bo2_type95.mdl"
SWEP.WorldModel = "models/weapons/arccw/w_bo2_type95.mdl"
SWEP.MirrorWorldModel = "models/weapons/arccw/w_bo2_type95.mdl"
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-7, 3.5, -6.5),
    ang        =    Angle(-7, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale = 1.05
}
SWEP.ViewModelFOV = 60

SWEP.Damage = 40
SWEP.DamageMin = 20 -- damage done at maximum range
SWEP.Range = 125 -- in METRES
SWEP.RangeMin = 38
SWEP.BloodDamage = 300
SWEP.ShockDamage = 350
SWEP.BleedChance = 50
SWEP.AmmoItem = "bullets_58x42"

SWEP.Penetration = 9
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 930 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 45
SWEP.ReducedClipSize = 20

SWEP.Recoil = 0.5
SWEP.RecoilSide = 0.35
SWEP.RecoilRise = 0.5
SWEP.SpeedMult = 0.95
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.3
SWEP.VisualRecoilMult = 0.25

SWEP.Delay = 60 / 650 -- 60 / RPM.
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

SWEP.NPCWeaponType = {
    "weapon_smg1",
    "weapon_ar2",
}
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 1.6 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 600 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.MagID = "hk416" -- the magazine pool this gun draws from

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "ArcCW_BO2.Type95_Fire"
SWEP.ShootSoundSilenced = "ArcCW_BO2.M27_Sil"
SWEP.DistantShootSound = {
    "^weapons/arccw/bo2_generic_ar/dist/0.wav",
    "^weapons/arccw/bo2_generic_ar/dist/1.wav",
    "^weapons/arccw/bo2_generic_ar/dist/2.wav",
    "^weapons/arccw/bo2_generic_ar/dist/3.wav"
}

SWEP.MuzzleEffect = "muzzleflash_4"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 4

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-2.535, 3, 0.775),
    Ang = Angle(0.2, 0.025, 0),
    Magnification = 1.25,
    CrosshairInSights = false,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(1, 3, 0.5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(0, 3, 0)
SWEP.SprintAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(15, 3, -2)
SWEP.CustomizeAng = Angle(15, 40, 20)

SWEP.HolsterPos = Vector(3, 0, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 30

SWEP.ExtraSightDist = 5

SWEP.DefaultBodygroups = "0000000"
SWEP.DefaultWMBodygroups = "0000000"

SWEP.AttachmentElements = { }

SWEP.Attachments = { }

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 1 / 30,
    },
    ["idle_empty"] = {
        Source = "idle_empty",
        Time = 1 / 30,
    },
    ["draw"] = {
        Source = "draw",
        Time = 1,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.25,
    },
    ["holster"] = {
        Source = "holster",
        Time = 0.75,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.25,
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        Time = 1,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.25,
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 0.75,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.25,
    },
    ["ready"] = {
        Source = "first_draw",
        Time = 1,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
        SoundTable = {
            {s = "ArcCW_BO2.AR_Back", t = 0.2},
            {s = "ArcCW_BO2.AR_Fwd", t = 0.4}
        }
    },
    ["fire"] = {
        Source = {"fire"},
        Time = 5 / 30,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = {"fire_last"},
        Time = 5 / 30,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = {"fire_ads"},
        Time = 5 / 30,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = {"fire_last_ads"},
        Time = 5 / 30,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 2.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.5,
        SoundTable = {
            {s = "ArcCW_BO2.AR_MagOut", t = 0.3},
            {s = "ArcCW_BO2.AR_MagIn", t = 1.25}
        },
        MinProgress = 1.4,
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 3,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
        SoundTable = {
            {s = "ArcCW_BO2.AR_MagOut", t = 0.3},
            {s = "ArcCW_BO2.AR_MagIn", t = 1.25},
            {s = "ArcCW_BO2.AR_Back", t = 2.05},
            {s = "ArcCW_BO2.AR_Fwd", t = 2.2},
        },
        MinProgress = 2.0,
    },
    ["reload_fast"] = {
        Source = "fast",
        Time = 1.79,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        Mult = 1.25,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
        SoundTable = {
            {s = "ArcCW_BO2.AR_MagOut", t = 0.3},
            {s = "ArcCW_BO2.AR_MagIn", t = 1.1}
        },
        MinProgress = 1.4
    },
    ["reload_empty_fast"] = {
        Source = "fast_empty",
        Time = 2.3,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        Mult = 1.25,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
        SoundTable = {
            {s = "ArcCW_BO2.AR_MagOut", t = 0.3},
            {s = "ArcCW_BO2.AR_MagIn", t = 1.1},
            {s = "ArcCW_BO2.AR_Back", t = 1.8},
            {s = "ArcCW_BO2.AR_Fwd", t = 1.95},
        },
        MinProgress = 2.0,
    },
    ["enter_sprint"] = {
        Source = "sprint_in",
        Time = 10 / 30
    },
    ["idle_sprint"] = {
        Source = "sprint_loop",
        Time = 30 / 40
    },
    ["exit_sprint"] = {
        Source = "sprint_out",
        Time = 10 / 30
    },
    ["enter_sprint_empty"] = {
        Source = "sprint_in_empty",
        Time = 10 / 30
    },
    ["idle_sprint_empty"] = {
        Source = "sprint_loop_empty",
        Time = 30 / 40
    },
    ["exit_sprint_empty"] = {
        Source = "sprint_out_empty",
        Time = 10 / 30
    },

-- UBGL OUT ANIMS ---------------------------------------------------------------

    ["idle_m203"] = {
        Source = "idle_gl",
        Time = 1 / 30,
    },
    ["draw_m203"] = {
        Source = "draw_gl",
        Time = 1,
    },
    ["holster_m203"] = {
        Source = "holster_gl",
        Time = 0.75,
    },
    ["idle_m203_empty"] = {
        Source = "idle_empty_gl",
        Time = 1 / 30,
    },
    ["draw_m203_empty"] = {
        Source = "draw_empty_gl",
        Time = 1,
    },
    ["holster_m203_empty"] = {
        Source = "holster_empty_gl",
        Time = 0.75,
    },
    ["ready_m203"] = {
        Source = "first_draw_gl",
        Time = 1,
        SoundTable = {
            {s = "ArcCW_BO2.AR_Back", t = 0.2},
            {s = "ArcCW_BO2.AR_Fwd", t = 0.4}
        }
    },
    ["fire_m203"] = {
        Source = {"fire_gl"},
        Time = 5 / 30,
        ShellEjectAt = 0,
    },
    ["fire_iron_m203"] = {
        Source = {"fire_ads_gl"},
        Time = 5 / 30,
        ShellEjectAt = 0,
    },
    ["fire_empty_m203"] = {
        Source = {"fire_last_gl"},
        Time = 5 / 30,
        ShellEjectAt = 0,
    },
    ["fire_iron_m203"] = {
        Source = {"fire_last_ads_gl"},
        Time = 5 / 30,
        ShellEjectAt = 0,
    },
    ["reload_m203"] = {
        Source = "reload_gl",
        Time = 2.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = "ArcCW_BO2.AR_MagOut", t = 0.3},
            {s = "ArcCW_BO2.AR_MagIn", t = 1.25}
        },
        MinProgress = 1.4,
    },
    ["reload_empty_m203"] = {
        Source = "reload_empty_gl",
        Time = 3,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = "ArcCW_BO2.AR_MagOut", t = 0.3},
            {s = "ArcCW_BO2.AR_MagIn", t = 1.25},
            {s = "ArcCW_BO2.AR_Back", t = 2.05},
            {s = "ArcCW_BO2.AR_Fwd", t = 2.1},
        },
        MinProgress = 2.0,
    },
    ["reload_m203_fast"] = {
        Source = "fast_gl",
        Time = 2.5,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = "ArcCW_BO2.AR_MagOut", t = 0.3},
            {s = "ArcCW_BO2.AR_MagIn", t = 1.1}
        },
    },
    ["reload_empty_m203_fast"] = {
        Source = "fast_empty_gl",
        Time = 3,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = "ArcCW_BO2.AR_MagOut", t = 0.3},
            {s = "ArcCW_BO2.AR_MagIn", t = 1.1},
            {s = "ArcCW_BO2.AR_Back", t = 1.8},
            {s = "ArcCW_BO2.AR_Fwd", t = 1.95},
        },
    },
    ["enter_sprint_m203"] = {
        Source = "sprint_in_gl",
        Time = 10 / 30
    },
    ["idle_sprint_m203"] = {
        Source = "sprint_loop_gl",
        Time = 30 / 40
    },
    ["exit_sprint_m203"] = {
        Source = "sprint_out_gl",
        Time = 10 / 30
    },
    ["enter_sprint_m203_empty"] = {
        Source = "sprint_in_empty_gl",
        Time = 10 / 30
    },
    ["idle_sprint_m203_empty"] = {
        Source = "sprint_loop_empty_gl",
        Time = 30 / 40
    },
    ["exit_sprint_m203_empty"] = {
        Source = "sprint_out_empty_gl",
        Time = 10 / 30
    },

-- UBGL IN ANIMS -----------------------------------------------------------------

    ["enter_ubgl"] = {
        Source = "idle_glsetup",
        Time = 0 / 30,
    },
    ["exit_ubgl"] = {
        Source = "idle_glsetup",
        Time = 0 / 30
    },
    ["idle_glsetup"] = {
        Source = "idle_glsetup",
        Time = 1 / 30,
    },
    ["in_glsetup"] = {
        Source = "glsetup_in",
        Time = 0.5,
    },
    ["out_glsetup"] = {
        Source = "glsetup_out",
        Time = 0.5,
    },
    ["fire_glsetup"] = {
        Source = "fire_glsetup",
        Time = 0.7,
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        TPAnimStartTime = 0,
    },
    ["reload_glsetup"] = {
        Source = "reload_glsetup",
        Time = 96 / 30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        TPAnimStartTime = 0.1,
        SoundTable = {
            {s = "ArcCW_BO1.M203_40mmOut", t = 18 / 30},
            {s = "ArcCW_BO1.M203_40mmIn", t = 48 / 30},
            {s = "ArcCW_BO1.M203_Close", t = 62 / 30},
        }
    },
    ["reload_glsetup_soh"] = {
        Source = "reload_glsetup",
        Time = 96 / 60,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        TPAnimStartTime = 0.1,
        SoundTable = {
            {s = "ArcCW_BO1.M203_40mmOut", t = 18 / 60},
            {s = "ArcCW_BO1.M203_40mmIn", t = 48 / 60},
            {s = "ArcCW_BO1.M203_Close", t = 62 / 60},
        },
    },
    ["enter_sprint_glsetup"] = {
        Source = "sprint_in_glsetup",
        Time = 10 / 30
    },
    ["idle_sprint_glsetup"] = {
        Source = "sprint_loop_glsetup",
        Time = 30 / 40
    },
    ["exit_sprint_glsetup"] = {
        Source = "sprint_out_glsetup",
        Time = 10 / 30
    },
}