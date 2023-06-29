AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
 
function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube05x05x025.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	-- 1 = bet, 2 = waiting turn, 3 = your turn
	self:SetStage(1)
end

function ENT:Use(ply)
	local pos = self:WorldToLocal(ply:GetEyeTrace().HitPos)
	local button = self:GetCurrentPad(pos)
	if not button then return end -- They're not looking at anything :/

	-- Betting stage
	if self:GetStage() == 1 then 
		-- Check if they have already placed a bet
		for k, v in pairs(self.table.panels) do
			if v:GetUser() == ply then
				PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.AlreadyPlaced, ply)
				return 
			end
		end

		if button == "bet_lower" then
			self.table:ChangeBet(ply, -self.table.data.bet.iteration)
			return
		elseif  button == "bet_raise" then
			self.table:ChangeBet(ply, self.table.data.bet.iteration)
			return
		elseif  button == "bet_place" then
			self.table:PlaceBet(ply, self)
		end
	elseif (self:GetStage() == 3) and (self:GetUser() == ply) then
		if button == "action_double" then
			self.table:TurnAction(self, "doubledown")
		elseif button == "action_split" then
			self.table:TurnAction(self, "split")
		elseif button == "action_hit" then
			self.table:TurnAction(self, "hit")
		elseif button == "action_stand" then
			self.table:TurnAction(self, "stand")
		end
	end
end