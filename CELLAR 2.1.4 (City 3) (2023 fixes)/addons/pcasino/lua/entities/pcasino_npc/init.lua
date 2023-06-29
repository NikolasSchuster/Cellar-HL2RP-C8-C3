AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local models = {}
-- The female models
for i=1, 6 do
	table.insert(models, "models/freeman/pcasino/owain_croupier_female0"..i..".mdl")
end
-- The male models
for i=1, 9 do
	table.insert(models, "models/freeman/pcasino/owain_croupier_male0"..i..".mdl")
end
function ENT:Initialize()
	self:SetModel(table.Random(models))
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetTrigger(true)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE + CAP_TURN_HEAD)

	self:SetSequence(self:LookupSequence("idle_subtle"))
end

function ENT:OnTakeDamage()        
	return 0    
end

function ENT:PostData()
end

function ENT:AcceptInput(name, ply)
	if (not self.data.text.chat) or (self.data.text.chat == " ") then return end

	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end

	if PerfectCasino.Cooldown.Check("pCasino:NPC", 1, ply) then return end

	if self:GetPos():DistToSqr(ply:GetPos()) > 200000 then return end

	PerfectCasino.Core.Msg(self.data.text.chat, ply)
end
