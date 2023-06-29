if (CLIENT) then
	SWEP.Slot = 5
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.PrintName = "Ворт-Энергия"
	SWEP.DrawCrosshair = true
end

SWEP.Author					= "Fruity"
SWEP.Instructions 			= "ЛКМ: Лечение"
SWEP.Purpose 				= ""
SWEP.Contact 				= ""

SWEP.Primary.IsAlwaysRaised = true
SWEP.IsAlwaysRaised = true
SWEP.Category = "Vortigaunts"
SWEP.Slot					= 5
SWEP.SlotPos				= 5
SWEP.Weight					= 5
SWEP.Spawnable     			= true
SWEP.AdminSpawnable			= false
SWEP.ViewModel 				= Model("models/c_arms_vortigaunt.mdl")
SWEP.ViewModelFOV = 110
SWEP.WorldModel 			= ""
SWEP.HoldType = "normal"

if CLIENT then
	SWEP.NextAllowedPlayRateChange = 0
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end


function SWEP:Deploy()
	if (!IsValid(self.Owner)) then
		return
	end

	if (SERVER) then
		if (!self.HealSound) then
		self.HealSound = CreateSound( self.Weapon, "npc/vort/health_charge.wav" )
		end
	end

	local viewModel = self.Owner:GetViewModel()

	if (IsValid(viewModel)) then
		viewModel:SetPlaybackRate(1)
		viewModel:ResetSequence(ACT_VM_FISTS_DRAW)
		if CLIENT then
			self.NextAllowedPlayRateChange = CurTime() + viewModel:SequenceDuration()
		end
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

function SWEP:Holster()
	if (!IsValid(self.Owner)) then
		return
	end

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

function SWEP:DispatchEffect(EFFECTSTR)
	local pPlayer=self.Owner
	if !pPlayer then return end
	local view
	if CLIENT then view=GetViewEntity() else view=pPlayer:GetViewEntity() end

	if ( !pPlayer:IsNPC() and view:IsPlayer() ) then
		ParticleEffectAttach( EFFECTSTR, PATTACH_POINT_FOLLOW, pPlayer, pPlayer:LookupAttachment( "leftclaw" ) )
	else
		ParticleEffectAttach( EFFECTSTR, PATTACH_POINT_FOLLOW, pPlayer, pPlayer:LookupAttachment( "leftclaw" ) )
	end
end

local function ConsumeFood(owner, amount)
	local character = owner:GetCharacter()
	local point = (amount / 2)

	character:SetHunger(math.max(character:GetHunger() - point, 0))
	character:SetThirst(math.max(character:GetThirst() - point, 0))
end

local function HasFood(owner, amount)
	local character = owner:GetCharacter()
	local point = (amount / 2)

	if (character:GetHunger() - point) < 0 then
		return false
	end

	if (character:GetThirst() - point) < 0 then
		return false
	end

	return true
end

function SWEP:PrimaryAttack()
	if (!self.Owner:Alive()) then return false end

	local eye = self.Owner:GetEyeTrace()
	if (!eye.Entity:IsPlayer()) and (eye.Entity:GetClass() != "prop_ragdoll") then return end
	if (eye.Entity:GetClass() == "prop_ragdoll" and !eye.Entity.ixPlayer) then return end

	local target = eye.Entity
	if (!IsValid(target)) then
		return false
	end

	local value = (self.Owner:GetLocalVar("stm", 0) - 20)

	if self.Owner:Health() <= 50 or value < 0 or !HasFood(self.Owner, 15) then
		if SERVER then
			self.Owner:NotifyLocalized("Вы слишком слабы, чтобы использовать свои силы!")
		end

		return
	end
	if (IsValid(target.ixPlayer)) then
		target = target.ixPlayer
	end
	if (target:GetPos():DistToSqr(self.Owner:GetShootPos()) > 105 * 105) then return end
	self:SetNextPrimaryFire( 10 )
	self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	if (CLIENT) then
		-- Adjust these variables to move the viewmodel's position
		self.IronSightsPos  = Vector(0, -5, -55)
		self.IronSightsAng  = Vector(35, 15, 10)
	end

	if (SERVER) then
		self.Owner:ForceSequence("heal_start", function()
			self:DispatchEffect("vortigaunt_charge_token")
			self.Owner:EmitSound( "npc/vort/health_charge.wav", 100, 150, 1, CHAN_AUTO )
			self:SendWeaponAnim( ACT_VM_RELOAD )
			timer.Simple(2, function()
				self.Owner:ForceSequence("heal_cycle", function()
					if (!self.Owner:Alive()) then return end
					if (target:GetPos():DistToSqr(self.Owner:GetShootPos()) <= 105 * 105) then
						if (target:IsPlayer()) then
							local character = target:GetCharacter()

							character:HealLimbs(40)
							character:SetBlood(math.min(character:GetBlood() + 800, 5000))
							character:SetShock(math.max(character:GetShock() - 2500, 0))
							character:SetRadLevel(math.max(character:GetRadLevel() - 350, 0))

							character:SetBleeding(false)
							character:SetFeelPain(false)

							if !target:InCriticalState() then
								target:SetHealth(ix.plugin.list["!damagesystem"]:GetMinimalHealth(character))
							end

							local isUnconscious = target:IsUnconscious()

							if isUnconscious and math.random(0, 100) < 30 then
								target:SetAction("@wakingUp", 30, function(client)
									client.ixUnconsciousOut = nil
									client:SetLocalVar("knocked", false)
									client:SetRagdolled(false)
								end)

								target.ixUnconsciousOut = true
							end
							self.Owner:ConsumeStamina(10)
							ConsumeFood(self.Owner, 15)
						end
					else
						self.Owner:StopSound("npc/vort/health_charge.wav")
					end

					self.Owner:StopParticles()
					self:SendWeaponAnim( ACT_VM_PULLBACK )
				end)
				timer.Simple(4, function()
					self.Owner:ForceSequence("heal_end", function()
						self:SetNextPrimaryFire( 0 )
						self.Owner:StopSound("npc/vort/health_charge.wav")
						self.Owner:Freeze(false)

						local viewModel = self.Owner:GetViewModel()

						if (IsValid(viewModel)) then
							viewModel:SetPlaybackRate(1)
							viewModel:ResetSequence(ACT_VM_FISTS_DRAW)
						end
					end)
				end)
			end)
		end)
		self.Owner:Freeze(true)
	end

	if (CLIENT) then
		timer.Simple(7, function()
		-- Adjust these variables to move the viewmodel's position
			self.IronSightsPos = Vector(-5, -5, -55)
			self.IronSightsAng = Vector(35, 15, 10)
		end)
	end
end

function SWEP:SecondaryAttack()
	return false
end