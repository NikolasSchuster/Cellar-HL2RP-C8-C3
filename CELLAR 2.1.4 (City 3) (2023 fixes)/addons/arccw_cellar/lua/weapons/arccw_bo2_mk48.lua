SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Black Ops II" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Mk 48 Mod 1"
SWEP.Trivia_Class = "Light Machine Gun"
SWEP.Trivia_Desc = "Belgian light machine gun. Scaled up version of the Mk 46 Mod 0 and fires the more powerful 7.62x51mm NATO. In use by US Naval Forces, USSOCOM and Indian Special Forces."
SWEP.Trivia_Manufacturer = "FN Herstal"
SWEP.Trivia_Calibre = "7.62x51mm NATO"
SWEP.Trivia_Mechanism = "Short-stroke gas piston"
SWEP.Trivia_Country = "Belgium"
SWEP.Trivia_Year = 2003

SWEP.Slot = 3

SWEP.ViewModel = "models/weapons/arccw/c_bo2_mk48.mdl"
SWEP.WorldModel = "models/weapons/arccw/w_bo2_mk48.mdl"
SWEP.MirrorWorldModel = "models/weapons/arccw/w_bo2_mk48.mdl"
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-8, 4.75, -8.25),
    ang        =    Angle(-5, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale   =   0.9
}
SWEP.ViewModelFOV = 60

SWEP.Damage = 40
SWEP.DamageMin = 30 -- damage done at maximum range
SWEP.Range = 150 -- in METRES
SWEP.RangeMin = 50
SWEP.BloodDamage = 555
SWEP.ShockDamage = 555
SWEP.BleedChance = 80
SWEP.AmmoItem = "bullets_7x62"

SWEP.Penetration = 15
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 735 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 4

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 100 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 250
SWEP.ReducedClipSize = 75

SWEP.Recoil = 0.75
SWEP.RecoilSide = 0.6
SWEP.RecoilRise = 1
SWEP.VisualRecoilMult = 0.25

SWEP.Delay = 60 / 710-- 60 / RPM.
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

SWEP.AccuracyMOA = 3 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 700 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 250

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "mk48" -- the magazine pool this gun draws from

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "ArcCW_BO2.Mk48_Fire"
SWEP.ShootSoundSilenced = "ArcCW_BO2.LSAT_Sil"
SWEP.DistantShootSound = {
    "^weapons/arccw/bo2_generic_lmg/dist/l.wav",
    "^weapons/arccw/bo2_generic_lmg/dist/r.wav"
}

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/shells/shell_762nato.mdl"
SWEP.ShellScale = 0.75
SWEP.ShellMaterial = "models/weapons/arcticcw/shell_556"

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 4

SWEP.SpeedMult = 0.7
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.75

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
     [1] = "j_bullet1",
     [2] = "j_bullet2",
     [3] = "j_bullet3",
     [4] = "j_bullet4",
     [5] = "j_bullet5",
     [6] = "j_bullet6",
     [7] = "j_bullet7",
     [8] = "j_bullet8",
     [9] = "j_bullet9",
     [10] = "j_bullet10",
     [11] = "j_bullet11",
     [12] = "j_bullet12",
     [13] = "j_bullet13",
     [14] = "j_bullet14",
     [15] = "j_bullet15",
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-3.735, 0, 1),
    Ang = Angle(0, 0.02, 0),
    Magnification = 1.1,
    CrosshairInSights = false,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 1, 0.5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.InBipodPos = Vector(-6, 0, -2)

SWEP.SprintPos = Vector(0, 0, 0.5)
SWEP.SprintAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(16, 3, -2)
SWEP.CustomizeAng = Angle(15, 40, 20)

SWEP.HolsterPos = Vector(3, 0, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 30

SWEP.ExtraSightDist = 5

--SWEP.DefaultPoseParams = {["idle"] = 0.5}

SWEP.AttachmentElements = {}

SWEP.Attachments = {}

SWEP.Hook_TranslateAnimation = function(wep, anim)
end

SWEP.RejectAttachments = {}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 1 / 30,
    },
    ["draw"] = {
        Source = "draw",
        Time = 35 / 30,
    },
    ["holster"] = {
        Source = "holster",
        Time = 24 / 30,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.2,
    },
    ["ready"] = {
        Source = "first_draw",
        Time = 2.2,
        SoundTable = {
            {s = "ArcCW_BO2.LMG_Back", t = 10 / 35},
            {s = "ArcCW_BO2.LMG_Fwd", t = 20 / 35},
        },
    },
    ["fire"] = {
        Source = {"fire"},
        Time = 7 / 30,
        ShellEjectAt = 0,
        SoundTable = {
            { s = "ArcCW_BO1.Mk48_Mech", t = 0 },
            { s = "ArcCW_BO1.Mk48_LFE", t = 0.1 },
        }
    },
    ["fire_iron"] = {
        Source = {"fire_ads"},
        Time = 7 / 30,
        ShellEjectAt = 0,
        SoundTable = {
            { s = "ArcCW_BO1.Mk48_Mech", t = 0 },
            { s = "ArcCW_BO1.Mk48_LFE", t = 0.1 },
        }
    },
    ["reload"] = {
        Source = "reload",
        Time = 281 / 35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Framerate = 37,
        Checkpoints = {28, 38, 69},
        LHIK = true,
        LHIKIn = nil,
        LHIKOut = 1,
        LastClip1OutTime = 75 / 35,
        SoundTable = {
            {s = "ArcCW_BO2.LMG_Open", t = 20 / 35},
            {s = "ArcCW_BO2.LMG_BoxOff", t = 50 / 35},
            {s = "ArcCW_BO2.LMG_BoxOn", t = 130 / 35},
            {s = "ArcCW_BO2.LMG_BeltPull", t = 160 / 35},
            {s = "ArcCW_BO2.LMG_BeltPlace", t = 175 / 35},
            {s = "ArcCW_BO2.LMG_Close", t = 185 / 35},
            {s = "ArcCW_BO2.LMG_LidClose", t = 190 / 35},
            {s = "ArcCW_BO2.LMG_Back", t = 210 / 35},
            {s = "ArcCW_BO2.LMG_Fwd", t = 220 / 35},
        },
    },
    ["reload_optic"] = {
        Source = "reload_optic",
        Time = 281 / 35,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Framerate = 37,
        Checkpoints = {28, 38, 69},
        LHIK = true,
        LHIKIn = nil,
        LHIKOut = 1,
        LastClip1OutTime = 75 / 35,
        SoundTable = {
            {s = "ArcCW_BO2.LMG_Open", t = 20 / 35},
            {s = "ArcCW_BO2.LMG_BoxOff", t = 50 / 35},
            {s = "ArcCW_BO2.LMG_BoxOn", t = 130 / 35},
            {s = "ArcCW_BO2.LMG_BeltPull", t = 160 / 35},
            {s = "ArcCW_BO2.LMG_BeltPlace", t = 175 / 35},
            {s = "ArcCW_BO2.LMG_Close", t = 185 / 35},
            {s = "ArcCW_BO2.LMG_LidClose", t = 190 / 35},
            {s = "ArcCW_BO2.LMG_Back", t = 210 / 35},
            {s = "ArcCW_BO2.LMG_Fwd", t = 220 / 35},
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