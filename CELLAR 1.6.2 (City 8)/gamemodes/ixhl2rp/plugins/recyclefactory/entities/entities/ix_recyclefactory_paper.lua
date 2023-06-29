AddCSLuaFile()
DEFINE_BASECLASS("ix_recyclefactory_base")

ENT.PrintName = "Paper"
ENT.Category = "HL2 RP Recycle Factory"
ENT.Base = "ix_recyclefactory_base"
ENT.Spawnable = true
ENT.AdminSpawnable = true

local GARBAGE_ITEMS = {
	["empty_carton"] = 2,
	["empty_takeout_carton"] = 1,
	["empty_chinese_takeout"] = 1,
}

function ENT:GetWorkTime()
	return 15
end

function ENT:GetStartCost()
	return 4
end	

function ENT:GetWorkItem()
	return "paper"
end	

function ENT:GetDisplay()
	return "PAPER"
end	

function ENT:CanGarbageUsed(item)
	return GARBAGE_ITEMS[item]
end
