local PLUGIN = PLUGIN

function PLUGIN:OnCharacterCreated(client, character)
	character:SetData("language", nil)
end

function PLUGIN:PlayerLoadedCharacter(client, character)
	timer.Simple(0.25, function()
		client:SetNetVar("language", character:GetData("language", nil))
	end)
end

function PLUGIN:CharacterPreSave(character)
	local client = character:GetPlayer()

	if (IsValid(client)) then
		character:SetData("language", client:GetNetVar("language", nil))
	end
end