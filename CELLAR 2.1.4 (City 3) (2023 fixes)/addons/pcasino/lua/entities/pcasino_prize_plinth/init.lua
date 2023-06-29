AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/freeman/owain_prize_plinth.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetAutomaticFrameAdvance(true)
	self:SetPlaybackRate(1)

	self.cacheSeq = {}
	self.cacheSeq['idle'] = self:LookupSequence("idle")
	self.cacheSeq['speen'] = self:LookupSequence("speen")
	self:SetSequence(self.cacheSeq['idle'])

	self.data = {}
end

function ENT:Think() -- Used so that the animation runs at the correct FPS
	self:NextThink(CurTime())

	return true
end

function ENT:PostData()
	if self.data.general.spin then
		self:ResetSequence(self.cacheSeq['speen'])
	end
	if not self.data.general.rope then
		self:SetBodygroup(1, 1)
	end
end