SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR" 
SWEP.AdminOnly = false

SWEP.PrintName = "AK47"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = "The AK-47 officially known as the Avtomat Kalashnikova (lit. 'Kalashnikov’s automatic device' also known as the Kalashnikov and AK), is a gas-operated, 7.62x39mm assault rifle, developed in the Soviet Union by Mikhail Kalashnikov. It is the originating firearm of the Kalashnikov rifle (or AK) family. 47 refers to the year it was finished. 																												 IN SERVICE: 1994-present (Other countries)								 IN SERVICE: 1949-1974 (Soviet Union)"
SWEP.Trivia_Manufacturer = "Mikhail Kalashnikov"
SWEP.Trivia_Calibre = "7.62x39mm Soviet"
SWEP.Trivia_Mechanism = "Gas-Operated"
SWEP.Trivia_Country = "USSR"
SWEP.Trivia_Year = 1947

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_tdon_mwak_mammal_edition.mdl"
SWEP.WorldModel = "models/weapons/w_tdon_mwak_mammal_edition.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "010000100000"

SWEP.Damage = 50
SWEP.DamageMin = 35
SWEP.BloodDamage = 600
SWEP.ShockDamage = 600
SWEP.BleedChance = 80
SWEP.AmmoItem = "bullets_7x62"

SWEP.Range = 100 -- in METRES
SWEP.Penetration = 15
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.

SWEP.PhysBulletMuzzleVelocity = 900

SWEP.Recoil = 0.8
SWEP.RecoilSide = 0.75
SWEP.RecoilRise = 1

SWEP.Delay = 60 / 550 -- 60 / RPM.
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

SWEP.AccuracyMOA = 10 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 700 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.MagID = "type2" -- the magazine pool this gun draws from

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "weapons/mw19/akfire.wav"
SWEP.ShootSoundSilenced = "weapons/mw19/akfire_sd.wav"
SWEP.DistantShootSound = "weapons/arccw/ak47/ak47-1-distant.wav"

SWEP.MeleeSwingSound = "arccw_go/m249/m249_draw.wav"
SWEP.MeleeMissSound = "weapons/iceaxe/iceaxe_swing1.wav"
SWEP.MeleeHitNPCSound = "physics/body/body_medium_break2.wav"

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    if wep:GetBuff_Mult("Mult_ReloadTime") > 0.9 then return end

    if anim == "reload_empty" then return "reload_empty_soh" 
    elseif anim == "reload" then return "reload_soh"	
	end
end

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/shells/shell_762nato.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1.5
SWEP.ShellRotateAngle = Angle(0, 180, 0)

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.94
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.33
SWEP.VisualRecoilMult = 1
SWEP.RecoilRise = 1

SWEP.IronSightStruct = {
    Pos = Vector(-2.701, -2.5, 0.994),
    Ang = Angle(-0.787, 0, -3),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -10)

SWEP.HolsterPos = Vector(8, -2, -4.011)
SWEP.HolsterAng = Angle(1.898, 54.613, -10.113)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(0, 0, 0)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.BarrelLength = 27

SWEP.AttachmentElements = {}

SWEP.ExtraSightDist = 5

SWEP.Attachments = {}

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "draw",
        Time = 1,
        SoundTable = {{s = "weapons/mw19/uni_weapon_draw_03.wav", t = 0}},
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["ready"] = {
        Source = "deploy",
        Time = 80/60,		
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 1,
    },
    ["fire"] = {
        Source = {"fire"},
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "iron",
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 150/60,			
        Framerate = 60,
        Checkpoints = {28, 38, 69},
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 1,
    },
    ["reload_empty"] = {
        Source = {"reload_empty", "reload_empty2"},
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 185/60,		
        Framerate = 60,
        Checkpoints = {28, 38, 69},
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 1,
    },
	["reload_soh"] = {
        Source = {"reload_soh1"},
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 145/60,			
        Framerate = 60,
        Checkpoints = {28, 38, 69},
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 1,
    },
    ["reload_empty_soh"] = {
        Source = {"reload_empty_soh", "reload_empty_soh2"},
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 165/60,			
        Framerate = 60,
        Checkpoints = {28, 38, 69},
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 1,
    },	
}