DEFINE_BASECLASS("base_gmodentity")

ENT.Type = "anim"
ENT.Author = "SchwarzKruppzo"
ENT.PrintName = "Empty Ration Dispenser"
ENT.Category = "HL2 RP Ration Factory"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Ration")
	self:NetworkVar("Float", 1, "Flash")
	self:NetworkVar("Bool", 0, "Locked")
	self:NetworkVar("String", 0, "Text")
	self:NetworkVar("Int", 0, "DispColor")
end