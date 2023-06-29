if SERVER then 
	AddCSLuaFile() 
end

local entityMeta = FindMetaTable("Entity")

function entityMeta:GetSkingroup(id)
	return (self:GetNWInt("sg_"..id) or 0)
end

function entityMeta:GetPrimaryVisorColor()
	return self:GetNWVector("PrimaryVisorColor")
end

function entityMeta:GetSecondaryVisorColor()
	return self:GetNWVector("SecondaryVisorColor")
end

function entityMeta:SetPrimaryVisorColor(vector)
	self:SetNWVector("PrimaryVisorColor", isvector(vector) and vector or Vector(0,0,0))
end

function entityMeta:SetSecondaryVisorColor(vector)
	self:SetNWVector("SecondaryVisorColor", isvector(vector) and vector or Vector(0,0,0))
end
