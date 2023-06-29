
net.Receive("ixCreateCustomItem", function(length)
	if (IsValid(ix.gui.createCustomItem)) then
		ix.gui.createCustomItem:Remove()
	end

	ix.gui.createCustomItem = vgui.Create("ixCreateCustomItem")
end)
