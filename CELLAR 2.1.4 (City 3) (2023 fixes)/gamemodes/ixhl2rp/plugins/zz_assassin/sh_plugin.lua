local PLUGIN = PLUGIN
PLUGIN.name = "Combine Assassin"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

ix.anim.assassin = {
	normal = {
		[ACT_MP_STAND_IDLE] = {"idle_relaxed", "idle_relaxed"},
		[ACT_MP_CROUCH_IDLE] = {"crouch_idle_relaxed", "crouch_idle_relaxed"},
		[ACT_MP_WALK] = {"walk_relaxed", "walk_relaxed"},
		[ACT_MP_CROUCHWALK] = {"crouch_walk_relaxed", "crouch_walk_relaxed"},
		[ACT_MP_RUN] = {"run_relaxed", "run_relaxed"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
		glide = "jump_relaxed",
		sit = ACT_BUSY_SIT_CHAIR,
		prone_walk = {"prone_walk_relaxed", "prone_walk_relaxed"},
		prone_idle = {"prone_idle_relaxed", "prone_idle_relaxed"},
	},
	arccw_ospr = {
		[ACT_MP_STAND_IDLE] = {"idle_relaxed", "idle_relaxed"},
		[ACT_MP_CROUCH_IDLE] = {"crouch_idle_relaxed", "crouch_idle_relaxed"},
		[ACT_MP_WALK] = {"walk_relaxed", "walk_relaxed"},
		[ACT_MP_CROUCHWALK] = {"crouch_walk_relaxed", "crouch_walk_relaxed"},
		[ACT_MP_RUN] = {"run_relaxed", "run_relaxed"},
		attack = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
		glide = "jump_relaxed",
		sit = ACT_BUSY_SIT_CHAIR,
		prone_walk = {"prone_walk_relaxed", "prone_walk_relaxed"},
		prone_idle = {"prone_idle_ospr_relaxed", "prone_idle_ospr_angry"},
	},
	/*pistol = {

	},
	smg = {

	},
	ar2 = {

	},
	knife = {

	},
	shotgun = {

	},
	grenade = {

	},
	melee = {

	},
	rpg = {

	},
	*/
	glide = ACT_GLIDE,
	vehicle = {
		["prop_vehicle_prisoner_pod"] = {"podpose", Vector(-3, 0, 0)},
		["prop_vehicle_jeep"] = {ACT_BUSY_SIT_CHAIR, Vector(14, 0, -14)},
		["prop_vehicle_airboat"] = {ACT_BUSY_SIT_CHAIR, Vector(8, 0, -20)},
		chair = {"stances_sit02", Vector(10, 0, -19)}
	}
}

ix.anim.SetModelClass("models/schwarzkruppzo/assassin.mdl", "assassin")