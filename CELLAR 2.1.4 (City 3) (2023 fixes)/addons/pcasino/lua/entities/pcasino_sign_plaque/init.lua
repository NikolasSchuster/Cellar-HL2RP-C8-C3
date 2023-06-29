AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/freeman/owain_casinosign_text.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self.data = {}
end

-- Backplate is 52 units by default, anything added to poseparam is an extension of that 52

function ENT:PostData()
	local letterMap = PerfectCasino.Core.Letter

	-- Back plate calculations
	local plateSize = 0

	for k, v in ipairs(string.Split(string.lower(self.data.general.text), "")) do
		if not letterMap[v] then -- It's either a space or a character we don't support
			plateSize = plateSize + 5.2
			continue
		end
		-- Back plate calcuation
		plateSize = plateSize + (letterMap[v].w*2)
	end

-- 88.3 backplate = 86.2 text size
-- 1.02 backplate = 1 text size

	self:SetPoseParameter("textbase_length", (1.02*plateSize) - 52)
end