ALWAYS_RAISED['ix_dissolver_manager'] = true
AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = 'Dissolver Manager'
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.CLMode = 0
end

SWEP.HoldType = 'fist'
SWEP.Category = 'HL2 RP'
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = 'models/weapons/v_pistol.mdl'
SWEP.WorldModel = 'models/weapons/w_pistol.mdl'
SWEP.Primary.Delay = 1
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 0
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = 'none'
SWEP.Secondary.Delay = 0.9
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = 'none'

local primary_entity_callbacks = {
	['ix_dissolver'] = function(entity)
		if entity:GetTerminal() then
			entity:get_entity():set_id(entity:GetTerminal())
		end
	end,
	['ix_dissolver_terminal'] = function(entity)
		entity:get_entity():SetNetVar('id', entity:GetTerminal())
	end
}

function SWEP:SetupDataTables()
	self:NetworkVar('Float', 0, 'Terminal')
end

function SWEP:Initialize()
	self:SetWeaponHoldType('knife')
end

function SWEP:Deploy()
	return true
end

function SWEP:get_entity()
	local data = {}
	data.start = self.Owner:GetShootPos()
	data.endpos = data.start + self.Owner:GetAimVector() * 84

	data.filter = {self, self.Owner}

	local trace = util.TraceLine(data)

	return trace.Entity
end

if (SERVER) then
	function SWEP:PrimaryAttack()
		if (not IsFirstTimePredicted()) then return end

		if IsValid(self:get_entity()) and primary_entity_callbacks[self:get_entity():GetClass()] and self:GetTerminal() ~= 0 then
			primary_entity_callbacks[self:get_entity():GetClass()](self)
			self.Owner:EmitSound('buttons/blip1.wav')
		end

		self:SetNextPrimaryFire(CurTime() + 1)
	end

	function SWEP:SecondaryAttack()
		if (not IsFirstTimePredicted()) then return end

		if IsValid(self:get_entity()) and self:get_entity():GetClass() == 'ix_dissolver_terminal' then
			self:SetTerminal(self:get_entity():id())
			self.Owner:EmitSound('buttons/blip1.wav')
		end

		self:SetNextSecondaryFire(CurTime() + 1)
	end

	function SWEP:Reload()
		if (not IsFirstTimePredicted()) then return end

		if self:GetTerminal() ~= 0 then
			self:SetTerminal(0)
		end
	end
else
	local connected_color = Color(0, 255, 0)
	local helper_font = 'ixMonoSmallFont'

	function SWEP:DrawHUD()
		local client = self.Owner
		local width, height = ScrW(), ScrH()
		local base_width, base_height = width * 0.5, height * 0.8
		local text_x, text_y = draw.SimpleText('Left Click: Set ID to Dissolver or Terminal', helper_font, base_width, base_height, color_white, 1, 1)
		base_height = base_height + text_y
		text_x, text_y = draw.SimpleText('Right Click: Take ID from Terminal', helper_font, base_width, base_height, color_white, 1, 1)
		base_height = base_height + text_y
		text_x, text_y = draw.SimpleText('Reload: Clear Terminal ID', helper_font, base_width, base_height, color_white, 1, 1)
	end

	hook.Add('PostDrawOpaqueRenderables', 'dissolver_manager_helper', function(bDrawingDepth, bDrawingSkybox)
		local client = LocalPlayer()
		local weapon = client:GetActiveWeapon()

		if IsValid(weapon) and weapon:GetClass() == 'ix_dissolver_manager' then
			local terminal

			for i = 1, #ents.FindByClass('ix_dissolver_terminal') do
				local terminals = ents.FindByClass('ix_dissolver_terminal')[i]

				if weapon:GetTerminal() == terminals:id() then
					terminal = terminals
					break
				end
			end

			if terminal then
				for i = 1, #terminal:get_dissolvers() do
					local dissolvers = terminal:get_dissolvers()[i]

					if dissolvers then
						render.DrawLine(terminal:GetPos(), dissolvers:LocalToWorld(dissolvers:OBBCenter()), connected_color)
					end
				end
			end
		end
	end)
end