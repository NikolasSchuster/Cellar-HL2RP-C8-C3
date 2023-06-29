ix.bar.list = {}

function ix.bar.Add(getValue, icon, priority, identifier)
	if (identifier) then
		ix.bar.Remove(identifier)
	end

	local index = #ix.bar.list + 1

	icon = icon or false
	priority = priority or index

	ix.bar.list[index] = {
		index = index,
		icon = icon,
		priority = priority,
		GetValue = getValue,
		identifier = identifier,
		panel = IsValid(ix.gui.bars) and ix.gui.bars:AddBar(index, icon, priority)
	}

	return priority
end

do
	ix.bar.Add(function()
		return math.max(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0)
	end, "cellar/ui/cross.png", 1, "health")

	ix.bar.Add(function()
		local character = LocalPlayer():GetCharacter()

		if character then
			return math.max(character:GetBlood() / 5000, 0)
		end
	end, "cellar/ui/blood.png", 2, "blood")

	ix.bar.Add(function()
		return math.Clamp((ix.plugin.list["stamina"].predictedStamina or 100) / LocalPlayer():GetCharacter():GetMaxStamina(), 0, 1)
	end, "cellar/ui/stam.png", 3, "stam")

	ix.bar.Add(function()
		local character = LocalPlayer():GetCharacter()

		if character then
			local hunger = character:GetHunger()
			return hunger / 100
		end
	end, "cellar/ui/food.png", 5, "hunger")
	
	ix.bar.Add(function()
		local character = LocalPlayer():GetCharacter()

		if character then
			local thirst = character:GetThirst()
			return thirst / 100
		end
	end, "cellar/ui/water.png", 6, "thirst")

	ix.bar.Add(function()
		local character = LocalPlayer():GetCharacter()

		if character then
			local radLevel = LocalPlayer():GetNetVar("radDmg") or 0
			local geiger = character:HasGeigerCounter()

			if geiger and radLevel > 0 then
				return (radLevel / 100)
			end
		end
	end, "cellar/ui/geiger.png", 7, "geiger")

	ix.bar.Add(function()
		local character = LocalPlayer():GetCharacter()

		if character then
			local filter = character:HasWearedFilter()

			if filter then
				return filter:GetFilterQuality() / filter.filterQuality
			end
		end
	end, "cellar/ui/filter.png", 8, "filter")
end