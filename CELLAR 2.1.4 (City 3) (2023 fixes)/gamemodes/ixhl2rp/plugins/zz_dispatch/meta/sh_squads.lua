if SERVER then
	util.AddNetworkString("ixSquadAddMember")
	util.AddNetworkString("ixSquadKickMember")
	util.AddNetworkString("ixSquadLeader")
	util.AddNetworkString("ixSquadSync")
	util.AddNetworkString("ixSquadSyncFull")
	util.AddNetworkString("ixSquadDestroy")
end

ix.util.Include("sh_player.lua")

local SQUAD = ix.meta.squad or {}
	SQUAD.__index = SQUAD

	SQUAD.tag = 0
	SQUAD.leader = nil
	SQUAD.members = {}
	SQUAD.member_counter = 0 -- used for limit condition
	SQUAD.counter = 0 -- used for UNIT TAGS
	SQUAD.players = {} -- cache of player entities, for fastest operating in UI

	function SQUAD:GetTagName()
		return dispatch.available_tags[self.tag] or "ERROR"
	end

	function SQUAD:GetMemberTag(character)
		local rank = ix.class.list[character:GetClass()].tag
		return string.format(dispatch.name_format, rank and rank.."." or "", self:GetTagName(), self.members[character] or 0)
	end
	
	function SQUAD:GetLimitCount()
		return self.member_counter
	end

	function SQUAD:GetPlayers()
		return self.players
	end

	function SQUAD:HasMember(character)
		return self.members[character]
	end
	
	function SQUAD:HasPlayer(client)
		return self.members[client:GetCharacter()]
	end

	function SQUAD:IsLeader(character)
		return self.leader == character
	end

	function SQUAD:IsStatic()
		return self.isStatic
	end

	function SQUAD:Setup(tag, character, isStatic)
		self.tag = tag
		self.leader = character
		self.members = {}
		self.counter = 0  
		self.member_counter = 0
		self.players = {}
		self.isStatic = isStatic

		if !isStatic then
			self:AddMember(character, true)
		end
	end

	function SQUAD:RecachePlayers()
		self.players = {}

		for character, _ in pairs(self.members) do
			local client = character:GetPlayer()
			if !client then continue end
			
			self.players[#self.players + 1] = client
		end
	end
	
	function SQUAD:AddMember(character, noNetwork)
		if !self:IsStatic() and self:GetLimitCount() >= dispatch.GetMemberLimit() then
			return false, "its full lmao"
		end

		local other_squad = character:GetSquad()

		if other_squad == self then
			return false, "already in this squad"
		elseif other_squad then
			other_squad:RemoveMember(character, false, true)
		end
		
		self.counter = self.counter + 1

		self.members[character] = self.counter
		self.member_counter = self.member_counter + 1 

		character:SetSquad(self)

		if SERVER and !noNetwork then
			net.Start("ixSquadAddMember")
				net.WriteUInt(self.tag, 5)
				net.WriteUInt(character:GetID(), 32)
			net.Send(dispatch.GetReceivers())
		end

		self:RecachePlayers()

		return true
	end

	function SQUAD:RemoveMember(character, noNetwork, full)
		if !character or !self:HasMember(character) then
			return false
		end 
		
		self.members[character] = nil
		self.member_counter = self.member_counter - 1 

		if !full then
			dispatch.unassigned_squad:AddMember(character)
		else
			character:SetSquad()
		end

		if SERVER then
			if !self:IsStatic() and self:GetLimitCount() <= 0 then
				self:Destroy(character)

				return true
			end

			if !noNetwork then
				net.Start("ixSquadKickMember")
					net.WriteUInt(self.tag, 5)
					net.WriteUInt(character:GetID(), 32)
					net.WriteBool(full)
				net.Send(dispatch.GetReceivers())
			end

			if self:IsLeader(character) then -- he was 
				self:SwitchLeader()
			end
		end

		self:RecachePlayers()

		return true
	end

	function SQUAD:SetLeader(character, noNetwork)
		if !self:HasMember(character) then
			return false
		end 

		self.leader = character

		if SERVER and !noNetwork then
			net.Start("ixSquadLeader")
				net.WriteUInt(self.tag, 5)
				net.WriteUInt(character:GetID(), 32)
			net.Send(dispatch.GetReceivers())
		end

		return true
	end

	function SQUAD:Destroy()
		if self:IsStatic() then
			return
		end
		
		if SERVER then
			net.Start("ixSquadDestroy")
				net.WriteUInt(self.tag, 5)
			net.Send(dispatch.GetReceivers())
		else
			for character, _ in pairs(self.members) do
				--character:SetSquad()

				dispatch.unassigned_squad:AddMember(character)
			end
		end

		dispatch.squads[self.tag] = nil
	end
	
	if SERVER then
		function SQUAD:SwitchLeader()
			for character, _ in pairs(self.members) do
				self:SetLeader(character)
				break
			end
		end

		function SQUAD:Sync(full, receivers)
			receivers = receivers or dispatch.GetReceivers()

			local leaderID = self:IsStatic() and 0 or self.leader:GetID()

			for char, counter in pairs(self.members) do
				if !IsValid(char:GetPlayer()) then
					self:RemoveMember(char, false, true)
				end
			end

			if !full then
				net.Start("ixSquadSync")
					net.WriteUInt(self.tag, 5)
					net.WriteUInt(leaderID, 32)
				net.Send(receivers)
			else
				net.Start("ixSquadSyncFull")
					net.WriteUInt(self.tag, 5)
					net.WriteUInt(leaderID, 32)
					net.WriteUInt(self.counter, 8)

					local members = {}

					for char, counter in pairs(self.members) do
						members[char:GetID()] = counter
					end

					net.WriteTable(members)
				net.Send(receivers)
			end
		end
	end
ix.meta.squad = SQUAD

if CLIENT then
	net.Receive("ixSquadDestroy", function(len)
		local tagID = net.ReadUInt(5)
		local squad = dispatch.squads[tagID]

		if squad then
			squad:Destroy()

			hook.Run("OnSquadDestroy", tagID, squad)
		end
	end)

	net.Receive("ixSquadSync", function(len)
		local tagID = net.ReadUInt(5)
		local leaderID = net.ReadUInt(32)
		local character = ix.char.loaded[leaderID]
		local squad = dispatch.CreateSquad(character, tagID)

		hook.Run("OnSquadSync", tagID, squad)
	end)
	
	net.Receive("ixSquadSyncFull", function(len)
		local tagID = net.ReadUInt(5)
		local leaderID = net.ReadUInt(32)
		local isStatic = leaderID == 0
		local counter = net.ReadUInt(8)
		local members = net.ReadTable()

		local leader = ix.char.loaded[leaderID]

		local SQUAD = dispatch.CreateSquad(isStatic and nil or leader, tagID, isStatic)

		if !SQUAD then
			print("SQUAD SYNC ERROR!")
			return
		end
		
		SQUAD.members = {}
		SQUAD.counter = counter

		for charID, id in pairs(members) do
			local character = ix.char.loaded[charID]

			if !character then continue end
			
			if !SQUAD.members[character] then
				SQUAD.members[character] = id
				SQUAD.member_counter = SQUAD.member_counter + 1
			end

			character:SetSquad(SQUAD)
		end

		SQUAD:RecachePlayers()

		hook.Run("OnSquadSync", tagID, SQUAD, true)
	end)

	net.Receive("ixSquadAddMember", function(len)
		local tagID = net.ReadUInt(5)
		local charID = net.ReadUInt(32)
		local squad = dispatch.squads[tagID]

		if squad then
			local character = ix.char.loaded[charID]

			squad:AddMember(character)

			hook.Run("OnSquadMemberJoin", tagID, squad, character)
		end
	end)

	net.Receive("ixSquadKickMember", function(len)
		local tagID = net.ReadUInt(5)
		local charID = net.ReadUInt(32)
		local full = net.ReadBool()
		local squad = dispatch.squads[tagID]

		if squad then
			local character = ix.char.loaded[charID]
			
			squad:RemoveMember(character, false, full)

			hook.Run("OnSquadMemberLeft", tagID, squad, character)
		end
	end)

	net.Receive("ixSquadLeader", function(len)
		local tagID = net.ReadUInt(5)
		local charID = net.ReadUInt(32)
		local squad = dispatch.squads[tagID]

		if squad then
			local character = ix.char.loaded[charID]
			
			squad:SetLeader(character)

			hook.Run("OnSquadChangedLeader", tagID, squad, character)
		end
	end)
end
