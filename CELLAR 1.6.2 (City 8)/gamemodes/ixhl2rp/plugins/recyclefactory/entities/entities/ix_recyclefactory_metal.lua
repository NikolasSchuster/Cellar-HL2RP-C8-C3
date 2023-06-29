AddCSLuaFile()
DEFINE_BASECLASS("ix_recyclefactory_base")

ENT.PrintName = "Metal"
ENT.Category = "HL2 RP Recycle Factory"
ENT.Base = "ix_recyclefactory_base"
ENT.Spawnable = true
ENT.AdminSpawnable = true

local GARBAGE_ITEMS = {
	["empty_can"] = 0.5,
	["empty_tin_can"] = 1,
	["ration_package"] = 2,
}
function ENT:GetWorkTime()
	return 30
end

function ENT:GetStartCost()
	return 10
end	

function ENT:GetWorkItem()
	return "scrap_metal"
end	

function ENT:GetDisplay()
	return "METAL"
end	

function ENT:CanGarbageUsed(item)
	return GARBAGE_ITEMS[item]
end
