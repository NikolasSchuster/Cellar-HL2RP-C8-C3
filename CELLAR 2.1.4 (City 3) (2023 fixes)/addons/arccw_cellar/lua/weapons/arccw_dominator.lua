SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "CELLAR" 
SWEP.AdminOnly = false

SWEP.PrintName = "Dominator"

SWEP.CrouchPos = Vector(-1, 3, -0.5)
SWEP.CrouchAng = Angle(0, 0, -15)

SWEP.IsDominator = true
SWEP.ImpulseSkill = true

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/fml/c_volked_pkp.mdl"
SWEP.WorldModel = "models/weapons/arccw/fml/w_volked_pkp.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000"
SWEP.DefaultWMBodygroups = "00000000"

SWEP.Damage = 38
SWEP.DamageMin = 29
SWEP.BloodDamage = 600
SWEP.ShockDamage = 1200
SWEP.BleedChance = 8
SWEP.AmmoItem = "bullets_dominator"

SWEP.Range = 300 -- in METRES
SWEP.Penetration = 15
SWEP.DamageType = DMG_SHOCK
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 900 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 90 -- DefaultClip is automatically set.

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.PhysBulletMuzzleVelocity = 900

SWEP.Recoil = 1.35
SWEP.RecoilSide = 0.215
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 2.0

SWEP.Delay = 60 / 490 -- 60 / RPM.
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
SWEP.NPCWeight = 80

SWEP.AccuracyMOA = 3.5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 700 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 220

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "m200b" -- the magazine pool this gun draws from

SWEP.ShootVol = 70 -- volume of shoot sound
SWEP.ShootPitch = 120 -- pitch of shoot sound

SWEP.ShootSound = "weapons/fml_pkp_volk/fire.wav"
SWEP.ShootSoundSilenced = "weapons/fml_pkp_volk/ak74_suppressed_fp.wav"
SWEP.DistantShootSound = "weapons/arccw/negev/negev-1-distant.wav"

SWEP.MeleeSwingSound = "arccw_go/m249/m249_draw.wav"
SWEP.MeleeMissSound = "weapons/iceaxe/iceaxe_swing1.wav"
SWEP.MeleeHitNPCSound = "physics/body/body_medium_break2.wav"

SWEP.MeleeTime = 0.5
SWEP.MeleeAttackTime = 0.1

SWEP.MuzzleEffect = "muzzleflash_smg"
SWEP.ShellModel = "models/weapons/arccw/fml/shell_volked_pkp.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1.5
SWEP.ShellRotateAngle = Angle(0, 180, 0)

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.7
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.475

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
	[6] = "Weapon_Bullet0",
	[5] = "Weapon_Bullet",
	[4] = "Weapon_Bullet2",
	[3] = "Weapon_Bullet3",
	[2] = "Weapon_Bullet4",
	[1] = "Weapon_Bullet5",
}

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
	Pos = Vector(-2.523, -3, 0.469),
	Ang = Angle(0, 0, 0),
	Magnification = 1.1,
	SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 5, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -10)

SWEP.HolsterPos = Vector(8, -2, -4.011)
SWEP.HolsterAng = Angle(1.898, 54.613, -10.113)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 32

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
		Source = "idle",
		Time = 1
	},
	["draw"] = {
		Source = "draw",
		Time = 0.35,
		SoundTable = {{s = "weapons/arccw/m249/m249_draw.wav", t = 0}},
		LHIK = true,
		LHIKIn = 0,
		LHIKOut = 0.25,
	},
	["ready"] = {
		Source = "deploy",
		Time = 1,
		LHIK = true,
		LHIKIn = 0,
		LHIKOut = 0.25,
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
		Source = "reload",
		TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		FrameRate = 30,
		LastClip1OutTime = 95/60,
		LHIK = true,
		LHIKIn = 0.2,
		LHIKOut = 0.5,
	},
	["reload_empty"] = {
		Source = "reload",
		TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		FrameRate = 30,
		LastClip1OutTime = 95/60,
		LHIK = true,
		LHIKIn = 0.2,
		LHIKOut = 0.5,
	},
	["bash"] = {
		Source = {"melee"},
		Time = 30/60,
	},
}


sound.Add({
	name = 			"ARCCW_FML_VOLKED_PKP.Foley1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fml_pkp_volk/m249_armmovement_01.wav"
})

sound.Add({
	name = 			"ARCCW_FML_VOLKED_PKP.Open",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fml_pkp_volk/wpn_g2a4_reload_empty_charge_fr49_2ch_v1_01.wav"
})

sound.Add({
	name = 			"ARCCW_FML_VOLKED_PKP.Out",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fml_pkp_volk/magout.wav"
})

sound.Add({
	name = 			"ARCCW_FML_VOLKED_PKP.Foley2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fml_pkp_volk/m249_shoulder.wav"
})

sound.Add({
	name = 			"ARCCW_FML_VOLKED_PKP.In",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fml_pkp_volk/magin.wav"
})

sound.Add({
	name = 			"ARCCW_FML_VOLKED_PKP.Chain",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fml_pkp_volk/charge.wav"
})

sound.Add({
	name = 			"ARCCW_FML_VOLKED_PKP.Close",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fml_pkp_volk/wpn_r101_emptyreload_boltback_fr51_2ch_v1_01.wav"
})

sound.Add({
	name = 			"ARCCW_FML_VOLKED_PKP.Hit",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fml_pkp_volk/wpn_r101_emptyreload_boltforward_fr55_2ch_v1_01.wav"
})

sound.Add({
	name = 			"ARCCW_FML_VOLKED_PKP.Bolt1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fml_pkp_volk/bolt_back.wav"
})

sound.Add({
	name = 			"ARCCW_FML_VOLKED_PKP.Bolt2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fml_pkp_volk/bolt_forward.wav"
})