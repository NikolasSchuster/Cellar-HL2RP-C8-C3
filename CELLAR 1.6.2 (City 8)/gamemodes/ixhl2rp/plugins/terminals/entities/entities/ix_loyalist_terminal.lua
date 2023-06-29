
local PLUGIN = PLUGIN

ENT.PrintName		= "Loyalist Terminal"
ENT.Category		= "HL2 RP"
ENT.Spawnable		= true
ENT.AdminOnly		= true
ENT.Model			= Model("models/props/cs_office/TV_plasma.mdl")
ENT.RenderGroup 	= RENDERGROUP_OPAQUE
ENT.bNoPersist = true

local scale = 0.07
local screenWidth, screenHeight = 56, 32.7
local halfWide, halfTall = screenWidth / 2, screenHeight / 2

if (SERVER) then
	function ENT:SpawnFunction(player, trace, class)
		if (!trace.Hit) then return end
		local entity = ents.Create(class)

		entity:SetPos(trace.HitPos + trace.HitNormal * 1.5)
		entity:Spawn()

		PLUGIN:SaveData()
		return entity
	end

	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local phys = self:GetPhysicsObject()

		if (IsValid(phys)) then
			phys:Wake()
		end
	end
elseif (CLIENT) then
	function ENT:Initialize()
		self.m_bInitialized = true
		self:SetSolid(SOLID_VPHYSICS)
	end

	function ENT:Think()
		if (!self.m_bInitialized) then
			self:Initialize()
		end

		local bShouldDraw = EyePos():DistToSqr(self:GetPos()) < 160000

		if (!IsValid(self.panel) and bShouldDraw) then
			self.panel = vgui.Create("ixLoyalistTerminal")
			self.panel:ParentToHUD()
		elseif (IsValid(self.panel) and !bShouldDraw) then
			self.panel:Remove()
		end

		self:NextThink(CurTime() + 1)
		return true
	end

	function ENT:UpdateLight()
		local light = DynamicLight(self:EntIndex())

		if (light) then
			light.pos = self:GetPos() + self:GetUp() * halfTall + self:GetForward() * 7
			light.dir = self:GetForward()
			light.outerangle = 0
			light.innerangle = 2
			light.r = 180
			light.g = 187
			light.b = 190
			light.size = 120
			light.brightness = 1
			light.style = 0
			light.dietime = CurTime() + 1
			light.decay = 500
		end
	end

	function ENT:DrawScreen()
		if (!self.panel or halo.RenderedEntity() == self) then
			return
		end

		local up = self:GetUp()
		local right = self:GetRight()
		local forward = self:GetForward()

		local drawAng = self:GetAngles()
		drawAng:RotateAroundAxis(up, 90)
		drawAng:RotateAroundAxis(right, -90)

		local drawPos = self:GetPos()
		drawPos:Add(right * halfWide + up * (screenHeight + 2.5) + forward * 6.1)

		vgui.Start3D2D(drawPos, drawAng, scale)
		vgui.MaxRange3D2D(84)
		self.panel:Paint3D2D()
		vgui.End3D2D()
	end

	function ENT:Draw()
		self:DrawModel()

		if (EyePos():DistToSqr(self:GetPos()) < 160000) then
			self:UpdateLight()
			self:DrawScreen()
		end
	end

	function ENT:OnRemove()
		if (IsValid(self.panel)) then
			self.panel:Remove()
		end

		if (IsValid(self.light)) then
			self.light:Remove()
		end
	end
end
