local PLUGIN = PLUGIN

PLUGIN.name = "Auto-Walk"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

local exitKeys = {IN_FORWARD, IN_BACK, IN_MOVELEFT, IN_MOVERIGHT}

function PLUGIN:SetupMove(client, move, usercmd)
	if !client.ixAutoWalk then 
		return 
	end

	move:SetForwardSpeed(move:GetMaxSpeed())

	for _, v in ipairs(exitKeys) do
		if usercmd:KeyDown(v) then
			client.ixAutoWalk = nil
		end
	end
end

function PLUGIN:PlayerButtonDown(client, btn)
	local curtime = CurTime()
	
	if btn == KEY_N and (!client.nextAutoWalk or client.nextAutoWalk <= curtime) then
		client.ixAutoWalk = !client.ixAutoWalk
		client.nextAutoWalk = curtime + 0.1
	end
end
