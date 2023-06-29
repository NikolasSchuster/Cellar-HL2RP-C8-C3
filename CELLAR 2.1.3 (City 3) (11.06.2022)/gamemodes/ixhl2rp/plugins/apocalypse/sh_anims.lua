ix.anim.zombie2 = {
	["normal"] = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_GMOD_GESTURE_RANGE_ZOMBIE
	},
	["pistol"] = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_GMOD_GESTURE_RANGE_ZOMBIE
	},
	["smg"] = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_GMOD_GESTURE_RANGE_ZOMBIE
	},
	["shotgun"] = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_GMOD_GESTURE_RANGE_ZOMBIE
	},
	["grenade"] = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_GMOD_GESTURE_RANGE_ZOMBIE
	},
	["melee"] = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_GMOD_GESTURE_RANGE_ZOMBIE
	}
}

local zombie_models = {
	"models/freshdead/freshdead_05.mdl",
	"models/freshdead/freshdead_06.mdl",
	"models/freshdead/freshdead_07.mdl",
	"models/freshdead/freshdead_05.mdl",
	"models/freshdead/freshdead_06.mdl",
	"models/freshdead/freshdead_05.mdl",
	"models/freshdead/freshdead_06.mdl",
	"models/freshdead/freshdead_05.mdl",
	"models/freshdead/freshdead_05.mdl",
	"models/freshdead/freshdead_06.mdl",
	"models/freshdead/freshdead_05.mdl",
	"models/freshdead/freshdead_07.mdl",
	"models/freshdead/freshdead_07.mdl",
	"models/freshdead/freshdead_07.mdl",
	"models/freshdead/freshdead_05.mdl",
	"models/freshdead/freshdead_06.mdl",
	"models/freshdead/freshdead_01.mdll",
	"models/freshdead/freshdead_02.mdl",
	"models/freshdead/freshdead_03.mdl",
	"models/freshdead/freshdead_04.mdl",
	"models/zombie/grabber_06.mdl",
	"models/zombie/seeker_02.mdl",
	"models/zombie/grabber_08.mdl",
	"models/zombie/junkie_03.mdl",
	"models/zombie/grabber_10.mdl",
	"models/zombie/grabber_07.mdl",
	"models/zombie/infected_07.mdl",
	"models/zombie/grabber_03.mdl",
	"models/zombie/grabber_06.mdl",
	"models/corrupt/zombie_02.mdl",
	"models/zombie/infected_12.mdl",
	"models/infected/new_infected_01.mdl",
	"models/zombie/grabber_09.mdl",
	"models/zombie/grabber_05.mdl"
}

for _, v in ipairs(zombie_models) do
	ix.anim.SetModelClass(v, "zombie2")
end