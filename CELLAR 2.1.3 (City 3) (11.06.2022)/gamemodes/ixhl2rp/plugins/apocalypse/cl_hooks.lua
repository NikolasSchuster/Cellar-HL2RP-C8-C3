local PLUGIN = PLUGIN

function PLUGIN:CanPlayerViewInventory()
	local char = LocalPlayer():GetCharacter()
	return not (char:GetData("zombie", false) and (char:GetData("zstage") == 3))
end
