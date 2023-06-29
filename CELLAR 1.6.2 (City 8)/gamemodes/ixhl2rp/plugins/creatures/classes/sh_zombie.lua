-- luacheck: globals CLASS_REGULARZOMBIE

CLASS.name = "Zombie"
CLASS.color = Color(200, 80, 80, 255);
CLASS.faction = FACTION_ZOMBIE;
CLASS.model = "models/zombie/classic.mdl";
CLASS.isDefault = true;
CLASS.description = "A zombie.";
CLASS.defaultPhysDesc = "A zombie.";
CLASS.infoTable = {
	health = 200,

	camera = {
		offset = Vector(0, 0, 60),
		dist = 70
	},

	anims = {
		melee1 = "attackA",
		melee2 = "attackB",
		melee3 = "attackC",
		melee4 = "attackD",
		melee5 = "attackE",
		melee6 = "attackF"
	},

	attack = {
		anims = 6,
		delay = 0.8,
		range = 80,
		dmg = 30
	},

	immunities = {
		DMG_ACID,
		DMG_DROWN,
		DMG_NERVEGAS,
		DMG_PARALYZE,
		DMG_POISON,
		DMG_RADIATION
	},

	sounds = {
		melee = "Zombie.Attack",
		melee_hit = "Zombie.AttackHit",
		melee_miss = "Zombie.AttackMiss",
		step = {"Zombie.FootstepLeft", "Zombie.FootstepRight"},
		pain = "Zombie.Pain",
		die = "Zombie.Die",
		idle = "Zombie.Idle",
		idle_delay = {3, 6}
	},

	moveSpeed = {
		walk = 50,
		run = 50
	},

	jumpPower = 180,
	duckBy = 0
}

CLASS_REGULARZOMBIE = CLASS.index
