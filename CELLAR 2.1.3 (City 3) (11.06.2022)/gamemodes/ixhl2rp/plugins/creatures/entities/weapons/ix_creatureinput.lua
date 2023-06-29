if (SERVER) then
	AddCSLuaFile()
end

if (CLIENT) then
	SWEP.Slot = 3
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.PrintName = "Creature Abilities"
	SWEP.DrawCrosshair = false;
end;

SWEP.Instructions = ""
SWEP.Purpose = "Captures user input and reacts according to their class' abilities."
SWEP.Contact = ""
SWEP.Author	= "Zombine"

SWEP.WorldModel = "";
SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl";

SWEP.HoldType = "normal";

SWEP.Category = "Special";
SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo = "none";

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none";

SWEP.FireWhenLowered = true
SWEP.NeverRaised = true

SWEP.NoIronSightFovChange = true
SWEP.NoIronSightAttack = true
SWEP.IronSightPos = Vector(0, 0, 0)
SWEP.IronSightAng = Vector(0, 0, 0)

-- Called when the SWEP is initialized.
function SWEP:Initialize()
	self:SetWeaponHoldType("normal");
end;

function SWEP:Holster(wep)
	return true;
end;

function SWEP:Deploy()
	local owner = self:GetOwner()
	owner.infoTable = nil;
	local infoTable = owner:GetClassTable();

	if (infoTable) then
		self.infoTable = table.Copy(infoTable);
	end

	return true;
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()

	if (CLIENT) then return; end;
	if (!owner:IsOnGround() and (istable(self.infoTable.attack) and !self.infoTable.attack.canAttackInAir)) then return; end;
	if (!IsFirstTimePredicted()) then return; end;
	if (!self.infoTable) then return; end;

	local direction = Angle(0, owner:EyeAngles().y, 0):Forward();

	if (self.infoTable.attack and self.infoTable.attack.func) then
		self.infoTable.attack.func(owner, self.infoTable);
		self:SetNextPrimaryFire(CurTime() + (self.infoTable.attack.delay or 1));

		owner.ixCouldShoot = true
		owner:SetNetVar("canShoot", true)
	elseif (self.infoTable.attack) then
		local anims = self.infoTable.anims;
		local animNum = self.infoTable.attack.anims and math.random(self.infoTable.attack.anims) or nil;
		local anim = anims[animNum and ("melee" .. animNum) or "attack"];
		local _, duration = owner:LookupSequence(anim);

		self:SetNextPrimaryFire(CurTime() + duration);

		owner:SetLocalVelocity(vector_origin);
		owner:SetMoveType(MOVETYPE_NONE);
		owner:ForceSequence(false);
		owner:ForceSequence(anim, nil, duration * 0.89, true);

		owner:SoundEvent("melee");

		if (self.infoTable.attack.delay) then
			timer.Simple(self.infoTable.attack.delay, function()
				if (!IsValid(owner)) then return; end;
				local attack = owner:TraceHullAttack(owner:EyePos(), owner:EyePos() + owner:EyeAngles():Forward() * self.infoTable.attack.range, Vector(-10, -10, -10), Vector(10, 10, 10), self.infoTable.attack.dmg, self.infoTable.attack.dmgType or DMG_SLASH, 1, true);

				if (IsValid(attack)) then
					if (self.infoTable.attack.launch) then
						attack:SetGroundEntity(nil);
						attack:SetVelocity(direction * self.infoTable.attack.launch + Vector(0, 0, self.infoTable.attack.launchUp or 30));
					end;

					owner:SoundEvent("melee_hit");
				else
					owner:SoundEvent("melee_miss");
				end;
			end);
		else
			if (!IsValid(owner)) then return; end;
			local attack = owner:TraceHullAttack(owner:EyePos(), owner:EyePos() + owner:EyeAngles():Forward() * self.infoTable.attack.range, Vector(-10, -10, -10), Vector(10, 10, 10), self.infoTable.attack.dmg, self.infoTable.attack.dmgType or DMG_SLASH, 1, true);

			if (IsValid(attack)) then
				if (self.infoTable.attack.launch) then
					attack:SetGroundEntity(nil);
					attack:SetVelocity(direction * self.infoTable.attack.launch + Vector(0, 0, self.infoTable.attack.launchUp or 30));
				end;

				owner:SoundEvent("melee_hit");
			else
				owner:SoundEvent("melee_miss");
			end;
		end;
	end;
end;

function SWEP:SecondaryAttack()
	local owner = self:GetOwner()

	if (!IsFirstTimePredicted()) then return; end;
	if (!self.infoTable) then return; end;
	if (CLIENT) then return; end;
	if (!owner:IsOnGround() and (istable(self.infoTable.attack2) and !self.infoTable.attack2.canAttackInAir)) then return; end;

	local direction = Angle(0, owner:EyeAngles().y, 0):Forward();

	if (self.infoTable.attack2 and self.infoTable.attack2.func) then
		self.infoTable.attack2.func(owner, self.infoTable);
		self:SetNextSecondaryFire(CurTime() + (self.infoTable.attack2.delay or 1));

		owner.ixCouldShoot = true
		owner:SetNetVar("canShoot", true)
	elseif (self.infoTable.attack2) then
		local anims = self.infoTable.anims;
		local animNum = self.infoTable.attack2.anims and math.random(self.infoTable.attack2.anims) or nil;
		local anim = anims[animNum and ("melee" .. animNum) or "attack"];
		local _, duration = owner:LookupSequence(anim);

		self:SetNextSecondaryFire(CurTime() + duration);

		owner:SetLocalVelocity(vector_origin);
		owner:SetMoveType(MOVETYPE_NONE);
		owner:ForceSequence(false);
		owner:ForceSequence(anim, nil, duration * 0.89, true);

		owner:SoundEvent("melee");

		if (self.infoTable.attack2.delay) then
			timer.Simple(self.infoTable.attack2.delay, function()
				if (!IsValid(owner)) then return; end;
				local attack = owner:TraceHullAttack(owner:EyePos(), owner:EyePos() + owner:EyeAngles():Forward() * self.infoTable.attack2.range, Vector(-10, -10, -10), Vector(10, 10, 10), self.infoTable.attack2.dmg, self.infoTable.attack2.dmgType or DMG_SLASH, 1, true);

				if (IsValid(attack)) then
					if (self.infoTable.attack2.launch) then
						attack:SetGroundEntity(nil);
						attack:SetVelocity(direction * self.infoTable.attack2.launch + Vector(0, 0, self.infoTable.attack2.launchUp or 30));
					end;

					owner:SoundEvent("melee_hit");
				else
					owner:SoundEvent("melee_miss");
				end;
			end);
		else
			if (!IsValid(owner)) then return; end;
			local attack = owner:TraceHullAttack(owner:EyePos(), owner:EyePos() + owner:EyeAngles():Forward() * self.infoTable.attack2.range, Vector(-10, -10, -10), Vector(10, 10, 10), self.infoTable.attack2.dmg, self.infoTable.attack2.dmgType or DMG_SLASH, 1, true);

			if (IsValid(attack)) then
				if (self.infoTable.attack2.launch) then
					attack:SetGroundEntity(nil);
					attack:SetVelocity(direction * self.infoTable.attack2.launch + Vector(0, 0, self.infoTable.attack2.launchUp or 30));
				end;

				owner:SoundEvent("melee_hit");
			else
				owner:SoundEvent("melee_miss");
			end;
		end;
	end;
end;

function SWEP:Reload()
	if (CLIENT) then return; end;

	if (self.infoTable and self.infoTable.reload) then
		self.infoTable.reload(self:GetOwner(), self.infoTable);
	end;
end;
