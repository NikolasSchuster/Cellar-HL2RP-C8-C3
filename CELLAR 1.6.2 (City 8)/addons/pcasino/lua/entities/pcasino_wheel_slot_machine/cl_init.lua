include("shared.lua")

function ENT:Initialize()
	self.active = false
	self.spin = false

	self.wheels = {}
	for i=0, self:GetNumPoseParameters()-2 do
		self.wheels[i+1] = {name = self:GetPoseParameterName(i)}
	end

	self.isPreSpin = false
	self.hasInitialized = true
end
function ENT:PostData()
	if not self.hasInitialized then
		self:Initialize()
	end
end

local colorGold = Color(255, 200, 0)
local colorPurple = Color(255, 0, 255)
local colorDarkWhite = Color(240, 240, 240)
function ENT:Draw()
	self:DrawModel()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 25000 then return end

	-- We can piggyback off the distance check to only request the entities data when it's needed :D
	if (not self.data) and (not PerfectCasino.Cooldown.Check(self:EntIndex(), 5)) then
		PerfectCasino.Core.RequestConfigData(self)
		return
	end

	if not self.data then return end

	-- For ticking value
	self.curJackpot = math.Approach(self.curJackpot or self:GetCurrentJackpot(), self:GetCurrentJackpot(), math.Round((self.data.bet.default*5)*FrameTime()))

	-- Basic setups
	local pos = self:GetPos()
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D(pos + (ang:Up()*-5.17) + (ang:Right()*-31.63) + (ang:Forward()*-0.1), ang, 0.02)
		-- Spinny wheel icons
		local itter = 0
		for i=1, 360, 360/12 do 
			itter = itter + 1
			local x = math.cos(math.rad(i - 90)) * 115
			local y = math.sin(math.rad(i - 90)) * 115

			draw.NoTexture()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(PerfectCasino.Icons[self.data.wheel[itter].p].mat)

			PerfectCasino.UI.DrawTexturedRectRotatedPoint(x, y, 80, 80, (-i), 0, -145)
			PerfectCasino.UI.TextRotated(self.data.wheel[itter].n, x, y, colorDarkWhite, "pCasino.Title.Static", i-90)
		end

		-- Pre spin text
		if self.isPreSpin and (math.ceil((CurTime()*2)%2) == 1) then
			draw.SimpleText(PerfectCasino.Translation.UI.SpinThatWheel, "pCasino.Entity.Bid", 0, 590, colorPurple, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		draw.SimpleText(string.format(PerfectCasino.Translation.UI.JackPot, PerfectCasino.Config.FormatMoney(self.curJackpot)), "pCasino.Title.Static", 0, 650, colorGold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.SimpleText(string.format(PerfectCasino.Translation.UI.Play, PerfectCasino.Config.FormatMoney(self.data.bet.default)), "pCasino.Title.Static", -415, 650, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	cam.End3D2D()
end

function ENT:Think()
	if not self.active then return end
	if self.win then
		for i=1, 2 do
			local winLight = DynamicLight(self:EntIndex()+i)
			if winLight then
				winLight.pos = self:GetPos()+(self:GetUp()*13)+(self:GetForward()*-5)+((self:GetRight()*3)*(-3+(2*i)))
				winLight.r = (self.win == 2) and ((math.Round(CurTime()%1) == 1) and 100 or 0) or 100
				winLight.g = self.win == 2 and 0 or 100
				winLight.b = (self.win == 2) and 100 or 0 -- and ((math.Round(CurTime()%2) == 1) and
				winLight.brightness = 3
				winLight.Decay = 1000
				winLight.Size = 100
				winLight.DieTime = CurTime() + 1
			end
		end
	end

	for k, v in pairs(self.wheels) do
		if v.spinning then
			self:SetPoseParameter(v.name, (CurTime()*600)%360)
		end
	end
end

-- Game specific code
function ENT:StartSpinning(i)
	self.wheels[i].spinning = true
end

function ENT:StopSpinning(i, result)
	local wheel = self.wheels[i]
	if not wheel then return end
	
	wheel.spinning = false
end

function ENT:StartWin(winData)
	-- 2 is jackpot, 1 is normal win
	self.win = tobool(winData.j) and 2 or 1
end

function ENT:EndWin()
	self.active = false
	self.win = nil
	self.spin = false
	self.isPreSpin = false
end

net.Receive("pCasino:WheelSlot:Spin:Start", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > 500000 then return end
	if not entity.data then return end

	entity.active = true

	for i=1, 3 do
		entity:StartSpinning(i)
	end
end)

net.Receive("pCasino:WheelSlot:Spin:Stop", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.active then return end
	if not entity.data then return end

	local key = net.ReadUInt(2)
	local result = net.ReadString()
	entity:StopSpinning(key, result)
end)

net.Receive("pCasino:WheelSlot:Spin:Win", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.active then return end
	if not entity.data then return end

	local winData = net.ReadTable()
	entity:StartWin(winData)
	
	if tobool(winData.j) then
		entity.isPreSpin = true
		return
	end

	timer.Simple(2, function()
		entity:EndWin()
	end)
end)

net.Receive("pCasino:WheelSlot:Spin:Spin", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.active then return end
	if not entity.data then return end

	entity.spin = true
	entity.isPreSpin = false
	timer.Simple(5, function()
		entity:EndWin()
	end)
end)