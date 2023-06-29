local PLUGIN = PLUGIN

util.AddNetworkString("ixPlayerSit")

net.Receive("ixPlayerSit", function(len, player)
	if player:Team() == FACTION_DISPATCH then
		return
	end
	
	local pos = net.ReadVector()
	local ang = net.ReadAngle()
	local option = math.Clamp(net.ReadUInt(5) or 1, 1, #PLUGIN.sitStances)
	local faction = player:Team()
	local character = player:GetCharacter()

	if player.ixUntimedSequence then
		return
	end

	if player:IsPilotScanner() then
		return
	end

	--if faction == FACTION_VORT then return; end
	
	if (!PLUGIN:CanSit(player, pos, option, character)) then
		return
	end

	if (!player.cwNextStance or CurTime() >= player.cwNextStance) then
		if (player:IsProne()) then
			prone.Exit(player)
		end

		player.cwNextStance = CurTime() + 2;

		local sitOffset = PLUGIN.sitOffsets[option] or vector_origin

		if character and character:GetGender() == GENDER_FEMALE then
			sitOffset = PLUGIN.sitOffsetsF[option] or sitOffset
		end

		local finalPos = pos + ang:Forward() * sitOffset.x + Vector(0, 0, sitOffset.z)
		
		player.latestSitPos = player:GetPos()
		player.latestSitAng = player:GetAngles()
		player.latestCharKey = player:GetCharacter():GetID()

		player:SetPos(finalPos)
		local angles = player:GetAngles()
		angles.y = ang.y
		player:SetAngles(angles)
		player:SetLocalVelocity(vector_origin)
		player:SetVelocity(vector_origin)

		player:SetNetVar("sitHelperPos", player:GetPos())
		player:SetNetVar("actEnterAngle", player:GetAngles())
		player.ixUntimedSequence = true
		player:SetCollisionGroup(COLLISION_GROUP_WORLD)
		player:ForceSequence(PLUGIN.sitStances[option], nil, 0, nil)
		

		net.Start("ixActEnter")
			net.WriteBool(true)
		net.Send(player)
	end
end)

function PLUGIN:PlayerLeaveSequence(client)
	if (client:GetNetVar("sitHelperPos")) then
		client.ixUntimedSequence = nil

		client:SetNetVar("sitHelperPos", nil)
		client:SetNetVar("actEnterAngle", nil)

		if client.latestCharKey == client:GetCharacter():GetID() then
			client:SetPos(client.latestSitPos)
			client:SetAngles(client.latestSitAng)
		end

		client.latestSitPos = nil
		client.latestSitAng = nil
		client.latestCharKey = nil
		
		client:SetLocalVelocity(vector_origin)
		client:SetVelocity(vector_origin)
		client:SetCollisionGroup(COLLISION_GROUP_PLAYER)

		net.Start("ixActLeave")
		net.Send(client)
	end
end

PLUGIN["prone.CanEnter"] = function(self, client)
	if (client:GetNetVar("sitHelperPos")) then
		return false
	end
end
