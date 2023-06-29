--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

--
-- Common Prop Protection Interface Support
-- http://ulyssesmod.net/archive/CPPI_v1-1.pdf
--

local randomNumber = math.Round(math.random() *50000)

CPPI = CPPI or {}
CPPI.CPPI_DEFER = randomNumber
CPPI.CPPI_NOTIMPLEMENTED = randomNumber +1

--
--
--

function CPPI:GetName()
	return "ServerGuard"
end

--
--
--

function CPPI:GetVersion()
	return "1.1"
end

--
--
--

function CPPI:GetInterfaceVersion()
	return 1.1
end

--
--
--

function CPPI:GetNameFromUID(uniqueID)
	local target = util.FindPlayer(tostring(uniqueID))
	
	if (IsValid(target)) then
		return target:Nick()
	end
end

local meta = FindMetaTable("Player")

--
--
--

function meta:CPPIGetFriends()
	local serverguard = SERVER and self.serverguard or CLIENT and g_serverGuard
	
	return serverguard and serverguard.prop_protection.friends
end

local meta = FindMetaTable("Entity")

--
--
--

function meta:CPPIGetOwner()
	if (self.serverguard) then
		if (!IsValid(self.serverguard.owner) and self.serverguard.owner != game.GetWorld()) then
			for k, v in ipairs(player.GetAll()) do
				if (v:SteamID() == self.serverguard.steamID) then
					self.serverguard.owner = v;
				end;
			end;
		end;
		
		if (self.serverguard.owner) then
			if (IsValid(self.serverguard.owner) or self.serverguard.owner == game.GetWorld()) then
				return self.serverguard.owner, self.serverguard.uniqueID;
			end;
		end;
	else
		if (self.GetPlayer) then
			local pPlayer = self:GetPlayer();

			if (IsValid(pPlayer)) then
				if (SERVER) then
				    self:CPPISetOwner(pPlayer);
				end;

				return pPlayer, pPlayer:UniqueID();
			end;
		end;
	end;

	return CPPI.CPPI_DEFER, CPPI.CPPI_DEFER;
end;

if (SERVER) then
	local plugin = plugin
	
	--
	--
	--

	function meta:CPPISetOwner(pPlayer)
		self.serverguard = self.serverguard or {}
		
		local name
		local steamID
		local uniqueID
		
		if (pPlayer == game.GetWorld()) then
			name = "World"
			steamID = "World"
			uniqueID = "World"
		else
			name = serverguard.player:GetName(pPlayer)
			steamID = pPlayer:SteamID()
			uniqueID = pPlayer:UniqueID()
		end
		
		self.serverguard.owner = pPlayer
		self.serverguard.name = name
		self.serverguard.steamID = steamID
		self.serverguard.uniqueID = uniqueID
		
		serverguard.netstream.Start(nil, "sgPropProtectionClearEntityData", self);

		hook.Call("CPPIAssignOwnership", nil, pPlayer, self, uniqueID);
	end
	
	--
	--
	--

	function meta:CPPISetOwnerUID(uniqueID)
		self.serverguard.uniqueID = uniqueID
	end
	
	--
	--
	--

	function meta:CPPICanTool(pPlayer, toolMode)
		return plugin.CanTool(pPlayer, nil, toolMode)
	end
	
	--
	--
	--

	function meta:CPPICanPhysgun(pPlayer)
		return plugin.PhysgunPickup(pPlayer, self)
	end
	
	--
	--
	--

	function meta:CPPICanPickup(pPlayer)
		return plugin.GravGunPickupAllowed(pPlayer, self)
	end
end