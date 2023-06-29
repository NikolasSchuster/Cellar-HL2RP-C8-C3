local BASE_RATE_H = 140
local BASE_RATE_T = 120

function PLUGIN:FoodTick(client)
	local character = client:GetCharacter()

	if (!character or client:GetMoveType() == MOVETYPE_NOCLIP) then
		return
	end

	local curTime = CurTime()
	local tickTime = ix.config.Get("needsTickTime", 4)
	local scale = 1

	character:SetHunger(math.Clamp(character:GetHunger() - (60 * scale * tickTime / (3600 * ix.config.Get("needsHungerHours", 6))), 0, 100))
	character:SetThirst(math.Clamp(character:GetThirst() - (60 * scale * tickTime / (3600 * ix.config.Get("needsThirstHours", 4))), 0, 100))
end

function PLUGIN:SetupFoodTimer(client)
	local uniqueID = "ixFood" .. client:SteamID()
	timer.Remove(uniqueID)

	local character = client:GetCharacter()
	if character then
		local faction = ix.faction.indices[character:GetFaction()]

		if faction.dontNeedFood then
			return
		end
	end

	timer.Create(uniqueID, ix.config.Get("needsTickTime", 4), 0, function()
		if !IsValid(client) then
			timer.Remove(uniqueID)
			return
		end

		self:FoodTick(client)
	end)
end

function PLUGIN:PostPlayerLoadout(client)
	self:SetupFoodTimer(client)
end

ix.config.Add("needsTickTime", 4, "How many seconds between each time a character's needs are calculated.", function(_, new)
		for _, client in ipairs(player.GetAll()) do
			PLUGIN:SetupFoodTimer(client)
		end
	end, {
	data = {min = 1, max = 24},
	category = "needs"
})