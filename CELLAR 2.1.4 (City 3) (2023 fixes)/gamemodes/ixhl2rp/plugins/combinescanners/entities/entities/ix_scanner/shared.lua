ENT.Type = "anim"
ENT.PrintName = "Scanner"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

ENT.maxSpeed = 125
ENT.maxSpeedZ = 50
ENT.maxSpeedSqr = ENT.maxSpeed ^ 2
ENT.minHoverPush = Vector(0, 0, 0.4)
ENT.minHoverHeight = Vector(0, 0, 20)
ENT.velocityDecay = Vector(0.975,0.975,0.95)
ENT.accelXY = 0
ENT.accelZ = 0
ENT.noise = Vector(0, 0, 0)
ENT.angleDecay = 0.2
ENT.turnSpeed = 30
ENT.faceAngles = Angle(0, 0, 0)
ENT.accelAnglular = Vector(0, 0, 0)
ENT.spotlightLength = 128
ENT.spotlightWidth = 25
ENT.spotlightEnableShadows = true
ENT.spotlightNear = 1
ENT.spotlightFar = 512
ENT.spotlightFOV = 60
ENT.spotlightLocalAngles = Angle(7.5, 0, 0)
ENT.spotlightHDRColorScale = 0.67
ENT.maxHealth = 100

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Pilot")
	self:NetworkVar("String", 0, "ID")
	self:NetworkVar("String", 1, "ScannerName")
end

local CAMHELPER = {}
CAMHELPER.Type = "anim"
function CAMHELPER:Initialize()
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetNoDraw(true)
	self:DrawShadow(false)
end
function CAMHELPER:Draw() end

scripted_ents.Register(CAMHELPER, "camera_helper")