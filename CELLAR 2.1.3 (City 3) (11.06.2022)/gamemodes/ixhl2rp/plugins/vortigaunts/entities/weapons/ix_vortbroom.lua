if (CLIENT) then
	SWEP.Slot = 3
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.PrintName = "Швабра"
	SWEP.DrawCrosshair = true
end

SWEP.Author					= ""
SWEP.Instructions 			= "ЛКМ: Уборка."
SWEP.Purpose 				= ""
SWEP.Contact 				= ""

SWEP.Category = "Vortigaunts"
SWEP.Slot					= 3
SWEP.SlotPos				= 5
SWEP.Weight					= 5
SWEP.IsAlwaysRaised = true
SWEP.Spawnable     			= true
SWEP.AdminSpawnable			= false
SWEP.HoldType 				= "smg"
SWEP.WorldModel 			= ""
SWEP.ViewModel 				= Model("models/c_arms_vortigaunt.mdl")
SWEP.ViewModelFOV = 110

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
		if (!self.Owner:Alive()) then return false end

		self.Owner.broomModel = ents.Create("prop_dynamic")
		self.Owner.broomModel:SetModel("models/props_c17/pushbroom.mdl")
		self.Owner.broomModel:SetMoveType(MOVETYPE_NONE)
		self.Owner.broomModel:SetSolid(SOLID_NONE)
		self.Owner.broomModel:SetParent(self.Owner)
		self.Owner.broomModel:DrawShadow(true)
		self.Owner.broomModel:Spawn()
		self.Owner.broomModel:Fire("setparentattachment", "cleaver_attachment", 0.01)
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

function SWEP:Holster()
	if (!IsValid(self.Owner)) then
		return
	end

	if (self.Owner.broomModel) then
		if (self.Owner.broomModel:IsValid()) then
			self.Owner.broomModel:Remove()
		end
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

function SWEP:PrimaryAttack()
	if (!self.Owner:Alive()) then return false end

	self:SetNextPrimaryFire( CurTime() + 2 )
	-- self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if (SERVER) then
		self.Owner:ForceSequence("sweep", nil,nil, false)
	end
end


function SWEP:SecondaryAttack()
	return false
end