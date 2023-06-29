local PLUGIN = PLUGIN

PLUGIN.PassiveXPGain = 1
PLUGIN.MaxPassiveLevel = 3
PLUGIN.PassiveXPRate = 5 * 60 -- every 5 minutes

function PLUGIN:PostPlayerLoadout(client)
	local character = client:GetCharacter()
	local uniqueID = "ixLeveling" .. client:SteamID()
	timer.Remove(uniqueID)

	if character and character:GetLevel() < self.MaxPassiveLevel then
		timer.Create(uniqueID, self.PassiveXPRate, 0, function()
			if !IsValid(client) then
				timer.Remove(uniqueID)
				return
			end

			local character = client:GetCharacter()

			if !character or character:GetLevel() >= self.MaxPassiveLevel then
				timer.Remove(uniqueID)
				return
			end

			character:AddLevelXP(self.PassiveXPGain, 1)
		end)
	end
end

function PLUGIN:OnCharacterCreated(client, character)
	local faction = ix.faction.indices[character:GetFaction()]

	if faction and faction.defaultLevel then
		character:SetLevel(faction.defaultLevel)
	end
end

local xpPerSymbol = 0.008

local function GetTextXP(text, level)
	local length = string.utf8len(text)
	local words = #string.Explode(" ", text) or 0
	local symbols = length - (length / words)
	local b = 1 - ((level - 1) / 10) ^ 1.44
	local a = (b ^ (1.5 + (1.75 ^ (1 - b))))
	local xp = (xpPerSymbol * symbols) * a

	return xp
end

local blacklist = {
	["pm"] = true,
	["looc"] = true,
	["ooc"] = true,
	["adminchat"] = true,
	["it"] = true,
}

function PLUGIN:PlayerMessageSend(speaker, chatType, text, bAnonymous, receivers, rawText)
	if IsValid(speaker) and !blacklist[chatType] then
		for _, client in pairs(receivers) do
			if client == speaker then continue end

			local character = client:GetCharacter()

			character:AddLevelXP(GetTextXP(text, character:GetLevel()), 2)
		end
	end
end