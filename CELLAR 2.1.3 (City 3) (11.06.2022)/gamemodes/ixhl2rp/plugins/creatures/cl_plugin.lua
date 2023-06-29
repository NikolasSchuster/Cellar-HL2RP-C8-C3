local PLUGIN = PLUGIN

net.Receive("UpdateClassTable", function(length)
	local client = net.ReadEntity()
	local class = net.ReadUInt(8)
	local infoTable = ix.class.list[class] and ix.class.list[class].infoTable

	if (IsValid(client) and istable(infoTable)) then
		client.infoTable = infoTable

		local hull = infoTable.hull
		local duckBy = infoTable.duckBy or 0

		if (isvector(hull) and isnumber(duckBy)) then
			client:SetStepSize(hull.z / 4)
			client:SetHull(-Vector(hull.x / 2, hull.y / 2, 0), Vector(hull.x / 2, hull.y / 2, hull.z))
			client:SetHullDuck(-Vector(hull.x / 2, hull.y / 2, 0), Vector(hull.x / 2, hull.y / 2, hull.z - duckBy or 0))
		else
			client:ResetHull()
			client:SetStepSize(18)
		end
	end
end)

net.Receive("ClearClassTable", function(length)
	local client = net.ReadEntity()

	if (IsValid(client)) then
		client.infoTable = nil

		client:ResetHull()
		client:SetStepSize(18)
	end
end)

net.Receive("HunterMuzzle", function(length)
	local client = net.ReadEntity()

	if (IsValid(client)) then
		if (client == LocalPlayer() and !ix.option.Get("thirdpersonEnabled", false)) then
			return
		end

		ParticleEffectAttach("hunter_muzzle_flash", PATTACH_POINT_FOLLOW, client, client.topEye and 5 or 4)
		client.topEye = !client.topEye
	end
end)

function PLUGIN:PlayerFootstep(client)
	local character = client:GetCharacter()

	if (!character) then
		return
	end

	if (client:SoundEvent("step", true)) then
		return true
	end
end

function PLUGIN:PlayerBindPress(client, bind, bPressed)
	if (bind:lower():find("impulse 100") and bPressed) then
		local faction = client:Team()

		if (faction != FACTION_ZOMBIE and faction != FACTION_SYNTH) then
			return
		end

		net.Start("FlashlightSwitched")
		net.SendToServer()

		local info = client:GetClassTable()

		if (info and info.bNoFlashlight) then
			return true
		end
	end
end

function PLUGIN:AdjustMouseSensitivity(oldSens)
	if (LocalPlayer():GetNetVar("ChargeTime", 0) ~= 0) then
		return LocalPlayer():GetClassTable().charge.steerMult or 0.025
	end
end

function PLUGIN:DoAnimationEvent(client, event, data)
	local info = client:GetClassTable()
	
	if info then
		if event == PLAYERANIMEVENT_JUMP then
			if info.jump then
				return ACT_INVALID
			end
		end
	end
end