-- luacheck: globals CLASS_ZOMBINE

CLASS.name = "Zombine"
CLASS.color = Color(200, 80, 80, 255);
CLASS.faction = FACTION_ZOMBIE;
CLASS.model = "models/zombie/zombie_soldier.mdl";
CLASS.isDefault = false;
CLASS.description = "A zombine.";
CLASS.defaultPhysDesc = "A zombine.";
CLASS.infoTable = {
	health = 200,
	armor = 200,

	camera = {
		offset = Vector(0, 0, 60),
	},

	anims = {
		attack = "FastAttack"
	},

	attack = {
		delay = 0.2,
		dmg = 45,
		range = 70
	},

	sounds = {
		melee = false,
		melee_hit = "Zombie.AttackHit",
		melee_miss = "Zombie.AttackMiss",
		nade = "Zombine.ReadyGrenade",
		step = {"Zombine.ScuffRight", "Zombine.ScuffLeft", "Zombie.FootstepRight", "Zombie.FootstepLeft"},
		idle = "Zombine.Idle",
		idle_delay = {10, 25},
		pain = "Zombine.Pain",
		die = "Zombine.Die"
	},

	immunities = {
		DMG_ACID,
		DMG_DROWN,
		DMG_NERVEGAS,
		DMG_PARALYZE,
		DMG_POISON,
		DMG_RADIATION
	},

	moveSpeed = {
		walk = 40,
		run = 180
	},

	attack2 = {
		func = function(player, infoTable)
			if (!player.hasNade) then
				player:ForceSequence("pullGrenade", nil, 1.1666666550769);

				player:SoundEvent("nade");
				player.hasNade = true;

				player:GetActiveWeapon().NeverRaised = false;
				player:SetWepRaised(true)

				timer.Simple(1, function()
					if (IsValid(player)) then
						player:EmitSound("Zombine.Charge")
					end;
				end);

				player.nade = ents.Create("npc_grenade_frag")
				player.nade:SetPos(player:GetPos())
				player.nade:SetParent(player);
				player.nade:Spawn();
				player.nade:Fire("setparentattachment", "grenade_attachment", 0);
				player.nade:Fire("SetTimer", "4", 0);
				player.nade:CallOnRemove("NadeSplodeKillPlayer", function()
					if (IsValid(player) and player:Alive()) then
						player.hasNade = false;
						player.nade = nil;
						player:Kill();
					end;
				end);
			end;
		end;
	},

	onDeath = function(player, infoTable, attacker)
		if (player.hasNade and IsValid(player.nade)) then
			player.nade:SetParent(nil);
			player.nade:PhysicsInit(SOLID_VPHYSICS);
			player.hasNade = false;
			player.nade = nil;
		end;
	end,

	jumpPower = 180
}

CLASS_ZOMBINE = CLASS.index
