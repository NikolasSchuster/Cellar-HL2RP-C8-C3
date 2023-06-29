-- luacheck: globals CLASS_REGULARHEADCRAB

CLASS.name = "Headcrab"
CLASS.color = Color(200, 80, 80, 255);
CLASS.faction = FACTION_ZOMBIE;
CLASS.isDefault = false;
CLASS.model = "models/headcrabclassic.mdl";
CLASS.description = "A headcrab.";
CLASS.defaultPhysDesc = "A headcrab.";
CLASS.infoTable = {
	camera = {
		offset = Vector(0, 0, 10),
		dist = 75
	},

	hull = Vector(20, 20, 10),

	sounds = {
		jump = "NPC_HeadCrab.Attack",
		bite = "NPC_HeadCrab.Bite",
		burrow_in = "NPC_Headcrab.BurrowIn",
		burrow_out = "NPC_Headcrab.BurrowOut",
		step = "NPC_BlackHeadcrab.FootstepWalk",
		pain = "NPC_HeadCrab.Pain",
		die = "NPC_HeadCrab.Die",
		idle = "NPC_Headcrab.Idle",
		idle_delay = {10, 20}
	},

	immunities = {
		DMG_ACID,
		DMG_NERVEGAS,
		DMG_PARALYZE,
		DMG_POISON,
		DMG_RADIATION
	},

	moveSpeed = {
		walk = 30,
		run = 60
	},

	noFallDamage = true,

	jumpPower = 200,

	jump = {
		delay = 2,
		func = function(player, moveData, infoTable)
			local v = player:EyeAngles():Forward();
			v.z = math.max(v.z / 2, 0);
			moveData:SetVelocity(v * 300);
			player:SoundEvent("jump");
			player.canBite = true;
			player:ForceSequence(false);
			player:ForceSequence("jumpattack_broadcast", nil, 1, true);
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

				crabbed:TakeDamage(12, player, player);

				player.canBite = nil;
			end;
		end;
	end,

	land = function(player, infoTable)
		player.canBite = nil;
		player:ForceSequence(false);
	end,

	health = 40;
}

CLASS_REGULARHEADCRAB = CLASS.index
