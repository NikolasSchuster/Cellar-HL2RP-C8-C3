SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR"
SWEP.AdminOnly = false

SWEP.PrintName = "Dragunov SVD-63"
SWEP.Trivia_Class = "Designated Marskman Rifle"
SWEP.Trivia_Desc = "Soviet semi-automatic sniper rifle aesthetically similar to the AK-47 built for designated marksmen. Also produced by the chinese gun manufacturer Norinco for the Chinese Army."
SWEP.Trivia_Manufacturer = "Kalashnikov Concern"
SWEP.Trivia_Calibre = "7.62x54mmR"
SWEP.Trivia_Mechanism = "Gas Operated, Rotating Bolt"
SWEP.Trivia_Country = "U.S.S.R."
SWEP.Trivia_Year = 1963

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/c_bo1_svd.mdl"
SWEP.WorldModel = "models/weapons/arccw/c_bo1_svd.mdl"
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    scale = 1.035,
    pos        =    Vector(-4.25, 4, -6.5),
    ang        =    Angle(-6, -1.25, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00111000000"

SWEP.Damage = 80
SWEP.DamageMin = 70 -- damage done at maximum range
SWEP.Range = 400 -- in METRES
SWEP.RangeMin = 40
SWEP.BloodDamage = 300
SWEP.ShockDamage = 500
SWEP.BleedChance = 80
SWEP.AmmoItem = "bullets_7x6254mmr"

SWEP.Penetration = 15
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 830 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 10 -- DefaultClip is automatically set.

SWEP.Recoil = 1.4
SWEP.RecoilSide = 0.75
SWEP.RecoilRise = 1

SWEP.SpeedMult = 0.85
SWEP.SightedSpeedMult = 0.35
SWEP.SightTime = 0.42

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 200

SWEP.AccuracyMOA = 1 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 800 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 50

SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.MagID = "svd" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "ArcCW_BO1.SVD_Fire"
SWEP.ShootSoundSilenced = "ArcCW_BO2.Ballista_Sil"
SWEP.DistantShootSound = {"^weapons/arccw/bo2_generic_sniper/dist/flux_l.wav", "^weapons/arccw/bo2_generic_sniper/dist/flux_r.wav"}

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 95
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
    Pos = Vector(-3.525, -4, 1.56),
    Ang = Angle(0, 0.05, 0),
    Magnification = 1.1,
    CrosshairInSights = false,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 2, 1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(0, 2, 1)
SWEP.SprintAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(15, 3, 0)
SWEP.CustomizeAng = Angle(15, 40, 22.5)

SWEP.HolsterPos = Vector(3, -3, 1)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
    ["rail"] = {
        VMBodygroups = {
            {ind = 2, bg = 1},
            {ind = 3, bg = 1},
        },
    },
}

SWEP.ExtraSightDist = 3

SWEP.RejectAttachments = {}

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic_sniper", "optic"}, -- what kind of attachments can fit here, can be string or table
        Bone = "tag_weapon", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(4, 0, 3.8),
            vang = Angle(0, 0, 0),
        },
        InstalledEles = "rail",
        MergeSlots = {2, 11, 12},
    },
    {
        Slot = "bo1_pso",
        Bone = "tag_weapon", -- relevant bone any attachments will be mostly referring to
        VMScale = Vector (1, 1, 1),
        Offset = {
            vpos = Vector(3, 0, 3.05),
            vang = Angle(0, 0, 0),
        },
        GivesFlags = {"cobrakai"},
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0),
        Installed = "optic_bo1_pso",
    },
}
SWEP.Animations = {
    ["idle"] = false,
    --[[{
        Source = "idle",
        Time = 1 / 35,
    },]]
    ["draw"] = {
        Source = "draw",
        Time = 56 / 35,
    },
    ["ready"] = {
        Source = "first_draw",
        Time = 70 / 35,
        SoundTable = {
            {s = "ArcCW_BO1.SVD_Back", t = 0.1},
            {s = "ArcCW_BO1.SVD_Fwd", t = 0.75},
        },
    },
    ["fire"] = {
        Source = {"fire"},
        Time = 13 / 35,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_ads",
        Time = 13 / 35,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 114 / 35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {33, 55},
        FrameRate = 30,
        SoundTable = {
            {s = "ArcCW_BO1.SVD_ClipOut", t = 0.2},
            {s = "ArcCW_BO1.SVD_ClipIn", t = 1.75},
        },
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 142 / 35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {33, 55, 88},
        FrameRate = 30,
        SoundTable = {
            {s = "ArcCW_BO1.SVD_ClipOut", t = 0.2},
            {s = "ArcCW_BO1.SVD_ClipIn", t = 1.75},
            {s = "ArcCW_BO1.SVD_Back", t = 2.25},
            {s = "ArcCW_BO1.SVD_Fwd", t = 2.5},
        },
    },
    ["reload_ext"] = {
        Source = "reload_ext",
        Time = 114 / 35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {33, 55},
        FrameRate = 30,
        SoundTable = {
            {s = "ArcCW_BO1.SVD_ClipOut", t = 0.2},
            {s = "ArcCW_BO1.SVD_ClipIn", t = 1.75},
        },
    },
    ["reload_empty_ext"] = {
        Source = "reload_empty_ext",
        Time = 142 / 35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {33, 55, 88},
        FrameRate = 30,
        SoundTable = {
            {s = "ArcCW_BO1.SVD_ClipOut", t = 0.2},
            {s = "ArcCW_BO1.SVD_ClipIn", t = 1.75},
            {s = "ArcCW_BO1.SVD_Back", t = 2.25},
            {s = "ArcCW_BO1.SVD_Fwd", t = 2.5},
        },
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
}