-- luacheck: globals CLASS_POISONHEADCRAB

local attackDelay = 1.35

CLASS.name = "Poison Headcrab"
CLASS.color = Color(200, 80, 80, 255);
CLASS.faction = FACTION_ZOMBIE;
CLASS.model = "models/headcrabblack.mdl";
CLASS.isDefault = false;
CLASS.wagesName = "Supplies";
CLASS.description = "A furry headcrab, reminiscent of a tarantula.";
CLASS.defaultPhysDesc = "A furry headcrab, reminiscent of a tarantula.";
CLASS.infoTable = {
	health = 60,

	camera = {
		offset = Vector(0, 0, 10),
		dist = 75
	},

	hull = Vector(20, 20, 10),

	sounds = {
		rattle = "NPC_BlackHeadcrab.AlertVoice",
		scream = "NPC_BlackHeadcrab.Telegraph",
		jump = "NPC_BlackHeadcrab.Attack",
		bite = "NPC_BlackHeadcrab.Bite",
		pain = "NPC_BlackHeadcrab.Pain",
		die = "NPC_BlackHeadcrab.Die",
		idle = "NPC_BlackHeadcrab.Idle",
		idle_delay = {6, 8},
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
		delay = attackDelay + 2,
		func = function(player, moveData, infoTable)
			player:SoundEvent("scream");

			player.canBite = true;
			player:ForceSequence(false);
			player:ForceSequence("tele_attack_a", nil, 2.5, true);

			timer.Simple(attackDelay, function()
				if (!IsValid(player) or !player:Alive() or !player:OnGround()) then return; end;

				local v = player:EyeAngles():Forward();
				v.z = math.max(v.z / 2, 0);

				player:SoundEvent("jump");
				player:SetGroundEntity(nil);
				player:SetVelocity(v * 400 + Vector(0, 0, 300));
				player.canBite = true;
			end);
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

				local dmgInfo = DamageInfo();
				dmgInfo:SetDamage(100);
				dmgInfo:SetDamageType(DMG_POISON);
				dmgInfo:SetAttacker(player);
				dmgInfo:SetInflictor(player);

				crabbed:TakeDamageInfo(dmgInfo);

				player.canBite = nil;
			end;
		end;
	end,

	moveSpeed = {
		walk = 40,
		run = 40
	},

	land = function(player, infoTable)
		player.canBite = nil;
		player:ForceSequence(false);
	end,

	noFallDamage = true,

	jumpPower = 0
}

CLASS_POISONHEADCRAB = CLASS.index
