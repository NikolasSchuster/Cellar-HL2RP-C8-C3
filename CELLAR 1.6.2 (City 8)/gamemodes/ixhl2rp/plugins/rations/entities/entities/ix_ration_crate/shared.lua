DEFINE_BASECLASS("base_gmodentity")

ENT.Type = "anim"
ENT.Author = "SchwarzKruppzo"
ENT.PrintName = "Empty Ration Crate"
ENT.Category = "HL2 RP Ration Factory"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.bNoPersist = true
ENT.isRationCrate = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "Count")
end
