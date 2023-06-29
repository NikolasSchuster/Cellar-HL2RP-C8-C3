include("shared.lua")


function ENT:Initialize()
	self.currentBid = 0
	self.active = false
	self.currentBets = {}

	self.hasInitialized = true
end

function ENT:PostData()
	if not self.hasInitialized then
		self:Initialize()
	end

	self.currentBid = self.data.bet.default
	self:GetCurrentPad(Vector(0, 0, 0)) -- To force generate the cache
end
function ENT:OnRemove()
	self:ClearBets()
end

local surface_setdrawcolor = surface.SetDrawColor
local surface_drawrect = surface.DrawRect
local draw_simpletext = draw.SimpleText
local black = Color(0, 0, 0, 155)
local white = Color(255, 255, 255, 100)
local gold = Color(255, 200, 0, 100)
function ENT:Draw()
	self:DrawModel()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 25000 then return end

	-- We can piggyback off the distance check to only request the entities data when it's needed :D
	if (not self.data) and (not PerfectCasino.Cooldown.Check(self:EntIndex(), 5)) then
		PerfectCasino.Core.RequestConfigData(self)
		return
	end

	if not self.data then return end


	local pos = self:GetPos()
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos + (ang:Up()*14.7) + (ang:Right()*20) + (ang:Forward()*-15.5), ang, 0.05)
		local button = self:GetCurrentPad(self:WorldToLocal(LocalPlayer():GetEyeTrace().HitPos))


		-- Bet limit
		if self.data.bet.betLimit and not (tonumber(self.data.bet.betLimit) == 0) then
			surface_setdrawcolor(black)
			surface_drawrect(5, -80, 410, 65)
			-- Border
			surface_setdrawcolor(white)
			surface_drawrect(0, -85, 420, 5)
			surface_drawrect(0, -80, 5, 65)
			surface_drawrect(415, -80, 5, 65)
			surface_drawrect(0, -15, 420, 5)
			-- Bet limit text
			draw_simpletext(string.format(PerfectCasino.Translation.UI.BetLimit, PerfectCasino.Config.FormatMoney(self.data.bet.betLimit)), "pCasino.Entity.Bid", 215, -47, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	
		-- Previous bet step
		surface_setdrawcolor(black)
		surface_drawrect(5, 5, 90, 65)
		-- Border
		surface_setdrawcolor(button == "bet_lower" and gold or white)
		surface_drawrect(0, 0, 100, 5)
		surface_drawrect(0, 5, 5, 65)
		surface_drawrect(95, 5, 5, 65)
		surface_drawrect(0, 70, 100, 5)
		-- Left arrow
		draw_simpletext("<", "pCasino.Entity.Arrows", 50, 35, button == "bet_lower" and gold or white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		-- Current bet
		surface_setdrawcolor(black)
		surface_drawrect(115, 5, 190, 65)
		-- Border
		surface_setdrawcolor(white)
		surface_drawrect(110, 0, 200, 5)
		surface_drawrect(110, 5, 5, 65)
		surface_drawrect(305, 5, 5, 65)
		surface_drawrect(110, 70, 200, 5)
		-- Current Bid
		draw_simpletext(PerfectCasino.Config.FormatMoney(self.currentBid), "pCasino.Entity.Bid", 215, 37, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		-- Next bet step
		-- Box
		surface_setdrawcolor(black)
		surface_drawrect(325, 5, 90, 65)
		-- Border
		surface_setdrawcolor(button == "bet_raise" and gold or white)
		surface_drawrect(320, 0, 100, 5)
		surface_drawrect(320, 5, 5, 65)
		surface_drawrect(415, 5, 5, 65)
		surface_drawrect(320, 70, 100, 5)
		-- Right arrow
		draw_simpletext(">", "pCasino.Entity.Arrows", 370, 35, button == "bet_raise" and gold or white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()

	if (not (self:GetStartRoundIn() == -1)) or (self:GetLastRoundNumber() >= 0) then
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)
		cam.Start3D2D(pos + (ang:Up()*-20.3) + (ang:Right()*-21.3) + (ang:Forward()*-20), ang, 0.05)
			
			-- Previous bet step
			surface_setdrawcolor(black)
			surface_drawrect(5, 5, 390, 65)
			-- Border
			surface_setdrawcolor(white)
			surface_drawrect(0, 0, 400, 5)
			surface_drawrect(0, 5, 5, 65)
			surface_drawrect(395, 5, 5, 65)
			surface_drawrect(0, 70, 400, 5)

			local text = (not (self:GetStartRoundIn() == -1)) and string.format(PerfectCasino.Translation.UI.Start, self.data.general.betPeriod - (os.time() - self:GetStartRoundIn())) or string.format(PerfectCasino.Translation.UI.Number, self:GetLastRoundNumber())
			draw_simpletext(text, "pCasino.Entity.Bid", 200, 37, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		cam.End3D2D()
	end

end

local tempStack = {}
local lastPad = false

local function clearTempStack()
	for k, v in pairs(tempStack) do
		if not IsValid(v) then continue end
		v:Remove()
	end
	tempStack = {}
end

function ENT:Think()
	if self.active then return end
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 25000 then return end

	local pos = self:WorldToLocal(LocalPlayer():GetEyeTrace().HitPos)
	local curPad, padData = self:GetCurrentPad(pos)

	if (not curPad) or (curPad == "bet_raise") or (curPad == "bet_lower") then
		lastPad = curPad
		if not table.IsEmpty(tempStack) then
			clearTempStack()
		end
		return
	end -- Don't do anything if it's not a bet pad

	if not (curPad == lastPad) then
		clearTempStack()
	end
	lastPad = curPad

	if table.IsEmpty(tempStack) then
		local chips = PerfectCasino.Chips:GetFromNumber(self.currentBid)
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 90)

		for k=#PerfectCasino.Chips.Types, 0, -1 do -- Run it in reverse, putting the highest chips at the bottom
			if not chips[k] then continue end
			for i=1, chips[k] do
				local plaque = k >= 11 -- There are 11 normal skins, so anything over 10 (11-1, due to skins starting at 0) we use the big plaque models

				local chip = ClientsideModel(plaque and "models/freeman/owain_casino_plaque.mdl" or "models/freeman/owain_casino_chip.mdl")
				table.insert(tempStack, chip)
				chip:SetParent(self)
				chip:SetSkin(plaque and k-11 or k)
				chip:SetPos(self:LocalToWorld(Vector(padData.origin.x, padData.origin.y, 14.8+((#tempStack+(self.currentBets[curPad] and #self.currentBets[curPad] or 0))*0.3))))
				chip:SetAngles(ang)
			end
		end
	else
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), CurTime()*30%360)
		for k, v in pairs(tempStack) do
			v:SetAngles(ang)
		end
	end
end

-- Chip code
function ENT:AddBet(pad, amount)
	local padName, padData = self:GetPadByName(pad)
	if not padName then return end

	self.currentBets[padName] = self.currentBets[padName] or {}

	local chips = PerfectCasino.Chips:GetFromNumber(amount)
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	for k=#PerfectCasino.Chips.Types, 0, -1 do -- Run it in reverse, putting the highest chips at the bottom
		if not chips[k] then continue end
		for i=1, chips[k] do
			local plaque = k >= 11 -- There are 11 normal skins, so anything over 10 (11-1, due to skins starting at 0) we use the big plaque models

			local chip = ClientsideModel(plaque and "models/freeman/owain_casino_plaque.mdl" or "models/freeman/owain_casino_chip.mdl")
			table.insert(self.currentBets[padName], chip)
			chip:SetParent(self)
			chip:SetSkin(plaque and k-11 or k)
			chip:SetPos(self:LocalToWorld(Vector(padData.origin.x, padData.origin.y, 14.5+(#self.currentBets[padName]*0.3))))
			chip:SetAngles(ang)
		end
	end

	clearTempStack() -- To update the hight to have over the new stack
end
function ENT:ClearBets()
	for _, pad in pairs(self.currentBets) do
		for k, v in pairs(pad) do
			v:Remove()
		end
	end

	self.currentBets = {}
end

function ENT:OnRemove()
	-- Clear the board of last rounds best
	for k, v in pairs(self.currentBets) do
		if not IsValid(v) then continue end

		v:Remove()
	end
	
	clearTempStack()
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

	local pos = self:WorldToLocal(LocalPlayer():GetEyeTrace().HitPos)
	local button = self:GetCurrentPad(pos)
	
	if not button then
		local options = {
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
				Derma_StringRequest("Снять токены", "Введите желаемую сумму", tostring(self:GetStoredMoney()), function(text)
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
end

net.Receive("pCasino:Roulette:Bet:Change", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.data then return end

	local newBet = net.ReadUInt(32)
	entity.currentBid = newBet
end)

net.Receive("pCasino:Roulette:Bet:Place", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end
	if not entity.data then return end
	if entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > 100000 then return end

	local pad = net.ReadString()
	local betAmount = net.ReadUInt(32)


	entity:AddBet(pad, betAmount)
end)
net.Receive("pCasino:Roulette:Bet:Clear", function()
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end

	entity:ClearBets()
end)