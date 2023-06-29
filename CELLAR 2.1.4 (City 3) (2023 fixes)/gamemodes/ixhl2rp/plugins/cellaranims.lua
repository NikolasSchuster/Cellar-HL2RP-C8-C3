local PLUGIN = PLUGIN

PLUGIN.name = "Cellar Animations"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = "Adds the proper animations for cellar models."

ix.anim = ix.anim or {}

ix.anim.cellarMale = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_fists"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_fists"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_fists"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_fists"},
		[ACT_MP_RUN] = {ACT_RUN, "run_fists"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
		glide = "jump_normal",
		sit = ACT_BUSY_SIT_CHAIR,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_normal", "pidle_fists_aim"},
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_pistol_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_pistol", "cidle_pistol_aim"},
		[ACT_MP_WALK] = {ACT_WALK, "walkaimall1_pistol"},
		[ACT_MP_CROUCHWALK] = {"cwalk_pistol", "cwalk_pistol_aim"},
		[ACT_MP_RUN] = {ACT_RUN, "run_aiming_all_pistol"},
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_GESTURE_RELOAD_PISTOL,
		glide = {"jump_pistol", "jump_pistol_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_pistol_aim"},
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {"cidle_smg1", "cidle_smg1_aim"},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE_RELAXED, "walkalertaimall1"},
		[ACT_MP_CROUCHWALK] = {"cwalk_smg1", "cwalk_smg1_aim"},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE_RELAXED, "run_alert_aiming_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = ACT_GESTURE_RELOAD_SMG1,
		glide = {"jump_smg1", "jump_smg1_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_smg1_aim"},
	},
	ar2 = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1_RELAXED, "idle_ar2_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_ar2", "cidle_ar2_aim"},
		[ACT_MP_WALK] = {"walk_AR2_Relaxed_all", "walkalertaimall1"},
		[ACT_MP_CROUCHWALK] = {"cwalk_ar2", "cwalk_ar2_aim"},
		[ACT_MP_RUN] = {"run_AR2_Relaxed_all", "run_alert_aiming_ar2_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_AR2,
		reload = "gesture_reload_ar2",
		glide = {"jump_ar2", "jump_ar2_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_ar2_aim"},
	},
	knife = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_knife"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_knife"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_knife"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_knife"},
		[ACT_MP_RUN] = {ACT_RUN, "run_knife"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE,
		glide = {"jump_normal", "jump_knife"},
		sit = ACT_COVER_PISTOL_LOW,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_knife_aim"},
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SHOTGUN_RELAXED, "idle_ar2_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_shotgun", "cidle_smg1_aim"},
		[ACT_MP_WALK] = {"walk_AR2_Relaxed_all", "walkalertaimall1"},
		[ACT_MP_CROUCHWALK] = {"cwalk_shotgun", "cwalk_smg1_aim"},
		[ACT_MP_RUN] = {"run_AR2_Relaxed_all", "run_alert_aiming_ar2_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_SHOTGUN,
		reload = "gesture_reload_ar2",
		glide = {"jump_shotgun", "jump_shotgun_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_shotgun_aim"},
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_melee_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_melee_aim"},
		[ACT_MP_WALK] = {ACT_WALK, "walkaimall1_melee"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_melee_aim"},
		[ACT_MP_RUN] = {ACT_RUN, "run_aiming_all_melee"},
		glide = {"jump_normal", "jump_melee_aim"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_melee_aim"},
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_melee_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_melee_aim"},
		[ACT_MP_WALK] = {ACT_WALK, "walkaimall1_melee"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_melee_aim"},
		[ACT_MP_RUN] = {ACT_RUN, "run_aiming_all_melee"},
		glide = {"jump_normal", "jump_melee_aim"},
		attack = ACT_MELEE_ATTACK_SWING_GESTURE,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_melee_aim"},
	},
	rpg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_RPG_RELAXED, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW_RPG, ACT_COVER_LOW_RPG},
		[ACT_MP_WALK] = {ACT_WALK_RPG_RELAXED, ACT_WALK_RPG},
		[ACT_MP_CROUCHWALK] = ACT_WALK_CROUCH_RPG,
		[ACT_MP_RUN] = {ACT_RUN_RPG_RELAXED, ACT_RUN_RPG},
		attack = ACT_RANGE_ATTACK_RPG,
		glide = {"jump_ar2", "jump_ar2_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_ar2_aim"},
	},
	glide = "jump_holding_glide",
	["sit"] = "sit",
	["sit_zen"] = "sit_zen",
	vehicle = {
		["prop_vehicle_prisoner_pod"] = {"podpose", Vector(-3, 0, 0)},
		["prop_vehicle_jeep"] = {ACT_BUSY_SIT_CHAIR, Vector(14, 0, -14)},
		["prop_vehicle_airboat"] = {ACT_BUSY_SIT_CHAIR, Vector(8, 0, -20)},
		chair = {"stances_sit02", Vector(10, 0, -19)}
	},
}

ix.anim.cellarFemale = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_fists"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_fists"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_fists"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_fists"},
		[ACT_MP_RUN] = {ACT_RUN, "run_fists"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
		glide = "jump_normal",
		sit = ACT_BUSY_SIT_CHAIR,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_normal", "pidle_fists_aim"},
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_PISTOL, "pistol_idle_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_pistol", "cidle_pistol_aim"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_aiming_p_all"},
		[ACT_MP_CROUCHWALK] = {"cwalk_pistol", "cwalk_pistol_aim"},
		[ACT_MP_RUN] = {ACT_RUN, "run_aiming_p_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_GESTURE_RELOAD_PISTOL,
		glide = {"jump_pistol", "jump_pistol_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_pistol_aim"},
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1_RELAXED, "idle_smg1_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_smg1", "cidle_smg1_aim"},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE_RELAXED, "walkalertaimall1"},
		[ACT_MP_CROUCHWALK] = {"cwalk_smg1", "cwalk_smg1_aim"},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE_RELAXED, "run_alert_aiming_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = ACT_GESTURE_RELOAD_SMG1,
		glide = {"jump_smg1", "jump_smg1_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_smg1_aim"},
	},
	ar2 = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1_RELAXED, "idle_ar2_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_ar2", "cidle_ar2_aim"},
		[ACT_MP_WALK] = {"walk_AR2_Relaxed_all", "walkalertaimall1"},
		[ACT_MP_CROUCHWALK] = {"cwalk_ar2", "cwalk_ar2_aim"},
		[ACT_MP_RUN] = {"run_AR2_Relaxed_all", "run_alert_aiming_ar2_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_AR2,
		reload = "gesture_reload_ar2",
		glide = {"jump_ar2", "jump_ar2_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_ar2_aim"},
	},
	knife = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_knife"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_knife"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_knife"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_knife"},
		[ACT_MP_RUN] = {ACT_RUN, "run_knife"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE,
		glide = {"jump_normal", "jump_knife"},
		sit = ACT_COVER_PISTOL_LOW,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_knife_aim"},
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SHOTGUN_RELAXED, "idle_ar2_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_shotgun", "cidle_shotgun_aim"},
		[ACT_MP_WALK] = {"walk_AR2_Relaxed_all", "walkalertaimall1"},
		[ACT_MP_CROUCHWALK] = {"cwalk_shotgun", "cwalk_shotgun_aim"},
		[ACT_MP_RUN] = {"run_AR2_Relaxed_all", "run_alert_aiming_ar2_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_SHOTGUN,
		reload = "gesture_reload_ar2",
		glide = {"jump_shotgun", "jump_shotgun_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_shotgun_aim"},
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_melee_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_melee_aim"},
		[ACT_MP_WALK] = {ACT_WALK, "walkaimall1_melee"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_melee_aim"},
		[ACT_MP_RUN] = {ACT_RUN, "run_aiming_all_melee"},
		glide = {"jump_normal", "jump_melee_aim"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_melee_aim"},
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_melee_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_melee_aim"},
		[ACT_MP_WALK] = {ACT_WALK, "walkaimall1_melee"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_melee_aim"},
		[ACT_MP_RUN] = {ACT_RUN, "run_aiming_all_melee"},
		glide = {"jump_normal", "jump_melee_aim"},
		attack = ACT_MELEE_ATTACK_SWING_GESTURE,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_melee_aim"},
	},
	rpg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_RPG_RELAXED, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW_RPG, ACT_COVER_LOW_RPG},
		[ACT_MP_WALK] = {ACT_WALK_RPG_RELAXED, ACT_WALK_RPG},
		[ACT_MP_CROUCHWALK] = ACT_WALK_CROUCH_RPG,
		[ACT_MP_RUN] = {ACT_RUN_RPG_RELAXED, ACT_RUN_RPG},
		attack = ACT_RANGE_ATTACK_RPG,
		glide = {"jump_ar2", "jump_ar2_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_ar2_aim"},
	},
	glide = ACT_GLIDE,
	vehicle = ix.anim.cellarMale.vehicle
}

ix.anim.cellarMaleMPF = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_fists"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_fists"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_fists"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_fists"},
		[ACT_MP_RUN] = {ACT_RUN, "run_fists"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
		glide = "jump_normal",
		sit = ACT_COVER_PISTOL_LOW,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_normal", "pidle_fists_aim"},
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_PISTOL, "pistolangryidle2"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_pistol", "cidle_pistol_aim"},
		[ACT_MP_WALK] = {ACT_WALK_PISTOL, ACT_WALK_AIM_PISTOL},
		[ACT_MP_CROUCHWALK] = {"cwalk_pistol", "cwalk_pistol_aim"},
		[ACT_MP_RUN] = {ACT_RUN_PISTOL, ACT_RUN_AIM_PISTOL},
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_GESTURE_RELOAD_PISTOL,
		glide = {"jump_pistol", "jump_pistol_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_pistol_aim"},
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1, "idle_smg1_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_smg1", "cidle_smg1_aim"},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE, "walk_smg1_aim"},
		[ACT_MP_CROUCHWALK] = {"cwalk_smg1", "cwalk_smg1_aim"},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE, "run_smg1_aim"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
		reload = ACT_HL2MP_GESTURE_RELOAD_SMG1,
		glide = {"jump_smg1", "jump_smg1_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_smg1_aim"},
	},
	ar2 = {
		[ACT_MP_STAND_IDLE] = {"idle_ar2", "idle_ar2_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_ar2", "cidle_ar2_aim"},
		[ACT_MP_WALK] = {"walk_ar2", "walk_ar2_aim"},
		[ACT_MP_CROUCHWALK] = {"cwalk_ar2", "cwalk_ar2_aim"},
		[ACT_MP_RUN] = {"run_ar2", "run_ar2_aim"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
		reload = ACT_HL2MP_GESTURE_RELOAD_AR2,
		glide = {"jump_ar2", "jump_ar2_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_ar2_aim"},
	},
	knife = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_knife"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_knife"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_knife"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_knife"},
		[ACT_MP_RUN] = {ACT_RUN, "run_knife"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE,
		glide = {"jump_normal", "jump_knife"},
		sit = ACT_COVER_PISTOL_LOW,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_knife_aim"},
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {"idle_shotgun", "idle_shotgun_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_shotgun", "cidle_shotgun_aim"},
		[ACT_MP_WALK] = {"walk_shotgun", "walk_shotgun_aim"},
		[ACT_MP_CROUCHWALK] = {"cwalk_shotgun", "cwalk_shotgun_aim"},
		[ACT_MP_RUN] = {"run_shotgun", "run_shotgun_aim"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
		reload = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
		glide = {"jump_shotgun", "jump_shotgun_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_shotgun_aim"},
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_melee_aim"},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_ANGRY},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_melee_aim"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		glide = {"jump_normal", "jump_melee_aim"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_melee_aim"},
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_melee_aim"},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_ANGRY},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_melee_aim"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		glide = {"jump_normal", "jump_melee_aim"},
		attack = ACT_MELEE_ATTACK_SWING_GESTURE,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_melee_aim"},
	},
	glide = ACT_GLIDE,
	vehicle = {
		prop_vehicle_airboat = {ACT_COVER_PISTOL_LOW, Vector(10, 0, 0)},
		prop_vehicle_jeep = {ACT_COVER_PISTOL_LOW, Vector(18, -2, 4)},
		prop_vehicle_prisoner_pod = {ACT_IDLE, Vector(-4, -0.5, 0)},
		chair = {"stances_sit02", Vector(10, 0, -19)}
	}
}

ix.anim.cellarFemaleMPF = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_fists"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_fists"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_fists"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_fists"},
		[ACT_MP_RUN] = {ACT_RUN, "run_fists"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
		glide = "jump_normal",
		sit = ACT_BUSY_SIT_CHAIR,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_normal", "pidle_fists_aim"},
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_PISTOL, "pistol_idle_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_pistol", "cidle_pistol_aim"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_aiming_p_all"},
		[ACT_MP_CROUCHWALK] = {"cwalk_pistol", "cwalk_pistol_aim"},
		[ACT_MP_RUN] = {ACT_RUN, "run_aiming_p_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_GESTURE_RELOAD_PISTOL,
		glide = {"jump_pistol", "jump_pistol_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_pistol_aim"},
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1_RELAXED, "idle_smg1_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_smg1", "cidle_smg1_aim"},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE_RELAXED, "walkalertaimall1"},
		[ACT_MP_CROUCHWALK] = {"cwalk_smg1", "cwalk_smg1_aim"},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE_RELAXED, "run_alert_aiming_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = ACT_GESTURE_RELOAD_SMG1,
		glide = {"jump_smg1", "jump_smg1_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_smg1_aim"},
	},
	ar2 = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1_RELAXED, "idle_ar2_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_ar2", "cidle_ar2_aim"},
		[ACT_MP_WALK] = {"walk_AR2_Relaxed_all", "walkalertaimall1"},
		[ACT_MP_CROUCHWALK] = {"cwalk_ar2", "cwalk_ar2_aim"},
		[ACT_MP_RUN] = {"run_AR2_Relaxed_all", "run_alert_aiming_ar2_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_AR2,
		reload = "gesture_reload_ar2",
		glide = {"jump_ar2", "jump_ar2_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_ar2_aim"},
	},
	knife = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_knife"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_knife"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_knife"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_knife"},
		[ACT_MP_RUN] = {ACT_RUN, "run_knife"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE,
		glide = {"jump_normal", "jump_knife"},
		sit = ACT_COVER_PISTOL_LOW,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_knife_aim"},
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SHOTGUN_RELAXED, "idle_ar2_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_shotgun", "cidle_shotgun_aim"},
		[ACT_MP_WALK] = {"walk_AR2_Relaxed_all", "walkalertaimall1"},
		[ACT_MP_CROUCHWALK] = {"cwalk_shotgun", "cwalk_shotgun_aim"},
		[ACT_MP_RUN] = {"run_AR2_Relaxed_all", "run_alert_aiming_ar2_all"},
		attack = ACT_GESTURE_RANGE_ATTACK_SHOTGUN,
		reload = "gesture_reload_ar2",
		glide = {"jump_shotgun", "jump_shotgun_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_shotgun_aim"},
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_melee_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_melee_aim"},
		[ACT_MP_WALK] = {ACT_WALK, "walkaimall1_melee"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_melee_aim"},
		[ACT_MP_RUN] = {ACT_RUN, "run_aiming_all_melee"},
		glide = {"jump_normal", "jump_melee_aim"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_melee_aim"},
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "idle_melee_aim"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_melee_aim"},
		[ACT_MP_WALK] = {ACT_WALK, "walkaimall1_melee"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_melee_aim"},
		[ACT_MP_RUN] = {ACT_RUN, "run_aiming_all_melee"},
		glide = {"jump_normal", "jump_melee_aim"},
		attack = ACT_MELEE_ATTACK_SWING_GESTURE,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_melee_aim"},
	},
	rpg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_RPG_RELAXED, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW_RPG, ACT_COVER_LOW_RPG},
		[ACT_MP_WALK] = {ACT_WALK_RPG_RELAXED, ACT_WALK_RPG},
		[ACT_MP_CROUCHWALK] = ACT_WALK_CROUCH_RPG,
		[ACT_MP_RUN] = {ACT_RUN_RPG_RELAXED, ACT_RUN_RPG},
		attack = ACT_RANGE_ATTACK_RPG,
		glide = {"jump_ar2", "jump_ar2_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_ar2_aim"},
	},
	glide = ACT_GLIDE,
	vehicle = {
		prop_vehicle_prisoner_pod = {"podpose", Vector(-3, 0, 0)},
		prop_vehicle_jeep = {"sitchair1", Vector(14, 0, -14)},
		prop_vehicle_airboat = {"sitchair1", Vector(8, 0, -20)},
		chair = {"stances_sit02", Vector(10, 0, -19)}
	}
}

ix.anim.cellarOTA = {
	normal = {
		[ACT_MP_STAND_IDLE] = {"idle_unarmed", "combatidle1_fists"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_fists"},
		[ACT_MP_WALK] = {"walkunarmed_all", "walk_aiming_all_fists"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_fists"},
		[ACT_MP_RUN] = {"runaimall1_melee", "runaimall1_fists"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
		glide = "jump_normal",
		sit = ACT_COVER_LOW,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_normal", "pidle_fists_aim"},
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {"idle1_pistol", "combatidle1_pistol"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_pistol", "cidle_pistol_aim"},
		[ACT_MP_WALK] = {"walkeasy_all_pistol", "walk_aiming_all_pistol"},
		[ACT_MP_CROUCHWALK] = {"cwalk_pistol", "cwalk_pistol_aim"},
		[ACT_MP_RUN] = {"runall_pistol", "runaimall1_pistol"},
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_GESTURE_RELOAD_PISTOL,
		glide = {"jump_pistol", "jump_pistol_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_pistol_aim"},
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {"idle1_smg1", "combatidle1_smg1"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_smg1", "cidle_smg1_aim"},
		[ACT_MP_WALK] = {"walkeasy_all_smg1", "walk_aiming_all"},
		[ACT_MP_CROUCHWALK] = {"cwalk_smg1", "cwalk_smg1_aim"},
		[ACT_MP_RUN] = {"runall", "runaimall1"},
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = ACT_GESTURE_RELOAD_SMG1,
		glide = {"jump_smg1", "jump_smg1_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_smg1_aim"},
	},
	ar2 = {
		[ACT_MP_STAND_IDLE] = {"idle1", "combatidle1"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_ar2", "cidle_ar2_aim"},
		[ACT_MP_WALK] = {"walkeasy_all", "walk_aiming_all"},
		[ACT_MP_CROUCHWALK] = {"cwalk_ar2", "cwalk_ar2_aim"},
		[ACT_MP_RUN] = {"runall", "runaimall1"},
		attack = ACT_GESTURE_RANGE_ATTACK_AR2,
		reload = ACT_GESTURE_RELOAD,
		glide = {"jump_ar2", "jump_ar2_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_ar2_aim"},
	},
	knife = {
		[ACT_MP_STAND_IDLE] = {"idle1_melee", "combatidle1_knife"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_knife"},
		[ACT_MP_WALK] = {"walkeasy_all_melee", "walk_aiming_all_knife"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_knife"},
		[ACT_MP_RUN] = {"runaimall1_melee", "runaimall1_knife"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE,
		glide = {"jump_normal", "jump_knife"},
		sit = ACT_COVER_PISTOL_LOW,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_knife_aim"},
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {"idle1_sg", "combatidle1_sg"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_shotgun", "cidle_shotgun_aim"},
		[ACT_MP_WALK] = {"walkeasy_all_sg", "walk_aiming_all_sg"},
		[ACT_MP_CROUCHWALK] = {"cwalk_shotgun", "cwalk_shotgun_aim"},
		[ACT_MP_RUN] = {"runaimall1_sg", "runaimall1_sg"},
		attack = ACT_GESTURE_RANGE_ATTACK_SHOTGUN,
		reload = ACT_GESTURE_RELOAD,
		glide = {"jump_shotgun", "jump_shotgun_aim"},
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_shotgun_aim"},
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {"idle1_melee", "combatidle1_melee"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_melee_aim"},
		[ACT_MP_WALK] = {"walkeasy_all_melee", "walk_aiming_all_melee"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_melee_aim"},
		[ACT_MP_RUN] = {"runaimall1_melee", "runaimall1_melee"},
		glide = {"jump_normal", "jump_melee_aim"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_melee_aim"},
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {"idle1_melee", "combatidle1_melee"},
		[ACT_MP_CROUCH_IDLE] = {"cidle_normal", "cidle_melee_aim"},
		[ACT_MP_WALK] = {"walkeasy_all_melee", "walk_aiming_all_melee"},
		[ACT_MP_CROUCHWALK] = {"cwalk_normal", "cwalk_melee_aim"},
		[ACT_MP_RUN] = {"runaimall1_melee", "runaimall1_melee"},
		glide = {"jump_normal", "jump_melee_aim"},
		attack = ACT_MELEE_ATTACK_SWING_GESTURE,
		prone_walk = {"pwalk_all", "pwalk_all"},
		prone_idle = {"pidle_holding", "pidle_melee_aim"},
	},
	glide = ACT_GLIDE,
	vehicle = {
		prop_vehicle_airboat = {ACT_COVER_PISTOL_LOW, Vector(10, 0, 0)},
		prop_vehicle_jeep = {ACT_COVER_PISTOL_LOW, Vector(18, -2, 4)},
		prop_vehicle_prisoner_pod = {ACT_IDLE, Vector(-4, -0.5, 0)},
		chair = {"stances_sit02", Vector(10, 0, -19)}
	}
}

function PLUGIN:SetupActs()
	-- sit
	ix.act.Register("Sit",  {"cellarMaleMPF", "cellarMale", "cellarFemaleMPF", "cellarFemale"}, {
		start = {"idle_to_sit_ground", "idle_to_sit_chair"},
		sequence = {"sit_ground", "sit_chair"},
		finish = {
			{"sit_ground_to_idle", duration = 2.1},
			""
		},
		untimed = true,
		idle = true
	})

	ix.act.Register("SitWall", {"cellarMaleMPF", "cellarMale", "cellarFemaleMPF", "cellarFemale"}, {
		sequence = {
			{"plazaidle4", check = FacingWallBack},
			{"injured1", check = FacingWallBack, offset = function(client)
				return client:GetForward() * 14
			end}
		},
		untimed = true,
		idle = true
	})

	-- stand
	ix.act.Register("Stand", {"cellarMaleMPF", "cellarMale"}, {
		sequence = {"lineidle01", "lineidle02", "lineidle03", "lineidle04"},
		untimed = true,
		idle = true
	})

	ix.act.Register("Stand", {"cellarFemaleMPF", "cellarFemale"}, {
		sequence = {"lineidle01", "lineidle02", "lineidle03"},
		untimed = true,
		idle = true
	})

	-- cheer
	ix.act.Register("Cheer", {"cellarMaleMPF", "cellarMale"}, {
		sequence = {{"cheer1", duration = 1.6}, "cheer2", "wave_smg1"}
	})

	ix.act.Register("Cheer", {"cellarFemaleMPF", "cellarFemale"}, {
		sequence = {"cheer1", "wave_smg1"}
	})

	-- lean
	ix.act.Register("Lean", {"cellarMaleMPF", "cellarMale", "cellarFemaleMPF", "cellarFemale"}, {
		start = {"idle_to_lean_back", "", ""},
		sequence = {
			{"lean_back", check = FacingWallBack},
			{"plazaidle1", check = FacingWallBack},
			{"plazaidle2", check = FacingWallBack}
		},
		untimed = true,
		idle = true
	})

	-- injured
	ix.act.Register("Injured", {"cellarMaleMPF", "cellarMale"}, {
		sequence = {"d1_town05_wounded_idle_1", "d1_town05_wounded_idle_2", "d1_town05_winston_down"},
		untimed = true,
		idle = true
	})

	ix.act.Register("Injured", {"cellarFemaleMPF", "cellarFemale"}, {
		sequence = "d1_town05_wounded_idle_1",
		untimed = true,
		idle = true
	})

	ix.act.Register("Arrest", {"cellarMaleMPF", "cellarMale"}, {
		sequence = "arrestidle",
		untimed = true
	})

	-- threat
	ix.act.Register("Threat", "cellarMaleMPF", {
		sequence = "plazathreat1",
	})

	-- deny
	ix.act.Register("Deny", "cellarMaleMPF", {
		sequence = "harassfront2",
	})

	-- motion
	ix.act.Register("Motion", "cellarMaleMPF", {
		sequence = {"motionleft", "motionright", "luggage"}
	})

	-- wave
	ix.act.Register("Wave",  {"cellarMaleMPF", "cellarMale", "cellarFemaleMPF", "cellarFemale"}, {
		sequence = {{"wave", duration = 2.75}, {"wave_close", duration = 1.75}}
	})

	-- pant
	ix.act.Register("Pant",  {"cellarMaleMPF", "cellarMale", "cellarFemaleMPF", "cellarFemale"}, {
		start = {"d2_coast03_postbattle_idle02_entry", "d2_coast03_postbattle_idle01_entry"},
		sequence = {"d2_coast03_postbattle_idle02", {"d2_coast03_postbattle_idle01", check = FacingWall}},
		untimed = true
	})

	-- window
	ix.act.Register("Window", {"cellarMaleMPF", "cellarMale"}, {
		sequence = "d1_t03_tenements_look_out_window_idle",
		untimed = true
	})

	ix.act.Register("Window", {"cellarFemaleMPF", "cellarFemale"}, {
		sequence = "d1_t03_lookoutwindow",
		untimed = true
	})
end

ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_01.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_02.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_03.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_04.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_05.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_06.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_07.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_08.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_09.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_10.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_11.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_12.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_13.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_14.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_15.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_16.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_17.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/male_18.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_01.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_02.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_03.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_04.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_05.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_06.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_07.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_08.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_09.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_10.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_11.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_12.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_13.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_14.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_15.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_16.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_17.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldcitizens/female_18.mdl", "cellarFemale")

ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_01.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_02.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_03.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_04.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_06.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_07.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_fang.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_hawke.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_rochelle.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_wraith.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/oldsuits/female_zoey.mdl", "cellarFemale")
ix.anim.SetModelClass("models/ecompd/myra.mdl", "cellarFemale")

ix.anim.SetModelClass("models/cellar/characters/metropolice/male.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/gurlukovich.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/gurevich.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/themask.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/riff.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/unnamed.mdl", "cellarMale")


-- BLYAT YA TUT OHUEL ZNATNO TOGDA 05.11.2021 VINTAGE THIEF
-- boys
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_01.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_02.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_03.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_04.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_05.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_06.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_07.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_08.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_09.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_10.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_11.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_12.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_13.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_14.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_15.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_16.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_17.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_18.mdl", "cellarMaleMPF")
-- girls
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_01.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_02.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_03.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_04.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_05.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_06.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_07.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_08.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_09.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_10.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_11.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_12.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_13.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_14.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_15.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_16.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_17.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/metropolice/female/cca_female_18.mdl", "cellarFemaleMPF")
-- BLYAT YA TUT ZOKONCHIL


--BLYAT OPYAT ETO GOVNO DELAT NADO EBAT 12.03.2022 VINTAGE THIEF
-- cca overseers
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/overseer/male/cca_overseer_01.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/overseer/male/cca_overseer_02.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/overseer/male/cca_overseer_03.mdl", "cellarMaleMPF")
-- boys cca
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_01.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_02.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_03.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_04.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_05.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_06.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_07.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_08.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_09.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_10.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_11.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_12.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/male/cca_male_13.mdl", "cellarMaleMPF")
-- girls cca
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_01.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_02.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_03.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_04.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_05.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_06.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_07.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_08.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_09.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_10.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_11.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_12.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_13.mdl", "cellarFemaleMPF")
-- overwatch
ix.anim.SetModelClass("models/cellar/characters/city3/overwatch/ota_ordinal.mdl", "cellarOTA")
ix.anim.SetModelClass("models/cellar/characters/city3/overwatch/ota_elite.mdl", "cellarOTA")
ix.anim.SetModelClass("models/cellar/characters/city3/overwatch/ota_regular.mdl", "cellarOTA")
-- citizen male
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_01.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_02.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_03.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_04.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_05.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_06.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_07.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_08.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_09.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_10.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_11.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_12.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_male_13.mdl", "cellarMale")
-- citizen female
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_01.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_02.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_03.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_04.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_05.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_06.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_07.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_08.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_09.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_10.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_11.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_12.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/female/c3_female_13.mdl", "cellarFemale")
-- konec

ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_valtan.mdl", "cellarMaleMPF")

ix.anim.SetModelClass("models/cellar/characters/female_02.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/chong.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/leaguemovement.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/leaguemovement_coat.mdl", "cellarMale")

ix.anim.SetModelClass("models/cellar/characters/zelen.mdl", "cellarMale") -- jessy

ix.anim.SetModelClass("models/vintagethief/ota/ota_ordinal.mdl", "cellarOTA")

ix.anim.SetModelClass("models/vintagethief/killjoy.mdl", "cellarFemale")
ix.anim.SetModelClass("models/vintagethief/durham.mdl", "cellarMale")

for i = 1, 9 do
	ix.anim.SetModelClass("models/cellar/characters/oldsuits/male_0"..i.."_closed_coat_tie.mdl", "cellarMale")
	ix.anim.SetModelClass("models/cellar/characters/oldsuits/male_0"..i.."_closed_tie.mdl", "cellarMale")
	ix.anim.SetModelClass("models/cellar/characters/oldsuits/male_0"..i.."_open.mdl", "cellarMale")
	ix.anim.SetModelClass("models/cellar/characters/oldsuits/male_0"..i.."_open_tie.mdl", "cellarMale")
	ix.anim.SetModelClass("models/cellar/characters/oldsuits/male_0"..i.."_open_waistcoat.mdl", "cellarMale")
	ix.anim.SetModelClass("models/cellar/characters/oldsuits/male_0"..i.."_shirt.mdl", "cellarMale")
	ix.anim.SetModelClass("models/cellar/characters/oldsuits/male_0"..i.."_shirt_tie.mdl", "cellarMale")
end

ix.anim.SetModelClass("models/cellar/characters/malogo.mdl", "cellarMale")

ix.anim.SetModelClass("models/cellar/characters/tno/chancellor.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_02.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_04.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_05.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_06.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_07.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_08.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_09.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_10.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_11.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_12.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_13.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_14.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_16.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_17.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/male_18.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/malogo.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/ynb.mdl", "cellarMaleMPF")


ix.anim.SetModelClass("models/cellar/characters/rodney.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/lubitar.mdl", "cellarMale")


ix.anim.SetModelClass("models/cellar/characters/female_lalalar.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/dance.mdl", "cellarMale")

ix.anim.SetModelClass("models/cellar/characters/combine/soldier_male.mdl", "cellarOTA")
ix.anim.SetModelClass("models/cellar/characters/combine/elite_male.mdl", "cellarOTA")
ix.anim.SetModelClass("models/cellar/characters/combine/sniper_male.mdl", "cellarOTA")
ix.anim.SetModelClass("models/cellar/characters/combine/soldier_female.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/combine/elite_female.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/combine/sniper_female.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/characters/combine/stripped_male.mdl", "cellarOTA")
ix.anim.SetModelClass("models/vintagethief/combine/ota/ota_27.mdl", "cellarOTA")

ix.anim.SetModelClass("models/cellar/characters/walker.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/solomon.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/green.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/longriver.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/joseph.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/ryan.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/karina.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/bradley.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/prohorov.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/krasnov.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/solomon_armor.mdl", "cellarMale")

ix.anim.SetModelClass("models/vintagethief/hecu/female.mdl", "cellarFemale")

ix.anim.SetModelClass("models/cellar/characters/female_terdavis.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/patricia.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/violetta.mdl", "cellarFemale")
ix.anim.SetModelClass("models/vintagethief/brave_squad.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/saller.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/olaf.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/fisher.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/blackstone.mdl", "cellarMale")

ix.anim.SetModelClass("models/vintagethief/zekek.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/beres.mdl", "cellarMale")

ix.anim.SetModelClass("models/cellar/characters/female_15_eyepatch.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/porter.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/riff_shirt.mdl", "cellarMale")

ix.anim.SetModelClass("models/cellar/characters/male_valtan.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/voinsparti.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/ksenax.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/yellowapple.mdl", "cellarFemale")
ix.anim.SetModelClass("models/vintagethief/dushman.mdl", "cellarFemale")

ix.anim.SetModelClass("models/cellar/characters/whned.mdl", "cellarFemale")

ix.anim.SetModelClass("models/vintagethief/rocky.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/citizens/twoozy.mdl", "cellarMale")


ix.anim.SetModelClass("models/vintagethief/f4_rebel.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/zimmerman.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/ksenax_bo.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/328.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/vintagethief/415.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/vintagethief/moore.mdl", "cellarMaleMPF")

ix.anim.SetModelClass("models/vintagethief/winter.mdl", "cellarMaleMPF")

ix.anim.SetModelClass("models/vintagethief/fluod.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/retribution/retribution_fem.mdl", "cellarFemale") 
ix.anim.SetModelClass("models/vintagethief/retribution/retribution_men.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/lemay.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/hazmat_worker.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/hazmat_armor.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/vertexsecond.mdl", "cellarMale")

--why zoutlands update's uniform was never writed in animations... why? WHY??

ix.anim.SetModelClass("models/cellar/characters/hazmat/medic_male.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/hazmat/medic_female.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/hazmat/hazard_male.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/hazmat/hazard_female.mdl", "cellarFemale")

ix.anim.SetModelClass("models/vintagethief/hunk.mdl", "cellarMaleMPF")

ix.anim.SetModelClass("models/cellar/characters/ciri.mdl", "cellarFemale")

ix.anim.SetModelClass("models/vintagethief/leon_fem.mdl", "cellarFemale")
ix.anim.SetModelClass("models/vintagethief/leon_battle.mdl", "cellarFemale")

ix.anim.SetModelClass("models/vintagethief/teresa.mdl", "cellarFemale")
ix.anim.SetModelClass("models/earl_krutoi/female_oberg.mdl", "cellarFemale")
ix.anim.SetModelClass("models/yan/bebra.mdl", "cellarMale")

ix.anim.SetModelClass("models/vintagethief/kenneth.mdl", "cellarMale")

ix.anim.SetModelClass("models/cellar/characters/riff.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/vintagethief/f_stkerokik.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/vintagethief/guomindang/guomindang_female_01.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/vintagethief/guomindang/guomindang_female_02.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/vintagethief/guomindang/guomindang_male_01.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/vintagethief/guomindang/guomindang_male_02.mdl", "cellarMale")

ix.anim.SetModelClass("models/cellar/characters/rolton.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/metropolice/male/cca_male_6664.mdl", "cellarMaleMPF")

ix.anim.SetModelClass("models/cellar/blum.mdl", "cellarFemale")

ix.anim.SetModelClass("models/vintagethief/natsume.mdl", "cellarFemale")
ix.anim.SetModelClass("models/vintagethief/spencer.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/vertex.mdl", "cellarMale")

ix.anim.SetModelClass("models/vintagethief/graham.mdl", "cellarMale")

ix.anim.SetModelClass("models/cellar/characters/larin.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/hellmodel.mdl", "cellarFemale")

ix.anim.SetModelClass("models/cellar/custom/metropolice/guard.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/custom/metropolice/boar_team.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/custom/metropolice/boar_team_female.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/vintagethief/shein.mdl", "cellarMale")

ix.anim.SetModelClass("models/cellar/characters/tno/officer_1.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_2.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_3.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_4.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_5.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_6.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_7.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_8.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_9.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_10.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_11.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_12.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_13.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_14.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_15.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_16.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_17.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_18.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_female_14.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_female_2.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_female_7.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_shultz.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_bauman.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/anonymous_m9.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/anonymous_f8.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/zhung.mdl", "cellarOTA")
ix.anim.SetModelClass("models/cellar/characters/avery.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/custom/metropolice/guard_female.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cellar/custom/metropolice/guard.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/vintagethief/mai.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/tno/officer_female_1.mdl", "cellarFemale")
ix.anim.SetModelClass("models/vintagethief/bjorn.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/allcaps.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/custom/ac_female.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/custom/ac_male.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/custom/ac_male_atomanik.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/custom/ac_male_themask.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/custom/odin_male.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/vintagethief/alberto.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/russians_arctic.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/olive.mdl", "cellarFemale")
ix.anim.SetModelClass("models/vintagethief/citizens/f_doming.mdl", "cellarFemale")
ix.anim.SetModelClass("models/florensio/florensio.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/vikar.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/metropolice/female/cca_female_lalalar.mdl", "cellarFemaleMPF")
ix.anim.SetModelClass("models/cultist.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/male/c3_varg.mdl", "cellarMale")
ix.anim.SetModelClass("models/vintagethief/f_garo.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/pla/male/male_pla.mdl", "cellarOTA")
ix.anim.SetModelClass("models/cellar/characters/city3/pla/female/female_pla.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/custom/ac_female_lalalar.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/vintagethief/characters/male/delta_john.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/vintagethief/characters/male/dorin.mdl", "cellarMale")
ix.anim.SetModelClass("models/frostofan4ik/russians_arctic.mdl", "cellarMale")
ix.anim.SetModelClass("models/leeetov/borz_f.mdl", "cellarMale")
ix.anim.SetModelClass("models/suits/black_gloves.mdl","cellarMale")
ix.anim.SetModelClass("models/custom/male_black_gloves.mdl", "cellarMale")
ix.anim.SetModelClass("models/custom/female_black_gloves.mdl", "cellarFemale")
ix.anim.SetModelClass("models/cellar/characters/city3/citizens/custom/graham_new.mdl", "cellarMale")
ix.anim.SetModelClass("models/cellar/custom/valk_male.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/custom/valk_female", "cellarFemaleMPF")
ix.anim.SetModelClass("models/custom/bodyguard/male_01.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/custom/bodyguard/male_02.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/custom/bodyguard/male_03.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/custom/m_contractor.mdl", "cellarMale")
ix.anim.SetModelClass("models/berkutcit/c3_berkut.mdl", "cellarMale")
ix.anim.SetModelClass("models/metropolice/cca_male/cca_berkut.mdl", "cellarMaleMPF")
ix.anim.SetModelClass("models/cellar/characters/vintagethief/iq.mdl", "cellarFemale")