
/*ix.bar.Add(function()
	local character = LocalPlayer():GetCharacter()

	if (character) then
		local radLevel = LocalPlayer():GetNetVar("radDmg") or 0
		local geiger = character:HasGeigerCounter()

		if geiger and radLevel > 0 then
			return 1, Format("%s рад/с", radLevel)
		end
	end

	return false
end, Color(50, 200, 50), nil, "geiger")

ix.bar.Add(function()
	local character = LocalPlayer():GetCharacter()

	if (character) then
		local filter = character:HasWearedFilter()
		if filter then
			return filter:GetFilterQuality() / filter.filterQuality, "СОСТОЯНИЕ ФИЛЬТРА"
		end
	end

	return false
end, Color(200, 200, 200), nil, "filter")*/