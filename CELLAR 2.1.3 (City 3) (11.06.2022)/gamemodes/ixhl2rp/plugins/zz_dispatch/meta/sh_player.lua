do
	local CHAR = ix.meta.character
	CHAR.GetOriginalName = CHAR.GetName

	local function recognize(char, id)
		local other = ix.char.loaded[id]

		if other then
			local faction = ix.faction.indices[other:GetFaction()]

			if faction and faction.isGloballyRecognized then
				return true
			end
		end

		local recognized = char:GetData("rgn", "")

		if recognized != "" and recognized:find(","..id..",") then
			return true
		end
	end

	function CHAR:GetSquadName()
		local squad_name = self.dispatchSquad and self.dispatchSquad:GetMemberTag(self) or "ERROR"

		if CLIENT then
			local char = LocalPlayer():GetCharacter()

			if char then
				if recognize(char, self:GetID()) then
					return squad_name
				end

				local fakename = char:GetData("aw_KnowFakeNames",{})[self:GetID()]

				return fakename or squad_name
			end
		end
		
		return squad_name
	end
	
	function CHAR:SetSquad(squad)
		-- TO DO: Solve Name Issue
		self.lastSquad = self.dispatchSquad
		self.dispatchSquad = squad
		self.GetName = squad and CHAR.GetSquadName or nil

		if CLIENT then
			if self:GetPlayer() == LocalPlayer() then
				if squad then
					hook.Run("OnJoinSquad", squad)
				else
					hook.Run("OnLeftSquad", self.lastSquad)
				end
			end
		else
			hook.Run("OnCharacterSquadChanged", self, self.lastSquad, self.dispatchSquad)
		end
	end

	function CHAR:GetSquad()
		return self.dispatchSquad
	end

	if SERVER then
		function CHAR:LeaveSquad()
			local squad = self:GetSquad()

			if squad then
				squad:RemoveMember(self, false, true)
			end
		end
	end
end

do
	local PLAYER = FindMetaTable("Player")

	if SERVER then
		function PLAYER:LeaveSquad()
			local character = self:GetCharacter()

			if character then
				character:LeaveSquad()
			end
		end
	end
end