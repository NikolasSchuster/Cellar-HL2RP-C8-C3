if (CLIENT) then
	SWEP.Slot = 0
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.PrintName = "Ворт-заряд"
	SWEP.DrawCrosshair = true

	game.AddParticles("particles/Vortigaunt_FX.pcf")
end

PrecacheParticleSystem("vortigaunt_beam")
PrecacheParticleSystem("vortigaunt_beam_b")
PrecacheParticleSystem("vortigaunt_charge_token")

SWEP.Instructions = "ЛКМ: Выстрел электрическим лучом Вортессенции."
SWEP.Purpose = ""
SWEP.Contact = ""
SWEP.Author	= ""
SWEP.Category = "Vortigaunts"

player_manager.AddValidModel("vortigaunt_arms2", "models/vortigaunt.mdl")
player_manager.AddValidHands("vortigaunt_arms2", "models/c_arms_vortigaunt.mdl", 1, "0000000")

SWEP.ViewModel 				= Model("models/c_arms_vortigaunt.mdl")
SWEP.ViewModelFOV = 110
SWEP.WorldModel = ""
SWEP.HoldType = "shotgun"

SWEP.Spawnable     			= true
SWEP.AdminSpawnable			= false

SWEP.Primary.IsAlwaysRaised = true
SWEP.IsAlwaysRaised = true
SWEP.IsVortibeam = true

SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 55
SWEP.Primary.Delay = 3
SWEP.Primary.Ammo = ""

SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0
SWEP.Secondary.Ammo	= ""

if CLIENT then
	SWEP.NextAllowedPlayRateChange = 0
end

-- Called when the SWEP is deployed.
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)

	local viewModel = self.Owner:GetViewModel()

	if (IsValid(viewModel)) then
		viewModel:SetPlaybackRate(1)
		viewModel:ResetSequence(ACT_VM_FISTS_DRAW)
		if CLIENT then
			self.NextAllowedPlayRateChange = CurTime() + viewModel:SequenceDuration()
		end
	end
end

-- Called when the SWEP is holstered.
function SWEP:Holster(switchingTo)
	self:SendWeaponAnim(ACT_VM_HOLSTER)

	local viewModel = self.Owner:GetViewModel()

	if (IsValid(viewModel)) then
		viewModel:SetPlaybackRate(1)
		viewModel:ResetSequence(ACT_VM_FISTS_HOLSTER)
		if CLIENT then
			self.NextAllowedPlayRateChange = CurTime() + viewModel:SequenceDuration()
		end
	end

	return true
end

if (CLIENT) then
	function SWEP:PreDrawViewModel(viewModel, weapon, client)
		local hands = player_manager.TranslatePlayerHands(player_manager.TranslateToPlayerModelName(client:GetModel()))

		if (hands and hands.model) then
			viewModel:SetModel(hands.model)
			viewModel:SetSkin(hands.skin)
			viewModel:SetBodyGroups(hands.body)
		end
	end

	function SWEP:DoDrawCrosshair(x, y)
		surface.SetDrawColor(255, 255, 255, 66)
		surface.DrawRect(x - 2, y - 2, 4, 4)
	end

	-- Adjust these variables to move the viewmodel's position
	SWEP.IronSightsPos  = Vector(-5, -5, -55)
	SWEP.IronSightsAng  = Vector(35, 15, 10)

	function SWEP:GetViewModelPosition(EyePos, EyeAng)
		local Mul = 1.0

		local Offset = self.IronSightsPos

		if (self.IronSightsAng) then
			EyeAng = EyeAng * 1

			EyeAng:RotateAroundAxis(EyeAng:Right(), 	self.IronSightsAng.x * Mul)
			EyeAng:RotateAroundAxis(EyeAng:Up(), 		self.IronSightsAng.y * Mul)
			EyeAng:RotateAroundAxis(EyeAng:Forward(),   self.IronSightsAng.z * Mul)
		end

		local Right 	= EyeAng:Right()
		local Up 		= EyeAng:Up()
		local Forward 	= EyeAng:Forward()

		EyePos = EyePos + Offset.x * Right * Mul
		EyePos = EyePos + Offset.y * Forward * Mul
		EyePos = EyePos + Offset.z * Up * Mul

		return EyePos, EyeAng
	end
end

if (CLIENT) then
	function SWEP:Think()
		if (!IsValid(self.Owner)) then
			return
		end

		local viewModel = self.Owner:GetViewModel()

		if (IsValid(viewModel) and self.NextAllowedPlayRateChange < CurTime()) then
			viewModel:SetPlaybackRate(1)
		end
	end
end

function SWEP:OnRemove()
	if (SERVER) then
		if self.Owner then
			if self.Owner.DrawViewModel then
				self.Owner:DrawViewModel(true)
			end
		end
	end

	if (self.Owner.broomModel) then
		if (self.Owner.broomModel:IsValid()) then
			self.Owner.broomModel:Remove()
		end
	end

	return true
end

-- Called when the SWEP is initialized.
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:CanPrimaryAttack()
	if (!self.Owner:OnGround()) then
		return false
	end

	return true
end

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()

	if (!self.Owner:Alive()) then return false end

	local v_thirst = (self.Owner:GetCharacter():GetThirst() - 20)
	local v_hunger = (self.Owner:GetCharacter():GetHunger() - 20)

	if self.Owner:Health() <= 50 or v_thirst < 0 or v_hunger < 0 then
		if SERVER then
			self.Owner:NotifyLocalized("Вы слишком слабы, чтобы использовать свои силы!")
		end

		return
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if (self.bIsFiring or !self:CanPrimaryAttack()) then return end
	self.bIsFiring = true

	if (CLIENT) then
		-- Adjust these variables to move the viewmodel's position
		self.IronSightsPos  = Vector(-10, -5, -70)
		self.IronSightsAng  = Vector(-5, 100, 10)
	end

	if SERVER then
		self.Owner:ForceSequence("Zapattack1", nil, 1.1, true)
	end

	local chargeSound = CreateSound(self.Owner, "NPC_Vortigaunt.ZapPowerup")
	chargeSound:Play()

	ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, self.Owner, self.Owner:LookupAttachment("leftclaw"))
	ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, self.Owner, self.Owner:LookupAttachment("rightclaw"))

	-- timer.Simple(1, function()
	-- 	if !IsValid(self.Owner) or CLIENT then
	-- 		return
	-- 	end

	-- 	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	-- end)

	timer.Simple(0.5, function()

		chargeSound:Stop()

		if !IsValid(self.Owner) then
			self.bIsFiring = false
			return
		end

		self.Owner:EmitSound("npc/vort/attack_shoot.wav", 40)

		local forward = self.Owner:EyeAngles():Forward()
		local tr = util.QuickTrace(self.Owner:EyePos(), (forward + VectorRand(-0.02, 0.02)) * 5000, self.Owner)

		sound.Play("npc/vort/attack_shoot.wav", tr.HitPos, 75)
		self.Owner:StopParticles()

		local leftClaw = self.Owner:LookupAttachment("leftclaw")

		if (leftClaw) then
			util.ParticleTracerEx(
				"vortigaunt_beam", self.Owner:GetAttachment(leftClaw).Pos, tr.HitPos, true, self.Owner:EntIndex(), leftClaw
			)
		end

		if (SERVER) then
			local damage = 1 //self.Owner:GetCharacter():GetSkillScale("vort_beam")
			local damageInfo = DamageInfo()

			damageInfo:SetAttacker(self.Owner)
			damageInfo:SetInflictor(self)
			damageInfo:SetDamage(damage)
			damageInfo:SetDamageForce(forward * damage)
			damageInfo:SetReportedPosition(leftClaw and self.Owner:GetAttachment(leftClaw).Pos or self.Owner:EyePos())
			damageInfo:SetDamagePosition(tr.HitPos)
			damageInfo:SetDamageType(DMG_SHOCK)

			local trent = tr.Entity
			local character = self.Owner:GetCharacter()

			character:SetHunger( math.Clamp(character:GetHunger() - 4, 0, 100))
			character:SetThirst( math.Clamp(character:GetThirst() - 4, 0, 100))

			if IsValid(trent) and (trent:IsPlayer() or trent:IsNPC()) then
				trent:TakeDamageInfo(damageInfo)
			else
				for k, v in ipairs(ents.FindInSphere(tr.HitPos, 48)) do
					-- local isplayer = v:IsPlayer()
					-- if isplayer then
					-- 	if v:Team() == FACTION_VORTIGAUNT then continue end
					-- end
					-- if !v:IsNPC() and !isplayer then continue end

					if (v:IsPlayer() and v:Team() == FACTION_VORTIGAUNT) or (!v:IsNPC() and !v:IsPlayer()) then
						continue
					end
	
					v:TakeDamageInfo(damageInfo)
	
				end
			end

			
		end

		local viewModel = self.Owner:GetViewModel()
		timer.Simple(1, function()
			if (IsValid(viewModel)) then
				viewModel:SetPlaybackRate(1)
				viewModel:ResetSequence(ACT_VM_FISTS_DRAW)
				if CLIENT then
					self.NextAllowedPlayRateChange = CurTime() + viewModel:SequenceDuration()
				end

				self.IronSightsPos  = Vector(-5, -5, -105)
				self.IronSightsAng  = Vector(35, 15, 10)
			end
		end)

		timer.Simple(2, function()
			self.IronSightsPos  = Vector(-5, -5, -55)
		end)

		self.bIsFiring = false
	end)
end

function SWEP:SecondaryAttack()
	return false
end