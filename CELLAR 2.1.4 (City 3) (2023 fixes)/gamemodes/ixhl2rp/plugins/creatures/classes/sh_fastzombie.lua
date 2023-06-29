-- luacheck: globals CLASS_FASTZOMBIE

local attackDelay2 = 0.5

CLASS.name = "Fast Zombie"
CLASS.color = Color(200, 80, 80, 255);
CLASS.faction = FACTION_ZOMBIE;
CLASS.model = "models/zombie/fast.mdl";
CLASS.isDefault = false;
CLASS.description = "A zombie.";
CLASS.defaultPhysDesc = "A zombie.";
CLASS.infoTable = {
	health = 100,

	anims = {
		idle = "idle",
		walk = "walk_all",
		run = "Run",
		jump = "leap_start",
		glide = "leap_loop",
		jump_attack = "leap",
		glide_attack = "leapstrike",
		attack = "Melee",
		climb = "climbloop",
		climb_start = "climbmount",
		release = "br2_roar"
	},

	attack = {
		delay = 0.2,
		func = function(player, infoTable)
			if (!player:IsOnGround() or player:GetVelocity():Length() > 1) then return; end;

			if (!player.ixAnimating) then
				player:ForceSequence("Melee", function()
					player.ixAnimating = nil
				end);
			end;

			if ((player.ixLastAttack or 0) < CurTime()) then
				if (player:TraceHullAttack(player:EyePos(), player:EyePos() + player:EyeAngles():Forward() * 40, Vector(-10, -10, -10), Vector(10, 10, 10), 10, DMG_SLASH, 1, true)) then
					player:SoundEvent("melee_hit");
				else
					player:SoundEvent("melee_miss");
				end;

				player.ixLastAttack = CurTime() + 0.3;
			end;

			if ((player.ixLastAttackSound or 0) < CurTime()) then
				player:SoundEvent("attack");
				player.ixLastAttackSound = CurTime() + 2;
			end;
		end;
	},

	attack2 = {
		delay = attackDelay2,
		canAttackInAir = true,
		func = function(player, infoTable)
			local start = player:GetPos() + Vector(0, 0, 10)
			local dir = player:GetAimVector()
			dir.z = 0
			dir:Normalize()
			local tracedata = {}
			tracedata.start = start
			tracedata.endpos = start + dir * 20
			tracedata.filter = player
			tracedata.mins = Vector(-8, -8, -8)
			tracedata.maxs = Vector(8, 8, 8)

			if (util.TraceHull(tracedata).Hit) then
				if (player:IsOnGround()) then
					player:SetVelocity(Vector(0, 0, 150))
					player:ForceSequence("climbmount", nil, 1, true);
				end;

				player:SetVelocity(Vector(0, 0, 310))

				if (!player.ixAnimating) then
					player:ForceSequence("climbloop", nil, nil, true);
					player.ixAnimating = true;

					timer.Simple(attackDelay2, function()
						player.ixAnimating = nil
					end)
				end;
			else
				player:ForceSequence(false);
				player.ixAnimating = nil;
			end;
		end;
	},

	sounds = {
		loop_move = "NPC_FastZombie.Moan1",
		move_pitch = 35,
		jump = "NPC_FastZombie.Scream",
		attack = "NPC_FastZombie.Frenzy",
		melee_hit = "NPC_FastZombie.AttackHit",
		melee_miss = "NPC_FastZombie.AttackMiss",
		step = {"NPC_FastZombie.GallopLeft", "NPC_FastZombie.GallopRight"},
		pain = "NPC_FastZombie.Die",
		die = "NPC_FastZombie.Die",
		idle = "NPC_FastZombie.Idle"
	},

	noFallDamage = true,

	jump = {
		delay = 2,
		func = function(player, moveData, infoTable)
			local v = player:EyeAngles():Forward()
			v:Normalize()
			player:SetGroundEntity(nil)
			moveData:SetVelocity(v * 650 + Vector(0, 0, 220));
			player.canAttack = true;
			player:SoundEvent("jump");
			player:ForceSequence("LeapStrike", nil, nil, true);
		end
   	},

	glideThink = function(player, infoTable)
		if (player.canAttack) then
			local attack = player:TraceHullAttack(player:EyePos(), player:EyePos() + player:EyeAngles():Forward() * 50,  Vector(-20,-20,-20),  Vector(20,20,20), 20, DMG_SLASH, 1, true);

			if (IsValid(attack)) then
				if (attack:IsPlayer() or attack:IsNPC()) then
					attack:SetVelocity(player:GetVelocity():GetNormalized() * 300);
				end

				attack:SetVelocity(player:GetVelocity():GetNormalized() * 300);
				player:SoundEvent("melee_hit");
				player.canAttack = nil;
			end;
		end;
	end,

	land = function(player, infoTable)
		player.nextLeap = CurTime() + 1;
		player.canAttack = nil;
		player:ForceSequence(false);
	end,

	moveSpeed = {
		run = 280,
		walk = 30
	},

	jumpPower = 200
}

CLASS_FASTZOMBIE = CLASS.index
