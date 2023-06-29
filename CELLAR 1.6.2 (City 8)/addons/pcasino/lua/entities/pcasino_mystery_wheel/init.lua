AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/freeman/owain_mystery_wheel.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetAutomaticFrameAdvance(true)
	self:SetPlaybackRate(1)

	self.cacheSeq = {}
	self.cacheSeq['idle'] = self:LookupSequence("idle")
	self.cacheSeq['speen'] = self:LookupSequence("speen")
	self:SetSequence(self.cacheSeq['idle'])

	self.data = {}
	self.isActive = false
end

function ENT:PostData()
end


function ENT:Think() -- Used so that the animation runs at the correct FPS
	if not self.isActive then return end
	
	self:NextThink(CurTime())
	return true
end

function ENT:Use(ply)
	if self.isActive then return end
	if not ply:IsPlayer() then return end
	if PerfectCasino.Cooldown.Check(self:EntIndex()..":Use", 0.5, ply) then return end

	if tobool(self.data.general.useFreeSpins) then
		if PerfectCasino.Spins[ply:SteamID64()] and (PerfectCasino.Spins[ply:SteamID64()] >= 1) then
			PerfectCasino.Core.TakeFreeSpin(ply)

			PerfectCasino.Core.Msg(PerfectCasino.Translation.Chat.UsedFreeSpin, ply)

			self:StartSpin(ply)
			return
		end
	end

	if tobool(self.data.buySpin.buy) then
		if PerfectCasino.Config.CanAfford(ply, self.data.buySpin.cost) then
			PerfectCasino.Config.AddMoney(ply, -self.data.buySpin.cost)
			hook.Run("pCasinoOnMysteryWheelBet", ply, self, self.data.buySpin.cost)

			PerfectCasino.Core.Msg(string.format(PerfectCasino.Translation.Chat.UsedPaidSpin, PerfectCasino.Config.FormatMoney(self.data.buySpin.cost)), ply)

			self:StartSpin(ply)
			return
		end
	end
end

function ENT:StartSpin(ply)
	self.isActive = true
	self:ResetSequence(self.cacheSeq['speen'])

	PerfectCasino.Sound.Play(self, "other_mystery_spin")

	local result = math.random(20)
	local winData = self.data.wheel[result]

	timer.Simple(3, function() -- We wait a moment so it can blend in with the spin.
		self:SetPoseParameter("mystery_wheel_changenumber", result)
	end)

	timer.Simple(self:SequenceDuration(self.cacheSeq['speen']), function()
		self.isActive = false
		if not IsValid(self) then return end
		if not IsValid(ply) then return end

		self:ResetSequence(self.cacheSeq['idle'])


		local customMsg = PerfectCasino.Config.RewardsFunctions[winData.f](ply, self, winData.i)
		PerfectCasino.Core.Msg(customMsg or string.format(PerfectCasino.Translation.Chat.SlotWheelSpin, winData.n), ply)
	end)
end