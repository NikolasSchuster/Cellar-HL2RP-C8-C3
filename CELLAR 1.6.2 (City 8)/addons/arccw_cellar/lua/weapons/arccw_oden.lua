SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR" 
SWEP.AdminOnly = false

SWEP.PrintName = "Oden"
SWEP.TrueName = "VKL"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = "The VKL is a fictional modified version of the VSSK (ВССК) Russian bullpup, gas operated, magazine-fed assault rifle chambered for the 12.7X55mm STs-130 subsonic round. The weapon is also known by the name VSSK and the additional name Vykhlop, which comes from the development program. It was developed in around 2002 for the special force units of FSB.  																												 IN SERVICE: 2004"
SWEP.Trivia_Manufacturer = "CKIB SOO"
SWEP.Trivia_Calibre = "12.7X55mm STs-130"
SWEP.Trivia_Mechanism = "Gas-Operated"
SWEP.Trivia_Country = "Russia"
SWEP.Trivia_Year = 2002

SWEP.Slot = 3

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/cod_mw2019/c_oden_mammaledition.mdl"
SWEP.WorldModel = "models/weapons/cod_mw2019/w_oden_mammaledition.mdl"
SWEP.ViewModelFOV = 60

SWEP.Damage = 70
SWEP.DamageMin = 40 -- damage done at maximum range
SWEP.BloodDamage = 800
SWEP.ShockDamage = 1000
SWEP.BleedChance = 75
SWEP.AmmoItem = "bullets_smg"

SWEP.Range = 100 -- in METRES
SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 725 -- projectile or phys bullet muzzle velocity
-- IN M/S


SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3
SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 1 / 25, type = "sound", value = Sound("COD_MW2019_SG552.Draw")},
		{time = 8 / 25, type = "sound", value = Sound("COD_MW2019_SG552.Slideforward")}
	},
	[ACT_VM_RELOAD] = {
		{time = 21 / 30, type = "sound", value = Sound("COD_MW2019_SG552.ClipOut")},
		{time = 35 / 30, type = "sound", value = Sound("COD_MW2019_SG552.ClipIn")},
		{time = 45 / 30, type = "sound", value = Sound("COD_MW2019_SG552.ClipOn")},
		{time = 62 / 30, type = "sound", value = Sound("COD_MW2019_SG552.Slideback")},
		{time = 67 / 30, type = "sound", value = Sound("COD_MW2019_SG552.Slideforward")}	
	}
}

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 20 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 30
SWEP.ReducedClipSize = 10

SWEP.Recoil = 0.8
SWEP.RecoilSide = 0.8
SWEP.RecoilRise = 1

SWEP.Delay = 60 / 410 -- 60 / RPM.
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
SWEP.NPCWeight = 200

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 700 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "type2" -- the magazine pool this gun draws from

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "weapons/cod_mw2019/oden/fire.wav"
SWEP.ShootSoundSilenced = "weapons/cod_mw2019/oden/rpk_suppressed_fp.wav"
SWEP.DistantShootSound = "weapons/arccw/ak47/ak47-1-distant.wav"

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/shells/shell_762nato.mdl"
SWEP.ShellScale = 1.5
SWEP.ShellMaterial = "models/weapons/arcticcw/shell_556_steel"

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 3 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.94
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.33
SWEP.VisualRecoilMult = 1
SWEP.RecoilRise = 0.6

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-2.681, -2, -0.201),
    Ang = Angle(-0.101, -0.431, 0),
    Magnification = 1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = Fire

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(8, -2, -4.011)
SWEP.HolsterAng = Angle(1.898, 54.613, -10.113)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(0, 0, 0)

SWEP.BarrelLength = 27

SWEP.AttachmentElements = {}

SWEP.ExtraSightDist = 5

SWEP.Attachments = {}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 0,
        SoundTable = {{s = "weapons/arccw/ak47/ak47_draw.wav", t = 0}},
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["draw"] = {
        Source = "Deploy",
        Time = 1,
        SoundTable = {{s = "weapons/cod_mw2019/oden/draw.wav", t = 0}},
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["ready"] = {
        Source = "draw",
        SoundTable = {{s = "weapons/cod_mw2019/oden/slideback.wav", t = 10/30},{s = "weapons/cod_mw2019/oden/slideforward.wav", t = 19/30}},
        LHIK = false,
        LHIKIn = 0,
        LHIKOut = 0.7,
    },
    ["fire"] = {
        Source = "fire",
        Time = 0.5,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "iron",
        Time = 0.5,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "wet",
        Time = 2.5,
        SoundTable = {{s = "weapons/cod_mw2019/oden/clipout.wav", t = 0.5},{s = "weapons/cod_mw2019/oden/clipin.wav", t = 1.3},{s = "weapons/cod_mw2019/oden/clipon.wav", t = 1.4}},
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Framerate = 37,
        Checkpoints = {28, 38, 69},
        LHIK = false,
        LHIKIn = 0.5,
        LHIKOut = 0.6,
    },
    ["reload_empty"] = {
        Source = "Reload",
        Time = 3,
        SoundTable = {{s = "weapons/cod_mw2019/oden/clipout.wav", t = 0.5},{s = "weapons/cod_mw2019/oden/clipin.wav", t = 1.3},{s = "weapons/cod_mw2019/oden/clipon.wav", t = 1.4},{s = "weapons/cod_mw2019/oden/slideback.wav", t = 2},{s = "weapons/cod_mw2019/oden/slideforward.wav", t = 2.2}},
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Framerate = 37,
        Checkpoints = {28, 38, 69},
        LHIK = false,
        LHIKIn = 0.5,
        LHIKOut = 0.6,
    },
    ["bash"] = {
        Source = {"melee"},
        Time = 40/35,
    },	
}

