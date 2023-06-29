local PLUGIN = PLUGIN
--[[
ix.bar.Add(function()
	local character = LocalPlayer():GetCharacter()

	if character then
		local hunger = character:GetHunger()
		return hunger / 100
	end
end, "willardnetworks/hud/food.png", nil, "hunger")
ix.bar.Add(function()
	local character = LocalPlayer():GetCharacter()

	if character then
		local thirst = character:GetThirst()
		return thirst / 100
	end
end, "willardnetworks/hud/water.png", nil, "thirst")
]]