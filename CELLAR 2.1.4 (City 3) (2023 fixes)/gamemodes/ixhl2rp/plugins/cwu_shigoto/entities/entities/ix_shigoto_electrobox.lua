local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "Electrobox"
ENT.Category = "CWU - HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = false
ENT.bNoPersist = true

if (SERVER) then
    
    function ENT:Initialize()

        self:SetNetVar("isbroken", false)
		self:SetNetVar("capacity", 100)
		self:SetModel("models/props_silo/electricalbox02.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self.nextUseTime = 0


    end
end

local qte_num = ix.config.Get("qte_numbers") 

for k,v in RandomPairs(qte_num) do
    print( v )
end