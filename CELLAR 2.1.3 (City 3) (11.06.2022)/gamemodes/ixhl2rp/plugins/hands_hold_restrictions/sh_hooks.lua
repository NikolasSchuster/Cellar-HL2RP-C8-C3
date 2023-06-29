
local speedMultipliers = {}

local function GetHeldChar(client)
	local heldPlayer = client.ixHeldPlayer

	if (IsValid(heldPlayer)) then
		return heldPlayer
	end

	return false
end

function PLUGIN:InitializedPlugins()
	speedMultipliers[FACTION_OTA] = 0.25
	speedMultipliers[FACTION_EOW] = 0.25
end

function PLUGIN:SetupMove(client, moveData)
	local heldPlayer = GetHeldChar(client)

	if (heldPlayer) then
		if (client:IsProne() and prone.CanExit(client)) then
			prone.Exit(client)
		end

		local character = client:GetCharacter()
		local strength = character:GetSpecial("st")
		local strengthFraction = 1 - strength / ix.config.Get("maxAttributes", 10)
		local speedMultiplier = speedMultipliers[heldPlayer:Team()] or 0.5
		speedMultiplier = math.abs(speedMultiplier * strengthFraction - 1)

		moveData:SetMaxClientSpeed(client:GetWalkSpeed() * speedMultiplier)
	end
end

PLUGIN["prone.CanEnter"] = function(_, client)
	if (GetHeldChar(client)) then
		return false
	end
end

if (SERVER) then
	function PLUGIN:CanPlayerHoldObject(client, entity)
		if (entity.ixPlayer) then
			local character = client:GetCharacter()

			if (character:GetSpecial("st") < 2) then
				return false
			end
		end
	end
end
