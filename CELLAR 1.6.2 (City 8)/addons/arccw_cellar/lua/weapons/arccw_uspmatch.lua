SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "CELLAR"
SWEP.AdminOnly = false

SWEP.PrintName = "USP Match"

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/cellar/c_uspmatch.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 75

SWEP.Damage = 35
SWEP.DamageMin = 15
SWEP.BloodDamage = 200
SWEP.ShockDamage = 700
SWEP.BleedChance = 75

SWEP.AmmoItem = "bullets_9mm"
SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses

SWEP.Range = 50
SWEP.Penetration = 5
SWEP.DamageType = DMG_BULLET

SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 300

SWEP.CanFireUnderwater = true

SWEP.TracerNum = 1
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 18
SWEP.ExtendedClipSize = 24
SWEP.ReducedClipSize = 8

SWEP.Recoil = 1
SWEP.RecoilSide = 0.5
SWEP.RecoilRise = 2
//SWEP.VisualRecoilMult = 2
SWEP.MaxRecoilBlowback = 1.2
//SWEP.VisualRecoilMult = 1.25
SWEP.RecoilPunch = 0

SWEP.Delay = 60 / 365 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    }
}

SWEP.AccuracyMOA = 10 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 200

SWEP.MagID = "sp40" -- the magazine pool this gun draws from

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "weapons/tnweapons/pistol/player_pistol_fire3.wav"
SWEP.DistantShootSound = "weapons/pistol/pistol_fire3.wav"

SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.175

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.75

SWEP.BarrelLength = 22

SWEP.BulletBones = {}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-1.855, 0, 0.5),
    Ang = Angle(0.1, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "revolver"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0, 0, 0)
SWEP.HolsterAng = Angle(0, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 7

SWEP.Animations = {
    ["idle"] = {
        Source = "base_idle",
    },
    ["idle_empty"] = {
        Source = "empty_idle",
    },
    ["enter_sprint"] = {
        Source = "base_idle",
        Time = 1
    },
    ["exit_sprint"] = {
        Source = "base_idle",
        Time = 1
    },
    ["idle_sprint"] = {
        Source = "base_sprint",
    },
    ["holster"] = {
        Source = "base_holster",
    },
    ["holster_empty"] = {
        Source = "empty_holster",
    },
    ["draw"] = {
        Source = "base_draw",
    },
    ["draw_empty"] = {
        Source = "empty_draw",
    },
    ["ready"] = {
        Source = "base_ready",
    },
    ["fire"] = {
        Source = {"base_fire", "base_fire2", "base_fire3"},
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "base_firelast",
        ShellEjectAt = 0,
    },
    ["fire_dry"] = {
        Source = "base_dryfire",
    },
    ["fire_iron"] = {
        Source = {"iron_fire_1", "iron_fire_2", "iron_fire_3"},
        ShellEjectAt = 0,
    },
    ["fire_empty_iron"] = {
        Source = "iron_firelast",
        ShellEjectAt = 0,
    },
    ["fire_iron_dry"] = {
        Source = "iron_dryfire",
    },
    ["reload"] = {
        Source = "base_reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    },
    ["reload_empty"] = {
        Source = "base_reloadempty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    },
    ["bash"] = {
        Source = {"melee_1", "melee_2", "melee_3"},
    },
    ["bash_empty"] = {
        Source = {"melee_1_empty", "melee_2_empty", "melee_3_empty"},
    },
}

function SWEP:Hook_SelectFireAnimation(anim)
    local iron    = self:GetState() == ArcCW.STATE_SIGHTS

    if self:Clip1() == 0 then
        return iron and "fire_empty_iron" or "fire_empty"
    end
end