util.AddNetworkString("squad.menu.datafile")
util.AddNetworkString("squad.menu.leader")
util.AddNetworkString("squad.menu.move")
util.AddNetworkString("squad.menu.reward")
util.AddNetworkString("squad.menu.spectate")
util.AddNetworkString("squad.menu.disband")
util.AddNetworkString("squad.menu.rewardall")

local ACCESS = {
	DISPATCH = 1,
	LEADER = 2,
	ALL = 4
}

local function CanUseMemberInteraction(client, target, access, minDatafileAccess)
	local character = client:GetCharacter()

	if !character or !target then return false end
	if !target:IsCombine() then return false end
	if minDatafileAccess and character:ReturnDatafilePermission() < minDatafileAccess then return false end

	local squad = character:GetSquad()
	local isPlayerDispatch = client:Team() == FACTION_DISPATCH

	local isDispatch = bit.band(access, ACCESS.DISPATCH) != 0 and isPlayerDispatch
	local isLeader = bit.band(access, ACCESS.LEADER) != 0 and (!isPlayerDispatch and (squad:IsLeader(character) and target:GetSquad() == squad) or false)

	if bit.band(access, ACCESS.ALL) != 0 or (isDispatch or isLeader) then
		return true
	end

	return false
end

function dispatch.OpenDatafile(client, target)
	local card = target:GetIDCard()

	if card then
		ix.command.Run(client, "Datafile", {card:GetData("cid", 0), card:GetData("number", 0)})
	end
end

net.Receive("squad.menu.datafile", function(len, client)
	local id = net.ReadUInt(32)
	local character = ix.char.loaded[id]

	if !character then return end
	if !CanUseMemberInteraction(client, character, ACCESS.ALL, 2) then return end

	dispatch.OpenDatafile(client, character)
end)

net.Receive("squad.menu.leader", function(len, client)
	local id = net.ReadUInt(32)
	local character = ix.char.loaded[id]

	if !character then return end

	local targetSquad = character:GetSquad()

	if !targetSquad or targetSquad:IsStatic() or targetSquad:IsLeader(character) then return end
	if !CanUseMemberInteraction(client, character, bit.bor(ACCESS.DISPATCH, ACCESS.LEADER)) then return end

	targetSquad:SetLeader(character)

	ix.log.Add(client:GetCharacter(), "squadLeader", targetSquad:GetTagName(), character)
end)

net.Receive("squad.menu.move", function(len, client)
	local id, new, squad_tag = net.ReadUInt(32), net.ReadBool(), net.ReadInt(5)
	local character = ix.char.loaded[id]
	local targetSquad = dispatch.GetSquads()[squad_tag]

	if !character then return end

	local squad = character:GetSquad()

	if !CanUseMemberInteraction(client, character, new and bit.bor(ACCESS.DISPATCH, ACCESS.LEADER) or ACCESS.DISPATCH) then return end

	local oldname = character:GetName()
	local newSquad = targetSquad
	if new then
		if client:Team() == FACTION_DISPATCH then
			newSquad = dispatch.CreateSquad(character)
		else
			if squad and !squad:IsStatic() then
				squad:RemoveMember(character)
			end
		end
	else
		if targetSquad then
			targetSquad:AddMember(character)
		end
	end

	ix.log.Add(client:GetCharacter(), "squadMove", oldname, newSquad and newSquad:GetTagName() or "UNIT")
end)

local DATAFILE = ix.plugin.list["datafile"]
net.Receive("squad.menu.reward", function(len, client)
	local id, points, reason = net.ReadUInt(32), net.ReadInt(32), net.ReadString()
	local character = ix.char.loaded[id]

	if !character then return end
	if !CanUseMemberInteraction(client, character, ACCESS.DISPATCH) then return end

	local datafileID = character:GetPlayer().ixDatafile

	if datafileID then
		DATAFILE:AddEntry(client, datafileID, "civil", reason, points)
	end

	character:GetPlayer():NotifyLocalized(points < 0 and "dispatchMinus" or "dispatchReward", client:GetName(), points, reason)
	ix.log.Add(client:GetCharacter(), "squadReward", character, points, reason)
end)

net.Receive("squad.menu.spectate", function(len, client)
	local id = net.ReadUInt(32)
	local character = ix.char.loaded[id]

	if !character then return end
	if !CanUseMemberInteraction(client, character, ACCESS.DISPATCH) then return end

	dispatch.Spectate(client, character:GetPlayer())

	ix.log.Add(client:GetCharacter(), "squadObserve", character)
end)

net.Receive("squad.menu.disband", function(len, client)
	local squad_tag = net.ReadUInt(5)
	local targetSquad = dispatch.GetSquads()[squad_tag]
	local character = client:GetCharacter()

	if !character or !targetSquad or targetSquad:IsStatic() then return end

	local isLeader = targetSquad:IsLeader(character)
	local isDispatch = client:Team() == FACTION_DISPATCH

	if isDispatch or isLeader then
		targetSquad:Destroy()

		ix.log.Add(character, "squadDestroy", targetSquad:GetTagName())
	end
end)

net.Receive("squad.menu.rewardall", function(len, client)
	local squad_tag, points, reason = net.ReadUInt(5), net.ReadInt(32), net.ReadString()
	local targetSquad = dispatch.GetSquads()[squad_tag]
	local character = client:GetCharacter()

	if !character or !targetSquad or targetSquad:IsStatic() then return end
	if !CanUseMemberInteraction(client, character, ACCESS.DISPATCH) then return end

	for k, v in pairs(targetSquad:GetPlayers()) do
		local datafileID = v.ixDatafile

		if datafileID then
			DATAFILE:AddEntry(client, datafileID, "civil", reason, points)
		end

		v:NotifyLocalized(points < 0 and "dispatchMinusAll" or "dispatchRewardAll", client:GetName(), points, reason)
	end

	ix.log.Add(client:GetCharacter(), "squadRewardAll", targetSquad:GetTagName(), points, reason)
end)