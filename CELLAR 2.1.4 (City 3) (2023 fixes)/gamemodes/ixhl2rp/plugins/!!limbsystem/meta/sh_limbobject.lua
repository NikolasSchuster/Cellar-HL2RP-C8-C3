ix.limb.stored = {}

local LIMB = {}
LIMB.__index = LIMB
LIMB[0] = 0
LIMB[1] = false -- hitgroup
LIMB[2] = "" --name
LIMB[3] = false -- texture
LIMB[4] = false --isHidden

function LIMB:__tostring() return "Limb["..self[2].."]" end
function LIMB:ID() return self[0] end
function LIMB:HitGroup() return self[1] end
function LIMB:Name() return self[2] end
function LIMB:Texture() return self[3] end
function LIMB:IsHidden() return self[4] end

local LIMBDATA = {}
LIMBDATA.__index = LIMBDATA
LIMBDATA.id = "unknown"
LIMBDATA.stored = {}
LIMBDATA.hgroups = {}
LIMBDATA.bodytexture = false

function LIMBDATA:__tostring()
	return "LimbData["..self.id.."]"
end

function LIMBDATA:AddLimb(name, hitgroup, texture)
	local limb = setmetatable({}, LIMB)
	limb[1] = hitgroup
	limb[2] = name

	if !hitgroup then
		limb[4] = true
	else
		limb[3] = texture
	end

	local id = #self.stored + 1

	limb[0] = id

	self.stored[id] = limb

	self["Get"..name:sub(1, 1):upper()..name:sub(2)] = function() return limb end

	if hitgroup then
		self.hgroups[hitgroup] = self.stored[id]
	end
end

function LIMBDATA:Get(num)
	return self.stored[num]
end

function LIMBDATA:GetByHitgroup(hitgroup)
	return self.hgroups[hitgroup]
end

function LIMBDATA:Register()
	return ix.limb.Register(self)
end

function ix.limb.New(id, bodytexture)
	local object = setmetatable({}, LIMBDATA)
	object.id = id or "unknown"
	object.bodytexture = bodytexture or false
	object.stored = {}
	object.hgroups = {}

	return object
end

function ix.limb.Register(limbdata)
	ix.limb.stored[limbdata.id] = limbdata

	return limbdata
end

function ix.limb.Get(id)
	return ix.limb.stored[id]
end