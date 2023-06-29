local PLUGIN = PLUGIN

net.Receive("ixSkillRoll", function(len)
	local x, y = input.GetCursorPos()

	local menu = DermaMenu()
	for k, v in pairs(ix.skills.list) do
		menu:AddOption(L(v.name), function() net.Start("ixSkillRoll") net.WriteString(k) net.SendToServer() end)
	end
	menu:Open()
	menu:SetPos(x, y)
end)

net.Receive("ixStatRoll", function(len)
	local x, y = input.GetCursorPos()

	local menu = DermaMenu()
	for k, v in SortedPairsByMemberValue(ix.specials.list, "weight") do
		menu:AddOption(L(v.name), function() net.Start("ixStatRoll") net.WriteString(k) net.SendToServer() end)
	end
	menu:Open()
	menu:SetPos(x, y)
end)