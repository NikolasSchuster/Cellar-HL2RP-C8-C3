include("shared.lua")

local knots = {
	Vector(-20, 0, 0),
	Vector(-30, 0, 0),
	Vector(120, 0, 0),
	Vector(90, 0, 0),
}

ENT.FlyLoopSound = Sound("npc/scanner/cbot_fly_loop.wav")
ENT.FlyLoopSound2 = Sound("npc/scanner/combat_scan_loop6.wav")

local function SimpleSpline(value)
	local valueSquared = value * value

	return (3 * valueSquared - 2 * valueSquared * value)
end

local function SimpleSplineRemapVal(val, A, B, C, D)
	if A == B then
		return val >= B and D or C
	end

	local cVal = (val - A) / (B - A)

	return C + (D - C) * SimpleSpline(cVal)
end

function ENT:Think()
	self.flCurrentDynamo = self.flCurrentDynamo or 0

	local velocity = self:GetVelocity()
	local lengthSqr = velocity:LengthSqr()
	local flCurrentDynamo = self:GetPoseParameter("dynamo_wheel")
	local speed	= velocity:Length()

	local flDynamoSpeed = (250 > 0 and speed / 250 or 1.0) * 60
	self.flCurrentDynamo = self.flCurrentDynamo - flDynamoSpeed
	if flCurrentDynamo < -180.0 then
		self.flCurrentDynamo = self.flCurrentDynamo + 360.0
	end

	self:SetPoseParameter("dynamo_wheel", self.flCurrentDynamo)

	local tailPerc = math.Clamp(velocity.z, -150, 250)
	tailPerc = SimpleSplineRemapVal(tailPerc, -150, 250, -25, 80)
	self:SetPoseParameter("tail_control", tailPerc)

	local pilot = self:GetPilot()
	local angles = self:GetAngles()
	local goalAngles = IsValid(pilot) and pilot:EyeAngles() or angles

	local hDiff = math.AngleDifference(goalAngles.y, angles.y) / 45
	local vDiff = math.AngleDifference(goalAngles.p, angles.p) / 45
	self:SetPoseParameter("flex_horz", hDiff * 20)
	self:SetPoseParameter("flex_vert", vDiff * 20)

	self:PlayFlySound()

	if self.sound then
		self.sound:ChangePitch(math.min(80 + (lengthSqr / 10000)*20, 255), 0.5)
	end

	self:InvalidateBoneCache()

	self:NextThink(CurTime())
	return true
end

function ENT:PlayFlySound()
	if !self.sound then
		local source = self.FlyLoopSound
		if self:GetModel():find("shield_scanner") then
			source = self.FlyLoopSound2
		end

		self.sound = CreateSound(self, source)
		self.sound:PlayEx(0.5, 100)
	elseif !self.sound:IsPlaying() then
		self.sound:Play()
	end
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
		self.sound = nil
	end
end

local colorTargetID = Color(50, 100, 150)

function ENT:HUDPaintTargetID(x, y, alpha)
	--y = Clockwork.kernel:DrawInfo(self:GetScannerName(), x, y, colorTargetID, alpha)
end

net.Receive("ScannerFlash", function()
	local entity = net.ReadEntity()

	if IsValid(entity) then
		local light = DynamicLight(entity:EntIndex())
		if !light then return end

		light.pos = entity:GetPos() + entity:GetForward() * 24
		light.r = 255
		light.g = 255
		light.b = 255
		light.brightness = 5
		light.Decay = 5000
		light.Size = 360
		light.DieTime = CurTime() + 1
	end
end)