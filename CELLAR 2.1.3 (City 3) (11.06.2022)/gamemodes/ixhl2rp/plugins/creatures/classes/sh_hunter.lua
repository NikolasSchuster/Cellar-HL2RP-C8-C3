-- luacheck: globals CLASS_HUNTER

CLASS.name = "Hunter"
CLASS.color = Color(200, 80, 80, 255);
CLASS.faction = FACTION_SYNTH;
CLASS.isDefault = true;
CLASS.description = "Hunter. Bark bark.";
CLASS.defaultPhysDesc = "Big hunter kill rebels.";
CLASS.prefix = "HNT-";
CLASS.infoTable = {
	hull = Vector(40, 40, 90),
	anims = {
		idle = "idle1",
		walk = "walk_all",
		run = "canter_all",
		jump = "jump",
		glide = "jump_idle",
		melee1 = "meleeleft",
		melee2 = "meleert",
		melee3 = "melee_02",
		shoot_loop = "shoot_unplanted",
		shoot_stop = "unplant",
		charge_loop = "charge_loop",
		charge_hit = "charge_miss_slide",
		charge_stop = "charge_miss_slide",
		charge_start = "charge_start",
		bark = "hunter_respond_1"
	},

	sounds = {
		melee = "NPC_Hunter.MeleeAnnounce",
		melee_hit = "NPC_Hunter.MeleeHit",
		shoot = "NPC_Hunter.FireMinigun",
		step = "NPC_Hunter.Footstep",
		charge_hit = "NPC_Hunter.ChargeHitEnemy",
		pain = "NPC_Hunter.Pain",
		die = "NPC_Hunter.Death",
		idle = "NPC_Hunter.Idle",
		idle_delay = {20, 50},
		scan = {
			"NPC_Hunter.Scan",
			"NPC_Hunter.FoundEnemyAck"
		}
	},

	attack = {
		func = function(player, info)
			player:SoundEvent("shoot", true)
			local flechette = ents.Create("hunter_flechette");
			local attPos = player:EyePos();
			local trace = util.TraceLine({
				start = attPos,
				endpos = player:GetEyeTrace().HitPos,
				filter = {player}
			});

			local normAng = trace.Normal:Angle();

			flechette:SetPos(attPos);
			flechette:SetVelocity(trace.Normal * 2000 + VectorRand() * 10);
			flechette:SetAngles(normAng);
			flechette:SetOwner(player);
			flechette:Spawn();

			net.Start("HunterMuzzle")
				net.WriteEntity(player)
			net.Broadcast()
		end,

		canAttackInAir = true,
		delay = 0.12
	},

	attack2 = {
		anims = 3,
		delay = .45,
		range = 120,
		dmg = 300,
		dmgType = DMG_DIRECT
	},

	reload = function(player, info)
		if ((player.nextBark or 0) < CurTime()) then
			player:ForceSequence("hunter_respond_1", nil, 1, true);
			player.nextBark = CurTime() + 2;
		end;
	end,

	flashlight = function(player, info)
		if (player:GetNetVar("ChargeTime", 0) == 0 and player:OnGround()) then
			player:ForceSequence("charge_start", function(client)
				client:SetNetVar("ChargeTime", CurTime() + 4);
				client:ForceSequence("charge_loop", nil, nil, true);
			end, 1.4, true);
		else
			player:SetNetVar("ChargeTime", nil);
			player:ForceSequence(nil);
			player:ForceSequence("charge_miss_slide", nil, 1.2, true);
		end;
	end,

	think = function(player, info)
		if (player:GetNetVar("ChargeTime", 0) ~= 0) then
			if (player:OnGround()) then
				local charge = info.charge;
				local angs = Angle(0, player:EyeAngles().y, 0):Forward();
				local attack = player:TraceHullAttack(player:GetPos() + Vector(0, 0, 21), player:GetPos() + Vector(0, 0, 21) + angs * 100, Vector(-30, -30, -20), Vector(30, 30, 20), charge.dmg, DMG_CRUSH, charge.launch or 1, true)

				local hullTrace = util.TraceHull({
					start = player:GetPos() + Vector(0, 0, 40),
					endpos = player:GetPos() + Vector(0, 0, 40) + angs * 70,
					mins = Vector(-30, -30, 0),
					maxs = Vector(30, 30, 20),
					filter = player
				});

				if (IsValid(attack)) then
					attack:SetGroundEntity(nil);
					attack:SetVelocity(player:GetVelocity():GetNormalized() * (charge.launch or 1) + Vector(0, 0, 200));
					player:ForceSequence(nil);
					player:ForceSequence("charge_miss_slide", nil, 1.2, true);
					player:SoundEvent("charge_hit");
					player:SetNetVar("ChargeTime", nil);
					return;
				else
					if (hullTrace.Hit) then
						player:ForceSequence(nil);
						player:ForceSequence("charge_crash", nil, 2);
						player:SetNetVar("ChargeTime", nil);
						return;
					end;
				end;
			else
				player:SetNetVar("ChargeTime", nil);
			end;
		end;
	end,

	moveSpeed = {
		walk = 300,
		run = 400
	},

	charge = {
		vel = 1100,
		delay = 1.4,
		dmg = 100,
		launch = 600
	},

	jumpPower = 450,
	health = 750,
	armor = 750,
	noFallDamage = true,

	camera = {
		offset = Vector(0, 0, 80),
	},

	bNoFlashlight = true
};

CLASS_HUNTER = CLASS.index
