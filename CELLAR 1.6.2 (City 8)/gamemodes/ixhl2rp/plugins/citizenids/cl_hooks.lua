function Schema:CreateCharacterInfo(panel)
	if (IsValid(panel) and self:GetFactionGroup(LocalPlayer():Team()) != FACTION_GROUP_REBEL) then
		panel.cid = panel:Add("ixListRow")
		panel.cid:SetList(panel.list)
		panel.cid:Dock(TOP)
		panel.cid:DockMargin(0, 0, 0, 8)
	end
end

function Schema:UpdateCharacterInfo(panel)
	local card = LocalPlayer():GetCharacter():GetIDCard()

	if IsValid(panel) and panel.cid then
		panel.cid:SetLabelText(L("citizenid"))
		panel.cid:SetText(string.format("##%s", card and card:GetData("cid") or "Н/Д"))
		panel.cid:SizeToContents()
	end
end

netstream.Hook("ixCitizenIDEdit", function(id, data)
	if IsValid(ix.gui.idEditor) then
		ix.gui.idEditor:Remove()
	end

	ix.gui.idEditorItemID = id
	ix.gui.idEditorItem = data
	ix.gui.idEditor = vgui.Create("ixIDEditor")
end)