AddCSLuaFile()
DEFINE_BASECLASS("ix_recyclefactory_base")

ENT.PrintName = "Plastic"
ENT.Category = "HL2 RP Recycle Factory"
ENT.Base = "ix_recyclefactory_base"
ENT.Spawnable = true
ENT.AdminSpawnable = true

local GARBAGE_ITEMS = {
	["electro_reclaimed"] = 2,
	["electro_circuit"] = 1,
	["empty_plastic_can"] = 0.5,
	["empty_plastic_bottle"] = 0.5,
	["empty_jug"] = 0.5,
	["empty_plastic_can"] = 0.5
}

function ENT:GetWorkTime()
	return 20
end

function ENT:GetStartCost()
	return 8
end

function ENT:GetWorkItem()
	return "plastic"
end

function ENT:GetDisplay()
	return "PLASTIC"
end

function ENT:CanGarbageUsed(item)
	return GARBAGE_ITEMS[item]
end
