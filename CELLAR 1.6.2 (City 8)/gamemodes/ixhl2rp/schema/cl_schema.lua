Schema.scoreboardClasses = {
	["scCityAdm"] = Color(255, 200, 100, 255),
	["scCWU"] = Color(255, 215, 0, 255),
	["scOTA"] = Color(150, 50, 50, 255)
}

function Schema:AddCombineDisplayMessage(text, color, ...)
	if (LocalPlayer():IsCombine() and IsValid(ix.gui.combine)) then
		ix.gui.combine:AddLine(text, color, nil, ...)
	end
end
