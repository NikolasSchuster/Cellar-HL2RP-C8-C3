AddCSLuaFile()
DEFINE_BASECLASS("ix_recyclefactory_base")

ENT.PrintName = "Metal"
ENT.Category = "HL2 RP Recycle Factory"
ENT.Base = "ix_recyclefactory_base"
ENT.Spawnable = true
ENT.AdminSpawnable = true

local GARBAGE_ITEMS = {
	["empty_can"] = 0.5,
	["empty_tin_can"] = 0.5,
	["metal_scrap"] = 2,
	["metal_armature"] = 2,
	["broken_mp7"] = 4,
	["broken_shotgun"] = 4,
	["broken_pistol"] = 2,
	["broken_357"] = 2,
	["chain"] = 0.5,
	["pan"] = 3,
	["crowbar"] = 2,
	["knife"] = 1,
	["tool_scissors"] = 1,
	["tool_hammer"] = 2,
	["tool_screw"] = 1,
	["flashlight"] = 1
}

function ENT:GetWorkTime()
	return 30
end

function ENT:GetStartCost()
	return 10
end

function ENT:GetWorkItem()
	return "metal_reclaimed"
end

function ENT:GetDisplay()
	return "METAL"
end

function ENT:CanGarbageUsed(item)
	return GARBAGE_ITEMS[item]
end
