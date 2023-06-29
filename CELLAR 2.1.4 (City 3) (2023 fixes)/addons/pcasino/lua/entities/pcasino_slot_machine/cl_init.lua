include("shared.lua")

function ENT:Initialize()
	self.wheels = {}
	for i=1, 3 do
		local wheel = ClientsideModel("models/freeman/owain_slotmachine_reel.mdl")
		self.wheels[i] = wheel
		wheel:SetParent(self)
		wheel:SetPos(self:GetPos()+(self:GetUp()*5.5)+(self:GetForward()*-10)+((self:GetRight()*-6)*(i-2)))
		wheel:SetAngles(self:GetAngles())
	end

	self.active = false

	self.hasInitialized = true
end

function ENT:PostData()
	if not self.hasInitialized then
		self:Initialize()
	end
end

function ENT:OnRemove()
	for k, v in pairs(self.wheels) do
		if IsValid(v) then v:Remove() end
	end
end

local colorGold = Color(255, 200, 0)
local colorPurple = Color(255, 0, 255)
function ENT:Draw()
	self:DrawModel()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 25000 then return end

	if (not self.wheels) or (not self.wheels[1]) or (not IsValid(self.wheels[1])) then self:Initialize() return end

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

	cam.Start3D2D(pos + (ang:Up()*-5.6) + (ang:Right()*-29.6), ang, 0.05)
		if tobool(self.data.jackpot.toggle) then
			draw.SimpleText(string.format(PerfectCasino.Translation.UI.JackPot, PerfectCasino.Config.FormatMoney(self.curJackpot)), "pCasino.Title.Static", 0, 0, (self.win and (self.win == 2)) and colorPurple or colorGold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText((math.ceil(CurTime())%2 == 1) and PerfectCasino.Translation.UI.ReadyToPlay or "", "pCasino.Title.Static", 0, 0, colorGold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
	
	ang:RotateAroundAxis(ang:Forward(), -20)

	cam.Start3D2D(pos + (ang:Up()*1.9) + (ang:Right()*5.1) + (ang:Forward()*5.5), ang, 0.05)
		draw.SimpleText(PerfectCasino.Config.FormatMoney(self.data.bet.default), "pCasino.Textbox.Static", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

local cooldown = 0
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
			local ang = v:GetAngles()
			ang:RotateAroundAxis(v:GetRight(), -600*FrameTime())
			v:SetAngles(ang)
		elseif v.reject and (v.reject > 0) then
			local bump = math.Clamp(math.Round(300*FrameTime()), 1, v.reject)

			local ang = v:GetAngles()
			ang:RotateAroundAxis(v:GetRight(), bump)
			v:SetAngles(ang)
			v.reject = v.reject - bump
			if (k == 3) and (v.reject <= 0) and (not isnumber(self.win)) then
				self.active = false -- All the wheels are in the right place
			end
		end
	end
end

-- Game specific code
function ENT:StartSpinning(i)
	local wheel = self.wheels[i]
	if (not wheel) or (not IsValid(wheel)) then self:Initialize() return end

	local randomAng = self:GetAngles()
	randomAng:RotateAroundAxis(self:GetRight(), math.random(0, 360))
	wheel:SetAngles(randomAng)

	wheel.spinning = true
end

local resultCache = {}
resultCache["dollar"] = 0
resultCache["bell"] = 1
resultCache["melon"] = 2
resultCache["cherry"] = 3
resultCache["seven"] = 4
resultCache["clover"] = 5
resultCache["diamond"] = 6
resultCache["berry"] = 7

local snap = 360/table.Count(resultCache)
local offset = -35
local rejectionVaule = 20
function ENT:StopSpinning(i, result)
	local wheel = self.wheels[i]
	if (not wheel) or (not IsValid(wheel)) then self:Initialize() return end
	
	wheel.spinning = false

	if result then
		local angleResult = resultCache[result] * snap - offset

		local ang = self:GetAngles()
		ang:RotateAroundAxis(wheel:GetRight(), angleResult-rejectionVaule)
		wheel:SetAngles(ang)

		wheel.reject = rejectionVaule
	end
end

function ENT:StartWin(winData)
	-- 2 is jackpot, 1 is normal win
	self.win = (tobool(winData.j) and tobool(self.data.jackpot.toggle)) and 2 or 1
end

function ENT:EndWin()
	self.active = false
	self.win = nil
end

ENT.PopulateEntityInfo = true

function ENT:GetEntityMenu()
	local cid = LocalPlayer():GetCharacter():GetIDCard()

	if !cid then 
		return
	end

	local accesses = cid:GetData("access", {})

	if !accesses["CASINO"] then
		return
	end

	local options = {
		["Играть"] = function()
			ix.menu.NetworkChoice(self, "Play")

			return false
		end,
		["Внести токены"] = function()
			Derma_StringRequest("Внести токены", "Введите желаемую сумму", "0", function(text)
				local amount = tonumber(text) or 0

				if amount > 0 then
					ix.menu.NetworkChoice(self, "Deposit", amount)
				end
			end)

			return false
		end,
		["Снять токены"] = function()
			Derma_StringRequest("Снять токены", "Введите желаемую сумму", tostring(self:GetCurrentJackpot()), function(text)
				local amount = tonumber(text) or 0

				if amount > 0 then
					ix.menu.NetworkChoice(self, "Withdraw", amount)
				end
			end)

			return false
		end,
	}

	return options
end

net.Receive("pCasino:BasicSlot:Spin:Start", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > 500000 then return end
	if not entity.data then return end

	entity.active = true

	for i=1, 3 do
		entity:StartSpinning(i)
	end
end)

net.Receive("pCasino:BasicSlot:Spin:Stop", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.active then return end
	if not entity.data then return end

	local key = net.ReadUInt(2)
	local result = net.ReadString()
	entity:StopSpinning(key, result)
end)

net.Receive("pCasino:BasicSlot:Spin:Win", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.active then return end
	if not entity.data then return end

	local winData = net.ReadTable()
	entity:StartWin(winData)

	timer.Simple((tobool(winData.j) and tobool(entity.data.jackpot.toggle)) and 5 or 2, function()
		if not IsValid(entity) then return end
		entity:EndWin()
	end)
end)