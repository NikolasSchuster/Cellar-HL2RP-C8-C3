-- luacheck: globals CLASS_FASTHEADCRAB

CLASS.name = "Fast Headcrab"
CLASS.color = Color(200, 80, 80, 255);
CLASS.faction = FACTION_ZOMBIE;
CLASS.model = "models/headcrab.mdl";
CLASS.isDefault = false;
CLASS.description = "A bony creature gifted with speed.";
CLASS.defaultPhysDesc = "A bony creature gifted with speed.";
CLASS.infoTable = {
	health = 25,

	camera = {
		offset = Vector(0, 0, 10),
		dist = 75
	},

	hull = Vector(20, 20, 10),

	sounds = {
		attack = "NPC_FastHeadcrab.Attack",
		bite = "NPC_FastHeadcrab.Bite",
		pain = "NPC_FastHeadcrab.Pain",
		die = "NPC_FastHeadcrab.Die",
		idle = "NPC_FastHeadcrab.Idle",
		idle_delay = {5, 7},
		step = "NPC_BlackHeadcrab.FootstepWalk"
	},

	immunities = {
		DMG_ACID,
		DMG_NERVEGAS,
		DMG_PARALYZE,
		DMG_POISON,
		DMG_RADIATION
	},

	jump = {
		delay = 1.5,
		func = function(player, moveData, infoTable)
			local v = player:EyeAngles():Forward();
				v.z = math.max(v.z / 2, 0);
			moveData:SetVelocity(v * 400);
			player:SoundEvent("attack");
			player.canBite = true;

			player:ForceSequence(false)
			player:ForceSequence("attack", nil, 1, true)
		end
	},

	glideThink = function(player, infoTable)
		if (player.canBite) then
			local aim = player:GetAimVector();
			aim.z = 0;
			aim:Normalize();

			local trace = util.TraceHull({
				start = player:EyePos(),
				endpos = player:EyePos() + aim * 20 - Vector(0, 0, 5),
				filter = player,
				mins = Vector(-8, -8, -8),
				maxs = Vector(8, 8, 8)
			});

			if (IsValid(trace.Entity)) then
				local crabbed = trace.Entity;

				if (crabbed:IsNPC() or crabbed:IsPlayer()) then
					player:SoundEvent("bite");
				end;

				crabbed:TakeDamage(7, player, player);

				player.canBite = nil;
			end;
		end;
	end,

	land = function(player, infoTable)
		player.canBite = nil;
		player:ForceSequence(false)
	end,

	moveSpeed = {
		walk = 120,
		run = 250
	},

	noFallDamage = true,

	jumpPower = 200
}

CLASS_FASTHEADCRAB = CLASS.index