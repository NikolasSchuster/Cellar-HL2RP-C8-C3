local PLUGIN = PLUGIN

PLUGIN.name = "Vortigaunts"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

ix.anim.cellarVort = {
	melee = {
		["attack"] = ACT_MELEE_ATTACK1,
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "ActionIdle"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_AIM},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM},
	},
	grenade = {
		["attack"] = ACT_MELEE_ATTACK1,
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "ActionIdle"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK}
	},
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_ANGRY},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		["attack"] = ACT_MELEE_ATTACK1
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "TCidlecombat"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		["reload"] = ACT_IDLE,
		[ACT_MP_RUN] = {ACT_RUN, "run_all_TC"},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, "Walk_all_TC"}
	},
	shotgun = { -- beam
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_ANGRY},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, "run_all"},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, "walk_all"},
		[ACT_MP_WALK] = {ACT_WALK, "walk_all"},
		["attack"] = ACT_GESTURE_RANGE_ATTACK1,
		["reload"] = ACT_IDLE,
		["glide"] = {ACT_RUN, ACT_RUN}
	},
	smg = { -- broom
		[ACT_MP_STAND_IDLE] = {"sweep_idle", "sweep_idle"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {"run_all", "run_all"},
		[ACT_MP_CROUCHWALK] = {"walk_all_holdbroom", "walk_all_holdbroom"},
		[ACT_MP_WALK] = {"walk_all_holdbroom", "walk_all_holdbroom"},
		["glide"] = {ACT_RUN, ACT_RUN}
	},
	glide = "jump_holding_glide",
	vehicle = {
		prop_vehicle_airboat = {ACT_COVER_PISTOL_LOW, Vector(10, 0, 0)},
		prop_vehicle_jeep = {ACT_COVER_PISTOL_LOW, Vector(18, -2, 4)},
		prop_vehicle_prisoner_pod = {ACT_IDLE, Vector(-4, -0.5, 0)},
		chair = {"chess_wait", Vector(20, 0, -19)}
	}
}

ix.anim.SetModelClass("models/vortigaunt.mdl", "cellarVort")
ix.anim.SetModelClass("models/vortigaunt_slave.mdl", "cellarVort")
ix.anim.SetModelClass("models/vortigaunt_blue.mdl", "cellarVort")
ix.anim.SetModelClass("models/vortigaunt_doctor.mdl", "cellarVort")

ix.util.Include("sv_plugin.lua")