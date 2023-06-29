AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/freeman/owain_casino_stool.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	-- Chair creation stuff
	self.chair = ents.Create("prop_vehicle_prisoner_pod")
	self.chair:SetParent(self)
	self.chair:SetModel("models/nova/airboat_seat.mdl")
	self.chair:SetPos(self:GetPos())
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), -90)
	self.chair:SetAngles(ang)
	self.chair:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	self.chair:Spawn()
	self.chair:Activate()
	self.chair:SetVehicleClass("Seat_Airboat")

	local phys = self.chair:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
	
	-- The fun stuff
	-- Make the chair invisible 

	self.chair:SetColor(Color(0, 0, 0, 0))
	self.chair:SetRenderMode(RENDERMODE_TRANSALPHA)

	-- Make the chair unbuyable if in DarkRP
	if DarkRP then
		self.chair:setKeysNonOwnable(true)
	end
	-- Mark the chair as a pcasino chair
	self.chair.pCasinoChair = true
end

function ENT:PostData()
end

function ENT:Use(ply)
	-- Someone is already in the chair
	if IsValid(self.chair:GetDriver()) then return end

	-- Get them into the chair
	ply:EnterVehicle(self.chair)
end