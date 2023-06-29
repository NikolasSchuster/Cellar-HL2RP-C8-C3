local PLUGIN = PLUGIN


util.AddNetworkString("ixUpdateQuests")
util.AddNetworkString("ixQuestPickup")

function PLUGIN:OnPlayerClearGarbage(client)
	local character = client:GetCharacter()
	local quests = character:GetData("quests", {})

	if quests["cwu_garbage"] then
		local garbages = character:GetData("cwuGarbage", 0)

		if garbages < 4 then
			character:SetData("cwuGarbage", math.Clamp(garbages + 1, 0, 4))
		end
	end
end

function PLUGIN:CharacterLoaded(character)
	timer.Simple(1, function()
		net.Start("ixUpdateQuests")
		net.Send(character:GetPlayer())
	end)
end
