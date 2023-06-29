include("shared.lua")

function ENT:Initialize()
	self.letters = {}

	self.hasInitialized = true
end

function ENT:PostData()
	if not self.hasInitialized then
		self:Initialize()
	end
	
	local letterMap = PerfectCasino.Core.Letter

	-- Letter calculations
	local startPoint = self:GetRight() * 25
	local curLength = vector_origin
	local right = self:GetRight()

	for k, v in ipairs(string.Split(string.lower(self.data.general.text), "")) do
		if not letterMap[v] then -- It's either a space or a character we don't support
			curLength = curLength + (self:GetRight() * 5)
			continue
		end

		-- Create the letter
		local letter = ClientsideModel("models/freeman/owain_casino_alphabet.mdl")
		table.insert(self.letters, letter)
		letter:SetParent(self)
		curLength = curLength + ((self:GetRight()) * (letterMap[v].w*2))
		letter:SetPos(self:GetPos() + startPoint - curLength + ((self:GetRight()) * (letterMap[v].w)))
		letter:SetAngles(self:GetAngles())
		letter:SetBodygroup(1, letterMap[v].b)
	end
end

function ENT:OnRemove()
	-- Clear the board of last rounds best
	for k, v in pairs(self.letters) do
		if not IsValid(v) then continue end

		v:Remove()
	end
end

function ENT:Draw()
	self:DrawModel()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 1000000 then return end

	-- We can piggyback off the distance check to only request the entities data when it's needed :D
	if (not self.data) and (not PerfectCasino.Cooldown.Check(self:EntIndex(), 5)) then
		PerfectCasino.Core.RequestConfigData(self)
		return
	end
end