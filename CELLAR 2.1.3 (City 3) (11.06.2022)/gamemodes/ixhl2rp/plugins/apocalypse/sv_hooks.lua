local PLUGIN = PLUGIN

function PLUGIN:CharacterLoaded(character)
	if character:GetData("zombie", false) and character:GetData("zstage", 1) != 3 then
		local timerID = "ixInfection_" .. character:GetID()
		timer.Create(timerID, 600, 3 - character:GetData("zstage"), function()
			if not character then
				timer.Remove(timerID)
			end
			self:AdvanceDisease(character)
		end)
	end
end

function PLUGIN:CanPlayerEquipItem(client, item, slot)
	if not IsValid(client) then return end
	local char = client:GetCharacter()
	return not (char:GetData("zombie", false) and (char:GetData("zstage") == 3))
end

function PLUGIN:CanPlayerInteractItem(client, action)
	if not IsValid(client) then return end
	local char = client:GetCharacter()
	return not (char:GetData("zombie", false) and (char:GetData("zstage") == 3))
end

hook.Add("prone.CanEnter", "Infection", function(client)
	if not IsValid(client) then return end
	local char = client:GetCharacter()
	return not (char:GetData("zombie", false) and (char:GetData("zstage") == 3))
end)
